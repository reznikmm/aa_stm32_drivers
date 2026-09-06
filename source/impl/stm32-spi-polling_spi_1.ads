--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces;
--  private with STM32.Registers.USART;

package STM32.SPI.Polling_SPI_1 is

   procedure Configure
     (SCK   : Pin;
      MISO  : Pin;
      MOSI  : Pin;
      Speed : Interfaces.Unsigned_32;
      Mode  : SPI_Mode)
     with Pre =>
       SCK  in (PA, 5) | (PB, 3) and then
       MISO in (PA, 6) | (PB, 4) and then
       MOSI in (PA, 7) | (PB, 5);
   --
   --  (Re-)configure SPI_1 on given pins and speed

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
     (STM32.Registers.SPI.SPI1_Periph, STM32.SPI_AF.SPI_1_AF);

   function Status return STM32.SPI.Status renames Implementation.Status;

   procedure Send (Data : Interfaces.Unsigned_8) renames Implementation.Send;

   procedure Receive (Data : out Interfaces.Unsigned_8)
     renames Implementation.Receive;

end STM32.SPI.Polling_SPI_1;
