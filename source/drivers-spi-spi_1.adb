--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces.STM32.RCC;
with System.STM32;

package body Drivers.SPI.SPI_1 is

   ------------
   -- Device --
   ------------

   protected body Device is

      ---------------
      -- Interrupt --
      ---------------

      procedure Interrupt is
      begin
         Implementation.On_Interrupt (Data);
      end Interrupt;

      -------------------------
      -- Start_Data_Exchange --
      -------------------------

      procedure Start_Data_Exchange
        (CS     : Pin;
         Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback) is
      begin
         Implementation.Start_Data_Exchange (Data, CS, Buffer, Length, Done);
      end Start_Data_Exchange;

   end Device;

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Self  : in out Device;
      SCK   : Pin;
      MISO  : Pin;
      MOSI  : Pin;
      Speed : Interfaces.Unsigned_32;
      Mode  : SPI_Mode)
   is
      pragma Unreferenced (Self);
   begin
      Interfaces.STM32.RCC.RCC_Periph.APB2ENR.SPI1EN := 1;

      Implementation.Configure
        (SCK   => SCK,
         MISO  => MISO,
         MOSI  => MOSI,
         Speed => Speed,
         Mode  => Mode,
         Clock => System.STM32.System_Clocks.PCLK2);
   end Configure;

   -------------------------
   -- Start_Data_Exchange --
   -------------------------

   procedure Start_Data_Exchange
     (Self   : in out Device;
      CS     : Pin;
      Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Self.Start_Data_Exchange (CS, Buffer, Length, Done);
   end Start_Data_Exchange;

end Drivers.SPI.SPI_1;
