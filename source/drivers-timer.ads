--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Common code for timer drivers.
--
--  Child packages provide a type and operations for a particular timer device.
--  The type is a protected type with priority descriminant. Its
--  Start_PWM operation sets PWM setting to by applied on the next cycle and
--  returns. When settings are applied, it triggers a callback provided as
--  a parameter.

private with Interfaces.STM32.GPIO;
private with Interfaces.STM32.TIM;

private with A0B.Callbacks;

package Drivers.Timer is

private

   procedure Init_GPIO (Item : Pin);

   procedure Init_GPIO
     (Periph : in out Interfaces.STM32.GPIO.GPIO_Peripheral;
      Pin  : Pin_Index);

   generic
      Periph : in out Interfaces.STM32.TIM.TIM3_Peripheral;
   package TIM_Implementation is
      --  Generic implementation for timer initializaion, operations and
      --  interrupt handling procedure

      type Internal_Data is limited private;

      procedure Configure
        (Pin   : Drivers.Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.STM32.UInt32);

      procedure On_Interrupt (Self : in out Internal_Data);

      procedure Start_PWM
        (Self   : in out Internal_Data;
         Period : Interfaces.Unsigned_16;
         Duty   : Interfaces.Unsigned_16;
         Done   : A0B.Callbacks.Callback);

   private

      type Internal_Data is limited record
         ARR  : Interfaces.STM32.TIM.ARR_ARR_L_Field;
         CCR  : Interfaces.STM32.TIM.CCR3_CCR3_L_Field;
         Done : A0B.Callbacks.Callback;
      end record;

   end TIM_Implementation;

end Drivers.Timer;
