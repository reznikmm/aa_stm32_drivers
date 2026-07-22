--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.RCC;

package body STM32.Timer.Polling_TIM_4 is

   procedure Generate_Event
     (Update          : Boolean := False;
      Trigger         : Boolean := False;
      Compare_Capture : Boolean_4_Array := (others => False)) is
   begin
      Implementation.Generate_Event (Update, Trigger, Compare_Capture);
   end Generate_Event;

   procedure Initialize (Pin : Pin_4_Array := (1 .. 0 => <>)) is
   begin
      STM32.Registers.RCC.RCC_Periph.APB1ENR.TIM_EN_2_7 (4) := True;
      STM32.Registers.RCC.RCC_Periph.APB1RSTR.TIM_EN_2_7 (4) := True;
      STM32.Registers.RCC.RCC_Periph.APB1RSTR.TIM_EN_2_7 (4) := False;

      for Item of Pin loop
         Init_GPIO (Item, AF_TIM_3_4_5);
      end loop;
   end Initialize;

   procedure Set_Frequency (Value : Positive) is
   begin
      Implementation.Set_Frequency (Value, STM32.System_Clocks.TIMCLK1);
   end Set_Frequency;

   procedure Setup
     (Slave_Mode    : Timer.Slave_Mode_Kind := Disabled;
      Trigger_Input : Polling_TIM_4.Trigger_Input := (others => <>);
      Channels      : Capture_Compare_Setting_Array := (1 .. 4 => <>);
      Master_Slave  : Boolean := False)
   is
      Input : constant Implementation.Trigger_Input :=
        (case Trigger_Input.Kind is
            when Other_Timer =>
              (Kind => Other_Timer,
               Master =>
                 (case Trigger_Input.Timer is
                     when 1 => 0,
                     when 2 => 1,
                     when 3 => 2,
                     when 8 => 3)),
            when Edge_Detected =>
              (Kind => Edge_Detected),
            when Filtered_Timer_Input =>
              (Filtered_Timer_Input, Trigger_Input.Channel),
            when External_Trigger =>
              (Kind => External_Trigger));
   begin
      Implementation.Setup_As_Slave (Slave_Mode, Input, Master_Slave);
      Implementation.Enable_Channel (Channels);
   end Setup;

end STM32.Timer.Polling_TIM_4;
