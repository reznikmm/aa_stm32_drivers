--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Common code for I2C STM32.
--
--  Child packages provide generics with operations for a particular I2C
--  device. The device generic package is instantinated with the priority. Its
--  Start_Reading and Start_Writing operations initialise the IO operation and
--  return. When the operation is completed, it triggers a callback provided
--  as a parameter. Read and write operations use a common wire and cannot be
--  performed at the same time.

with Ada.Interrupts;
with System;

with A0B.Callbacks;

private with Interfaces;
private with STM32.Registers.I2C;

package STM32.I2C is

   type I2C_Slave_Address is mod 2**7;
   --  I2C 7-bit slave address

private

   procedure Init_GPIO (Item : Pin);

   generic
      Periph          : in out STM32.Registers.I2C.I2C_Peripheral;
      Event_Interrupt : Ada.Interrupts.Interrupt_ID;
      Error_Interrupt : Ada.Interrupts.Interrupt_ID;
      Priority        : System.Interrupt_Priority;
   package I2C_Implementation is
      --  Generic implementation for I2C initializaion, operations and
      --  interrupt handling procedure

      procedure Configure
        (SCL   : Pin;
         SDA   : Pin;
         Speed : Interfaces.Unsigned_32)
           with Pre => Speed in 100_001 .. 400_000;

      protected Device
        with Interrupt_Priority => Priority
      is

         procedure Start_Data_Exchange
           (Slave  : I2C_Slave_Address;
            Buffer : System.Address;
            Write  : Natural;
            Read   : Natural;
            Done   : A0B.Callbacks.Callback);
         --  Start I2C a write and/or read operation.

         function Has_Error return Boolean;

      private
         procedure On_Event;

         pragma Attach_Handler (On_Event, Event_Interrupt);

         procedure On_Error;

         pragma Attach_Handler (On_Error, Error_Interrupt);

         Buffer : System.Address;
         Last   : Natural;
         Next   : Positive;
         Read   : Natural;
         Done   : A0B.Callbacks.Callback;
         Slave  : Interfaces.Unsigned_8;  --  Slave + Dir bit
         Error  : Boolean;
      end Device;

   end I2C_Implementation;

end STM32.I2C;
