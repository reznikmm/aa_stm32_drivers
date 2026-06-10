--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with A0B.Callbacks;
with Ada.Synchronous_Task_Control;
with I2C_Devices;
with STM32.I2C;
with Suspension_Object_Callbacks;
with STM32;

procedure I2C is
   package UART renames I2C_Devices.UART_2;

   SDA : constant STM32.Pin := (STM32.PB, 7);
   SCL : constant STM32.Pin := (STM32.PB, 8);

   Buffer  : String (1 .. 1);
   Signal  : aliased Ada.Synchronous_Task_Control.Suspension_Object;
   Done    : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Signal);
begin
   UART.Configure
     (TX   => (STM32.PD, 5),
      RX   => (STM32.PD, 6),
      Rate => 115_200);

   UART.Put ("I2C Scan:" & ASCII.CR & ASCII.LF);

   I2C_Devices.I2C_1.Configure
     (SCL   => SCL,
      SDA   => SDA,
      Speed => 400_000);

   for Slave in STM32.I2C.I2C_Slave_Address'(8) .. 16#77# loop

      I2C_Devices.I2C_1.Start_Data_Exchange
        (Slave  => Slave,
         Buffer => Buffer'Address,
         Write  => 0,
         Read   => 0,
         Done   => Done);

      Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);

      if I2C_Devices.I2C_1.Has_Error then
         UART.Put (".");
      else
         UART.Put (Slave'Image & ASCII.CR & ASCII.LF);
      end if;
   end loop;

   UART.Put (" done!" & ASCII.CR & ASCII.LF);

   loop
      delay 0.5;
   end loop;
end I2C;
