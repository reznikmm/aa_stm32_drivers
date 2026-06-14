--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces;
with STM32.Polling.SPI_1;
with STM32.GPIO;

procedure SPI_Polling is
   package SPI renames STM32.Polling.SPI_1;

   CS : constant STM32.Pin := (STM32.PD, 13);
begin
   STM32.GPIO.Configure_Output (Pin => CS);
   STM32.GPIO.Set_Output (Pin => CS, Value => 1);

   SPI.Configure
     (SCK   => (STM32.PB, 3),
      MISO  => (STM32.PB, 4),
      MOSI  => (STM32.PB, 5),
      Speed => 3_000_000,
      Mode  => 3);

   delay 0.5;

   loop
      declare
         use type Interfaces.Unsigned_8;
         Value : Interfaces.Unsigned_8;
      begin
         STM32.GPIO.Set_Output (CS, 0);

         SPI.Send (16#D0#);
         SPI.Receive (Value);
         pragma Assert (Value /= 123);

         SPI.Send (16#00#);
         SPI.Receive (Value);
         pragma Assert (Value /= 123);

         STM32.GPIO.Set_Output (CS, 1);

         delay 1.0;
      end;
   end loop;
end SPI_Polling;
