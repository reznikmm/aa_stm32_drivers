--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  USART_6 device with DMA.

with Interfaces;
with STM32.DMA;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.USART;
private with STM32.DMA.Stream_2_1;
private with STM32.DMA.Stream_2_6;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.UART.DMA_USART_6 is

   procedure Configure
     (TX        : Pin;
      RX        : Pin;
      Rate      : Interfaces.Unsigned_32;
      Parity    : STM32.UART.Parity := None;
      Stop_Bits : Extended_Stop_Bits := 1.0)
     with Pre =>
       TX in (PC, 6) and then
       RX in (PC, 7);
   --
   --  Configure USART_6 on given pins and speed (baud rate)

   procedure Set_Baud_Rate (Rate : Interfaces.Unsigned_32);
   --  Reconfigure USART_6 speed (baud rate)

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

   package Stream_2_1 is new STM32.DMA.Stream_2_1 (Priority);
   package Stream_2_6 is new STM32.DMA.Stream_2_6 (Priority);

   package Implementation is new DMA_Implementation
     (STM32.Registers.USART.USART6_Periph,
      UART_4_8,
      Channel   => 5,
      Interrupt => Ada.Interrupts.Names.USART6_Interrupt,
      Priority  => Priority,
      RX_Stream => Stream_2_1.Stream,
      TX_Stream => Stream_2_6.Stream);

end STM32.UART.DMA_USART_6;
