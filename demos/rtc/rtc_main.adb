--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with A0B.Callbacks;
with Ada.Synchronous_Task_Control;
with Devices;
with STM32.RTC;
with Suspension_Object_Callbacks;

procedure RTC_Main is
   package USART_1 renames Devices.USART_1;

   subtype String_2 is String (1 .. 2);

   -----------
   -- Image --
   -----------

   function Image (Value : Natural) return String_2 is
      Result : String := Value'Image;
   begin
      Result (1) := '0';

      return String_2 (Result (Result'Last - 1 .. Result'Last));
   end Image;

   Buffer  : String := "Hello, World!" & Character'Val (10);
   Signal  : aliased Ada.Synchronous_Task_Control.Suspension_Object;
   Done    : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Signal);

   Date   : STM32.RTC.Date;
   Time   : STM32.RTC.Time;
   Ignore : Boolean;
begin
   USART_1.Configure
     (TX    => (STM32.PA, 9),
      RX    => (STM32.PA, 10),
      Speed => 115_200);

   STM32.RTC.Initialize
     (Date =>
        (Year => 25, Month => 6, Day => 14, Weekday => STM32.RTC.Saturday),
      Time => (18, 33, 00),
      Success => Ignore);

   loop
      USART_1.Start_Writing (Buffer'Address, Buffer'Length, Done);

      Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);

      STM32.RTC.Clock (Date, Time);

      declare
         Value : String :=
           Image (Date.Year) & "-" &
           Image (Date.Month) & "-" &
           Image (Date.Day) & " " &
           Image (Time.Hour) & ":" &
           Image (Time.Minute) & ":" &
           Image (Time.Second) & " " &
           STM32.RTC.Weekday'Image (Date.Weekday) &
           Character'Val (10);
      begin
         USART_1.Start_Writing (Value'Address, Value'Length, Done);
         Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);
      end;

      delay 1.0;
   end loop;
end RTC_Main;
