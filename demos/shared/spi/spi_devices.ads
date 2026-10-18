--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------

--  with STM32.SPI.SPI_1;
with STM32.SPI.DMA_SPI_1;
with STM32.UART.DMA_USART_2;

package SPI_Devices is

   package SPI_1 is new STM32.SPI.DMA_SPI_1 (Priority => 241);
   --  package SPI_1 is new STM32.SPI.SPI_1 (Priority => 241);
   package USART_2 is new STM32.UART.DMA_USART_2 (Priority => 241);

end SPI_Devices;
