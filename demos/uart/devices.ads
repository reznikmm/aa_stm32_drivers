--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Drivers.UART.USART_1;

package Devices is

   USART_1 : Drivers.UART.USART_1.Device (Priority => 241);

end Devices;
