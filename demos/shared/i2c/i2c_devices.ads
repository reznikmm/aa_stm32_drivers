--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.I2C.I2C_1;
with STM32.Polling.USART_2;

package I2C_Devices is

   package I2C_1 is new STM32.I2C.I2C_1 (Priority => 241);
   package UART_2 renames STM32.Polling.USART_2;

end I2C_Devices;
