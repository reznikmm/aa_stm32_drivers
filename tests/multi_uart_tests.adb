--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.Assertions;
with Ada.Synchronous_Task_Control;
with Ada.Text_IO;
with A0B.Callbacks;
with STM32.UART.USART_1;
with STM32.UART.USART_2;
with STM32.UART.USART_3;
with STM32.UART.UART_3;
with STM32.UART.UART_4;
with STM32.UART.UART_5;
with STM32.UART.USART_6;
with Suspension_Object_Callbacks;
with System;

procedure Multi_UART_Tests is
   use Ada.Synchronous_Task_Control;
   Priority : constant System.Interrupt_Priority :=
     System.Interrupt_Priority'First;
   package U1 is new STM32.UART.USART_1 (Priority);
   package U2 is new STM32.UART.USART_2 (Priority);
   package U3 is new STM32.UART.UART_3 (Priority);
   package U4 is new STM32.UART.UART_4 (Priority);
   package U5 is new STM32.UART.UART_5 (Priority);
   package U6 is new STM32.UART.USART_6 (Priority);
   package Legacy_3 is new STM32.UART.USART_3 (Priority);

   type Signals is array (1 .. 6) of aliased Suspension_Object;
   Read_Done, Write_Done : Signals;
   type Callbacks is array (1 .. 6) of A0B.Callbacks.Callback;
   Read_CB, Write_CB : Callbacks;
   type Messages is array (1 .. 6) of String (1 .. 5);
   Output : Messages := ("PORT1", "PORT2", "PORT3", "PORT4", "PORT5", "PORT6");
   Input : Messages;
   Expected : constant Messages :=
     ("DATA1", "DATA2", "DATA3", "DATA4", "DATA5", "DATA6");
   Alias_Message : String := "ALIAS";
   One_Stop : STM32.UART.Standard_Stop_Bits := 1;
   Rejected : Boolean := False;

   procedure Close_All is
   begin
      U1.Close;
      U2.Close;
      U3.Close;
      U4.Close;
      U5.Close;
      U6.Close;
      Legacy_3.Close;
   end Close_All;
begin
   for J in Read_CB'Range loop
      Read_CB (J) := Suspension_Object_Callbacks.Create_Callback (Read_Done (J));
      Write_CB (J) :=
        Suspension_Object_Callbacks.Create_Callback (Write_Done (J));
   end loop;

   --  The aliases retain the underlying pin validation contracts.
   begin
      U1.Configure ((STM32.PK, 15), (STM32.PA, 10), 115_200);
   exception
      when Ada.Assertions.Assertion_Error => Rejected := True;
   end;
   pragma Assert (Rejected);
   Rejected := False;
   begin
      U4.Configure ((STM32.PK, 15), (STM32.PA, 1), 115_200, Stop_Bits => One_Stop);
   exception
      when Ada.Assertions.Assertion_Error => Rejected := True;
   end;
   pragma Assert (Rejected);

   U1.Configure ((STM32.PA, 9), (STM32.PA, 10), 115_200);
   U2.Configure ((STM32.PA, 2), (STM32.PA, 3), 115_200);
   U3.Configure ((STM32.PB, 10), (STM32.PB, 11), 115_200);
   U4.Configure ((STM32.PA, 0), (STM32.PA, 1), 115_200, Stop_Bits => One_Stop);
   U5.Configure ((STM32.PC, 12), (STM32.PD, 2), 115_200, Stop_Bits => One_Stop);
   U6.Configure ((STM32.PC, 6), (STM32.PC, 7), 115_200);

   Legacy_3.Configure ((STM32.PB, 10), (STM32.PB, 11), 115_200);
   Legacy_3.Start_Writing
     (Alias_Message'Address, Alias_Message'Length, Write_CB (3));
   Suspend_Until_True (Write_Done (3));
   pragma Assert (not Legacy_3.Has_Error);
   Legacy_3.Close;

   U1.Start_Reading (Input (1)'Address, 5, Read_CB (1));
   U2.Start_Reading (Input (2)'Address, 5, Read_CB (2));
   U3.Start_Reading (Input (3)'Address, 5, Read_CB (3));
   U4.Start_Reading (Input (4)'Address, 5, Read_CB (4));
   U5.Start_Reading (Input (5)'Address, 5, Read_CB (5));
   U6.Start_Reading (Input (6)'Address, 5, Read_CB (6));
   U1.Start_Writing (Output (1)'Address, 5, Write_CB (1));
   U2.Start_Writing (Output (2)'Address, 5, Write_CB (2));
   U3.Start_Writing (Output (3)'Address, 5, Write_CB (3));
   U4.Start_Writing (Output (4)'Address, 5, Write_CB (4));
   U5.Start_Writing (Output (5)'Address, 5, Write_CB (5));
   U6.Start_Writing (Output (6)'Address, 5, Write_CB (6));
   Ada.Text_IO.Put_Line ("READY");
   Ada.Text_IO.Flush;

   for J in Read_Done'Range loop
      Suspend_Until_True (Write_Done (J));
      Suspend_Until_True (Read_Done (J));
   end loop;
   pragma Assert (Input = Expected);
   pragma Assert
     (U1.Bytes_Read = 5 and U2.Bytes_Read = 5 and U3.Bytes_Read = 5
      and U4.Bytes_Read = 5 and U5.Bytes_Read = 5 and U6.Bytes_Read = 5);
   pragma Assert
     (not U1.Has_Error and not U2.Has_Error and not U3.Has_Error
      and not U4.Has_Error and not U5.Has_Error and not U6.Has_Error);

   --  Original UART_5/USART_6 Stop operations leave the ports usable.
   U5.Start_Reading (Input (5)'Address, 5, Read_CB (5));
   U5.Stop;
   Suspend_Until_True (Read_Done (5));
   pragma Assert (U5.Has_Error and not U5.Is_Busy);
   U6.Start_Reading (Input (6)'Address, 5, Read_CB (6));
   U6.Stop;
   Suspend_Until_True (Read_Done (6));
   pragma Assert (U6.Has_Error and not U6.Is_Busy);
   U5.Start_Writing (Output (5)'Address, 5, Write_CB (5));
   U6.Start_Writing (Output (6)'Address, 5, Write_CB (6));
   Suspend_Until_True (Write_Done (5));
   Suspend_Until_True (Write_Done (6));
   Close_All;
exception
   when others =>
      Close_All;
      raise;
end Multi_UART_Tests;
