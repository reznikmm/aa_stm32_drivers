--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Driver for UART_4.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with Interfaces.STM32.USART;

package STM32.UART.UART_4 is

   type Device (Priority : System.Any_Priority) is limited private;
   --  UART_4 device. Priority is used for underlying protected object.

   procedure Configure
     (Self  : in out Device;
      TX    : Pin;
      RX    : Pin;
      Speed : Interfaces.Unsigned_32)
     with Pre =>
       TX in ('A', 0) | ('C', 10) and then
       RX in ('A', 1) | ('C', 11);
   --
   --  Configure UART_4 on given pins and speed (baud rate)

   procedure Set_Speed
     (Self  : in out Device;
      Speed : Interfaces.Unsigned_32);
   --  Reconfigure UART_4 speed (baud rate)

   procedure Start_Reading
     (Self   : in out Device;
      Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback);
   --  Start reading into given Buffer of provided Length. When Buffer is
   --  filled with input bytes trigger Done callback. No other call to
   --  Start_Reading is allowed until Done is triggered.

   procedure Start_Writing
     (Self   : in out Device;
      Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback);
   --  Start writing given Buffer of provided Length. When Buffer is
   --  sent trigger Done callback. No other call to Start_Writing is allowed
   --  until Done is triggered.

private

   package Implementation is new UART_Implementation
     (Interfaces.STM32.USART.UART4_Periph);

   protected type Device (Priority : System.Any_Priority)
     with Priority => Priority
   is
      procedure Set_Speed
        (Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.STM32.UInt32);

      procedure Start_Reading
        (Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback);

      procedure Start_Writing
        (Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback);

   private
      procedure Interrupt;

      pragma Attach_Handler (Interrupt, Ada.Interrupts.Names.UART4_Interrupt);

      Data : Implementation.Internal_Data;
   end Device;

end STM32.UART.UART_4;
