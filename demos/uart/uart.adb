--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with A0B.Callbacks;
with Ada.Synchronous_Task_Control;
with Devices;
with STM32;
with Suspension_Object_Callbacks;

procedure UART is
   package USART_1 renames Devices.USART_1;
   Buffer  : String := "Hello, World!";
   Signal  : aliased Ada.Synchronous_Task_Control.Suspension_Object;
   Done    : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Signal);
begin
   USART_1.Configure
     (TX    => (STM32.PA, 9),
      RX    => (STM32.PA, 10),
      Speed => 115_200);

   loop
      USART_1.Start_Writing (Buffer'Address, Buffer'Length, Done);

      Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);

      --  Write complete!
   end loop;
end UART;
