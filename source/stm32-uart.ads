--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------

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

   type Status is record
      Parity_Error   : Boolean;
      Framing_Error  : Boolean;
      Noise_Detected : Boolean;
      Overrun        : Boolean;
      Idle_Line      : Boolean;
      Data_Available : Boolean;
      Send_Complete  : Boolean;
      Ready_To_Send  : Boolean;
   end record;

private
   for Status use record
      Parity_Error   at 0 range 0 .. 0;
      Framing_Error  at 0 range 1 .. 1;
      Noise_Detected at 0 range 2 .. 2;
      Overrun        at 0 range 3 .. 3;
      Idle_Line      at 0 range 4 .. 4;
      Data_Available at 0 range 5 .. 5;
      Send_Complete  at 0 range 6 .. 6;
      Ready_To_Send  at 0 range 7 .. 7;
   end record;

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

         procedure Start_Reading_Till_Idle
           (Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback);

         function Bytes_Read return Natural;

         procedure Start_Writing
           (Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback);

      private
         procedure Interrupt_Handler;

         pragma Attach_Handler (Interrupt_Handler, Interrupt);

         Divider  : Interfaces.Unsigned_32;
         Input    : Buffer_Record;
         Output   : Buffer_Record;
         Set_Idle : Boolean;
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

   generic
      Periph : in out STM32.Registers.USART.USART_Peripheral;
      Fun    : GPIO_Function;
   package Polling_Implementation is
      --  Generic polling implementation for UART initializaion and operations

      procedure Configure
        (TX    : Pin;
         RX    : Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32);

      procedure Set_Baud_Rate
        (Rate  : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32);

      function Status return STM32.UART.Status with Inline;

      procedure Receive (Data : out Interfaces.Unsigned_8);

      procedure Send (Data : Interfaces.Unsigned_8);

      procedure Put (Data : String);

   private

      function To_Status (Raw : STM32.Registers.USART.SR_Register)
        return STM32.UART.Status is
          (Parity_Error   => Raw.PE,
           Framing_Error  => Raw.FE,
           Noise_Detected => Raw.NF,
           Overrun        => Raw.ORE,
           Idle_Line      => Raw.IDLE,
           Data_Available => Raw.RXNE,
           Send_Complete  => Raw.TC,
           Ready_To_Send  => Raw.TXE);

      pragma Warnings (Off, "volatile actual passed by copy");

      function Status return STM32.UART.Status is
        (To_Status (Periph.SR));

      pragma Warnings (On, "volatile actual passed by copy");

   end Polling_Implementation;

end STM32.UART;
