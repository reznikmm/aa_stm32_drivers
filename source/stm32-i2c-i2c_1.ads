--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  I2C_1 device.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.I2C;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.I2C.I2C_1 is

   procedure Configure
     (SCL   : Pin;
      SDA   : Pin;
      Speed : Interfaces.Unsigned_32)
        with Pre =>
         SCL in (PB, 6) | (PB, 8) and then
         SDA in (PB, 7) | (PB, 9);
   --
   --  (Re-)configure I2C_1 on given pins and speed

   procedure Start_Data_Exchange
     (Slave  : I2C_Slave_Address;
      Buffer : System.Address;
      Write  : Natural;
      Read   : Natural;
      Done   : A0B.Callbacks.Callback);

   function Has_Error return Boolean;

private

   package Implementation is new I2C_Implementation
     (STM32.Registers.I2C.I2C1_Periph,
      Event_Interrupt => Ada.Interrupts.Names.I2C1_EV_Interrupt,
      Error_Interrupt => Ada.Interrupts.Names.I2C1_ER_Interrupt,
      Priority        => Priority);

   function Has_Error return Boolean is (Implementation.Device.Has_Error);

end STM32.I2C.I2C_1;
