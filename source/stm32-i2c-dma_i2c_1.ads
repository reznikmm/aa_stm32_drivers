--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  I2C_1 device.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.I2C;
private with STM32.DMA.Stream_1_0;
private with STM32.DMA.Stream_1_6;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.I2C.DMA_I2C_1 is

   procedure Configure
     (SCL   : Pin;
      SDA   : Pin;
      Speed : Interfaces.Unsigned_32)
        with Pre =>
         SCL in (PB, 6) | (PB, 8) and then
         SDA in (PB, 7) | (PB, 9);
   --
   --  (Re-)configure I2C_1 on given pins and speed

   function Is_Bus_Busy return Boolean;
   --  Check if a communication is in progress on the bus.

   procedure Start_Data_Exchange
     (Slave  : I2C_Slave_Address;
      Buffer : System.Address;
      Write  : Natural;
      Read   : Natural;
      Done   : A0B.Callbacks.Callback);
   --  Start a write and/or read operation when the bus is free.

   function Has_Error return Boolean;
   --  Check if the last operation resulted in an error.

   procedure Recover_Bus
     (SCL   : Pin;
      SDA   : Pin;
      Speed : Interfaces.Unsigned_32)
        with Pre => Speed in 100_001 .. 400_000;
   --  This procedure:
   --  * resets I2C peripheral then
   --  * tries to recover the bus by toggling SCL keeping SDA low for 8
   --    cycles to make slave accept NACK and release the bus then
   --  * enables the peripheral back.
   --
   --  This procedure takes 9.5 cycles at the given speed.

private

   package Stream_1_0 is new STM32.DMA.Stream_1_0 (Priority);
   package Stream_1_6 is new STM32.DMA.Stream_1_6 (Priority);

   package Implementation is new DMA_Implementation
     (STM32.Registers.I2C.I2C1_Periph,
      Channel         => 1,
      Priority        => Priority,
      Event_Interrupt => Ada.Interrupts.Names.I2C1_EV_Interrupt,
      Error_Interrupt => Ada.Interrupts.Names.I2C1_ER_Interrupt,
      RX_Stream       => Stream_1_0.Stream,
      TX_Stream       => Stream_1_6.Stream);

   function Has_Error return Boolean is (Implementation.Device.Has_Error);

   function Is_Bus_Busy return Boolean is (Implementation.Is_Bus_Busy);

   procedure Recover_Bus
     (SCL   : Pin;
      SDA   : Pin;
      Speed : Interfaces.Unsigned_32) renames Implementation.Recover_Bus;

end STM32.I2C.DMA_I2C_1;
