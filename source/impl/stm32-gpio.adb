--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces.STM32.RCC;
with Interfaces.STM32.SYSCFG;
with STM32.Registers.EXTI;
with STM32.Registers.GPIO;

with STM32.Registers.GPIO;

package body STM32.GPIO is

   Mode_IN  : constant := 0;
   Mode_OUT : constant := 1;
   Mode_AF  : constant := 2;
   Mode_AN  : constant := 3;

   --  OTYPER constants
   Push_Pull  : constant Boolean := False;
   Open_Drain : constant Boolean := True;

   --  OSPEEDR constants
   Speed_2MHz   : constant := 0; -- Low speed
   Speed_25MHz  : constant := 1; -- Medium speed
   Speed_50MHz  : constant := 2; -- Fast speed
   Speed_100MHz : constant := 3; -- High speed

   --  PUPDR constants
   No_Pull   : constant := 0;
   Pull_Up   : constant := 1;
   Pull_Down : constant := 2;

   ---------------------
   -- Clear_Interrupt --
   ---------------------

   procedure Clear_Interrupt (Pin : STM32.Pin) is

      EXTI_Periph : STM32.Registers.EXTI.EXTI_Peripheral renames
        STM32.Registers.EXTI.EXTI_Periph;

   begin
      EXTI_Periph.PR (Natural (Pin.Pin)) := True;  --  Clear pending
   end Clear_Interrupt;

   -------------------------
   -- Configure_Interrupt --
   -------------------------

   procedure Configure_Interrupt
     (Pin       : STM32.Pin;
      Pull_Up   : Boolean := False;
      Pull_Down : Boolean := False)
   is

      procedure Configure_Interrupt
        (GPIO : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin  : Pin_Index);

      -------------------------
      -- Configure_Interrupt --
      -------------------------

      procedure Configure_Interrupt
        (GPIO : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin  : Pin_Index) is
      begin
         GPIO.MODER (Pin) := Mode_IN;
         GPIO.PUPDR (Pin) :=
           (if Pull_Up then STM32.GPIO.Pull_Up
            elsif Pull_Down then STM32.GPIO.Pull_Down
            else STM32.GPIO.No_Pull);
      end Configure_Interrupt;

      EXTI_Periph : STM32.Registers.EXTI.EXTI_Peripheral renames
        STM32.Registers.EXTI.EXTI_Periph;

      SYSCFG_Periph : Interfaces.STM32.SYSCFG.SYSCFG_Peripheral renames
        Interfaces.STM32.SYSCFG.SYSCFG_Periph;

      EXTICR : array (STM32.Pin_Index range 0 .. 3) of
        Interfaces.STM32.SYSCFG.EXTICR1_Register
          with Import, Address => SYSCFG_Periph.EXTICR1'Address;

      Port : constant Natural :=
        STM32.Port'Pos (Pin.Port) - STM32.Port'Pos (STM32.Port'First);
   begin
      Enable_GPIO (Pin.Port);

      Configure_Interrupt
        (STM32.Registers.GPIO.GPIO_Periph (Pin.Port), Pin.Pin);

      EXTICR (Pin.Pin / 4).EXTI.Arr (Pin.Pin mod 4) :=
        Interfaces.STM32.SYSCFG.EXTICR1_EXTI_Element (Port);

      EXTI_Periph.RTSR (Natural (Pin.Pin)) := True;  --  Rising trigger
      EXTI_Periph.FTSR (Natural (Pin.Pin)) := False;  --  Falling trigger
      EXTI_Periph.PR (Natural (Pin.Pin)) := True;  --  Clear pending
      EXTI_Periph.IMR (Natural (Pin.Pin)) := True;  --  Unmask interrupt
   end Configure_Interrupt;

   ----------------------
   -- Configure_Output --
   ----------------------

   procedure Configure_Output (Pin : STM32.Pin) is

      procedure Configure_Output
        (GPIO : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin  : Pin_Index);

      ----------------------
      -- Configure_Output --
      ----------------------

      procedure Configure_Output
        (GPIO : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin  : Pin_Index) is
      begin
         GPIO.MODER     (Pin) := Mode_OUT;
         GPIO.PUPDR     (Pin) := No_Pull;
         GPIO.OSPEEDR   (Pin) := Speed_50MHz;
         GPIO.OTYPER    (Pin) := Push_Pull;
      end Configure_Output;

   begin
      Enable_GPIO (Pin.Port);
      Configure_Output (STM32.Registers.GPIO.GPIO_Periph (Pin.Port), Pin.Pin);
   end Configure_Output;

   -----------------
   -- Enable_GPIO --
   -----------------

   procedure Enable_GPIO (Port : STM32.Port) is
      RCC : Interfaces.STM32.RCC.RCC_Peripheral renames
        Interfaces.STM32.RCC.RCC_Periph;
   begin
      case Port is
         when PA =>
            RCC.AHB1ENR.GPIOAEN  := 1;
         when PB =>
            RCC.AHB1ENR.GPIOBEN  := 1;
         when PC =>
            RCC.AHB1ENR.GPIOCEN  := 1;
         when PD =>
            RCC.AHB1ENR.GPIODEN  := 1;
         when PE =>
            RCC.AHB1ENR.GPIOEEN  := 1;
      end case;
   end Enable_GPIO;

   ----------------
   -- Set_Output --
   ----------------

   procedure Set_Output
     (Pin   : STM32.Pin;
      Value : STM32.Bit)
   is
      procedure Set_Output
        (Periph : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin    : Pin_Index;
         Value  : STM32.Bit);

      ----------------
      -- Set_Output --
      ----------------

      procedure Set_Output
        (Periph : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin    : Pin_Index;
         Value  : STM32.Bit)
      is
         use type Interfaces.STM32.Bit;
         use type Interfaces.STM32.UInt16;
      begin
         if Value = 0 then
            Periph.BSRR.BR (Pin) := True;
         else
            Periph.BSRR.BS (Pin) := True;
         end if;
      end Set_Output;

   begin
      Set_Output (STM32.Registers.GPIO.GPIO_Periph (Pin.Port), Pin.Pin, Value);
   end Set_Output;

end STM32.GPIO;
