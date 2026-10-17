--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  SDIO card enumeration shared by SDIO demos.
--
--  It powers the card up (optionally), runs CMD0, CMD5, CMD3, CMD7, reads
--  CCCR with CMD52, switches the bus to 4 bits, then reads the common CIS
--  with CMD53 (data transfer) and compares the first bytes with CMD52.

with Interfaces;
with System;

with STM32.SDIO;

generic
   with procedure Send_Command
     (Item  : STM32.SDIO.Command;
      Error : out STM32.SDIO.Error_Kind);

   with procedure Send_Data_Command
     (Item   : STM32.SDIO.Command;
      Data   : STM32.SDIO.Data_Transfer;
      Buffer : System.Address;
      Error  : out STM32.SDIO.Error_Kind);

   with procedure Set_Bus
     (Speed : Positive;
      Width : STM32.SDIO.Bus_Width);

   with procedure Put (Text : String);

   with function Short_Response return Interfaces.Unsigned_32;

   with function Response_Command return STM32.SDIO.Command_Index;

package SDIO_Card is

   procedure Reset;

   procedure Run (Data_Speed : Positive);
   --  Enumerate the card, then switch to 4-bit bus at Data_Speed (Hz)

end SDIO_Card;
