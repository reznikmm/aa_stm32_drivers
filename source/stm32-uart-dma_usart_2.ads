--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  USART_2 device with DMA.

with Interfaces;
with STM32.DMA;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.USART;
private with STM32.DMA.Stream_1_5;
private with STM32.DMA.Stream_1_6;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.UART.DMA_USART_2 is

   procedure Configure
     (TX        : Pin;
      RX        : Pin;
      Rate      : Interfaces.Unsigned_32;
      Parity    : STM32.UART.Parity := None;
      Stop_Bits : Extended_Stop_Bits := 1.0)
     with Pre =>
       TX in (PA, 2) | (PD, 5) and then
       RX in (PA, 3) | (PD, 6);
   --
   --  Configure USART_2 on given pins and speed (baud rate)

   procedure Set_Baud_Rate (Rate : Interfaces.Unsigned_32);
   --  Reconfigure USART_2 speed (baud rate)

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

   package Stream_1_5 is new STM32.DMA.Stream_1_5 (Priority);
   package Stream_1_6 is new STM32.DMA.Stream_1_6 (Priority);

   package Implementation is new DMA_Implementation
     (STM32.Registers.USART.USART2_Periph,
      UART_1_3,
      Channel   => 4,
      Interrupt => Ada.Interrupts.Names.USART2_Interrupt,
      Priority  => Priority,
      RX_Stream => Stream_1_5.Stream,
      TX_Stream => Stream_1_6.Stream);

end STM32.UART.DMA_USART_2;
