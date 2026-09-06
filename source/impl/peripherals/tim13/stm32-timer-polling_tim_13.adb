--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.RCC;

package body STM32.Timer.Polling_TIM_13 is

   procedure Setup (Channel : Capture_Compare_Setting) is
   begin
      Implementation.Enable_Channel ((1 => Channel));
   end Setup;

   procedure Enable_Channel (On : Boolean) is
   begin
      Implementation.Enable_Channel (1, On);
   end Enable_Channel;

   procedure Generate_Event
     (Update, Compare_Capture : Boolean := False) is
   begin
      Implementation.Generate_Event
        (Update,
         Compare_Capture => (1 => Compare_Capture, others => False));
   end Generate_Event;

   procedure Initialize (Pin : Pin_1_Array := (1 .. 0 => <>)) is
   begin
      STM32.Registers.RCC.RCC_Periph.APB1ENR.TIM_EN_12_14 (13) := True;
      STM32.Registers.RCC.RCC_Periph.APB1RSTR.TIM_EN_12_14 (13) := True;
      STM32.Registers.RCC.RCC_Periph.APB1RSTR.TIM_EN_12_14 (13) := False;

      for Item of Pin loop
         Init_GPIO (Item, AF_TIM_12_14);
      end loop;
   end Initialize;

   procedure Set_Compare_Value (Value : Interfaces.Unsigned_16) is
   begin
      Implementation.Set_Compare_Value (1, Value);
   end Set_Compare_Value;

   procedure Set_Frequency (Value : Positive) is
   begin
      Implementation.Set_Frequency (Value, STM32.System_Clocks.TIMCLK1);
   end Set_Frequency;

end STM32.Timer.Polling_TIM_13;
