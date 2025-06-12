--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.System_Clocks;
with STM32.Registers.RCC;

package body STM32.Timer.DMA_TIM_5 is

   -------------------
   -- Configure_PWM --
   -------------------

   procedure Configure_PWM
     (Pins    : Pin_Array;
      Speed   : Interfaces.Unsigned_32;
      Period  : Interfaces.Unsigned_32;
      Duty    : Interfaces.Unsigned_32) is
   begin
      STM32.Registers.RCC.RCC_Periph.APB1ENR.TIM_EN_2_7 (5) := True;
      STM32.Registers.RCC.RCC_Periph.APB1RSTR.TIM_EN_2_7 (5) := True;
      STM32.Registers.RCC.RCC_Periph.APB1RSTR.TIM_EN_2_7 (5) := False;

      Implementation.Configure
        (Pin    => Pins,
         Fun    => AF_TIM_3_4_5,
         Speed  => Speed,
         Period => Period,
         Duty   => Duty,
         Clock  => STM32.System_Clocks.TIMCLK1);
   end Configure_PWM;

end STM32.Timer.DMA_TIM_5;
