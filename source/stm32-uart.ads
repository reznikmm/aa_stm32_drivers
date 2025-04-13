--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Common code for UART STM32.
--
--  Child packages provide a type and operations for a particular UART device.
--  The type is a protected type with priority descriminant. Its Start_Reading
--  and Start_Writing operations initialise the IO operation and return. When
--  the operation is completed, it triggers a callback provided as a parameter.
--  Read and write operations use separate wires and can be performed
--  independently (in parallel or overlapping in time).

private with Interfaces.STM32.GPIO;
private with Interfaces.STM32.USART;
private with System;

private with A0B.Callbacks;

package STM32.UART is
   pragma Preelaborate;

private

   procedure Init_GPIO
     (TX  : Pin;
      Fun : Interfaces.STM32.UInt4);

   procedure Init_GPIO
     (GPIO : in out Interfaces.STM32.GPIO.GPIO_Peripheral;
      Pin  : Pin_Index;
      Fun  : Interfaces.STM32.UInt4);

   generic
      Periph : in out Interfaces.STM32.USART.USART1_Peripheral;
   package USART_Implementation is
      --  Generic implementation for UART initializaion, operations and
      --  interrupt handling procedure

      type Internal_Data is limited private;

      procedure Configure
        (TX    : Pin;
         RX    : Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.STM32.UInt32);

      procedure Set_Speed
        (Self  : in out Internal_Data;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.STM32.UInt32);

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
         Divider : Interfaces.STM32.UInt32;
         Input   : Buffer_Record;
         Output  : Buffer_Record;
      end record;

   end USART_Implementation;

   generic
      Periph : in out Interfaces.STM32.USART.UART4_Peripheral;
   package UART_Implementation is
      --  Generic implementation for UART initializaion, operations and
      --  interrupt handling procedure. The same as USART_Implementation, but
      --  it differs with the type of Periph.

      type Internal_Data is limited private;

      procedure Configure
        (TX    : Pin;
         RX    : Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.STM32.UInt32);

      procedure Set_Speed
        (Self  : in out Internal_Data;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.STM32.UInt32);

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
         Divider : Interfaces.STM32.UInt32;
         Input   : Buffer_Record;
         Output  : Buffer_Record;
      end record;

   end UART_Implementation;
end STM32.UART;
