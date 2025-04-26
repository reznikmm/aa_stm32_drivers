--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with A0B.Callbacks;
with Ada.Synchronous_Task_Control;
with Devices;
with STM32;
with Suspension_Object_Callbacks;

procedure UART_DMA is
   package UART renames Devices.UART_4;
   Buffer  : String := "      Hello, World!" & ASCII.LF;
   Count   : Natural := 0;
   Signal  : aliased Ada.Synchronous_Task_Control.Suspension_Object;
   Done    : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Signal);
begin
   UART.Configure
     (TX    => (STM32.PC, 10),
      RX    => (STM32.PC, 11),
      Speed => 115_200);

   loop
      declare
         Image : constant String := Count'Image;
      begin
         Buffer (Image'Range) := Image;
         Count := Count + 1;
      end;

      UART.Start_Writing (Buffer'Address, Buffer'Length, Done);

      Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);
      --  Write complete!

      delay 0.5;
   end loop;
end UART_DMA;
