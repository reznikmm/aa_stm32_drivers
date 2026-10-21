--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------

with A0B.Callbacks;
with Ada.Synchronous_Task_Control;
with Ada.Command_Line;
with Ada.Text_IO;
with STM32.UART.USART_2;
with STM32;
with System;
with Suspension_Object_Callbacks;

procedure UART_IRQ is
   package USART_2 is new STM32.UART.USART_2
     (Priority => System.Interrupt_Priority'First);
   Buffer  : String := "Hello, World!";
   Signal  : aliased Ada.Synchronous_Task_Control.Suspension_Object;
   Done    : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Signal);
begin
   USART_2.Configure
     (TX   => (STM32.PA, 2),
      RX   => (STM32.PA, 3),
      Rate => 115_200);

   --  An optional count makes the demo useful for automated checks.
   for J in 1 .. (if Ada.Command_Line.Argument_Count = 0 then Positive'Last
                  else Positive'Value (Ada.Command_Line.Argument (1))) loop
      USART_2.Start_Writing (Buffer'Address, Buffer'Length, Done);

      Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);

      if USART_2.Has_Error then
         Ada.Text_IO.Put_Line
           (Ada.Text_IO.Standard_Error, "UART write failed");
         Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
         exit;
      end if;

      delay 1.0;
   end loop;

   USART_2.Close;
exception
   when others =>
      USART_2.Close;
      raise;
end UART_IRQ;
