--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.GPIO;
with STM32.Registers.GPIO;

with A0B.Callbacks.Generic_Subprogram;

package body STM32.UART is

   procedure Configure
     (TX     : Pin;
      RX     : Pin;
      Speed  : Interfaces.Unsigned_32;
      Clock  : Interfaces.Unsigned_32;
      Periph : in out STM32.Registers.USART.USART_Peripheral;
      Fun    : GPIO_Function)
     with Inline;

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (TX     : Pin;
      RX     : Pin;
      Speed  : Interfaces.Unsigned_32;
      Clock  : Interfaces.Unsigned_32;
      Periph : in out STM32.Registers.USART.USART_Peripheral;
      Fun    : GPIO_Function)
   is
      use type Interfaces.Unsigned_32;

      Divider  : constant Interfaces.Unsigned_32 := 25 * Clock / (4 * Speed);
      Fraction : constant Interfaces.Unsigned_32 := Divider rem 100;

   begin
      Init_GPIO (TX, Fun);
      Init_GPIO (RX, Fun);

      Periph.BRR.DIV_Fraction := (Fraction * 16 + 50) / 100;
      Periph.BRR.DIV_Mantissa := Divider / 100;

      Periph.CR1 :=
        (SBK      => False,
         RWU      => False,
         RE       => True,  --  Receiver enable
         TE       => True,  --  Transmitter enable
         IDLEIE   => False,  --  IDLE interrupt enable
         RXNEIE   => False,
         TCIE     => False,  --  Transmission complete interrupt enable
         TXEIE    => False,
         PEIE     => False,  --  Parity Error
         PS       => False,  --  is Odd parity
         PCE      => False,  --  Parity control enable
         WAKE     => False,
         M        => False,  --  9 bits
         UE       => True,  --  USART enable
         Reserved => 0,
         OVER8    => False);
   end Configure;

   package body DMA_Implementation is

      procedure RX_Done (Buffer : in out Buffer_Record);

      package RX_Callback is new A0B.Callbacks.Generic_Subprogram
        (Buffer_Record, RX_Done);

      procedure TX_Done (Buffer : in out Buffer_Record);

      package TX_Callback is new A0B.Callbacks.Generic_Subprogram
        (Buffer_Record, TX_Done);

      procedure RX_Done (Buffer : in out Buffer_Record) is
      begin
         Periph.CR3.DMAR := False;
         A0B.Callbacks.Emit (Buffer.Done);
      end RX_Done;

      procedure TX_Done (Buffer : in out Buffer_Record) is
      begin
         Periph.CR3.DMAT := False;
         A0B.Callbacks.Emit (Buffer.Done);
      end TX_Done;

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (TX    : Pin;
         RX    : Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32) is
      begin
         Configure (TX, RX, Speed, Clock, Periph, Fun);
      end Configure;

      ------------------
      -- On_Interrupt --
      ------------------

      procedure On_Interrupt (Self : in out Internal_Data) is
         use type Interfaces.Unsigned_32;

         SR : constant STM32.Registers.USART.SR_Register := Periph.SR;
         --  Keep SR copy to avoid losing clear-on-read bits
      begin
         if Periph.CR1.TCIE and then SR.TC then
            --  Change UART speed on transmission complete
            Periph.CR1.TE := False;  --  Transmitter disable
            Periph.CR1.RE := False;  --  Receiver disable

            Periph.BRR.DIV_Fraction := (Self.Divider mod 100 * 16 + 50) / 100;
            Periph.BRR.DIV_Mantissa := Self.Divider / 100;

            Periph.CR1.TCIE := False;  --  disable transmission complete irq
            Periph.CR1.TE := True;  --  Transmitter enable
            Periph.CR1.RE := True;  --  Receiver enable
         end if;
      end On_Interrupt;

      ---------------
      -- Set_Speed --
      ---------------

      procedure Set_Speed
        (Self  : in out Internal_Data;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32)
      is
         use type Interfaces.Unsigned_32;
      begin
         Self.Divider := 25 * Clock / (4 * Speed);
         Periph.CR1.TCIE := True;  --  enable transmission complete interrupt
      end Set_Speed;

      -------------------
      -- Start_Reading --
      -------------------

      procedure Start_Reading
        (Self   : in out Internal_Data;
         Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback) is
      begin
         Self.Input.Done := Done;
         Periph.CR3.DMAR := True;

         RX_Stream.Start_Transfer
           (Channel,
            Source =>
              (Address     => Periph.DR'Address,
               Item_Length => 1,  --  8 bit
               Increment   => 0,
               Burst       => 1),
            Target =>
              (Address => Buffer,
               Item_Length => 1,
               Increment   => 1,
               Burst       => 1),
            Count => Interfaces.Unsigned_16 (Length),
            FIFO => 4,
            Prio => STM32.DMA.Low,
            Done => RX_Callback.Create_Callback (Self.Input));
      end Start_Reading;

      -------------------
      -- Start_Writing --
      -------------------

      procedure Start_Writing
        (Self   : in out Internal_Data;
         Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback) is
      begin
         Self.Output.Done := Done;
         Periph.CR3.DMAT := True;

         --  Clear SR.TC
         Periph.SR :=
           (TC             => False,  --  clear TC
            RXNE           => True,   --  don't clear RXNE
            LBD            => True,   --  don't clear LBD
            CTS            => True,   --  don't clear CTS
            Reserved_10_31 => 0,      --  all others are read-only
            others         => False);

         TX_Stream.Start_Transfer
           (Channel,
            Source =>
              (Address => Buffer,
               Item_Length => 1,
               Increment   => 1,
               Burst       => 1),
            Target =>
              (Address     => Periph.DR'Address,
               Item_Length => 1,  --  16 bit access???
               Increment   => 0,
               Burst       => 1),
            Count => Interfaces.Unsigned_16 (Length),
            FIFO => 4,
            Prio => STM32.DMA.Low,
            Done => TX_Callback.Create_Callback (Self.Output));
      end Start_Writing;

   end DMA_Implementation;

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO
     (TX  : Pin;
      Fun : GPIO_Function)
   is
      procedure Init_GPIO
        (GPIO : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin  : Pin_Index;
         Fun  : GPIO_Function);

      ---------------
      -- Init_GPIO --
      ---------------

      procedure Init_GPIO
        (GPIO : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin  : Pin_Index;
         Fun  : GPIO_Function) is
      begin
         GPIO.MODER   (Pin) := STM32.Registers.GPIO.Mode_AF;
         GPIO.OSPEEDR (Pin) := STM32.Registers.GPIO.Speed_50MHz;
         GPIO.OTYPER  (Pin) := STM32.Registers.GPIO.Push_Pull;
         GPIO.PUPDR   (Pin) := STM32.Registers.GPIO.Pull_Up;
         GPIO.AFR     (Pin) := Fun;
      end Init_GPIO;

   begin
      STM32.GPIO.Enable_GPIO (TX.Port);
      Init_GPIO (STM32.Registers.GPIO.GPIO_Periph (TX.Port), TX.Pin, Fun);
   end Init_GPIO;

   -------------------------
   -- UART_Implementation --
   -------------------------

   package body UART_Implementation is

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (TX    : Pin;
         RX    : Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32) is
      begin
         Configure (TX, RX, Speed, Clock, Periph, Fun);
      end Configure;

      ------------------
      -- On_Interrupt --
      ------------------

      procedure On_Interrupt (Self : in out Internal_Data) is
         use type Interfaces.Unsigned_32;

         Input : Buffer_Record renames Self.Input;

         Input_Buffer : String (1 .. Positive'Last)
           with Import, Address => Self.Input.Buffer;

         Output : Buffer_Record renames Self.Output;

         Output_Buffer : String (1 .. Positive'Last)
           with Import, Address => Self.Output.Buffer;

         SR : constant STM32.Registers.USART.SR_Register := Periph.SR;
         --  Keep SR copy to avoid losing clear-on-read bits
      begin
         if Periph.CR1.RXNEIE and then SR.RXNE then
            Input_Buffer (Input.Next) := Character'Val (Periph.DR);
            Input.Next := Input.Next + 1;

            if Input.Next > Input.Last then
               Periph.CR1.RXNEIE := False;
               A0B.Callbacks.Emit (Input.Done);
               A0B.Callbacks.Unset (Input.Done);
            end if;
         end if;

         if Periph.CR1.TXEIE and then SR.TXE then
            Periph.DR := Character'Pos (Output_Buffer (Output.Next));

            Output.Next := Output.Next + 1;

            if Output.Next > Output.Last then
               Periph.CR1.TXEIE := False;
               A0B.Callbacks.Emit (Output.Done);
               A0B.Callbacks.Unset (Output.Done);
            end if;
         end if;

         if Periph.CR1.TCIE and then SR.TC then
            --  Change UART speed on transmission complete
            Periph.CR1.TE := False;  --  Transmitter disable
            Periph.CR1.RE := False;  --  Receiver disable

            Periph.BRR.DIV_Fraction := (Self.Divider mod 100 * 16 + 50) / 100;
            Periph.BRR.DIV_Mantissa := Self.Divider / 100;

            Periph.CR1.TCIE := False;  --  disable transmission complete irq
            Periph.CR1.TE := True;  --  Transmitter enable
            Periph.CR1.RE := True;  --  Receiver enable
         end if;
      end On_Interrupt;

      ---------------
      -- Set_Speed --
      ---------------

      procedure Set_Speed
        (Self  : in out Internal_Data;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32)
      is
         use type Interfaces.Unsigned_32;
      begin
         Self.Divider := 25 * Clock / (4 * Speed);
         Periph.CR1.TCIE := True;  --  enable transmission complete interrupt
      end Set_Speed;

      -------------------
      -- Start_Reading --
      -------------------

      procedure Start_Reading
        (Self   : in out Internal_Data;
         Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback) is
      begin
         pragma Assert (not A0B.Callbacks.Is_Set (Self.Input.Done));

         Self.Input :=
           (Buffer => Buffer,
            Last   => Length,
            Next   => 1,
            Done => Done);

         Periph.CR1.RXNEIE := True;
         --  RXNE (RX not empty) interrupt enable. TBD: errors interrupts?
      end Start_Reading;

      -------------------
      -- Start_Writing --
      -------------------

      procedure Start_Writing
        (Self   : in out Internal_Data;
         Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback) is
      begin
         pragma Assert (not A0B.Callbacks.Is_Set (Self.Output.Done));

         Self.Output :=
           (Buffer => Buffer,
            Last   => Length,
            Next   => 1,
            Done   => Done);

         Periph.CR1.TXEIE := True;  --  interrupt is generated whenever TXE=1
      end Start_Writing;

   end UART_Implementation;

end STM32.UART;
