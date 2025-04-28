--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with A0B.Callbacks;
with Ada.Synchronous_Task_Control;
with SPI_Devices;
with STM32.GPIO;
with Suspension_Object_Callbacks;

procedure SPI_DMA is
   package UART renames SPI_Devices.UART_4;

   CS : constant STM32.Pin := (STM32.PB, 0);

   Buffer  : String := "Hello, World!" & ASCII.LF;
   Signal  : aliased Ada.Synchronous_Task_Control.Suspension_Object;
   Done    : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Signal);
begin
   UART.Configure
     (TX    => (STM32.PC, 10),
      RX    => (STM32.PC, 11),
      Speed => 115_200);

   UART.Start_Writing (Buffer'Address, Buffer'Length, Done);

   Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);

   STM32.GPIO.Configure_Output (Pin => CS);
   STM32.GPIO.Set_Output (CS, 1);

   SPI_Devices.SPI_1.Configure
     (SCK   => (STM32.PB, 3),
      MISO  => (STM32.PB, 4),
      MOSI  => (STM32.PB, 5),
      Speed => 42_000_000,
      Mode  => 3);

   Buffer (1) := Character'Val (16#9F#);

   SPI_Devices.SPI_1.Start_Data_Exchange
     (CS     => CS,
      Buffer => Buffer'Address,
      Length => 4,
      Done   => Done);

   Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);

   UART.Start_Writing (Buffer'Address, Buffer'Length, Done);

   Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);

   loop
      delay 0.5;
   end loop;
end SPI_DMA;
