--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  SPI_4 device.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.SPI;
private with STM32.DMA.Stream_2_0;
private with STM32.DMA.Stream_2_1;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.SPI.DMA_SPI_4 is

   procedure Configure
     (SCK   : Pin;
      MISO  : Pin;
      MOSI  : Pin;
      Speed : Interfaces.Unsigned_32;
      Mode  : SPI_Mode)
     with Pre =>
       SCK  in (PE, 2) | (PE, 12) and then
       MISO in (PE, 5) | (PE, 13) and then
       MOSI in (PE, 6) | (PE, 14);
   --
   --  (Re-)configure SPI_4 on given pins and speed

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

   package Stream_2_0 is new STM32.DMA.Stream_2_0 (Priority);
   package Stream_2_1 is new STM32.DMA.Stream_2_1 (Priority);

   package Implementation is new DMA_Implementation
     (STM32.Registers.SPI.SPI4_Periph,
      Channel   => 4,
      Interrupt => Ada.Interrupts.Names.SPI4_Interrupt,
      Priority  => Priority,
      AF        => SPI_3_6_AF,
      RX_Stream => Stream_2_0.Stream,
      TX_Stream => Stream_2_1.Stream);

end STM32.SPI.DMA_SPI_4;
