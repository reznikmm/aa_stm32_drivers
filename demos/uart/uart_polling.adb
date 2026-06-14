--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  The polling API is the simplest way to use UART/USART. It is ideal for
--  debug output (UART print), bootloaders, or simple programs where you do
--  not want to deal with callbacks. It is indispensable when you need to send
--  a small number of bytes.

with STM32.Polling.USART_2;

procedure UART_Polling is
   package UART renames STM32.Polling.USART_2;

begin
   UART.Configure
      (TX   => (STM32.PD, 5),
       RX   => (STM32.PD, 6),
       Rate => 115_200);

   for Step in 1 .. 1E9 loop
      UART.Put ("Hello! Step:" & Step'Image & ASCII.CR & ASCII.LF);
      delay 1.0;
   end loop;
end UART_Polling;
