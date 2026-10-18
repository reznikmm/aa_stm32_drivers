--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------

with STM32.UART.USART_1;
with STM32.UART.DMA_USART_2;

package Devices is

   package USART_1 is new STM32.UART.USART_1 (Priority => 241);
   package USART_2 is new STM32.UART.DMA_USART_2 (Priority => 241);

end Devices;
