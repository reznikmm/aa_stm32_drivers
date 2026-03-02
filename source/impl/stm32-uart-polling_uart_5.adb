--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.RCC;
with STM32.System_Clocks;

package body STM32.UART.Polling_UART_5 is

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (TX   : Pin;
      RX   : Pin;
      Rate : Interfaces.Unsigned_32) is
   begin
      STM32.Registers.RCC.RCC_Periph.APB1ENR.UART5EN := True;

      Implementation.Configure
        (TX, RX, Rate,
         Clock => STM32.System_Clocks.PCLK1);
   end Configure;

   -------------------
   -- Set_Baud_Rate --
   -------------------

   procedure Set_Baud_Rate (Rate : Interfaces.Unsigned_32) is
   begin
      Implementation.Set_Baud_Rate
        (Rate => Rate, Clock => STM32.System_Clocks.PCLK1);
   end Set_Baud_Rate;

end STM32.UART.Polling_UART_5;
