--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  TIM3 device.

with Ada.Interrupts.Names;
with Interfaces;
with System;

with A0B.Callbacks;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.Timer.TIM_3 is

   procedure Configure
     (Pin   : STM32.Pin;
      Speed : Interfaces.Unsigned_32)
     with Pre =>
       Pin in (PC, 8);
   --
   --  Configure TIM3 on given pins and speed

   procedure Start_PWM
     (Period : Interfaces.Unsigned_16;
      Duty   : Interfaces.Unsigned_16;
      Done   : A0B.Callbacks.Callback);
   --  Set PWM setting to by applied on the next cycle and returns. When
   --  settings are applied, it triggers a callback provided as a parameter.

private

   package Implementation is new TIM_Implementation
     (STM32.Registers.TIM.TIM3_Periph,
      Channel   => 3,
      Interrupt => Ada.Interrupts.Names.TIM3_Interrupt,
      Priority  => Priority);

end STM32.Timer.TIM_3;
