--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Synchronous_Task_Control;
with System;

with A0B.Callbacks;
with STM32.Polling.USART_2;
with STM32.SDIO;

with SDIO_IRQ_Device;
with SDIO_Board;
with SDIO_Card;
with Suspension_Object_Callbacks;

procedure SDIO_IRQ is
   package UART renames STM32.Polling.USART_2;
   package SDIO renames SDIO_IRQ_Device;

   Signal : aliased Ada.Synchronous_Task_Control.Suspension_Object;
   Done   : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Signal);

   procedure Send_Command
     (Item  : STM32.SDIO.Command;
      Error : out STM32.SDIO.Error_Kind);

   procedure Send_Data_Command
     (Item   : STM32.SDIO.Command;
      Data   : STM32.SDIO.Data_Transfer;
      Buffer : System.Address;
      Error  : out STM32.SDIO.Error_Kind);

   ------------------
   -- Send_Command --
   ------------------

   procedure Send_Command
     (Item  : STM32.SDIO.Command;
      Error : out STM32.SDIO.Error_Kind) is
   begin
      SDIO.Start_Command (Item, Done);
      Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);
      Error := SDIO.Last_Error;
   end Send_Command;

   -----------------------
   -- Send_Data_Command --
   -----------------------

   procedure Send_Data_Command
     (Item   : STM32.SDIO.Command;
      Data   : STM32.SDIO.Data_Transfer;
      Buffer : System.Address;
      Error  : out STM32.SDIO.Error_Kind) is
   begin
      SDIO.Start_Command (Item, Data, Buffer, Done);
      Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);
      Error := SDIO.Last_Error;
   end Send_Data_Command;

   package Card is new SDIO_Card
     (Send_Command      => Send_Command,
      Send_Data_Command => Send_Data_Command,
      Short_Response    => SDIO.Short_Response,
      Response_Command  => SDIO.Response_Command,
      Set_Bus           => SDIO.Set_Bus,
      Put               => UART.Put);
begin
   UART.Configure
     (TX   => SDIO_Board.UART_TX,
      RX   => SDIO_Board.UART_RX,
      Rate => 115_200);

   UART.Put ("SDIO interrupt demo" & ASCII.CR & ASCII.LF);

   Card.Reset;

   SDIO.Configure
     (Clock_Pin   => SDIO_Board.Clock_Pin,
      Command_Pin => SDIO_Board.Command_Pin,
      Data_Pins   => SDIO_Board.Data_Pins,
      Speed       => 400_000);

   Card.Run (Data_Speed => 8_000_000);
   --  The interrupt handler serves the FIFO: keep the speed moderate

   loop
      delay 1.0;
   end loop;
end SDIO_IRQ;
