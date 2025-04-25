--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Common code for UART STM32.
--
--  Child packages provide generics with operations for a particular UART device.
--  The device generic package is instantinated with the priority. Its
--  Start_Reading and Start_Writing operations initialise the IO operation and
--  return. When the operation is completed, it triggers a callback provided
--  as a parameter. Read and write operations use separate wires and can be
--  performed independently (in parallel or time overlap).

private with System;
with Interfaces;

private with A0B.Callbacks;
private with STM32.Registers.GPIO;
private with STM32.Registers.USART;

package STM32.UART is
   pragma Preelaborate;

private

   subtype GPIO_Function is Interfaces.Unsigned_32 range 7 .. 8;

   UART_1_3 : constant := 7;
   UART_4_8 : constant := 8;

   procedure Init_GPIO
     (TX  : Pin;
      Fun : GPIO_Function);

   generic
      Periph : in out STM32.Registers.USART.USART_Peripheral;
      Fun    : GPIO_Function;
   package UART_Implementation is
      --  Generic implementation for UART initializaion, operations and
      --  interrupt handling procedure. The same as USART_Implementation, but
      --  it differs with the type of Periph.

      type Internal_Data is limited private;

      procedure Configure
        (TX    : Pin;
         RX    : Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32);

      procedure Set_Speed
        (Self  : in out Internal_Data;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32);

      procedure On_Interrupt (Self : in out Internal_Data);

      procedure Start_Reading
        (Self   : in out Internal_Data;
         Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback);

      procedure Start_Writing
        (Self   : in out Internal_Data;
         Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback);

   private

      type Buffer_Record is record
         Buffer : System.Address;
         Last   : Positive;
         Next   : Positive;
         Done   : A0B.Callbacks.Callback;
      end record;

      type Internal_Data is limited record
         Divider : Interfaces.Unsigned_32;
         Input   : Buffer_Record;
         Output  : Buffer_Record;
      end record;

   end UART_Implementation;
end STM32.UART;
