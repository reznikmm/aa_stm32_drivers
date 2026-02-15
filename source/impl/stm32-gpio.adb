--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.EXTI;
with STM32.Registers.GPIO;
with STM32.Registers.RCC;
with STM32.Registers.SYSCFG;

package body STM32.GPIO is

   ---------------------
   -- Clear_Interrupt --
   ---------------------

   procedure Clear_Interrupt (Pin : STM32.Pin) is

      EXTI_Periph : STM32.Registers.EXTI.EXTI_Peripheral renames
        STM32.Registers.EXTI.EXTI_Periph;

      Value : STM32.Registers.EXTI.Boolean_Array_23 := (others => False);
   begin
      Value (Natural (Pin.Pin)) := True;
      EXTI_Periph.PR := Value;  --  Clear pending
   end Clear_Interrupt;

   ---------------------
   -- Configure_Input --
   ---------------------

   procedure Configure_Input
     (Pin       : STM32.Pin;
      Pull_Up   : Boolean := False;
      Pull_Down : Boolean := False)
   is
      Device : STM32.Registers.GPIO.GPIO_Peripheral renames
        STM32.Registers.GPIO.GPIO_Periph (Pin.Port);
   begin
      Enable_GPIO (Pin.Port);
      Device.MODER (Pin.Pin) := STM32.Registers.GPIO.Mode_IN;
      Device.PUPDR (Pin.Pin) :=
        (if Pull_Up then STM32.Registers.GPIO.Pull_Up
         elsif Pull_Down then STM32.Registers.GPIO.Pull_Down
         else STM32.Registers.GPIO.No_Pull);
   end Configure_Input;

   -------------------------
   -- Configure_Interrupt --
   -------------------------

   procedure Configure_Interrupt
     (Pin       : STM32.Pin;
      Pull_Up   : Boolean := False;
      Pull_Down : Boolean := False)
   is

      EXTI_Periph : STM32.Registers.EXTI.EXTI_Peripheral renames
        STM32.Registers.EXTI.EXTI_Periph;

      SYSCFG_Periph : STM32.Registers.SYSCFG.SYSCFG_Peripheral renames
        STM32.Registers.SYSCFG.SYSCFG_Periph;

      GPIO_Periph : STM32.Registers.GPIO.GPIO_Peripheral renames
        STM32.Registers.GPIO.GPIO_Periph (Pin.Port);

   begin
      Enable_GPIO (Pin.Port);

      GPIO_Periph.MODER (Pin.Pin) := STM32.Registers.GPIO.Mode_IN;
      GPIO_Periph.PUPDR (Pin.Pin) :=
        (if Pull_Up then STM32.Registers.GPIO.Pull_Up
         elsif Pull_Down then STM32.Registers.GPIO.Pull_Down
         else STM32.Registers.GPIO.No_Pull);

      SYSCFG_Periph.EXTICR (Pin.Pin / 4).EXTI (Pin.Pin mod 4) :=
        STM32.Port'Pos (Pin.Port);

      EXTI_Periph.RTSR (Natural (Pin.Pin)) := True;  --  Rising trigger
      EXTI_Periph.FTSR (Natural (Pin.Pin)) := False;  --  Falling trigger
      EXTI_Periph.PR (Natural (Pin.Pin)) := True;  --  Clear pending
      EXTI_Periph.IMR (Natural (Pin.Pin)) := True;  --  Unmask interrupt
   end Configure_Interrupt;

   ----------------------
   -- Configure_Output --
   ----------------------

   procedure Configure_Output
     (Pin       : STM32.Pin;
      Pull_Up   : Boolean := False;
      Pull_Down : Boolean := False)
   is

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
         GPIO.MODER   (Pin) := STM32.Registers.GPIO.Mode_OUT;
         GPIO.PUPDR   (Pin) :=
           (if Pull_Up then STM32.Registers.GPIO.Pull_Up
            elsif Pull_Down then STM32.Registers.GPIO.Pull_Down
            else STM32.Registers.GPIO.No_Pull);
         GPIO.OSPEEDR (Pin) := STM32.Registers.GPIO.Speed_50MHz;
         GPIO.OTYPER  (Pin) := STM32.Registers.GPIO.Push_Pull;
      end Configure_Output;

   begin
      Enable_GPIO (Pin.Port);
      Configure_Output (STM32.Registers.GPIO.GPIO_Periph (Pin.Port), Pin.Pin);
   end Configure_Output;

   -----------------
   -- Enable_GPIO --
   -----------------

   procedure Enable_GPIO (Port : STM32.Port) is
      RCC : STM32.Registers.RCC.RCC_Peripheral renames
        STM32.Registers.RCC.RCC_Periph;
   begin
      RCC.AHB1ENR.GPIOxEN (Port) := True;
   end Enable_GPIO;

   ---------------
   -- Get_Input --
   ---------------

   function Get_Input (Pin : STM32.Pin) return STM32.Bit is
     (Boolean'Pos
       (STM32.Registers.GPIO.GPIO_Periph (Pin.Port).IDR.Arr (Pin.Pin)));

   ------------------------
   -- Pending_Interrupts --
   ------------------------

   function Pending_Interrupts return Pending_Interrupt_Set is
      EXTI_Periph : STM32.Registers.EXTI.EXTI_Peripheral renames
        STM32.Registers.EXTI.EXTI_Periph;
   begin
      return Pending_Interrupt_Set (EXTI_Periph.PR (0 .. 15));
   end Pending_Interrupts;

   ----------------
   -- Set_Output --
   ----------------

   procedure Set_Output
     (Pin   : STM32.Pin;
      Value : STM32.Bit)
   is
      Device : STM32.Registers.GPIO.GPIO_Peripheral renames
        STM32.Registers.GPIO.GPIO_Periph (Pin.Port);
   begin
      if Value = 0 then
         Device.BSRR.BR (Pin.Pin) := True;
      else
         Device.BSRR.BS (Pin.Pin) := True;
      end if;
   end Set_Output;

end STM32.GPIO;
