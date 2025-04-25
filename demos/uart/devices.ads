--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.UART.USART_1;

package Devices is

   package USART_1 is new STM32.UART.USART_1 (Priority => 241);

end Devices;
