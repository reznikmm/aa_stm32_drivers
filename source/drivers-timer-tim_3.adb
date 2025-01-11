--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces.STM32.RCC;
with System.STM32;

package body Drivers.Timer.TIM_3 is

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Self  : in out Device;
      Pin   : Drivers.Pin;
      Speed : Interfaces.Unsigned_32)
   is
      pragma Unreferenced (Self);
   begin
      Interfaces.STM32.RCC.RCC_Periph.APB1ENR.TIM3EN := 1;
      Interfaces.STM32.RCC.RCC_Periph.APB1RSTR.TIM3RST := 1;
      Interfaces.STM32.RCC.RCC_Periph.APB1RSTR.TIM3RST := 0;

      Implementation.Configure
        (Pin,
         Speed,
         Clock => System.STM32.System_Clocks.TIMCLK1);
   end Configure;

   ------------
   -- Device --
   ------------

   protected body Device is

      ---------------
      -- Interrupt --
      ---------------

      procedure Interrupt is
      begin
         Implementation.On_Interrupt (Data);
      end Interrupt;

      ---------------
      -- Start_PWM --
      ---------------

      procedure Start_PWM
        (Period : Interfaces.Unsigned_16;
         Duty   : Interfaces.Unsigned_16;
         Done   : A0B.Callbacks.Callback) is
      begin
         Implementation.Start_PWM (Data, Period, Duty, Done);
      end Start_PWM;

   end Device;

   ---------------
   -- Start_PWM --
   ---------------

   procedure Start_PWM
     (Self   : in out Device;
      Period : Interfaces.Unsigned_16;
      Duty   : Interfaces.Unsigned_16;
      Done   : A0B.Callbacks.Callback) is
   begin
      Self.Start_PWM (Period, Duty, Done);
   end Start_PWM;

end Drivers.Timer.TIM_3;
