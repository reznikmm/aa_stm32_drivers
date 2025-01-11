--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Common code for I2C drivers.
--
--  Child packages provide a type and operations for a particular I2C device.
--  The type is a protected type with priority descriminant. Its Start_Reading
--  and Start_Writing operations initialise the IO operation and return. When
--  the operation is completed, it triggers a callback provided as a parameter.
--  Read and write operations use a common wire and cannot be performed at the
--  same time.

with System;

with A0B.Callbacks;

private with Interfaces.STM32.I2C;

package Drivers.I2C is
   pragma Preelaborate;

   type I2C_Slave_Address is mod 2**7;

private

   procedure Init_GPIO (Item : Pin);

   generic
      Periph : in out Interfaces.STM32.I2C.I2C_Peripheral;
   package I2C_Implementation is
      --  Generic implementation for I2C initializaion, operations and
      --  interrupt handling procedure

      type Internal_Data is limited private;

      procedure Configure
        (SCL   : Pin;
         SDA   : Pin;
         Speed : Interfaces.Unsigned_32)
           with Pre => Speed in 100_001 .. 400_000;

      procedure On_Event (Self : in out Internal_Data);

      procedure On_Error (Self : in out Internal_Data);

      procedure Start_Data_Exchange
        (Self   : in out Internal_Data;
         Slave  : I2C_Slave_Address;
         Buffer : System.Address;
         Write  : Natural;
         Read   : Natural;
         Done   : A0B.Callbacks.Callback);
      --  Start I2C a write and/or read operation.

      function Has_Error (Self : Internal_Data) return Boolean;

   private

      type Internal_Data is limited record
         Buffer   : System.Address;
         Last     : Natural;
         Next     : Positive;
         Read     : Natural;
         Done     : A0B.Callbacks.Callback;
         Slave    : Interfaces.STM32.I2C.DR_DR_Field;  --  Slave + Dir bit
         Error    : Boolean;
      end record;
      --  If Read > 0 then don't call Done, but start reading instead

      function Has_Error (Self : Internal_Data) return Boolean is (Self.Error);

   end I2C_Implementation;

end Drivers.I2C;
