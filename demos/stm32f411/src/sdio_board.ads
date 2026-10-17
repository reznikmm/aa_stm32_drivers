--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Board settings for SDIO demos. Adjust them for your board.

with STM32;

package SDIO_Board is

   Clock_Pin   : constant STM32.Pin := (STM32.PB, 15);
   Command_Pin : constant STM32.Pin := (STM32.PA, 6);

   Data_Pins   : constant STM32.Pin_Array :=
     ((STM32.PB, 7), (STM32.PA, 8), (STM32.PA, 9), (STM32.PB, 5));

   Reset_Pin   : constant STM32.Pin := (STM32.PB, 14);
   --  Reset pin of the WiFi module (BCM43362)

   WiFi_IRQ_Pin : constant STM32.Pin := (STM32.PA, 0);

   UART_TX : constant STM32.Pin := (STM32.PA, 2);
   UART_RX : constant STM32.Pin := (STM32.PA, 3);

end SDIO_Board;
