--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  SDIO host controller, interrupt driven variant.
--
--  Start_Command initiates the command and returns. The interrupt handler
--  finishes the command phase, serves the FIFO and triggers the Done
--  callback when the operation is completed.
--
--  Hardware flow control is disabled (see errata ES0182), so the interrupt
--  handler must keep up with the bus. Use a high Priority and a moderate
--  bus speed, or use DMA_SDIO for fast transfers.

with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;

generic
   Priority : System.Interrupt_Priority;
   --  Priority is used for underlying protected object.
package STM32.SDIO.Generic_SDIO is

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
   --  Change SDIO_CK frequency (Hz) and data bus width. Don't call it while
   --  a command is in progress.

   procedure Start_Command
     (Item : Command;
      Done : A0B.Callbacks.Callback);
   --  Send a command without data. Done is triggered when the response is
   --  received (or the command is sent for No_Response).

   procedure Start_Command
     (Item   : Command;
      Data   : Data_Transfer;
      Buffer : System.Address;
      Done   : A0B.Callbacks.Callback)
     with Pre => Is_Word_Aligned (Buffer);
   --  Send a data command and transfer Data.Length bytes from/to Buffer.
   --  The buffer must remain available until Done is triggered.

   function Short_Response return Interfaces.Unsigned_32;
   --  32 bits of the last short response (card status for R1, OCR for R3
   --  and R4, flags and data for R5, RCA and status for R6).

   function Long_Response return Response_Words;
   --  Last long response (R2)

   function Response_Command return Command_Index;
   --  Command index of the last response (63 for R2, R3, R4)

   function Has_Error return Boolean;
   --  The last operation has failed

   function Last_Error return Error_Kind;
   --  The result of the last completed operation

   procedure Enable_Card_Interrupt (Done : A0B.Callbacks.Callback);
   --  Enable SDIO card interrupt (DAT1). When the card signals an interrupt
   --  the driver disables it and triggers Done. Clear the interrupt source
   --  in the card, then call Enable_Card_Interrupt again.

   procedure Disable_Card_Interrupt;

private

   protected Device
     with Interrupt_Priority => Priority
   is
      procedure Start_Command
        (Item     : Command;
         Has_Data : Boolean;
         Data     : Data_Transfer;
         Buffer   : System.Address;
         Done     : A0B.Callbacks.Callback);

      procedure Enable_Card_Interrupt (Done : A0B.Callbacks.Callback);

      procedure Disable_Card_Interrupt;

      function Last_Error return Error_Kind;

   private
      procedure Interrupt_Handler;

      pragma Attach_Handler
        (Interrupt_Handler, Ada.Interrupts.Names.SDIO_Interrupt);

      State          : Transfer_State;
      Busy           : Boolean := False;
      Error          : Error_Kind := No_Error;
      Done           : A0B.Callbacks.Callback;
      Card_Enabled   : Boolean := False;
      Card_Interrupt : A0B.Callbacks.Callback;
   end Device;

   function Last_Error return Error_Kind is (Device.Last_Error);

   function Has_Error return Boolean is (Device.Last_Error /= No_Error);

   function Short_Response return Interfaces.Unsigned_32 renames
     STM32.SDIO.Short_Response;

   function Long_Response return Response_Words renames
     STM32.SDIO.Long_Response;

   function Response_Command return Command_Index renames
     STM32.SDIO.Response_Command;

end STM32.SDIO.Generic_SDIO;
