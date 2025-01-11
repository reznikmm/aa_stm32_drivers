--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Driver for SPI_1.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with Interfaces.STM32.SPI;

package Drivers.SPI.SPI_1 is

   type Device (Priority : System.Any_Priority) is limited private;
   --  SPI_1 device. Priority is used for underlying protected object.

   procedure Configure
     (Self  : in out Device;
      SCK   : Pin;
      MISO  : Pin;
      MOSI  : Pin;
      Speed : Interfaces.Unsigned_32)
     with Pre =>
       SCK  in ('A', 5) | ('B', 3) and then
       MISO in ('A', 6) | ('B', 4) and then
       MOSI in ('A', 7) | ('B', 5);
   --
   --  (Re-)configure SPI_1 on given pins and speed

   procedure Start_Data_Exchange
     (Self   : in out Device;
      CS     : Pin;
      Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback);
   --  Start writing data from the Buffer of the specified Length and reading
   --  data into the space vacated in the buffer. When Buffer is filled with
   --  input bytes trigger Done callback. No other call to Start_Data_Exchange
   --  is allowed until Done is triggered. The buffer must remain available
   --  until Done is called.

private

   package Implementation is new SPI_Implementation
     (Interfaces.STM32.SPI.SPI1_Periph);

   protected type Device (Priority : System.Any_Priority)
     with Priority => Priority
   is
      procedure Start_Data_Exchange
        (CS     : Pin;
         Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback);

   private
      procedure Interrupt;

      pragma Attach_Handler (Interrupt, Ada.Interrupts.Names.SPI1_Interrupt);

      Data : Implementation.Internal_Data;
   end Device;

end Drivers.SPI.SPI_1;
