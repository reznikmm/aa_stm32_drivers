--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Common code for UART STM32.
--
--  Child packages provide generics with operations for a particular UART
--  device. The device generic package is instantinated with the priority. Its
--  Start_Reading and Start_Writing operations initialise the IO operation and
--  return. When the operation is completed, it triggers a callback provided
--  as a parameter. Read and write operations use separate wires and can be
--  performed independently (in parallel or time overlap).

private with Ada.Interrupts;
private with System;
with Interfaces;

private with A0B.Callbacks;
private with STM32.Registers.USART;
private with STM32.DMA;

package STM32.UART is

private

   subtype GPIO_Function is Interfaces.Unsigned_32 range 7 .. 8;

   UART_1_3 : constant := 7;
   UART_4_8 : constant := 8;

   procedure Init_GPIO
     (TX  : Pin;
      Fun : GPIO_Function);

   type Buffer_Record is record
      Buffer : System.Address;
      Last   : Positive;
      Next   : Positive;
      Done   : A0B.Callbacks.Callback;
   end record;

   generic
      Periph    : in out STM32.Registers.USART.USART_Peripheral;
      Fun       : GPIO_Function;
      Interrupt : Ada.Interrupts.Interrupt_ID;
      Priority  : System.Interrupt_Priority;
   package UART_Implementation is
      --  Generic implementation for UART initializaion, operations and
      --  interrupt handling procedure.

      procedure Configure
        (TX    : Pin;
         RX    : Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32);

      protected Device
        with Interrupt_Priority => Priority
      is
         procedure Set_Speed
           (Speed : Interfaces.Unsigned_32;
            Clock : Interfaces.Unsigned_32);

         procedure Start_Reading
           (Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback);

         procedure Start_Writing
           (Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback);

      private
         procedure Interrupt_Handler;

         pragma Attach_Handler (Interrupt_Handler, Interrupt);

         Divider : Interfaces.Unsigned_32;
         Input   : Buffer_Record;
         Output  : Buffer_Record;
      end Device;

   end UART_Implementation;

   generic
      Periph    : in out STM32.Registers.USART.USART_Peripheral;
      Fun       : GPIO_Function;
      Channel   : STM32.DMA.Channel_Id;
      Interrupt : Ada.Interrupts.Interrupt_ID;
      Priority  : System.Interrupt_Priority;

      with package RX_Stream is new STM32.DMA.Generic_DMA_Stream (<>);
      with package TX_Stream is new STM32.DMA.Generic_DMA_Stream (<>);

   package DMA_Implementation is
      --  Generic DMA based implementation for UART initializaion, operations
      --  and interrupt handling procedure.

      procedure Configure
        (TX    : Pin;
         RX    : Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32);

      protected Device
        with Interrupt_Priority => Priority
      is
         procedure Set_Speed
           (Speed : Interfaces.Unsigned_32;
            Clock : Interfaces.Unsigned_32);

         procedure Start_Reading
           (Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback);

         procedure Start_Writing
           (Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback);

      private
         procedure Interrupt_Handler;

         pragma Attach_Handler (Interrupt_Handler, Interrupt);

         Divider     : Interfaces.Unsigned_32;
         Input_Done  : aliased A0B.Callbacks.Callback;
         Output_Done : aliased A0B.Callbacks.Callback;
      end Device;

   end DMA_Implementation;

end STM32.UART;
