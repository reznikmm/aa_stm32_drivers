--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Interrupts;
with System;
with A0B.Callbacks;
with STM32.Registers.TIM;
with STM32.Timer.Generic_Polling_Implementation;

generic
   Periph    : in out STM32.Registers.TIM.TIM_Peripheral;
   Interrupt : Ada.Interrupts.Interrupt_ID;
   Priority  : System.Interrupt_Priority;
package STM32.Timer.Basic_Implementation is

   procedure Configure (Setting : Basic_Settings);
   --  Change timer configuration

   function Configuration return Basic_Configuration with Inline;
   --  Return current timer configuration

   procedure Update_Generation;
   --  Re-initializes the timer counter and generates an update of the
   --  registers. Note that the prescaler counter is cleared too (but
   --  the prescaler ratio is not affected).

   procedure Set_Prescaler (Value : Interfaces.Unsigned_16);
   --  Assign prescaler

   procedure Set_Frequency
     (Value : Positive;
      Clock : Interfaces.Unsigned_32);
   --  Assign prescaler to make timer works on given frequency (Hz).

   function Frequency (Clock : Interfaces.Unsigned_32) return Positive;
   --  Return current frequency (Hz) corresponding to the prescaler value
   --  and clock frequency.

   procedure Set_Counter (Value : Interfaces.Unsigned_16);
   --  Change current counter value

   procedure Set_Auto_Reload_Value (Value : Interfaces.Unsigned_16);
   --  Change ARR (Auto-reload register). This is counter upper limit.

   function Counter return Interfaces.Unsigned_16;
   --  Current counter value

   procedure Set_Callback (On_Update : A0B.Callbacks.Callback);
   --  Assign callback to emit on timer update interrupt.

private

   pragma Warnings (Off, "volatile actual passed by copy");

   package Polling is new Generic_Polling_Implementation
     (Periph => Periph);

   pragma Warnings (On, "volatile actual passed by copy");

   function Counter return Interfaces.Unsigned_16 renames Polling.Counter;

   function Configuration return Basic_Configuration
     renames Polling.Configuration;

   procedure Set_Prescaler
     (Value : Interfaces.Unsigned_16) renames Polling.Set_Prescaler;

   procedure Set_Frequency
     (Value : Positive;
      Clock : Interfaces.Unsigned_32) renames Polling.Set_Frequency;

   function Frequency (Clock : Interfaces.Unsigned_32) return Positive
                          renames Polling.Frequency;

   procedure Set_Counter
     (Value : Interfaces.Unsigned_16) renames Polling.Set_Counter;

   procedure Set_Auto_Reload_Value
     (Value : Interfaces.Unsigned_16) renames Polling.Set_Auto_Reload_Value;

   protected Device
     with Interrupt_Priority => Priority
   is

      procedure Set_Callback (On_Update : A0B.Callbacks.Callback);

   private
      procedure Interrupt_Handler;

      pragma Attach_Handler (Interrupt_Handler, Interrupt);

      Callback : A0B.Callbacks.Callback;
   end Device;

end STM32.Timer.Basic_Implementation;
