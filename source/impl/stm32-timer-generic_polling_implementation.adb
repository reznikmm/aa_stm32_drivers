--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

package body STM32.Timer.Generic_Polling_Implementation is

   procedure Enable_Channel
     (Channel : Channel_Index;
      Setting : Capture_Compare_Setting);

   procedure Configure
     (Setting               : Basic_Settings;
      Filter_Clock_Division : Optional_1_2_4)
   is
      CR1 : STM32.Registers.TIM.CR1_Register := Periph.CR1;
   begin
      if Setting.Auto_Reload_Buffered.Is_Set then
         CR1.ARPE := Setting.Auto_Reload_Buffered.Value;
      end if;

      if Setting.One_Pulse_Mode.Is_Set then
         CR1.OPM := Setting.One_Pulse_Mode.Value;
      end if;

      if Setting.Update_Request.Is_Set then
         CR1.URS := not Setting.Update_Request.Value;
      end if;

      if Setting.Update_Disable.Is_Set then
         CR1.UDIS := Setting.Update_Disable.Value;
      end if;

      if Setting.Enable.Is_Set then
         CR1.CEN := Setting.Enable.Value;
      end if;

      if Filter_Clock_Division.Is_Set then
         CR1.CKD :=
           (case Filter_Clock_Division.Value is
               when 1 => 0,
               when 2 => 1,
               when 4 => 2);
      end if;

      Periph.CR1 := CR1;
   end Configure;

   function To_Basic_Configuration
     (CR1 : STM32.Registers.TIM.CR1_Register) return Basic_Configuration is
      (Auto_Reload_Buffered => CR1.ARPE,
       One_Pulse_Mode       => CR1.OPM,
       Update_Request       => not CR1.URS,
       Update_Disable       => CR1.UDIS,
       Enable               => CR1.CEN) with Inline;

   function Configuration return Basic_Configuration is
      (To_Basic_Configuration (Periph.CR1));

   procedure Enable_Channel
     (Channel : Channel_Index;
      Setting : Capture_Compare_Setting)
   is
      Low  : constant Natural range 0 .. 1 := (Channel - 1) mod 2;
      High : constant Natural range 0 .. 1 := (Channel - 1) / 2;
   begin
      Periph.CCER (Channel) :=
        (CCxE => False, CCxP => 0, CCxNE => False, CCxNP => 0);

      if Setting.Is_Input then
         Periph.CCMR (High).CCMR_Input (Low) :=
           (CCxS   =>
              (if Setting.Input.Use_Trigger_Input then 3
               elsif Channel = Setting.Input.Channel then 1
               else 2),
            ICxPCS =>
              (case Setting.Prescaler is
                  when 1 => 0,
                  when 2 => 1,
                  when 4 => 2,
                  when 8 => 3),
            ICxF =>
              (case Setting.Filter.Kind is
                  when No_Filter => 0,
                  when F_CK_INT =>
                    (case Setting.Filter.Count is
                     when 2 => 1,
                     when 4 => 2,
                     when 8 => 3,
                     when others => raise Constraint_Error),
                  when F_DTS =>
                    (case Setting.Filter.Divider is
                     when 2 =>
                       (case Setting.Filter.Count is
                        when 6 => 4,
                        when 8 => 5,
                        when others => raise Constraint_Error),
                     when 4 =>
                       (case Setting.Filter.Count is
                        when 6 => 6,
                        when 8 => 7,
                        when others => raise Constraint_Error),
                     when 8 =>
                       (case Setting.Filter.Count is
                        when 6 => 8,
                        when 8 => 9,
                        when others => raise Constraint_Error),
                     when 16 =>
                       (case Setting.Filter.Count is
                        when 5 => 10,
                        when 6 => 11,
                        when 8 => 12,
                        when others => raise Constraint_Error),
                     when 32 =>
                       (case Setting.Filter.Count is
                        when 5 => 13,
                        when 6 => 14,
                        when 8 => 15,
                        when others => raise Constraint_Error))));
      else
         Periph.CCMR (High).CCMR_Output (Low) :=
           (CCxS  => 0,
            OCxFE => Setting.Fast_PWM,
            OCxPE => Setting.Compare_Value_Preload,
            OCxM  => Compare_Mode'Pos (Setting.Compare_Mode),
            OCxCE => False);
      end if;

      Periph.CCER (Channel) :=
        (CCxE => True,
         CCxP =>
           (if not Setting.Is_Input then 1 - Setting.Active_Level
            elsif Setting.Falling_Edge then 1
            elsif Setting.Rising_Edge then 0
            else raise Constraint_Error),
         CCxNE => False,  --  complementary output enable
         CCxNP =>
           (if Setting.Is_Input
              and then Setting.Rising_Edge
              and then Setting.Falling_Edge then 1 else 0));
   end Enable_Channel;

   procedure Enable_Channel (Setting : Capture_Compare_Setting_Array) is
   begin
      for J in Setting'Range loop
         Enable_Channel (J, Setting (J));
      end loop;
   end Enable_Channel;

   procedure Enable_Channel (Channel : Channel_Index; On : Boolean) is
   begin
      Periph.CCER (Channel).CCxE := On;
   end Enable_Channel;

   function Frequency (Clock : Interfaces.Unsigned_32) return Positive is
      use type Interfaces.Unsigned_32;
   begin
      return Positive (Clock / (Periph.PSC + 1));
   end Frequency;

   procedure Generate_Event
     (Update          : Boolean := False;
      Trigger         : Boolean := False;
      Compare_Capture : Boolean_2_Array := (others => False)) is
   begin
      Periph.EGR :=
        (UG       => Update,
         TG       => Trigger,
         Reserved => 0,
         CCxG     =>
           (1 => Compare_Capture (1),
            2 => Compare_Capture (2),
            others => False),
         others   => False);
   end Generate_Event;

   procedure Set_Frequency
     (Value : Positive;
      Clock : Interfaces.Unsigned_32)
   is
      use type Interfaces.Unsigned_32;
      Prescaler : Interfaces.Unsigned_32 :=
       Clock / Interfaces.Unsigned_32 (Value);
   begin
      Prescaler := Interfaces.Unsigned_32'Max (Prescaler, 1);
      Prescaler := Interfaces.Unsigned_32'Min (Prescaler, 2**16);
      Set_Prescaler (Interfaces.Unsigned_16 (Prescaler - 1));
   end Set_Frequency;

   procedure Set_Compare_Value
     (Channel : Channel_Index;
      Value  : Interfaces.Unsigned_16) is
   begin
      Periph.CCR (Channel) := Interfaces.Unsigned_32 (Value);
   end Set_Compare_Value;

   procedure Set_Prescaler (Value : Interfaces.Unsigned_16) is
   begin
      Periph.PSC := Interfaces.Unsigned_32 (Value);
   end Set_Prescaler;

   procedure Set_Counter (Value : Interfaces.Unsigned_16) is
   begin
      Periph.CNT := Interfaces.Unsigned_32 (Value);
   end Set_Counter;

   procedure Set_Auto_Reload_Value (Value : Interfaces.Unsigned_16) is
   begin
      Periph.ARR := Interfaces.Unsigned_32 (Value);
   end Set_Auto_Reload_Value;

   procedure Setup_As_Slave
     (Slave_Mode    : Slave_Mode_Kind := Disabled;
      Trigger_Input : Generic_Polling_Implementation.Trigger_Input;
      Master_Slave  : Boolean := False)
   is
      TS : constant Natural range 0 .. 7 :=
        (case Trigger_Input.Kind is
            when Other_Timer => Trigger_Input.Master,
            when Edge_Detected => 4,
            when Filtered_Timer_Input => 4 + Trigger_Input.Channel,
            when External_Trigger => 7);
   begin
      Periph.SMCR :=
        (SMS      =>
           (case Slave_Mode is
               when Disabled => 0,
               when Reset => 4,
               when Gated => 5,
               when Trigger => 6,
               when External_Clock => 7),
         Reserved => 0,
         TS       => Interfaces.Unsigned_32 (TS),
         MSM      => Master_Slave,
         ETF      => 0,
         ETPS     => 0,
         ECE      => False,
         ETP      => False);
   end Setup_As_Slave;

end STM32.Timer.Generic_Polling_Implementation;
