--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.RCC;

package body STM32.I2S.Polling_I2S_3 is

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (CK        : Pin;
      WS        : Pin;
      SD        : Pin;
      Frequency : Positive;
      Clock     : Positive;
      Format    : Data_Format := Data_16;
      Standard  : I2S_Standard := Philips;
      Polarity  : Clock_Polarity := Idle_Low) is
   begin
      STM32.Registers.RCC.RCC_Periph.APB1ENR.SPI3EN := True;

      Implementation.Configure
        (CK, WS, SD, Frequency, Clock, Format, Standard, Polarity);
   end Configure;

end STM32.I2S.Polling_I2S_3;
