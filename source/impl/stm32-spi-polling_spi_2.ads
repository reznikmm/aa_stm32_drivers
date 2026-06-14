--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces;

package STM32.SPI.Polling_SPI_2 is

   procedure Configure
     (SCK   : Pin;
      MISO  : Pin;
      MOSI  : Pin;
      Speed : Interfaces.Unsigned_32;
      Mode  : SPI_Mode)
     with Pre =>
       SCK  in (PB, 10) | (PB, 13) and then
       MISO in (PB, 14) | (PC, 2) and then
       MOSI in (PB, 15) | (PC, 3);
   --
   --  (Re-)configure SPI_2 on given pins and speed

   function Status return STM32.SPI.Status with Inline;
   --  Return current receiver/transmitter status

   function Data_Available return Boolean is (Status.Data_Available);
   --  Check if RX data available

   procedure Receive (Data : out Interfaces.Unsigned_8);
   --  Wait for RX data and read it into Data

   function Ready_To_Send return Boolean is (Status.Ready_To_Send);
   --  Check if TX register is empty

   procedure Send (Data : Interfaces.Unsigned_8);
   --  Wait while is TX register is empty and push Data to it

private

   package Implementation is new Polling_Implementation
     (STM32.Registers.SPI.SPI2_Periph, SPI_2_3_AF);

   function Status return STM32.SPI.Status renames Implementation.Status;

   procedure Send (Data : Interfaces.Unsigned_8) renames Implementation.Send;

   procedure Receive (Data : out Interfaces.Unsigned_8)
     renames Implementation.Receive;

end STM32.SPI.Polling_SPI_2;