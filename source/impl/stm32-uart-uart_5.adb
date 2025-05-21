--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.RCC;
with STM32.System_Clocks;

package body STM32.UART.UART_5 is

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (TX    : Pin;
      RX    : Pin;
      Speed : Interfaces.Unsigned_32) is
   begin
      STM32.Registers.RCC.RCC_Periph.APB1ENR.UART5EN := True;

      Implementation.Configure
        (TX, RX, Speed,
         Clock => STM32.System_Clocks.PCLK1);
   end Configure;


   ---------------
   -- Set_Speed --
   ---------------

   procedure Set_Speed (Speed : Interfaces.Unsigned_32) is
   begin
      Implementation.Device.Set_Speed
        (Speed,
         Clock => STM32.System_Clocks.PCLK1);
   end Set_Speed;

   -------------------
   -- Start_Reading --
   -------------------

   procedure Start_Reading
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Implementation.Device.Start_Reading (Buffer, Length, Done);
   end Start_Reading;

   -------------------
   -- Start_Writing --
   -------------------

   procedure Start_Writing
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Implementation.Device.Start_Writing (Buffer, Length, Done);
   end Start_Writing;

end STM32.UART.UART_5;
