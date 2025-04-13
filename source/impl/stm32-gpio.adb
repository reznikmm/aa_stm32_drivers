--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces.STM32.GPIO;
with Interfaces.STM32.RCC;
with Interfaces.STM32.SYSCFG;
with Interfaces.STM32.EXTI;
with System.STM32;

package body STM32.GPIO is

   procedure Set_Output
     (Periph : in out Interfaces.STM32.GPIO.GPIO_Peripheral;
      Pin    : Pin_Index;
      Value  : Interfaces.STM32.Bit);

   procedure Configure_Output
     (GPIO : in out Interfaces.STM32.GPIO.GPIO_Peripheral;
      Pin  : Pin_Index);

   ---------------------
   -- Clear_Interrupt --
   ---------------------

   procedure Clear_Interrupt (Pin : STM32.Pin) is

      EXTI_Periph : Interfaces.STM32.EXTI.EXTI_Peripheral renames
        Interfaces.STM32.EXTI.EXTI_Periph;

      Value : Interfaces.STM32.EXTI.PR_Register := (others => <>);
   begin
      Value.PR.Arr (Pin.Pin) := True;
      EXTI_Periph.PR := Value;  --  Clear pending
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
        (GPIO : in out Interfaces.STM32.GPIO.GPIO_Peripheral;
         Pin  : Pin_Index);

      -------------------------
      -- Configure_Interrupt --
      -------------------------

      procedure Configure_Interrupt
        (GPIO : in out Interfaces.STM32.GPIO.GPIO_Peripheral;
         Pin  : Pin_Index) is
      begin
         GPIO.MODER.Arr (Pin) := System.STM32.Mode_IN;
         GPIO.PUPDR.Arr (Pin) :=
           (if Pull_Up then System.STM32.Pull_Up
            elsif Pull_Down then System.STM32.Pull_Down
            else System.STM32.No_Pull);
      end Configure_Interrupt;

      EXTI_Periph : Interfaces.STM32.EXTI.EXTI_Peripheral renames
        Interfaces.STM32.EXTI.EXTI_Periph;

      SYSCFG_Periph : Interfaces.STM32.SYSCFG.SYSCFG_Peripheral renames
        Interfaces.STM32.SYSCFG.SYSCFG_Periph;

      EXTICR : array (STM32.Pin_Index range 0 .. 3) of
        Interfaces.STM32.SYSCFG.EXTICR1_Register
          with Import, Address => SYSCFG_Periph.EXTICR1'Address;

      Port : constant Natural :=
        STM32.Port'Pos (Pin.Port) - STM32.Port'Pos (STM32.Port'First);
   begin
      Enable_GPIO (Pin.Port);

      case Pin.Port is
         when PA =>
            Configure_Interrupt (Interfaces.STM32.GPIO.GPIOA_Periph, Pin.Pin);
         when PB =>
            Configure_Interrupt (Interfaces.STM32.GPIO.GPIOB_Periph, Pin.Pin);
         when PC =>
            Configure_Interrupt (Interfaces.STM32.GPIO.GPIOC_Periph, Pin.Pin);
         when PD =>
            Configure_Interrupt (Interfaces.STM32.GPIO.GPIOD_Periph, Pin.Pin);
         when PE =>
            Configure_Interrupt (Interfaces.STM32.GPIO.GPIOE_Periph, Pin.Pin);
      end case;

      EXTICR (Pin.Pin / 4).EXTI.Arr (Pin.Pin mod 4) :=
        Interfaces.STM32.SYSCFG.EXTICR1_EXTI_Element (Port);

      EXTI_Periph.RTSR.TR.Arr (Pin.Pin) := True;  --  Rising trigger
      EXTI_Periph.FTSR.TR.Arr (Pin.Pin) := False;  --  Falling trigger
      EXTI_Periph.PR.PR.Arr (Pin.Pin) := True;  --  Clear pending
      EXTI_Periph.IMR.MR.Arr (Pin.Pin) := True;  --  Unmask interrupt
   end Configure_Interrupt;

   ----------------------
   -- Configure_Output --
   ----------------------

   procedure Configure_Output (Pin : STM32.Pin) is
   begin
      Enable_GPIO (Pin.Port);

      case Pin.Port is
         when PA =>
            Configure_Output (Interfaces.STM32.GPIO.GPIOA_Periph, Pin.Pin);
         when PB =>
            Configure_Output (Interfaces.STM32.GPIO.GPIOB_Periph, Pin.Pin);
         when PC =>
            Configure_Output (Interfaces.STM32.GPIO.GPIOC_Periph, Pin.Pin);
         when PD =>
            Configure_Output (Interfaces.STM32.GPIO.GPIOD_Periph, Pin.Pin);
         when PE =>
            Configure_Output (Interfaces.STM32.GPIO.GPIOE_Periph, Pin.Pin);
      end case;
   end Configure_Output;

   ----------------------
   -- Configure_Output --
   ----------------------

   procedure Configure_Output
     (GPIO : in out Interfaces.STM32.GPIO.GPIO_Peripheral;
      Pin  : Pin_Index) is
   begin
      GPIO.MODER.Arr     (Pin) := System.STM32.Mode_OUT;
      GPIO.PUPDR.Arr     (Pin) := System.STM32.No_Pull;
      GPIO.OSPEEDR.Arr   (Pin) := System.STM32.Speed_50MHz;
      GPIO.OTYPER.OT.Arr (Pin) := System.STM32.Push_Pull;
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

   ------------------------
   -- Pending_Interrupts --
   ------------------------

   function Pending_Interrupts return Pending_Interrupt_Set is
      EXTI_Periph : Interfaces.STM32.EXTI.EXTI_Peripheral renames
        Interfaces.STM32.EXTI.EXTI_Periph;
   begin
      return Pending_Interrupt_Set (EXTI_Periph.PR.PR.Arr (0 .. 15));
   end Pending_Interrupts;

   ----------------
   -- Set_Output --
   ----------------

   procedure Set_Output
     (Periph : in out Interfaces.STM32.GPIO.GPIO_Peripheral;
      Pin    : Pin_Index;
      Value  : Interfaces.STM32.Bit)
   is
      use type Interfaces.STM32.Bit;
      use type Interfaces.STM32.UInt16;
   begin
      if Value = 0 then
         Periph.BSRR.BR.Val := 2 ** Pin;
      else
         Periph.BSRR.BS.Val := 2 ** Pin;
      end if;
   end Set_Output;

   ----------------
   -- Set_Output --
   ----------------

   procedure Set_Output
     (Pin   : STM32.Pin;
      Value : Interfaces.STM32.Bit) is
   begin
      case Pin.Port is
         when PA =>
            Set_Output (Interfaces.STM32.GPIO.GPIOA_Periph, Pin.Pin, Value);
         when PB =>
            Set_Output (Interfaces.STM32.GPIO.GPIOB_Periph, Pin.Pin, Value);
         when PC =>
            Set_Output (Interfaces.STM32.GPIO.GPIOC_Periph, Pin.Pin, Value);
         when PD =>
            Set_Output (Interfaces.STM32.GPIO.GPIOD_Periph, Pin.Pin, Value);
         when PE =>
            Set_Output (Interfaces.STM32.GPIO.GPIOE_Periph, Pin.Pin, Value);
      end case;
   end Set_Output;

end STM32.GPIO;
