--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with A0B.Callbacks;
with Ada.Synchronous_Task_Control;
with Tim_Devices;
with STM32.Timer;
with Suspension_Object_Callbacks;

procedure TIM_DMA is
   package TIM renames Tim_Devices.TIM_5;

   Duty   : aliased STM32.Timer.Unsigned_32_Array (1 .. 2) := (2_000, 3_000);
   Count  : Natural := 0;
   Signal : aliased Ada.Synchronous_Task_Control.Suspension_Object;
   Done   : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Signal);
begin
   TIM.Configure_PWM
     (Pins   => (2 => (STM32.PA, 1)),  --  Make only Channel 2 active
      Speed  => 2_000,   --  2kHz
      Period => 4_000,   --  4_000 / 2kHz = 2 seconds
      Duty   => 2_000);  --  2_000 / 2kHz = 1 second

   TIM.Start_PWM_With_Duty
     (Duty    => Duty,
      On_Half => Done);

   loop
      Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);
      Count := Count + 1;

      --  Blink 10 times
      if Count mod 10 = 0 then

         --  Then change blink pattern
         if Count mod 20 = 0 then
            Duty := (2_000, 3_000);
         else
            Duty := (1_000, 2_000);
         end if;
      end if;
   end loop;
end TIM_DMA;
