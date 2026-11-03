--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces;
with System;

private with Ada.Interrupts;
private with A0B.Callbacks;
private with STM32.DMA;
private with STM32.Registers.SPI;
private with STM32.SPI_AF;

package STM32.I2S is

   type Data_Format is (Data_16, Data_16_Extended, Data_24, Data_32);
   --  Data_16 uses 16-bit channel slots; the others use 32-bit slots.

   type I2S_Standard is (Philips, MSB_Justified, LSB_Justified);
   type Clock_Polarity is (Idle_Low, Idle_High);

   subtype Transfer_Length is Positive range 1 .. 65_535;
   type Sample_Buffer is
     array (Positive range <>) of Interfaces.Unsigned_16;
   --  Raw half-words in wire order: left then right. Data_24 and Data_32
   --  use two half-words per channel, most significant half-word first.
   --  In Data_24 the low eight bits of the second half-word are padding.

private

   procedure Clear_Receiver
     (Periph : in out STM32.Registers.SPI.SPI_Peripheral);

   procedure Check_Buffer
     (Periph : STM32.Registers.SPI.SPI_Peripheral;
      Buffer : System.Address;
      Length : Transfer_Length);

   generic
      Periph : in out STM32.Registers.SPI.SPI_Peripheral;
      AF     : STM32.SPI_AF.SPI_AF;
   package Polling_Implementation is

      procedure Configure
        (CK        : Pin;
         WS        : Pin;
         SD        : Pin;
         Frequency : Positive;
         Clock     : Positive;
         Format    : Data_Format;
         Standard  : I2S_Standard;
         Polarity  : Clock_Polarity);

      procedure Receive (Buffer : System.Address; Length : Transfer_Length);
      function Has_Error return Boolean;

   private
      Error : Boolean := False;
   end Polling_Implementation;

   generic
      Periph    : in out STM32.Registers.SPI.SPI_Peripheral;
      AF        : STM32.SPI_AF.SPI_AF;
      Interrupt : Ada.Interrupts.Interrupt_ID;
      Priority  : System.Interrupt_Priority;
   package IRQ_Implementation is

      package Common is new Polling_Implementation (Periph, AF);

      protected Device with Interrupt_Priority => Priority is
         procedure Start_Reading
           (Buffer : System.Address;
            Length : Transfer_Length;
            Done   : A0B.Callbacks.Callback);
         function Is_Busy return Boolean;
         function Has_Error return Boolean;
      private
         procedure Interrupt_Handler;
         pragma Attach_Handler (Interrupt_Handler, Interrupt);

         Busy   : Boolean := False;
         Error  : Boolean := False;
         Buffer : System.Address;
         Last   : Transfer_Length := 1;
         Next   : Positive := 1;
         Done   : A0B.Callbacks.Callback;
      end Device;

   end IRQ_Implementation;

   generic
      Periph    : in out STM32.Registers.SPI.SPI_Peripheral;
      AF        : STM32.SPI_AF.SPI_AF;
      Interrupt : Ada.Interrupts.Interrupt_ID;
      Priority  : System.Interrupt_Priority;
      with package RX_Stream is new STM32.DMA.Generic_DMA_Stream (<>);
   package DMA_Implementation is

      package Common is new Polling_Implementation (Periph, AF);

      protected Device with Interrupt_Priority => Priority is
         procedure Start_Reading
           (Buffer : System.Address;
            Length : Transfer_Length;
            Done   : A0B.Callbacks.Callback);
         procedure DMA_Complete;
         function Is_Busy return Boolean;
         function Has_Error return Boolean;
      private
         procedure Interrupt_Handler;
         pragma Attach_Handler (Interrupt_Handler, Interrupt);

         procedure Finish;

         Busy  : Boolean := False;
         Error : Boolean := False;
         Done  : A0B.Callbacks.Callback;
      end Device;

   end DMA_Implementation;

end STM32.I2S;
