--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Common code for timer STM32.
--
--  Child packages provide generics with operations for a particular timer
--  device. The device generic package is instantinated with the priority. Its
--  Start_PWM operation sets PWM setting to by applied on the next cycle and
--  returns. When settings are applied, it triggers a callback provided as
--  a parameter.

private with Ada.Interrupts;
with Interfaces;
private with System;

private with STM32.Registers.TIM;
private with STM32.DMA;

private with A0B.Callbacks;

package STM32.Timer is

   subtype Channel_Index is Positive range 1 .. 4;

   type Pin_Array is array (Channel_Index range <>) of STM32.Pin;

   type Unsigned_16_Array is array (Positive range <>)
     of Interfaces.Unsigned_16;

   type Unsigned_32_Array is array (Positive range <>)
     of Interfaces.Unsigned_32;

   type Capture_Polarity is (Rising_Edge, Falling_Edge, Both_Edges);

   type Optional_Boolean (Is_Set : Boolean := False) is record
      case Is_Set is
         when True =>
            Value : Boolean;
         when False =>
            null;
      end case;
   end record;

   function True  return Optional_Boolean is (True, True);
   function False return Optional_Boolean is (True, False);

   type Basic_Settings is record
      Auto_Reload_Buffered : Optional_Boolean;
      --  Auto-reload register (ARR) preload enable
      One_Pulse_Mode : Optional_Boolean;
      --  Stop counter at the next update event
      Update_Request : Optional_Boolean;
      --  If True Update Generation triggers interrupt or DMA
      Update_Disable : Optional_Boolean;
      --  If True the Update event is not generated, shadow registers keep
      --  their value (ARR, PSC). However the counter and the prescaler are
      --  reinitialized
      Enable : Optional_Boolean;
      --  Counter enabled
   end record;

   type Basic_Configuration is record
      Auto_Reload_Buffered : Boolean;
      --  Auto-reload register (ARR) preload enable
      One_Pulse_Mode : Boolean;
      --  Stop counter at the next update event
      Update_Request : Boolean;
      --  If True Update Generation triggers interrupt or DMA
      Update_Disable : Boolean;
      --  If True the Update event is not generated, shadow registers keep
      --  their value (ARR, PSC). However the counter and the prescaler are
      --  reinitialized
      Enable : Boolean;
      --  Counter enabled
   end record;

   type Division_1_4 is range 1 .. 4
     with Static_Predicate => Division_1_4 in 1 | 2 | 4;

   type Optional_1_2_4 (Is_Set : Boolean := False) is record
      case Is_Set is
         when True =>
            Value : Division_1_4;
         when False =>
            null;
      end case;
   end record;

   type Compare_Mode is
     (Frozen,
      --  The comparison between the output compare value and the counter has
      --  no effect on the outputs.
      Active_On_Match,
      --  Set channel to active level when the counter matches the compare
      --  value.
      Inactive_On_Match,
      --  Set channel to inactive level when the counter matches the compare
      --  value.
      Toggle_On_Match,
      --  Toggle channel when the counter matches the compare value.
      Force_Inactive,
      --  Force channel to inactive level
      Force_Active,
      --  Force channel to active level
      PWM_Active,
      --  Channel is active as long as counter less than the compare value.
      PWM_Inactive);
      --  Channel is inactive as long as counter less than the compare value.

   type Input_Filter_Kind is (No_Filter, F_CK_INT, F_DTS);

   type Division_2_32 is range 2 .. 32
     with Static_Predicate => Division_2_32 in 2 | 4 | 8 | 16 | 32;

   type Input_Capture_Filter (Kind : Input_Filter_Kind := No_Filter) is record
      case Kind is
         when No_Filter =>
            null;
         when others =>
            Count : Positive range 2 .. 8;
            case Kind is
               when F_DTS =>
                  Divider : Division_2_32;
               when others =>
                  null;
            end case;
      end case;
   end record;

   type Division_1_8 is range 1 .. 8
     with Static_Predicate => Division_1_8 in 1 | 2 | 4 | 8;

   type Compare_Input (Use_Trigger_Input : Boolean := False) is record
      case Use_Trigger_Input is
         when True =>
            null;
         when False =>
            Channel : Channel_Index := 1;
      end case;
   end record;
   --  Define input for a compare channel

   Channel_1 : constant Compare_Input :=
     (Use_Trigger_Input => False, Channel => 1);

   type Capture_Compare_Setting (Is_Input : Boolean := False) is record
      case Is_Input is
         when True =>
            Rising_Edge  : Boolean := True;
            Falling_Edge : Boolean := False;
            Filter       : Input_Capture_Filter;
            Prescaler    : Division_1_8 := 1;
            Input        : Compare_Input;
         when False =>
            Active_Level          : Bit := 1;
            Compare_Mode          : STM32.Timer.Compare_Mode := Frozen;
            Compare_Value_Preload : Boolean := False;
            Fast_PWM              : Boolean := False;  --  See OC1FE in RM090
      end case;
   end record
     with Dynamic_Predicate =>
       (if Capture_Compare_Setting.Is_Input
        then Capture_Compare_Setting.Rising_Edge or
          Capture_Compare_Setting.Falling_Edge);

   type Capture_Compare_Setting_Array is array (Channel_Index range <>) of
     Capture_Compare_Setting
       with Dynamic_Predicate =>
        (for all Channel in Capture_Compare_Setting_Array'Range =>
           Input_Channel_Matches_Index
             (Capture_Compare_Setting_Array (Channel), Channel));
    --  Capture channel 1..2 can have Input.Channel 1|2 only.
    --  Capture channel 3..4 can have Input.Channel 3|4 only.

   subtype Positive_1 is Positive range 1 .. 1;
   subtype Positive_2 is Positive range 1 .. 2;
   subtype Positive_4 is Positive range 1 .. 4;

   type Pin_1_Array is array (Positive_1 range <>) of Pin;
   type Pin_2_Array is array (Positive_2 range <>) of Pin;
   type Pin_4_Array is array (Positive_4 range <>) of Pin;

   type Boolean_2_Array is array (Channel_Index range 1 .. 2) of Boolean;
   type Boolean_4_Array is array (Channel_Index) of Boolean;

   type Slave_Mode_Kind is
     (Disabled,
      Reset,
      --  Rising edge of the selected trigger input reinitializes the counter
      --  and generates an update of the registers
      Gated,
      --  The counter clock is enabled when the trigger input is high. The
      --  counter stops (but is not reset) as soon as the trigger becomes
      --  low. Counter starts and stops are both controlled
      Trigger,
      --  The counter starts on a rising edge of the trigger (but it is not
      --  reset). Only the start of the counter is controlled
      External_Clock
      --  Rising edges of the selected trigger clock the counter
   );

   type Trigger_Input_Kind is
     (Other_Timer,           --  Internal Trigger 0..3
      Edge_Detected,         --  TI1 Edge Detector
      Filtered_Timer_Input,  --  Filtered Timer Input 1..2
      External_Trigger);

