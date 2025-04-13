--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Driver for I2C_1.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.I2C;

package STM32.I2C.I2C_1 is

   type Device (Priority : System.Any_Priority) is limited private;
   --  I2C_1 device. Priority is used for underlying protected object.

   procedure Configure
     (Self  : in out Device;
      SCL   : Pin;
      SDA   : Pin;
      Speed : Interfaces.Unsigned_32)
        with Pre =>
         SCL in (PB, 6) | (PB, 8) and then
         SDA in (PB, 7) | (PB, 9);
   --
   --  (Re-)configure I2C_1 on given pins and speed

   procedure Start_Data_Exchange
     (Self   : in out Device;
      Slave  : I2C_Slave_Address;
      Buffer : System.Address;
      Write  : Natural;
      Read   : Natural;
      Done   : A0B.Callbacks.Callback);

   function Has_Error (Self : Device) return Boolean;

private

   package Implementation is new I2C_Implementation
     (STM32.Registers.I2C.I2C1_Periph);

   protected type Device (Priority : System.Any_Priority)
     with Priority => Priority
   is

      procedure Start_Data_Exchange
        (Slave  : I2C_Slave_Address;
         Buffer : System.Address;
         Write  : Natural;
         Read   : Natural;
         Done   : A0B.Callbacks.Callback);

      function Has_Error return Boolean;

   private
      procedure On_Event;

      pragma Attach_Handler (On_Event, Ada.Interrupts.Names.I2C1_EV_Interrupt);

      procedure On_Error;

      pragma Attach_Handler (On_Error, Ada.Interrupts.Names.I2C1_ER_Interrupt);

      Data : Implementation.Internal_Data;
   end Device;

end STM32.I2C.I2C_1;
