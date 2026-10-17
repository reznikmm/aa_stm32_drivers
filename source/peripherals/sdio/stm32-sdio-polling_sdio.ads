--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  SDIO host controller, polling variant.
--
--  Each procedure returns when the operation is complete. The CPU moves data
--  through the 32-word FIFO. Hardware flow control is disabled (see errata
--  ES0182), so a slow CPU loop or an interrupt in the middle of a transfer
--  could cause Receive_Overrun/Transmit_Underrun. Keep bus speed moderate for
--  data transfers in this variant.

with System;

package STM32.SDIO.Polling_SDIO is

   procedure Configure
     (Clock_Pin   : Pin;
      Command_Pin : Pin;
      Data_Pins   : Pin_Array;
      Speed       : Positive := 400_000;
      Width       : Bus_Width := 1)
     with Pre =>
       Is_Valid_Pin_Set (Clock_Pin, Command_Pin, Data_Pins)
         and then Speed > 0
         and then Natural (Width) <= Data_Pins'Length;
   --  Enable SDIO, configure pins and power on the card bus. Card
   --  identification requires Speed <= 400kHz and Width = 1.

   procedure Set_Bus
     (Speed : Positive;
      Width : Bus_Width);
   --  Change SDIO_CK frequency (Hz) and data bus width. Speeds above
   --  SDIOCLK/2 (usually 24 MHz) use the clock divider bypass mode.

   procedure Send_Command
     (Item  : Command;
      Error : out Error_Kind);
   --  Send a command without data and wait for the response. Use
   --  Short_Response/Long_Response to get the response.

   procedure Send_Command
     (Item   : Command;
      Data   : Data_Transfer;
      Buffer : System.Address;
      Error  : out Error_Kind)
     with Pre => Is_Word_Aligned (Buffer);
   --  Send a data command and transfer Data.Length bytes from/to Buffer.

   function Short_Response return Interfaces.Unsigned_32;
   --  32 bits of the last short response (card status for R1, OCR for R3
   --  and R4, flags and data for R5, RCA and status for R6).

   function Long_Response return Response_Words;
   --  Last long response (R2)

   function Response_Command return Command_Index;
   --  Command index of the last response (63 for R2, R3, R4)

   function Has_Card_Interrupt return Boolean;
   --  SDIO card has signaled an interrupt (DAT1)

   procedure Clear_Card_Interrupt;
   --  Clear the card interrupt flag. Clear the interrupt source in the card
   --  first, otherwise the flag is set again.

private

   function Short_Response return Interfaces.Unsigned_32 renames
     STM32.SDIO.Short_Response;

   function Long_Response return Response_Words renames
     STM32.SDIO.Long_Response;

   function Response_Command return Command_Index renames
     STM32.SDIO.Response_Command;

end STM32.SDIO.Polling_SDIO;