private

   procedure Init_GPIO (Item : Pin; Fun : Interfaces.Unsigned_32);

   AF_TIM_1_2   : constant := 1;
   AF_TIM_3_4_5 : constant := 2;
   AF_TIM_8_11  : constant := 3;
   AF_TIM_12_14 : constant := 9;

   generic
      Periph    : in out STM32.Registers.TIM.TIM_Peripheral;
      Channel   : Channel_Index;
      Interrupt : Ada.Interrupts.Interrupt_ID;
      Priority  : System.Interrupt_Priority;
   package TIM_Implementation is
      --  Generic implementation for timer initializaion, operations and
      --  interrupt handling procedure

      procedure Configure
        (Pin   : STM32.Pin;
         Fun   : Interfaces.Unsigned_32;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32);

      protected Device
        with Interrupt_Priority => Priority
      is

         procedure Start_PWM
           (Period : Interfaces.Unsigned_16;
            Duty   : Interfaces.Unsigned_16;
            Done   : A0B.Callbacks.Callback);

      private
         procedure Interrupt_Handler;

         pragma Attach_Handler (Interrupt_Handler, Interrupt);

         ARR  : Interfaces.Unsigned_32;
         CCR  : Interfaces.Unsigned_32;
         Done : A0B.Callbacks.Callback;
      end Device;

   end TIM_Implementation;

   generic
      Periph    : in out STM32.Registers.TIM.TIM_Peripheral;
      Channel   : STM32.DMA.Channel_Id;

      type Register_Value is mod <>;
      type Register_Value_Array is array (Positive range <>) of Register_Value;

      with package Stream is new STM32.DMA.Generic_DMA_Stream (<>);
   package DMA_Implementation is

      procedure Configure
        (Pin    : Pin_Array;
         Fun    : Interfaces.Unsigned_32;
         Speed  : Interfaces.Unsigned_32;
         Period : Interfaces.Unsigned_32;
         Duty   : Interfaces.Unsigned_32;
         Clock  : Interfaces.Unsigned_32);

      procedure Start_PWM_Duty
        (Duty    : Register_Value_Array;
         On_Half : A0B.Callbacks.Callback);

      procedure Start_PWM_Period
        (Period  : Register_Value_Array;
         On_Half : A0B.Callbacks.Callback);

      procedure Start_PWM
        (Data    : Register_Value_Array;
         On_Half : A0B.Callbacks.Callback);
      --  Data: Period + N x Duty

      procedure Stop;

   end DMA_Implementation;

   generic
      Periph    : in out STM32.Registers.TIM.TIM_Peripheral;
      Channel   : Channel_Index;
      Interrupt : Ada.Interrupts.Interrupt_ID;
      Priority  : System.Interrupt_Priority;
   package Capture_Implementation is
      --  Generic implementation for timer capturing initializaion, operations
      --  and interrupt handling procedure

      procedure Configure
        (Pin      : STM32.Pin;
         Fun      : Interfaces.Unsigned_32;
         Speed    : Interfaces.Unsigned_32;
         Period   : Interfaces.Unsigned_32;
         Polarity : Capture_Polarity;
         Clock    : Interfaces.Unsigned_32);

      procedure Start (On_Signal : A0B.Callbacks.Callback);

      function Captured_Value return Interfaces.Unsigned_32;

      procedure Stop;

      protected Device
        with Interrupt_Priority => Priority
      is

         procedure Set_Callback (On_Signal : A0B.Callbacks.Callback);
         function Captured_Value return Interfaces.Unsigned_32;

      private
         procedure Interrupt_Handler;

         pragma Attach_Handler (Interrupt_Handler, Interrupt);

         Value    : Interfaces.Unsigned_32 := 0;
         Callback : A0B.Callbacks.Callback;
      end Device;

   end Capture_Implementation;

   function Input_Channel_Matches_Index
     (Item    : Capture_Compare_Setting;
      Channel : Channel_Index) return Boolean is
       (if Item.Is_Input and then not Item.Input.Use_Trigger_Input then
         (if Channel in 1 .. 2 then Item.Input.Channel in 1 | 2
          else Item.Input.Channel in 3 | 4));

end STM32.Timer;
