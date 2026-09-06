--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  SPI_5 device.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.SPI;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.SPI.SPI_5 is

   procedure Configure
     (SCK   : Pin;
      MISO  : Pin;
      MOSI  : Pin;
      Speed : Interfaces.Unsigned_32;
      Mode  : SPI_Mode)
     with Pre =>
       SCK  in (PF, 7) | (PH, 6) and then
       MISO in (PF, 8) | (PH, 7) and then
       MOSI in (PF, 9) | (PF, 11);
   --
   --  (Re-)configure SPI_5 on given pins and speed

   procedure Start_Data_Exchange
     (CS     : Pin;
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
     (STM32.Registers.SPI.SPI5_Periph,
      AF        => SPI_3_6_AF,
      Interrupt => Ada.Interrupts.Names.SPI5_Interrupt,
      Priority  => Priority);

end STM32.SPI.SPI_5;