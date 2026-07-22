--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.System_Clocks;
with STM32.Timer.Generic_Polling_Implementation;

package STM32.Timer.Polling_TIM_5 is

   procedure Initialize (Pin : Pin_4_Array := (1 .. 0 => <>))
     with Pre =>
       (for all Item of Pin => Item in
          (PA, 0) |
          (PA, 1) |
          (PA, 2) |
          (PA, 3));
   --  Enable timer and reset it.

   procedure Configure
     (Setting               : Basic_Settings;
      Filter_Clock_Division : Optional_1_2_4 := (Is_Set => False));
   --  Change timer configuration including F_DTS clock division

   function Configuration return Basic_Configuration with Inline;
   --  Return current timer configuration

   subtype Master_Timer is Positive
     with Static_Predicate => Master_Timer in 2 | 3 | 4 | 8;

   type Trigger_Input (Kind : Trigger_Input_Kind := Other_Timer) is record
      case Kind is
         when Other_Timer =>
            Timer : Master_Timer := 2;
         when Edge_Detected =>
            null;  --  TI1 Edge Detector
         when Filtered_Timer_Input =>
            Channel : Positive range 1 .. 2;
         when External_Trigger =>
            null;  --  ETRF
      end case;
   end record;

   procedure Setup
     (Slave_Mode    : Timer.Slave_Mode_Kind := Disabled;
      Trigger_Input : Polling_TIM_5.Trigger_Input := (others => <>);
      Channels      : Capture_Compare_Setting_Array := (1 .. 4 => <>);
      Master_Slave  : Boolean := False)
     with Pre =>
       not (Slave_Mode = Gated and Trigger_Input.Kind = Edge_Detected) and
       (Trigger_Input.Kind in Other_Timer | Edge_Detected or else
         (for all Channel of Channels =>
            not (Channel.Is_Input and then Channel.Input.Use_Trigger_Input)));
   --  Set slave mode, trigger input, configure and enable Capture/Compare
   --  channels.

   procedure Enable_Channel (Channel : Channel_Index; On : Boolean);
   --  Enable or disable already configured Capture/Compare channel.

   procedure Generate_Event
     (Update          : Boolean := False;
      Trigger         : Boolean := False;
      Compare_Capture : Boolean_4_Array := (others => False));
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

   procedure Set_Counter (Value : Interfaces.Unsigned_32);
   --  Change current counter value

   procedure Set_Auto_Reload_Value (Value : Interfaces.Unsigned_32);
   --  Change ARR (Auto-reload register). This is counter upper limit.

   function Counter return Interfaces.Unsigned_32;
   --  Current counter value

   procedure Set_Compare_Value
     (Channel : Channel_Index; Value : Interfaces.Unsigned_32);
   --  Assign value to CCRx register

   function Captured_Value
     (Channel : Channel_Index) return Interfaces.Unsigned_32;
   --  Return captured value from CCRx register

private

   pragma Warnings (Off, "volatile actual passed by copy");

   package Implementation is new Generic_Polling_Implementation
     (Periph => STM32.Registers.TIM.TIM5_Periph);

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

   function Frequency return Positive is
     (Implementation.Frequency (STM32.System_Clocks.TIMCLK1));

   function Captured_Value
     (Channel : Channel_Index) return Interfaces.Unsigned_32 is
       (STM32.Registers.TIM.TIM5_Periph.CCR (Channel));

   function Counter return Interfaces.Unsigned_32 is
     (STM32.Registers.TIM.TIM5_Periph.CNT);

end STM32.Timer.Polling_TIM_5;
