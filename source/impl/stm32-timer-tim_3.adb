--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.RCC;
with STM32.System_Clocks;

package body STM32.Timer.TIM_3 is

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Pin   : STM32.Pin;
      Speed : Interfaces.Unsigned_32) is
   begin
      STM32.Registers.RCC.RCC_Periph.APB1ENR.TIM_EN_2_7 (3) := True;
      STM32.Registers.RCC.RCC_Periph.APB1RSTR.TIM_EN_2_7 (3) := True;
      STM32.Registers.RCC.RCC_Periph.APB1RSTR.TIM_EN_2_7 (3) := False;

      Implementation.Configure
        (Pin,
         AF_TIM3_CH3,
         Speed,
         Clock => STM32.System_Clocks.TIMCLK1);
   end Configure;

   ---------------
   -- Start_PWM --
   ---------------

   procedure Start_PWM
     (Period : Interfaces.Unsigned_16;
      Duty   : Interfaces.Unsigned_16;
      Done   : A0B.Callbacks.Callback) is
   begin
      Implementation.Device.Start_PWM (Period, Duty, Done);
   end Start_PWM;

end STM32.Timer.TIM_3;
