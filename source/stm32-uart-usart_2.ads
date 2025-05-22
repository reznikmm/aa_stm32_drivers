--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  USART_2 device.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.USART;

generic
   Priority : System.Interrupt_Priority;
   --  Priority is used for underlying protected object.
package STM32.UART.USART_2 is

   procedure Configure
     (TX    : Pin;
      RX    : Pin;
      Speed : Interfaces.Unsigned_32)
     with Pre =>
       TX in (PA, 2) | (PD, 5) and then
       RX in (PA, 3) | (PD, 6);
   --
   --  Configure USART_2 on given pins and speed

   procedure Set_Speed (Speed : Interfaces.Unsigned_32);
   --  Reconfigure USART_2 speed (baud rate)

   procedure Start_Reading
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback);
   --  Start reading into given Buffer of provided Length. When Buffer
   --  is filled with input bytes trigger Done callback. No other call to
   --  Start_Reading or Start_Reading_Till_Idle is allowed until Done is
   --  triggered.

   procedure Start_Reading_Till_Idle
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback);
   --  Start a read operation into the provided Buffer of given Length. The
   --  read operation will complete and the Done callback will be triggered
   --  either when the Buffer is completely filled, or when an idle line
   --  condition (no new bytes received for a defined period) is detected on
   --  the UART line after at least one byte has been received. No other call
   --  to Start_Reading_Till_Idle or Start_Reading is allowed until Done is
   --  triggered.

   function Bytes_Read return Natural;
   --  Returns the number of bytes actually read during the last
   --  completed asynchronous read operation (e.g., Start_Reading or
   --  Start_Reading_Till_Idle). This function should be called only after
   --  the Done callback for a read operation has been triggered.

   procedure Start_Writing
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback);
   --  Start writing given Buffer of provided Length. When Buffer is
   --  sent trigger Done callback. No other call to Start_Writing is allowed
   --  until Done is triggered.

private

   package Implementation is new UART_Implementation
     (STM32.Registers.USART.USART2_Periph,
      UART_1_3,
      Ada.Interrupts.Names.USART2_Interrupt,
      Priority);

   function Bytes_Read return Natural is (Implementation.Device.Bytes_Read);

end STM32.UART.USART_2;
