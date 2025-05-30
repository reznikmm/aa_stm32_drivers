--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  UART_4 device with DMA.

with Interfaces;
with STM32.DMA;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.USART;
private with STM32.DMA.Stream_1_2;
private with STM32.DMA.Stream_1_4;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.UART.DMA_UART_4 is

   procedure Configure
     (TX    : Pin;
      RX    : Pin;
      Speed : Interfaces.Unsigned_32)
     with Pre =>
       TX in (PA, 0) | (PC, 10) and then
       RX in (PA, 1) | (PC, 11);
   --
   --  Configure UART_4 on given pins and speed (baud rate)

   procedure Set_Speed (Speed : Interfaces.Unsigned_32);
   --  Reconfigure UART_4 speed (baud rate)

   procedure Start_Reading
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback);
   --  Start reading into given Buffer of provided Length. When Buffer is
   --  filled with input bytes trigger Done callback. No other call to
   --  Start_Reading is allowed until Done is triggered.

   procedure Start_Writing
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback);
   --  Start writing given Buffer of provided Length. When Buffer is
   --  sent trigger Done callback. No other call to Start_Writing is allowed
   --  until Done is triggered.

private

   package Stream_1_2 is new STM32.DMA.Stream_1_2 (Priority);
   package Stream_1_4 is new STM32.DMA.Stream_1_4 (Priority);

   package Implementation is new DMA_Implementation
     (STM32.Registers.USART.UART4_Periph,
      UART_4_8,
      Channel   => 4,
      Interrupt => Ada.Interrupts.Names.UART4_Interrupt,
      Priority  => Priority,
      RX_Stream => Stream_1_2.Stream,
      TX_Stream => Stream_1_4.Stream);

end STM32.UART.DMA_UART_4;
