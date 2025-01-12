--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with A0B.Callbacks;
with Ada.Synchronous_Task_Control;
with Devices;
with Drivers.UART.USART_1;
with Suspension_Object_Callbacks;

procedure UART is
   USART_1 : Drivers.UART.USART_1.Device renames Devices.USART_1;
   Buffer  : String := "Hello, World!";
   Signal  : aliased Ada.Synchronous_Task_Control.Suspension_Object;
   Done    : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Signal);
begin
   Drivers.UART.USART_1.Configure
     (USART_1,
      TX    => ('A', 9),
      RX    => ('A', 10),
      Speed => 115_200);

   loop
      Drivers.UART.USART_1.Start_Writing
        (USART_1, Buffer'Address, Buffer'Length, Done);

      Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);

      --  Write complete!
   end loop;
end UART;
