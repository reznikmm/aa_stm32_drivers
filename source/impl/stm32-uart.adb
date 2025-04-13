--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with System.STM32;

with STM32.GPIO;

package body STM32.UART is

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO
     (GPIO : in out Interfaces.STM32.GPIO.GPIO_Peripheral;
      Pin  : Pin_Index;
      Fun  : Interfaces.STM32.UInt4) is
   begin
      GPIO.MODER.Arr     (Pin) := System.STM32.Mode_AF;
      GPIO.OSPEEDR.Arr   (Pin) := System.STM32.Speed_50MHz;
      GPIO.OTYPER.OT.Arr (Pin) := System.STM32.Push_Pull;
      GPIO.PUPDR.Arr     (Pin) := System.STM32.Pull_Up;

      if Pin in GPIO.AFRL.Arr'Range then
         GPIO.AFRL.Arr (Pin) := Fun;
      else
         GPIO.AFRH.Arr (Pin) := Fun;
      end if;
   end Init_GPIO;

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO
     (TX  : Pin;
      Fun : Interfaces.STM32.UInt4) is
   begin
      STM32.GPIO.Enable_GPIO (TX.Port);

      case TX.Port is
         when PA =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOA_Periph, TX.Pin, Fun);
         when PB =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOB_Periph, TX.Pin, Fun);
         when PC =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOC_Periph, TX.Pin, Fun);
         when PD =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOD_Periph, TX.Pin, Fun);
         when PE =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOE_Periph, TX.Pin, Fun);
      end case;
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
         Clock : Interfaces.STM32.UInt32)
      is
         use type Interfaces.STM32.UInt32;

         Divider  : constant Interfaces.STM32.UInt32 :=
           25 * Clock / (4 * Interfaces.STM32.UInt32 (Speed));

         Fraction : constant Interfaces.STM32.UInt32 := Divider rem 100;
      begin
         Init_GPIO (TX, System.STM32.AF_USART6);
         Init_GPIO (RX, System.STM32.AF_USART6);

         Periph.BRR.DIV_Fraction :=
           Interfaces.STM32.USART.BRR_DIV_Fraction_Field
             ((Fraction * 16 + 50) / 100);

         Periph.BRR.DIV_Mantissa :=
           Interfaces.STM32.USART.BRR_DIV_Mantissa_Field (Divider / 100);

         Periph.CR1.UE := 1;  --  USART enable
         Periph.CR1.TE := 1;  --  Transmitter enable
         Periph.CR1.RE := 1;  --  Receiver enable
      end Configure;

      ------------------
      -- On_Interrupt --
      ------------------

      procedure On_Interrupt (Self : in out Internal_Data) is
         use type Interfaces.STM32.Bit;
         use type Interfaces.STM32.UInt32;

         Input : Buffer_Record renames Self.Input;

         Input_Buffer : String (1 .. Positive'Last)
           with Import, Address => Self.Input.Buffer;

         Output : Buffer_Record renames Self.Output;

         Output_Buffer : String (1 .. Positive'Last)
           with Import, Address => Self.Output.Buffer;

         SR : constant Interfaces.STM32.USART.SR_Register := Periph.SR;
         --  Keep SR copy to avoid losing clear-on-read bits
      begin
         if Periph.CR1.RXNEIE /= 0 and then SR.RXNE /= 0 then
            Input_Buffer (Input.Next) := Character'Val (Periph.DR.DR);
            Input.Next := Input.Next + 1;

            if Input.Next > Input.Last then
               Periph.CR1.RXNEIE := 0;
               A0B.Callbacks.Emit (Input.Done);
               A0B.Callbacks.Unset (Input.Done);
            end if;
         end if;

         if Periph.CR1.TXEIE /= 0 and then SR.TXE /= 0 then
            Periph.DR :=
              (DR     => Character'Pos (Output_Buffer (Output.Next)),
               others => 0);

            Output.Next := Output.Next + 1;

            if Output.Next > Output.Last then
               Periph.CR1.TXEIE := 0;
               A0B.Callbacks.Emit (Output.Done);
               A0B.Callbacks.Unset (Output.Done);
            end if;
         end if;

         if Periph.CR1.TCIE /= 0 and then SR.TC /= 0 then
            --  Change UART speed on transmission complete
            Periph.CR1.TE := 0;  --  Transmitter disable
            Periph.CR1.RE := 0;  --  Receiver disable

            Periph.BRR.DIV_Fraction :=
              Interfaces.STM32.USART.BRR_DIV_Fraction_Field
                ((Self.Divider mod 100 * 16 + 50) / 100);

            Periph.BRR.DIV_Mantissa :=
              Interfaces.STM32.USART.BRR_DIV_Mantissa_Field
                (Self.Divider / 100);

            Periph.CR1.TCIE := 0;  --  disable transmission complete interrupt
            Periph.CR1.TE := 1;  --  Transmitter enable
            Periph.CR1.RE := 1;  --  Receiver enable
         end if;
      end On_Interrupt;

      ---------------
      -- Set_Speed --
      ---------------

      procedure Set_Speed
        (Self  : in out Internal_Data;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.STM32.UInt32)
      is
         use type Interfaces.STM32.UInt32;
      begin
         Self.Divider :=
           25 * Clock / (4 * Interfaces.STM32.UInt32 (Speed));

         Periph.CR1.TCIE := 1;  --  enable transmission complete interrupt
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

         Periph.CR1.RXNEIE := 1;
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

         Periph.CR1.TXEIE := 1;  --  interrupt is generated whenever TXE=1
      end Start_Writing;

   end UART_Implementation;

   --------------------------
   -- USART_Implementation --
   --------------------------

   package body USART_Implementation is

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (TX    : Pin;
         RX    : Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.STM32.UInt32)
      is
         use type System.Address;
         use type Interfaces.STM32.UInt32;

         Divider  : constant Interfaces.STM32.UInt32 :=
           25 * Clock / (4 * Interfaces.STM32.UInt32 (Speed));

         Fraction : constant Interfaces.STM32.UInt32 := Divider rem 100;

         Alt_Function : constant Interfaces.STM32.UInt4 :=
           (if Periph'Address = Interfaces.STM32.USART.USART6_Periph'Address
            then System.STM32.AF_USART6
            else System.STM32.AF_USART1);
      begin
         Init_GPIO (TX, Alt_Function);
         Init_GPIO (RX, Alt_Function);

         Periph.BRR.DIV_Fraction :=
           Interfaces.STM32.USART.BRR_DIV_Fraction_Field
             ((Fraction * 16 + 50) / 100);

         Periph.BRR.DIV_Mantissa :=
           Interfaces.STM32.USART.BRR_DIV_Mantissa_Field (Divider / 100);

         Periph.CR1.UE := 1;  --  USART enable
         Periph.CR1.TE := 1;  --  Transmitter enable
         Periph.CR1.RE := 1;  --  Receiver enable
      end Configure;

      ------------------
      -- On_Interrupt --
      ------------------

      procedure On_Interrupt (Self : in out Internal_Data) is
         use type Interfaces.STM32.Bit;
         use type Interfaces.STM32.UInt32;

         Input : Buffer_Record renames Self.Input;

         Input_Buffer : String (1 .. Positive'Last)
           with Import, Address => Self.Input.Buffer;

         Output : Buffer_Record renames Self.Output;

         Output_Buffer : String (1 .. Positive'Last)
           with Import, Address => Self.Output.Buffer;

         SR : constant Interfaces.STM32.USART.SR_Register_1 := Periph.SR;
         --  Keep SR copy to avoid losing clear-on-read bits
      begin
         if Periph.CR1.RXNEIE /= 0 and then SR.RXNE /= 0 then
            Input_Buffer (Input.Next) := Character'Val (Periph.DR.DR);
            Input.Next := Input.Next + 1;

            if Input.Next > Input.Last then
               Periph.CR1.RXNEIE := 0;
               A0B.Callbacks.Emit (Input.Done);
               A0B.Callbacks.Unset (Input.Done);
            end if;
         end if;

         if Periph.CR1.TXEIE /= 0 and then SR.TXE /= 0 then
            Periph.DR :=
              (DR     => Character'Pos (Output_Buffer (Output.Next)),
               others => 0);

            Output.Next := Output.Next + 1;

            if Output.Next > Output.Last then
               Periph.CR1.TXEIE := 0;
               A0B.Callbacks.Emit (Output.Done);
               A0B.Callbacks.Unset (Output.Done);
            end if;
         end if;

         if Periph.CR1.TCIE /= 0 and then SR.TC /= 0 then
            --  Change UART speed on transmission complete
            Periph.CR1.TE := 0;  --  Transmitter disable
            Periph.CR1.RE := 0;  --  Receiver disable

            Periph.BRR.DIV_Fraction :=
              Interfaces.STM32.USART.BRR_DIV_Fraction_Field
                ((Self.Divider mod 100 * 16 + 50) / 100);

            Periph.BRR.DIV_Mantissa :=
              Interfaces.STM32.USART.BRR_DIV_Mantissa_Field
                (Self.Divider / 100);

            Periph.CR1.TCIE := 0;  --  disable transmission complete interrupt
            Periph.CR1.TE := 1;  --  Transmitter enable
            Periph.CR1.RE := 1;  --  Receiver enable
         end if;
      end On_Interrupt;

      ---------------
      -- Set_Speed --
      ---------------

      procedure Set_Speed
        (Self  : in out Internal_Data;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.STM32.UInt32)
      is
         use type Interfaces.STM32.UInt32;
      begin
         Self.Divider :=
           25 * Clock / (4 * Interfaces.STM32.UInt32 (Speed));

         Periph.CR1.TCIE := 1;  --  enable transmission complete interrupt
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

         Periph.CR1.RXNEIE := 1;
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

         Periph.CR1.TXEIE := 1;  --  interrupt is generated whenever TXE=1
      end Start_Writing;

   end USART_Implementation;

end STM32.UART;
