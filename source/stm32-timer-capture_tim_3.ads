--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  TIM3 device capturing.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.Timer.Capture_TIM_3 is

   procedure Configure
     (Pin      : STM32.Pin;
      Speed    : Interfaces.Unsigned_32;
      Period   : Interfaces.Unsigned_16;
      Polarity : Capture_Polarity)
     with Pre => Pin in (PA, 6) | (PB, 4) | (PC, 6);
   --  Configure TIM3 to capture signals on given pin with speed and period.
   --  The Speed parameter specifies in what units the Period value
   --  is given. For example, to specify value in microseconds, set
   --  Speed => 1_000_000 (1MHz).

   procedure Start (On_Signal : A0B.Callbacks.Callback);
   --  Start capturing signals. Call the On_Signal callback when the
   --  corresponding edge has been detected on the pin. Than use
   --  Captured_Value to get timer's counter when signal was detected. To stop,
   --  call the Stop procedure.

   function Captured_Value return Interfaces.Unsigned_16;
   --  Returns the timer's counter that was when the signal was detected.
   --  Counter is increased from 0 to Period in cycle.

   procedure Stop;
   --  To stop capturing

private

   package Implementation is new Capture_Implementation
     (STM32.Registers.TIM.TIM3_Periph,
      Channel   => 1,
      Interrupt => Ada.Interrupts.Names.TIM3_Interrupt,
      Priority  => Priority);

   procedure Start
     (On_Signal : A0B.Callbacks.Callback) renames Implementation.Start;

   procedure Stop renames Implementation.Stop;

end STM32.Timer.Capture_TIM_3;
