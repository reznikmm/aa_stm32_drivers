--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with System.STM32;

with Drivers.GPIO;

package body Drivers.SPI is

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO
     (Periph : in out Interfaces.STM32.GPIO.GPIO_Peripheral;
      Pin    : Pin_Index)
   is
      AF_SPI1_6    : constant := 5;
   begin
      Periph.MODER.Arr     (Pin) := System.STM32.Mode_AF;
      Periph.OSPEEDR.Arr   (Pin) := System.STM32.Speed_100MHz;
      Periph.OTYPER.OT.Arr (Pin) := System.STM32.Push_Pull;
      Periph.PUPDR.Arr     (Pin) := System.STM32.Pull_Up;

      if Pin in Periph.AFRL.Arr'Range then
         Periph.AFRL.Arr (Pin) := AF_SPI1_6;
      else
         Periph.AFRH.Arr (Pin) := AF_SPI1_6;
      end if;
   end Init_GPIO;

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO (Item : Pin) is
   begin
      Drivers.GPIO.Enable_GPIO (Item.Port);

      case Item.Port is
         when 'A' =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOA_Periph, Item.Pin);
         when 'B' =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOB_Periph, Item.Pin);
         when 'C' =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOC_Periph, Item.Pin);
         when 'D' =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOD_Periph, Item.Pin);
         when 'E' =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOE_Periph, Item.Pin);
      end case;
   end Init_GPIO;

   package body SPI_Implementation is

      procedure Configure
        (SCK   : Pin;
         MISO  : Pin;
         MOSI  : Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.STM32.UInt32)
      is
         use type Interfaces.Unsigned_32;
         BR : Interfaces.STM32.SPI.CR1_BR_Field := 0;

      begin
         Init_GPIO (SCK);
         Init_GPIO (MISO);
         Init_GPIO (MOSI);

         for J in 1 .. 8 loop
            exit when Interfaces.Unsigned_32 (Clock) / 2 ** J <= Speed;
            BR := Interfaces.STM32.SPI.CR1_BR_Field'Succ (BR);
         end loop;

         Periph.CR1.SPE := False;  --  Disable

         Periph.CR1 :=
           (MSTR           => True,   --  Master configuration
            SSI            => True,   --  NSS pin is ignored.
            BIDIMODE       => False,  --  2-line unidirectional data mode
            BIDIOE         => False,  --  Output disabled in bidirectional mode
            RXONLY         => False,  --  Full duplex (Transmit and receive)
            CPHA           => True,   --  Mode 3
            CPOL           => True,   --  Mode 3
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

      ------------------
      -- On_Interrupt --
      ------------------

      procedure On_Interrupt (Self : in out Internal_Data) is

         Buffer : String (1 .. Positive'Last)
           with Import, Address => Self.Buffer;

         SR : constant Interfaces.STM32.SPI.SR_Register := Periph.SR;
         --  This register is cleared when read, so read it once
      begin
         if Periph.CR2.TXEIE and then SR.TXE then

            Periph.DR.DR := Character'Pos (Buffer (Self.Next_Out));
            Self.Next_Out := Self.Next_Out + 1;

            if Self.Next_Out > Self.Last then
               Periph.CR2.TXEIE := False;
            end if;
         end if;

         if Periph.CR2.RXNEIE and then SR.RXNE then

            Buffer (Self.Next_In) := Character'Val (Periph.DR.DR);
            Self.Next_In := Self.Next_In + 1;

            if Self.Next_In > Self.Last then
               Drivers.GPIO.Set_Output (Self.CS, 1);
               Periph.CR2.RXNEIE := False;
               A0B.Callbacks.Emit (Self.Done);
               A0B.Callbacks.Unset (Self.Done);
            end if;
         end if;
      end On_Interrupt;

      -------------------------
      -- Start_Data_Exchange --
      -------------------------

      procedure Start_Data_Exchange
        (Self   : in out Internal_Data;
         CS     : Pin;
         Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback) is
      begin
         pragma Assert (not A0B.Callbacks.Is_Set (Self.Done));

         Self.Buffer   := Buffer;
         Self.Last     := Length;
         Self.Next_In  := 1;
         Self.Next_Out := 1;
         Self.Done     := Done;
         Self.CS       := CS;

         Drivers.GPIO.Set_Output (CS, 0);
         Periph.CR2.RXNEIE := True;  --  RXNE (RX not empty) interrupt enable
         Periph.CR2.TXEIE := True;  --  TXE interrupt enable
      end Start_Data_Exchange;

   end SPI_Implementation;

end Drivers.SPI;
