--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with STM32.UART.UART_3;

--  Retain the original STM32 package name alongside UART_3.
generic package STM32.UART.USART_3 renames STM32.UART.UART_3;
