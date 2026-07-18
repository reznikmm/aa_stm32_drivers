--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.TIM;

generic
   Periph : in out STM32.Registers.TIM.TIM_Peripheral;
package STM32.Timer.Basic_Polling_Implementation is

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

private

   function Counter return Interfaces.Unsigned_16 is
     (Interfaces.Unsigned_16'Mod (Periph.CNT));

end STM32.Timer.Basic_Polling_Implementation;
