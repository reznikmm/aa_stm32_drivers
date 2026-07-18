--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.RCC;

package body STM32.Timer.Polling_TIM_6 is

   procedure Reset is
   begin
      STM32.Registers.RCC.RCC_Periph.APB1ENR.TIM_EN_2_7 (6) := True;
      STM32.Registers.RCC.RCC_Periph.APB1RSTR.TIM_EN_2_7 (6) := True;
      STM32.Registers.RCC.RCC_Periph.APB1RSTR.TIM_EN_2_7 (6) := False;
   end Reset;

   procedure Set_Frequency (Value : Positive) is
   begin
      Implementation.Set_Frequency (Value, STM32.System_Clocks.TIMCLK1);
   end Set_Frequency;

end STM32.Timer.Polling_TIM_6;
