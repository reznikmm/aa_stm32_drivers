--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.RCC;
with STM32.System_Clocks;

package body STM32.SPI.SPI_4 is

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (SCK   : Pin;
      MISO  : Pin;
      MOSI  : Pin;
      Speed : Interfaces.Unsigned_32;
      Mode  : SPI_Mode) is
   begin
      STM32.Registers.RCC.RCC_Periph.APB2ENR.SPI4EN := True;

      Implementation.Configure
        (SCK   => SCK,
         MISO  => MISO,
         MOSI  => MOSI,
         Speed => Speed,
         Mode  => Mode,
         Clock => STM32.System_Clocks.PCLK2);
   end Configure;

   -------------------------
   -- Start_Data_Exchange --
   -------------------------

   procedure Start_Data_Exchange
     (CS     : Pin;
      Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Implementation.Device.Start_Data_Exchange (CS, Buffer, Length, Done);
   end Start_Data_Exchange;

end STM32.SPI.SPI_4;
