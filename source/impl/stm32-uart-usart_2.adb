--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------

with STM32.Registers.RCC;
with STM32.System_Clocks;

package body STM32.UART.USART_2 is

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (TX        : Pin;
      RX        : Pin;
      Rate      : Interfaces.Unsigned_32;
      Parity    : STM32.UART.Parity := None;
      Stop_Bits : Extended_Stop_Bits := 1.0) is
   begin
      STM32.Registers.RCC.RCC_Periph.APB1ENR.USART2EN := True;

      Implementation.Configure
        (TX,
         RX,
         Rate,
         Clock => STM32.System_Clocks.PCLK1,
         Parity => Parity,
         Stop_Bits => Stop_Bits);
   end Configure;

   -------------------
   -- Set_Baud_Rate --
   -------------------

   procedure Set_Baud_Rate (Rate : Interfaces.Unsigned_32) is
   begin
      Implementation.Device.Set_Baud_Rate
        (Rate,
         Clock => STM32.System_Clocks.PCLK1);
   end Set_Baud_Rate;

   -------------------
   -- Set_Stop_Bits --
   -------------------

   procedure Set_Stop_Bits (Value : Extended_Stop_Bits) is
   begin
      Implementation.Device.Set_Stop_Bits (Value);
   end Set_Stop_Bits;

   -------------------
   -- Set_Stop_Bits --
   -------------------

   procedure Set_Stop_Bits (Value : Standard_Stop_Bits) is
   begin
      Set_Stop_Bits (case Value is when 1 => 1.0, when 2 => 2.0);
   end Set_Stop_Bits;

   ----------------
   -- Set_Parity --
   ----------------

   procedure Set_Parity (Value : Parity) is
   begin
      Implementation.Device.Set_Parity (Value);
   end Set_Parity;

   ------------
   -- Enable --
   ------------

   procedure Enable is
   begin
      Implementation.Device.Set_Enabled (True);
   end Enable;

   -------------
   -- Disable --
   -------------

   procedure Disable is
   begin
      Implementation.Device.Set_Enabled (False);
   end Disable;

   -------------
   -- Is_Busy --
   -------------

   function Is_Busy return Boolean is
   begin
      return Implementation.Device.Is_Busy;
   end Is_Busy;

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

   -----------------------------
   -- Start_Reading_Till_Idle --
   -----------------------------

   procedure Start_Reading_Till_Idle
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Implementation.Device.Start_Reading_Till_Idle (Buffer, Length, Done);
   end Start_Reading_Till_Idle;

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

end STM32.UART.USART_2;
