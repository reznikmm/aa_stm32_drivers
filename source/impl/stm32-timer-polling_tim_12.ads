--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.System_Clocks;
with STM32.Timer.Generic_Polling_Implementation;

package STM32.Timer.Polling_TIM_12 is

   procedure Initialize (Pin : Pin_2_Array := (1 .. 0 => <>))
     with Pre =>
       (for all Item of Pin => Item in
          (PB, 14) | (PB, 15) | (PH, 6) | (PH, 9));
   --  Enable timer and reset it.

   procedure Configure
     (Setting               : Basic_Settings;
      Filter_Clock_Division : Optional_1_2_4 := (Is_Set => False));
   --  Change timer configuration including F_DTS clock division

   function Configuration return Basic_Configuration with Inline;
   --  Return current timer configuration

   subtype Master_Timer is Positive
     with Static_Predicate => Master_Timer in 4 | 5 | 13 | 14;

   subtype Trigger_Input_Kind is Timer.Trigger_Input_Kind range
     Other_Timer .. Filtered_Timer_Input;

   type Trigger_Input (Kind : Trigger_Input_Kind := Other_Timer) is record
      case Kind is
         when Other_Timer =>
            Timer : Master_Timer := 4;
         when Edge_Detected =>
            null;  --  TI1 Edge Detector
         when Filtered_Timer_Input =>
            Channel : Positive range 1 .. 2;
      end case;
   end record;

   procedure Setup
     (Slave_Mode    : Timer.Slave_Mode_Kind := Disabled;
      Trigger_Input : Polling_TIM_12.Trigger_Input := (others => <>);
      Channels      : Capture_Compare_Setting_Array := (1 .. 2 => <>);
      Master_Slave  : Boolean := False)
     with Pre => Channels'Last <= 2 and
       not (Slave_Mode = Gated and Trigger_Input.Kind = Edge_Detected) and
       (Trigger_Input.Kind in Other_Timer | Edge_Detected or else
         (for all Channel of Channels =>
            not (Channel.Is_Input and then Channel.Input.Use_Trigger_Input)));
   --  Set slave mode, trigger input, configure and enable Capture/Compare
   --  channels.
   --
   --  Precondition:
   --  * The Gated mode must not be used if TI1F_ED is selected as the trigger
   --    input.
   --  * Capture (Input) channel can use Trigger_Input (TRC) only
   --    for internal triggers (ITRx) or TI1 Edge Detector (TI1F_ED).
   --
   --  * @param Slave_Mode - Slave mode selection (SMCR.SMS)
   --  * @param Trigger_Input - Trigger selection (SMCR.TS)
   --  * @param Channels - Capture/Compare channels configuration
   --  * @param Master_Slave -
   --    The effect of an event on the trigger input is delayed to allow a
   --    perfect synchronization between the current timer and its slaves. It
   --    is useful in order to synchronize several timers on a single external
   --    event.

   procedure Enable_Channel (Channel : Channel_Index; On : Boolean)
     with Pre => Channel <= 2;
   --  Enable or disable already configured Capture/Compare channel.

   procedure Generate_Event
     (Update          : Boolean := False;
      Trigger         : Boolean := False;
      Compare_Capture : Boolean_2_Array := (others => False));
   --
   --  * Update -
   --    Re-initializes the timer counter and generates an update of the
   --    registers. Note that the prescaler counter is cleared too (but
   --    the prescaler ratio is not affected).
   --
   --  * Trigger -
   --    Generates an input trigger event: active edge detected on trigger
   --    input when the slave mode controller is enabled in all modes but gated
   --    mode. When gated mode is selected: starts or stops the counter.
   --
   --  * Compare_Capture (x) -
   --    A capture/compare event is generated on channel x.
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

   procedure Set_Compare_Value
     (Channel : Channel_Index; Value : Interfaces.Unsigned_16)
       with Pre => Channel <= 2;
   --  Assign value to CCRx register

   function Captured_Value
     (Channel : Channel_Index) return Interfaces.Unsigned_16
       with Pre => Channel <= 2;
   --  Return captured value from CCRx register

private

   pragma Warnings (Off, "volatile actual passed by copy");

   package Implementation is new Generic_Polling_Implementation
     (Periph => STM32.Registers.TIM.TIM12_Periph);

   pragma Warnings (On, "volatile actual passed by copy");

   procedure Configure
     (Setting               : Basic_Settings;
      Filter_Clock_Division : Optional_1_2_4 := (Is_Set => False)) renames
     Implementation.Configure;

   procedure Enable_Channel (Channel : Channel_Index; On : Boolean) renames
     Implementation.Enable_Channel;

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

   procedure Set_Compare_Value
     (Channel : Channel_Index; Value : Interfaces.Unsigned_16) renames
       Implementation.Set_Compare_Value;

   function Captured_Value
     (Channel : Channel_Index) return Interfaces.Unsigned_16 renames
       Implementation.Captured_Value;

   function Frequency return Positive is
     (Implementation.Frequency (STM32.System_Clocks.TIMCLK1));

end STM32.Timer.Polling_TIM_12;
