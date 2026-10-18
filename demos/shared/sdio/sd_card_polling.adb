--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Polling.SDIO;
with STM32.Polling.USART_2;

with SDIO_Board;
with SD_Card;

procedure SD_Card_Polling is
   package UART renames STM32.Polling.USART_2;
   package SDIO renames STM32.Polling.SDIO;

   package Card is new SD_Card
     (Send_Command      => SDIO.Send_Command,
      Send_Data_Command => SDIO.Send_Command,
      Set_Bus           => SDIO.Set_Bus,
      Put               => UART.Put);
begin
   UART.Configure
     (TX   => SDIO_Board.UART_TX,
      RX   => SDIO_Board.UART_RX,
      Rate => 115_200);

   UART.Put ("SD card polling demo" & ASCII.CR & ASCII.LF);

   SDIO.Configure
     (Clock_Pin   => SDIO_Board.Clock_Pin,
      Command_Pin => SDIO_Board.Command_Pin,
      Data_Pins   => SDIO_Board.Data_Pins,
      Speed       => 400_000);

   Card.Run (Data_Speed => 4_000_000);
   --  No hardware flow control: keep the speed low for CPU driven FIFO

   loop
      delay 1.0;
   end loop;
end SD_Card_Polling;
