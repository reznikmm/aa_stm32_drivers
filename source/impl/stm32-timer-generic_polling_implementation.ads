--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.TIM;

generic
   Periph : in out STM32.Registers.TIM.TIM_Peripheral;
package STM32.Timer.Generic_Polling_Implementation is

   procedure Configure
     (Setting               : Basic_Settings;
      Filter_Clock_Division : Optional_1_2_4);
   --  Change timer configuration including F_DTS clock division

   function Configuration return Basic_Configuration with Inline;
   --  Return current timer configuration

   type Trigger_Input (Kind : Trigger_Input_Kind := Edge_Detected) is record
      case Kind is
         when Other_Timer =>
            Master : Natural range 0 .. 3;
         when Edge_Detected =>
            null;
         when Filtered_Timer_Input =>
            Channel : Positive range 1 .. 2;
         when External_Trigger =>
            null;
      end case;
   end record;

   type Slave_Mode (Kind : Slave_Mode_Kind := Disabled) is record
      case Kind is
         when Disabled | External_Clock =>
            null;
         when others =>
            Input : Trigger_Input;
      end case;
   end record;

   procedure Setup_As_Slave
     (Slave_Mode    : Slave_Mode_Kind := Disabled;
      Trigger_Input : Generic_Polling_Implementation.Trigger_Input;
      Master_Slave  : Boolean := False);
   --  Configure slave mode control register (TIMx_SMCR)

   procedure Enable_Channel (Setting : Capture_Compare_Setting_Array);
   --  Configure and enable Capture or Compare channel.

   procedure Enable_Channel (Channel : Channel_Index; On : Boolean);
   --  Enable or disable already configured Capture/Compare channel.

   procedure Generate_Event
     (Update          : Boolean := False;
      Trigger         : Boolean := False;
      Compare_Capture : Boolean_4_Array := (others => False));
   --  Generate selected events:
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

   procedure Set_Compare_Value
     (Channel : Channel_Index;
      Value   : Interfaces.Unsigned_16);
   --  Assign value to CCRx register

   function Captured_Value
     (Channel : Channel_Index) return Interfaces.Unsigned_16;
   --  Return captured value from CCRx register

private

   function Counter return Interfaces.Unsigned_16 is
     (Interfaces.Unsigned_16'Mod (Periph.CNT));

   function Captured_Value
     (Channel : Channel_Index) return Interfaces.Unsigned_16 is
       (Interfaces.Unsigned_16'Mod (Periph.CCR (Channel)));

end STM32.Timer.Generic_Polling_Implementation;
