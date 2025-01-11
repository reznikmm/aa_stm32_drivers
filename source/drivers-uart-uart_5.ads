--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Driver for UART_5.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with Interfaces.STM32.USART;

package Drivers.UART.UART_5 is

   type Device (Priority : System.Any_Priority) is limited private;
   --  UART_5 device. Priority is used for underlying protected object.

   procedure Configure
     (Self  : in out Device;
      TX    : Pin;
      RX    : Pin;
      Speed : Interfaces.Unsigned_32)
     with Pre =>
       TX in ('C', 12) and then
       RX in ('D', 2);
   --
   --  Configure UART_5 on given pins and speed

   procedure Set_Speed
     (Self  : in out Device;
      Speed : Interfaces.Unsigned_32);
   --  Reconfigure UART_5 speed (baud rate)

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
     (Interfaces.STM32.USART.UART5_Periph);

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

      pragma Attach_Handler (Interrupt, Ada.Interrupts.Names.UART5_Interrupt);

      Data : Implementation.Internal_Data;
   end Device;

end Drivers.UART.UART_5;
