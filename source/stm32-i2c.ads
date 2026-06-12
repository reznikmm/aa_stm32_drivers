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
private with STM32.DMA;
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

      function Is_Bus_Busy return Boolean;
      --  Check if a communication is in progress on the bus.

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

   private

      function Is_Bus_Busy return Boolean is (Periph.SR2.BUSY);

   end I2C_Implementation;

   generic
      Periph          : in out STM32.Registers.I2C.I2C_Peripheral;
      Channel         : STM32.DMA.Channel_Id;
      Priority        : System.Interrupt_Priority;
      Event_Interrupt : Ada.Interrupts.Interrupt_ID;
      Error_Interrupt : Ada.Interrupts.Interrupt_ID;

      with package RX_Stream is new STM32.DMA.Generic_DMA_Stream (<>);
      with package TX_Stream is new STM32.DMA.Generic_DMA_Stream (<>);
   package DMA_Implementation is

      procedure Configure
        (SCL   : Pin;
         SDA   : Pin;
         Speed : Interfaces.Unsigned_32)
           with Pre => Speed in 100_001 .. 400_000;

      function Is_Bus_Busy return Boolean;
      --  Check if a communication is in progress on the bus.

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

         procedure On_Transfer_Complete;

      private
         procedure On_Event;

         pragma Attach_Handler (On_Event, Event_Interrupt);

         procedure On_Error;

         pragma Attach_Handler (On_Error, Error_Interrupt);

         Buffer : System.Address;
         Last   : Natural;
         Read   : Natural;
         Done   : A0B.Callbacks.Callback;
         Slave  : Interfaces.Unsigned_8;  --  Slave + Dir bit
         Error  : Boolean;
         Stop   : Boolean;
      end Device;

   private

      function Is_Bus_Busy return Boolean is (Periph.SR2.BUSY);

   end DMA_Implementation;

end STM32.I2C;
