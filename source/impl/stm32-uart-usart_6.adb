--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.RCC;
with STM32.System_Clocks;

package body STM32.UART.USART_6 is

   ------------
   -- Device --
   ------------

   protected body Device is

      procedure Set_Speed
        (Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32) is
      begin
         Implementation.Set_Speed (Data, Speed, Clock);
      end Set_Speed;

      procedure Start_Reading
        (Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback) is
      begin
         Implementation.Start_Reading (Data, Buffer, Length, Done);
      end Start_Reading;

      procedure Start_Writing
        (Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback) is
      begin
         Implementation.Start_Writing (Data, Buffer, Length, Done);
      end Start_Writing;

      procedure Interrupt is
      begin
         Implementation.On_Interrupt (Data);
      end Interrupt;

   end Device;

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Self  : in out Device;
      TX    : Pin;
      RX    : Pin;
      Speed : Interfaces.Unsigned_32)
   is
      pragma Unreferenced (Self);
   begin
      STM32.Registers.RCC.RCC_Periph.APB2ENR.USART6EN := True;

      Implementation.Configure
        (TX, RX, Speed,
         Clock => STM32.System_Clocks.PCLK2);
   end Configure;

   ---------------
   -- Set_Speed --
   ---------------

   procedure Set_Speed
     (Self  : in out Device;
      Speed : Interfaces.Unsigned_32) is
   begin
      Self.Set_Speed
        (Speed,
         Clock => STM32.System_Clocks.PCLK2);
   end Set_Speed;

   -------------------
   -- Start_Reading --
   -------------------

   procedure Start_Reading
     (Self   : in out Device;
      Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Self.Start_Reading (Buffer, Length, Done);
   end Start_Reading;

   -------------------
   -- Start_Writing --
   -------------------

   procedure Start_Writing
     (Self   : in out Device;
      Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Self.Start_Writing (Buffer, Length, Done);
   end Start_Writing;

end STM32.UART.USART_6;
