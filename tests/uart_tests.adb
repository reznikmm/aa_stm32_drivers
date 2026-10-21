--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
with Ada.Command_Line;
with Ada.Synchronous_Task_Control;
with Ada.Text_IO;
with A0B.Callbacks;
with A0B.Callbacks.Generic_Parameterless;
with GNAT.Serial_Communications;
with STM32.UART.USART_2;
with Suspension_Object_Callbacks;
with System;

procedure UART_Tests is
   package UART is new STM32.UART.USART_2
     (Priority => System.Interrupt_Priority'First);
   use Ada.Synchronous_Task_Control;
   Read_Done, Write_Done : aliased Suspension_Object;
   Read_Callback : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Read_Done);
   Write_Callback : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Write_Done);
   Input : String (1 .. 32);
   Output : String := "Hello, World!";
   Large : String (1 .. 65_536) := (others => 'X');
   Calls : Natural := 0;
   Rejected : Boolean := False;

   procedure Rearm;
   package Rearm_Callbacks is new A0B.Callbacks.Generic_Parameterless (Rearm);
   procedure Rearm is
   begin
      Calls := Calls + 1;
      if Calls = 1 then
         UART.Start_Writing
           (Output'Address, Output'Length, Rearm_Callbacks.Create_Callback);
      else
         Set_True (Write_Done);
      end if;
   end Rearm;

   procedure Ready is
   begin
      Ada.Text_IO.Put_Line ("READY");
      Ada.Text_IO.Flush;
   end Ready;

   procedure Wait_Read is
   begin
      Suspend_Until_True (Read_Done);
      pragma Assert (not UART.Has_Error);
   end Wait_Read;

   Mode : constant String := Ada.Command_Line.Argument (1);
begin
   if Mode = "missing" then
      begin
         UART.Configure ((STM32.PA, 2), (STM32.PA, 3), 115_200);
         raise Program_Error with "Missing device accepted";
      exception
         when GNAT.Serial_Communications.Serial_Error => null;
      end;
      UART.Close;
      return;
   end if;

   UART.Configure
     ((if Mode = "alternate" then (STM32.PD, 5) else (STM32.PA, 2)),
      (if Mode = "alternate" then (STM32.PD, 6) else (STM32.PA, 3)), 115_200);
   UART.Set_Baud_Rate (9_600);
   UART.Set_Stop_Bits (STM32.UART.Standard_Stop_Bits'(2));
   UART.Set_Stop_Bits (STM32.UART.Extended_Stop_Bits'(1.0));
   UART.Set_Parity (STM32.UART.None);
   UART.Set_Baud_Rate (115_200);

   begin
      UART.Set_Baud_Rate (123);
      raise Program_Error with "Unsupported baud accepted";
   exception
      when Constraint_Error => null;
   end;
   begin
      UART.Set_Stop_Bits (STM32.UART.Extended_Stop_Bits'(1.5));
      raise Program_Error with "Unsupported stop bits accepted";
   exception
      when Constraint_Error => null;
   end;

   if Mode = "duplex" or Mode = "alternate" then
      UART.Start_Reading (Input'Address, 5, Read_Callback);
      pragma Assert (UART.Is_Busy);
      begin
         UART.Start_Reading (Input'Address, 5, Read_Callback);
      exception
         when Program_Error => Rejected := True;
      end;
      pragma Assert (Rejected);
      UART.Start_Writing (Output'Address, Output'Length, Write_Callback);
      Ready;
      Suspend_Until_True (Write_Done);
      Wait_Read;
      pragma Assert (Input (1 .. 5) = "abcde" and UART.Bytes_Read = 5);
   elsif Mode = "idle" or Mode = "full" then
      UART.Start_Reading_Till_Idle
        (Input'Address, (if Mode = "full" then 5 else Input'Length),
         Read_Callback);
      Ready;
      Wait_Read;
      pragma Assert (Input (1 .. 5) = "abcde" and UART.Bytes_Read = 5);
   elsif Mode = "cancel" then
      UART.Start_Reading (Input'Address, Input'Length, Read_Callback);
      Ready;
      delay 0.05;
      UART.Disable;
      Suspend_Until_True (Read_Done);
      pragma Assert (UART.Has_Error and not UART.Is_Busy);
      UART.Enable;
      UART.Start_Reading (Input'Address, 5, Read_Callback);
      Ready;
      Wait_Read;
      pragma Assert (not UART.Has_Error and UART.Bytes_Read = 5);
   elsif Mode = "rearm" then
      UART.Start_Writing
        (Output'Address, Output'Length, Rearm_Callbacks.Create_Callback);
      Ready;
      Suspend_Until_True (Write_Done);
      pragma Assert (Calls = 2 and not UART.Has_Error);
   elsif Mode = "large" then
      UART.Start_Writing (Large'Address, Large'Length, Write_Callback);
      Ready;
      Suspend_Until_True (Write_Done);
      pragma Assert (not UART.Has_Error);
   elsif Mode = "disconnect" then
      UART.Start_Reading (Input'Address, Input'Length, Read_Callback);
      Ready;
      Suspend_Until_True (Read_Done);
      pragma Assert (UART.Has_Error and not UART.Is_Busy);
   else
      raise Program_Error with "Unknown test mode";
   end if;
   UART.Close;
exception
   when others =>
      UART.Close;
      raise;
end UART_Tests;
