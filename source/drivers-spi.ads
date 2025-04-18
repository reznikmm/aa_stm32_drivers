--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Common code for SPI drivers.
--
--  Child packages provide a type and operations for a particular SPI device.
--  The type is a protected type with priority descriminant. Its
--  Start_Data_Exchange operation initialises the IO operation and returns.
--  When the operation is completed, it triggers a callback provided as a
--  parameter.

private with Interfaces.STM32.GPIO;
private with Interfaces.STM32.SPI;
private with System;

private with A0B.Callbacks;

package Drivers.SPI is
   pragma Preelaborate;

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

   procedure Init_GPIO
     (Periph : in out Interfaces.STM32.GPIO.GPIO_Peripheral;
      Pin  : Pin_Index);

   generic
      Periph : in out Interfaces.STM32.SPI.SPI_Peripheral;
   package SPI_Implementation is
      --  Generic implementation for SPI initializaion, operations and
      --  interrupt handling procedure

      type Internal_Data is limited private;

      procedure Configure
        (SCK   : Pin;
         MISO  : Pin;
         MOSI  : Pin;
         Speed : Interfaces.Unsigned_32;
         Mode  : SPI_Mode;
         Clock : Interfaces.STM32.UInt32);

      procedure On_Interrupt (Self : in out Internal_Data);

      procedure Start_Data_Exchange
        (Self   : in out Internal_Data;
         CS     : Pin;
         Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback);

   private

      type Internal_Data is limited record
         Buffer   : System.Address;
         Last     : Positive;
         Next_In  : Positive;
         Next_Out : Positive;
         Done     : A0B.Callbacks.Callback;
         CS       : Pin;
      end record;

   end SPI_Implementation;

end Drivers.SPI;
