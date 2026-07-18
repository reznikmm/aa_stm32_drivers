--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.System_Clocks;
with STM32.Timer.Basic_Polling_Implementation;

package STM32.Timer.Polling_TIM_6 is

   procedure Reset;
   --  Enable timer and reset it.

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

   procedure Set_Frequency (Value : Positive);
   --  Assign prescaler to make timer works on given frequency (Hz).

   function Frequency return Positive;
   --  Return current frequency (Hz) corresponding to the prescaler value
   --  and clock frequency.

   procedure Set_Counter (Value : Interfaces.Unsigned_16);
   --  Change current counter value

   procedure Set_Auto_Reload_Value (Value : Interfaces.Unsigned_16);
   --  Change ARR (Auto-reload register). This is counter upper limit.

   function Counter return Interfaces.Unsigned_16;
   --  Current counter value

private

   pragma Warnings (Off, "volatile actual passed by copy");

   package Implementation is new Basic_Polling_Implementation
     (Periph => STM32.Registers.TIM.TIM6_Periph);

   pragma Warnings (On, "volatile actual passed by copy");

   procedure Configure (Setting : Basic_Settings) renames
     Implementation.Configure;

   function Configuration return Basic_Configuration renames
     Implementation.Configuration;

   procedure Update_Generation renames
     Implementation.Update_Generation;

   procedure Set_Prescaler (Value : Interfaces.Unsigned_16) renames
     Implementation.Set_Prescaler;

   procedure Set_Counter (Value : Interfaces.Unsigned_16) renames
     Implementation.Set_Counter;

   procedure Set_Auto_Reload_Value (Value : Interfaces.Unsigned_16) renames
     Implementation.Set_Auto_Reload_Value;

   function Counter return Interfaces.Unsigned_16 renames
     Implementation.Counter;

   function Frequency return Positive is
     (Implementation.Frequency (STM32.System_Clocks.TIMCLK1));

end STM32.Timer.Polling_TIM_6;
