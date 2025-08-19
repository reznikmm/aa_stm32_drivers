--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  SPI_2 device.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.SPI;
private with STM32.DMA.Stream_1_3;
private with STM32.DMA.Stream_1_4;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.SPI.DMA_SPI_2 is

   procedure Configure
     (SCK   : Pin;
      MISO  : Pin;
      MOSI  : Pin;
      Speed : Interfaces.Unsigned_32;
      Mode  : SPI_Mode)
     with Pre =>
       SCK  in (PB, 10) | (PB, 13) and then
       MISO in (PB, 14) | (PC, 2) and then
       MOSI in (PB, 15) | (PC, 3);
   --
   --  (Re-)configure SPI_2 on given pins and speed

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

   package Stream_1_3 is new STM32.DMA.Stream_1_3 (Priority);
   package Stream_1_4 is new STM32.DMA.Stream_1_4 (Priority);

   package Implementation is new DMA_Implementation
     (STM32.Registers.SPI.SPI2_Periph,
      Channel   => 0,
      Interrupt => Ada.Interrupts.Names.SPI2_Interrupt,
      Priority  => Priority,
      RX_Stream => Stream_1_3.Stream,
      TX_Stream => Stream_1_4.Stream);

end STM32.SPI.DMA_SPI_2;
