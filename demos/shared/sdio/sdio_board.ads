--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Board settings for SDIO demos. Adjust them for your board.

with STM32;

package SDIO_Board is

   Clock_Pin   : constant STM32.Pin := (STM32.PC, 12);
   Command_Pin : constant STM32.Pin := (STM32.PD, 2);

   Data_Pins   : constant STM32.Pin_Array :=
     ((STM32.PC, 8), (STM32.PC, 9), (STM32.PC, 10), (STM32.PC, 11));

   Reset_Pin : constant STM32.Pin := (STM32.PB, 14);
   --  reset pin of the WiFi module (BCM43362)

   UART_TX : constant STM32.Pin := (STM32.PA, 2);
   UART_RX : constant STM32.Pin := (STM32.PA, 3);

end SDIO_Board;
