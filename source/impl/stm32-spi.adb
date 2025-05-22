--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with A0B.Callbacks.Generic_Subprogram;

with STM32.GPIO;
with STM32.Registers.GPIO;

package body STM32.SPI is

   procedure Configure
     (Periph : in out STM32.Registers.SPI.SPI_Peripheral;
      SCK    : Pin;
      MISO   : Pin;
      MOSI   : Pin;
      Speed  : Interfaces.Unsigned_32;
      Mode   : SPI_Mode;
      Clock  : Interfaces.Unsigned_32);

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Periph : in out STM32.Registers.SPI.SPI_Peripheral;
      SCK    : Pin;
      MISO   : Pin;
      MOSI   : Pin;
      Speed  : Interfaces.Unsigned_32;
      Mode   : SPI_Mode;
      Clock  : Interfaces.Unsigned_32)
   is
      use type Interfaces.Unsigned_32;
      BR : Interfaces.Unsigned_32 := 0;

      CPHA : constant Boolean := Mode in 1 | 3;
      CPOL : constant Boolean := Mode in 2 | 3;
   begin
      Init_GPIO (SCK);
      Init_GPIO (MISO);
      Init_GPIO (MOSI);

      for J in 1 .. 8 loop
         exit when Clock / 2 ** J <= Speed;
         BR := BR + 1;
      end loop;

      Periph.CR1.SPE := False;  --  Disable

      Periph.CR1 :=
        (MSTR           => True,   --  Master configuration
         SSI            => True,   --  NSS pin is ignored.
         BIDIMODE       => False,  --  2-line unidirectional data mode
         BIDIOE         => False,  --  Output disabled in bidirectional mode
         RXONLY         => False,  --  Full duplex (Transmit and receive)
         CPHA           => CPHA,
         CPOL           => CPOL,
         BR             => BR,     --  Baud rate control
         SPE            => False,
         LSBFIRST       => False,  --  MSB transmitted first
         SSM            => True,   --  Use SSI bit instead of NSS pin
         DFF            => False,  --  8-bit data frame format
         CRCNEXT        => False,
         CRCEN          => False,
         Reserved_16_31 => 9);

      Periph.CR1.SPE := True;  --  Enable
   end Configure;

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO (Item : Pin) is

      procedure Init_GPIO
        (Periph : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin    : Pin_Index);

      ---------------
      -- Init_GPIO --
      ---------------

      procedure Init_GPIO
        (Periph : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin    : Pin_Index)
      is
         AF_SPI1_6    : constant := 5;
      begin
         Periph.MODER   (Pin) := STM32.Registers.GPIO.Mode_AF;
         Periph.OSPEEDR (Pin) := STM32.Registers.GPIO.Speed_100MHz;
         Periph.OTYPER  (Pin) := STM32.Registers.GPIO.Push_Pull;
         Periph.PUPDR   (Pin) := STM32.Registers.GPIO.Pull_Up;
         Periph.AFR     (Pin) := AF_SPI1_6;
      end Init_GPIO;

   begin
      STM32.GPIO.Enable_GPIO (Item.Port);
      Init_GPIO (STM32.Registers.GPIO.GPIO_Periph (Item.Port), Item.Pin);
   end Init_GPIO;

   ------------------------
   -- DMA_Implementation --
   ------------------------

   package body DMA_Implementation is

      procedure RX_Done (Data : in out Data_Record);

      package RX_Callback is new A0B.Callbacks.Generic_Subprogram
        (Data_Record, RX_Done);

      procedure TX_Done (Data : in out Data_Record);

      package TX_Callback is new A0B.Callbacks.Generic_Subprogram
        (Data_Record, TX_Done);

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (SCK   : Pin;
         MISO  : Pin;
         MOSI  : Pin;
         Speed : Interfaces.Unsigned_32;
         Mode  : SPI_Mode;
         Clock : Interfaces.Unsigned_32) is
      begin
         Configure
           (Periph,
            SCK   => SCK,
            MISO  => MISO,
            MOSI  => MOSI,
            Speed => Speed,
            Mode  => Mode,
            Clock => Clock);
      end Configure;

      protected body Device is

         -----------------------
         -- Interrupt_Handler --
         -----------------------

         procedure Interrupt_Handler is
            Ignore : Interfaces.Unsigned_16;
         begin
            --  Overrun error
            Error := True;
            TX_Stream.Stop_Transfer (Ignore);
            RX_Stream.Stop_Transfer (Ignore);

            --  Clear overrun error flag
            Ignore := Interfaces.Unsigned_16 (Periph.DR.DR);

            while not (Periph.SR.TXE and not Periph.SR.BSY) loop
               null;
            end loop;

            if A0B.Callbacks.Is_Set (Data.Done) then
               STM32.GPIO.Set_Output (Data.CS, 1);
               A0B.Callbacks.Emit_Once (Data.Done);
            end if;
         end Interrupt_Handler;

         ---------------
         -- Has_Error --
         ---------------

         function Has_Error return Boolean is
            (Error or else
             RX_Stream.Has_Error or else
             TX_Stream.Has_Error);

         -------------------------
         -- Start_Data_Exchange --
         -------------------------

         procedure Start_Data_Exchange
           (CS     : Pin;
            Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback) is
         begin
            pragma Assert (not A0B.Callbacks.Is_Set (Data.Done));

            Error := False;
            Data.Done := Done;
            Data.CS := CS;

            RX_Stream.Start_Transfer
              (Channel => Channel,
               Source  =>
                 (Address     => Periph.DR'Address,
                  Item_Length => 1,  --  8 bit
                  Increment   => 0,
                  Burst       => 1),
               Target  =>
                 (Address     => Buffer,
                  Item_Length => 1,
                  Increment   => 1,
                  Burst       => 1),
               Count   => Interfaces.Unsigned_16 (Length),
               FIFO    => 4,
               Prio    => STM32.DMA.Low,
               Done    => RX_Callback.Create_Callback (Data));

            TX_Stream.Start_Transfer
              (Channel => Channel,
               Source  =>
                 (Address     => Buffer,
                  Item_Length => 1,
                  Increment   => 1,
                  Burst       => 1),
               Target  =>
                 (Address     => Periph.DR'Address,
                  Item_Length => 1,  --  8 bit
                  Increment   => 0,
                  Burst       => 1),
               Count   => Interfaces.Unsigned_16 (Length),
               FIFO    => 4,
               Prio    => STM32.DMA.Low,
               Done    => TX_Callback.Create_Callback (Data));

            STM32.GPIO.Set_Output (CS, 0);

            Periph.CR2 :=
              (RXDMAEN       => True,
               TXDMAEN       => True,
               SSOE          => False,
               Reserved_3_3  => 0,
               FRF           => False,  --  Frame format
               ERRIE         => True,
               RXNEIE        => False,  --  RXNE (RX not empty) IRQ enable
               TXEIE         => False,  --  TXE interrupt enable
               Reserved_8_31 => 0);
         end Start_Data_Exchange;

      end Device;

      -------------
      -- RX_Done --
      -------------

      procedure RX_Done (Data : in out Data_Record) is
      begin
         while not (Periph.SR.TXE and not Periph.SR.BSY) loop
            null;
         end loop;

         Periph.CR2 :=
           (RXDMAEN       => False,
            TXDMAEN       => False,
            SSOE          => False,
            Reserved_3_3  => 0,
            FRF           => False,
            ERRIE         => False,
            RXNEIE        => False,
            TXEIE         => False,
            Reserved_8_31 => 0);

         if A0B.Callbacks.Is_Set (Data.Done) then
            STM32.GPIO.Set_Output (Data.CS, 1);
            A0B.Callbacks.Emit_Once (Data.Done);
         end if;
      end RX_Done;

      -------------
      -- TX_Done --
      -------------

      procedure TX_Done (Data : in out Data_Record) is
      begin
         null;  --  Nothing to do here?
      end TX_Done;

   end DMA_Implementation;

   ------------------------
   -- SPI_Implementation --
   ------------------------

   package body SPI_Implementation is

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (SCK   : Pin;
         MISO  : Pin;
         MOSI  : Pin;
         Speed : Interfaces.Unsigned_32;
         Mode  : SPI_Mode;
         Clock : Interfaces.Unsigned_32) is
      begin
         Configure
           (Periph,
            SCK   => SCK,
            MISO  => MISO,
            MOSI  => MOSI,
            Speed => Speed,
            Mode  => Mode,
            Clock => Clock);
      end Configure;

      protected body Device is

         -----------------------
         -- Interrupt_Handler --
         -----------------------

         procedure Interrupt_Handler is

            Buffer : String (1 .. Positive'Last)
              with Import, Address => Device.Buffer;

            SR : constant STM32.Registers.SPI.SR_Register := Periph.SR;
         begin
            if Periph.CR2.TXEIE and then SR.TXE then

               Periph.DR.DR := Character'Pos (Buffer (Next_Out));
               Next_Out := Next_Out + 1;

               if Next_Out > Last then
                  Periph.CR2.TXEIE := False;
               end if;
            end if;

            if Periph.CR2.RXNEIE and then SR.RXNE then

               Buffer (Next_In) := Character'Val (Periph.DR.DR);
               Next_In := Next_In + 1;

               if Next_In > Last then
                  STM32.GPIO.Set_Output (CS, 1);
                  Periph.CR2.RXNEIE := False;
                  A0B.Callbacks.Emit (Done);
                  A0B.Callbacks.Unset (Done);
               end if;
            end if;
         end Interrupt_Handler;

         -------------------------
         -- Start_Data_Exchange --
         -------------------------

         procedure Start_Data_Exchange
           (CS     : Pin;
            Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback) is
         begin
            pragma Assert (not A0B.Callbacks.Is_Set (Device.Done));

            Device.Buffer   := Buffer;
            Device.Last     := Length;
            Device.Next_In  := 1;
            Device.Next_Out := 1;
            Device.Done     := Done;
            Device.CS       := CS;

            STM32.GPIO.Set_Output (CS, 0);
            Periph.CR2.RXNEIE := True;  --  RXNE (RX not empty) IRQ enable
            Periph.CR2.TXEIE := True;  --  TXE interrupt enable
         end Start_Data_Exchange;

      end Device;

   end SPI_Implementation;

end STM32.SPI;
