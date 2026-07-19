--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.System_Clocks;
with STM32.Timer.Generic_Polling_Implementation;

package STM32.Timer.Polling_TIM_11 is

   procedure Initialize (Pin : Pin_1_Array := (1 .. 0 => <>))
     with Pre => (for all Item of Pin => Item in (PB, 9) | (PF, 7));
   --  Enable timer and reset it.

   procedure Configure
     (Setting               : Basic_Settings;
      Filter_Clock_Division : Optional_1_2_4 := (Is_Set => False));
   --  Change timer configuration including F_DTS clock division

   function Configuration return Basic_Configuration with Inline;
   --  Return current timer configuration

   procedure Setup (Channel : Capture_Compare_Setting)
     with Pre => (if Channel.Is_Input then Channel.Input = Channel_1);
   --  Configure and enable Capture or Compare channel.

   procedure Enable_Channel (On : Boolean);
   --  Enable or disable already configured Capture/Compare channel.

   procedure Generate_Event (Update, Compare_Capture : Boolean := False);
   --
   --  * Update -
   --    Re-initializes the timer counter and generates an update of the
   --    registers. Note that the prescaler counter is cleared too (but
   --    the prescaler ratio is not affected).
   --
   --  * Compare_Capture -
   --    A capture/compare event is generated on channel 1.
   --    - If CCx is configured as output:
   --      Set the CCxIF flag, send the corresponding interrupt if enabled.
   --
   --    - If CCx is configured as input:
   --      The current counter value is captured in the TIMx_CCRx register. Set
   --      the CCxIF flag, the corresponding interrupt is sent if enabled. Set
   --      the CCxOF flag if the CCxIF flag was already high.

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

   procedure Set_Compare_Value (Value : Interfaces.Unsigned_16);
   --  Assign value to CCR1 register

   function Captured_Value return Interfaces.Unsigned_16;
   --  Return captured value from CCR1 register

private

   pragma Warnings (Off, "volatile actual passed by copy");

   package Implementation is new Generic_Polling_Implementation
     (Periph => STM32.Registers.TIM.TIM11_Periph);

   pragma Warnings (On, "volatile actual passed by copy");

   procedure Configure
     (Setting               : Basic_Settings;
      Filter_Clock_Division : Optional_1_2_4 := (Is_Set => False)) renames
     Implementation.Configure;

   function Configuration return Basic_Configuration renames
     Implementation.Configuration;

   procedure Set_Prescaler (Value : Interfaces.Unsigned_16) renames
     Implementation.Set_Prescaler;

   procedure Set_Counter (Value : Interfaces.Unsigned_16) renames
     Implementation.Set_Counter;

   procedure Set_Auto_Reload_Value (Value : Interfaces.Unsigned_16) renames
     Implementation.Set_Auto_Reload_Value;

   function Counter return Interfaces.Unsigned_16 renames
     Implementation.Counter;

   function Captured_Value return Interfaces.Unsigned_16 is
     (Implementation.Captured_Value (1));

   function Frequency return Positive is
     (Implementation.Frequency (STM32.System_Clocks.TIMCLK2));

end STM32.Timer.Polling_TIM_11;
