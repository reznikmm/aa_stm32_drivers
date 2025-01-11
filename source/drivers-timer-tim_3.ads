--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Interrupts.Names;
with Interfaces;
with System;

with A0B.Callbacks;

package Drivers.Timer.TIM_3 is

   type Device (Priority : System.Any_Priority) is limited private;
   --  TIM3 device. Priority is used for underlying protected object.

   procedure Configure
     (Self  : in out Device;
      Pin   : Drivers.Pin;
      Speed : Interfaces.Unsigned_32)
     with Pre =>
       Pin in ('C', 8);
   --
   --  Configure TIM3 on given pins and speed

   procedure Start_PWM
     (Self   : in out Device;
      Period : Interfaces.Unsigned_16;
      Duty   : Interfaces.Unsigned_16;
      Done   : A0B.Callbacks.Callback);

private

   package Implementation is new TIM_Implementation
     (Interfaces.STM32.TIM.TIM3_Periph);

   protected type Device (Priority : System.Any_Priority)
     with Priority => Priority
   is

      procedure Start_PWM
        (Period : Interfaces.Unsigned_16;
         Duty   : Interfaces.Unsigned_16;
         Done   : A0B.Callbacks.Callback);

   private
      procedure Interrupt;

      pragma Attach_Handler (Interrupt, Ada.Interrupts.Names.TIM3_Interrupt);

      Data : Implementation.Internal_Data;
   end Device;


end Drivers.Timer.TIM_3;
