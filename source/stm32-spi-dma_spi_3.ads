--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  SPI_3 device.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.SPI;
private with STM32.DMA.Stream_1_0;
private with STM32.DMA.Stream_1_5;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.SPI.DMA_SPI_3 is

   procedure Configure
     (SCK   : Pin;
      MISO  : Pin;
      MOSI  : Pin;
      Speed : Interfaces.Unsigned_32;
      Mode  : SPI_Mode)
     with Pre =>
       SCK  in (PB, 3) | (PC, 10) and then
       MISO in (PB, 4) | (PC, 11) and then
       MOSI in (PB, 5) | (PC, 12);
   --
   --  (Re-)configure SPI_3 on given pins and speed

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

   package Stream_1_0 is new STM32.DMA.Stream_1_0 (Priority);
   --  TBD: Should be configurable between Stream_1_0/Stream_1_2
   package Stream_1_5 is new STM32.DMA.Stream_1_5 (Priority);
   --  TBD: Should be configurable between Stream_1_4/Stream_1_5

   package Implementation is new DMA_Implementation
     (STM32.Registers.SPI.SPI3_Periph,
      Channel   => 0,
      Interrupt => Ada.Interrupts.Names.SPI3_Interrupt,
      Priority  => Priority,
      AF        => SPI_3_6_AF,
      RX_Stream => Stream_1_0.Stream,
      TX_Stream => Stream_1_5.Stream);

end STM32.SPI.DMA_SPI_3;
