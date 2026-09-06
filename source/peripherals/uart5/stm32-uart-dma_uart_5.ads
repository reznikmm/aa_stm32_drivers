--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  UART_5 device with DMA.

with Interfaces;
with STM32.DMA;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.USART;
private with STM32.DMA.Stream_1_0;
private with STM32.DMA.Stream_1_7;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.UART.DMA_UART_5 is

   procedure Configure
     (TX        : Pin;
      RX        : Pin;
      Rate      : Interfaces.Unsigned_32;
      Parity    : STM32.UART.Parity := None;
      Stop_Bits : Standard_Stop_Bits := 1)
     with Pre =>
       TX in (PC, 12) and then
       RX in (PD, 2);
   --
   --  Configure UART_5 on given pins and speed (baud rate)

   procedure Set_Baud_Rate (Rate : Interfaces.Unsigned_32);
   --  Reconfigure UART_5 speed (baud rate)

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

   package Stream_1_0 is new STM32.DMA.Stream_1_0 (Priority);
   package Stream_1_7 is new STM32.DMA.Stream_1_7 (Priority);

   package Implementation is new DMA_Implementation
     (STM32.Registers.USART.UART5_Periph,
      UART_4_8,
      Channel   => 4,
      Interrupt => Ada.Interrupts.Names.UART5_Interrupt,
      Priority  => Priority,
      RX_Stream => Stream_1_0.Stream,
      TX_Stream => Stream_1_7.Stream);

end STM32.UART.DMA_UART_5;
