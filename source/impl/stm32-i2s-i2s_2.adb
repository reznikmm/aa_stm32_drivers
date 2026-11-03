--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.RCC;

package body STM32.I2S.I2S_2 is

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
      if Is_Busy then
         raise Program_Error;
      end if;

      STM32.Registers.RCC.RCC_Periph.APB1ENR.SPI2EN := True;

      Implementation.Common.Configure
        (CK, WS, SD, Frequency, Clock, Format, Standard, Polarity);
   end Configure;

end STM32.I2S.I2S_2;
