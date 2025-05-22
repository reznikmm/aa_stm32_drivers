--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Common code for SPI STM32.
--
--  Child packages provide generics with operations for a particular SPI
--  device. The device generic package is instantinated with the priority. Its
--  Start_Data_Exchange operation initialises the IO operation and returns.
--  When the operation is completed, it triggers a callback provided as a
--  parameter.

private with Ada.Interrupts;
private with Interfaces;
private with System;

private with A0B.Callbacks;
private with STM32.DMA;
private with STM32.Registers.SPI;

package STM32.SPI is

   type SPI_Mode is range 0 .. 3;
   --  Clock polarity and phase mode.
   --
   --  Also known as CPOL and CPHA (for clock polarity and clock phase)
   --  options. The combinations of polarity and phases are referred to by
   --  these "SPI mode" numbers with CPOL as the high order bit and CPHA as
   --  the low order bit:
   --
   --  | Mode | CPOL | CPHA | Data Shifted       | Data Sampled |
   --  | ---- | ---- | ---- | ------------------ | ------------ |
   --  |    0 |    0 |    0 | falling SCLK or CS |  rising SCLK |
   --  |    1 |    0 |    1 |  rising SCLK       | falling SCLK |
   --  |    2 |    1 |    0 |  rising SCLK or CS | falling SCLK |
   --  |    3 |    1 |    1 | falling SCLK       |  rising SCLK |

private

   procedure Init_GPIO (Item : Pin);

   generic
      Periph    : in out STM32.Registers.SPI.SPI_Peripheral;
      Interrupt : Ada.Interrupts.Interrupt_ID;
      Priority  : System.Interrupt_Priority;
   package SPI_Implementation is
      --  Generic implementation for SPI initializaion, operations and
      --  interrupt handling procedure

      procedure Configure
        (SCK   : Pin;
         MISO  : Pin;
         MOSI  : Pin;
         Speed : Interfaces.Unsigned_32;
         Mode  : SPI_Mode;
         Clock : Interfaces.Unsigned_32);

      protected Device
        with Interrupt_Priority => Priority
      is
         procedure Start_Data_Exchange
           (CS     : Pin;
            Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback);

      private
         procedure Interrupt_Handler;

         pragma Attach_Handler (Interrupt_Handler, Interrupt);

         Buffer   : System.Address;
         Last     : Positive;
         Next_In  : Positive;
         Next_Out : Positive;
         Done     : A0B.Callbacks.Callback;
         CS       : Pin;
      end Device;

   end SPI_Implementation;

   generic
      Periph    : in out STM32.Registers.SPI.SPI_Peripheral;
      Channel   : STM32.DMA.Channel_Id;
      Interrupt : Ada.Interrupts.Interrupt_ID;
      Priority  : System.Interrupt_Priority;

      with package RX_Stream is new STM32.DMA.Generic_DMA_Stream (<>);
      with package TX_Stream is new STM32.DMA.Generic_DMA_Stream (<>);
   package DMA_Implementation is
      --  Generic implementation for SPI initializaion, operations and
      --  interrupt handling procedure

      procedure Configure
        (SCK   : Pin;
         MISO  : Pin;
         MOSI  : Pin;
         Speed : Interfaces.Unsigned_32;
         Mode  : SPI_Mode;
         Clock : Interfaces.Unsigned_32);

      type Data_Record is limited record
         Done  : A0B.Callbacks.Callback;
         CS    : Pin;
      end record;

      protected Device
        with Interrupt_Priority => Priority
      is
         procedure Start_Data_Exchange
           (CS     : Pin;
            Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback);

         function Has_Error return Boolean;

      private
         procedure Interrupt_Handler;

         pragma Attach_Handler (Interrupt_Handler, Interrupt);

         Data  : aliased Data_Record;
         Error : Boolean;
      end Device;

   end DMA_Implementation;

end STM32.SPI;
