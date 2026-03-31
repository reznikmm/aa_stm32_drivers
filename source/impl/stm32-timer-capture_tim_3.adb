--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.System_Clocks;
with STM32.Registers.RCC;

package body STM32.Timer.Capture_TIM_3 is

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Pin      : STM32.Pin;
      Speed    : Interfaces.Unsigned_32;
      Period   : Interfaces.Unsigned_16;
      Polarity : Capture_Polarity) is
   begin
      --  enable timer
      STM32.Registers.RCC.RCC_Periph.APB1ENR.TIM_EN_2_7 (3) := True;
      --  reset
      STM32.Registers.RCC.RCC_Periph.APB1RSTR.TIM_EN_2_7 (3) := True;
      STM32.Registers.RCC.RCC_Periph.APB1RSTR.TIM_EN_2_7 (3) := False;

      Implementation.Configure
        (Pin      => Pin,
         Fun      => AF_TIM_3_4_5,
         Speed    => Speed,
         Period   => Interfaces.Unsigned_32 (Period),
         Polarity => Polarity,
         Clock    => STM32.System_Clocks.TIMCLK1);
   end Configure;

   --------------------
   -- Captured_Value --
   --------------------

   function Captured_Value return Interfaces.Unsigned_16
   is
      use type Interfaces.Unsigned_32;
   begin
      return Interfaces.Unsigned_16
        (Implementation.Captured_Value and 16#FFFF#);
   end Captured_Value;

end STM32.Timer.Capture_TIM_3;
