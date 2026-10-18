--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  SD memory card initialization and block reading shared by SD demos.
--
--  It runs CMD0, CMD8, ACMD41, CMD2, CMD3, CMD9, CMD7, switches the bus to
--  4 bits with ACMD6, then reads block 0 with CMD17 and blocks 0 .. 1 with
--  CMD18 + CMD12 and compares them. The card is never written.

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

   with function Long_Response return STM32.SDIO.Response_Words;

package SD_Card is

   procedure Run (Data_Speed : Positive);
   --  Initialize the card, then switch to 4-bit bus at Data_Speed (Hz)

end SD_Card;
