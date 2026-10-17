--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  SDIO host controller with DMA.
--
--  Data is moved by DMA2 Stream 3 (channel 4) in the peripheral flow
--  control mode, so the SDIO peripheral defines the transfer length. The
--  command phase and the transfer end are handled by the SDIO interrupt.
--  The Done callback is triggered when both the SDIO data path and the DMA
--  stream are finished.
--
--  The buffer must be word aligned and located in SRAM (DMA has no access
--  to the CCM data RAM). A 16-byte aligned buffer allows 4-word memory
--  bursts.

with Interfaces;
with System;

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.DMA.Stream_2_3;

generic
   Priority : System.Interrupt_Priority;
   --  Priority is used for underlying protected objects (SDIO and DMA).
package STM32.SDIO.DMA_SDIO is

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
      Width : Bus_Width)
     with Pre => Speed > 0;
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
     with Pre => Is_Word_Aligned (Buffer) and Is_DMA_Accessible (Buffer);
   --  Send a data command and transfer Data.Length bytes from/to Buffer.
   --  The buffer must remain available until Done is triggered.

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

   package Stream_2_3 is new STM32.DMA.Stream_2_3 (Priority);

   protected Device
     with Interrupt_Priority => Priority
   is
      procedure Start_Command
        (Item     : Command;
         Has_Data : Boolean;
         Data     : Data_Transfer;
         Buffer   : System.Address;
         Done     : A0B.Callbacks.Callback);

      procedure DMA_Complete;
      --  Called by the DMA stream callback

      procedure Enable_Card_Interrupt (Done : A0B.Callbacks.Callback);

      procedure Disable_Card_Interrupt;

      function Last_Error return Error_Kind;

   private
      procedure Interrupt_Handler;

      pragma Attach_Handler
        (Interrupt_Handler, Ada.Interrupts.Names.SDIO_Interrupt);

      procedure Try_To_Finish;
      --  Complete the operation if SDIO and DMA have finished. Stop DMA if
      --  SDIO has failed.

      State          : Transfer_State;
      Busy           : Boolean := False;
      Wait_DMA       : Boolean := False;
      DMA_Failed     : Boolean := False;
      Error          : Error_Kind := No_Error;
      Done           : A0B.Callbacks.Callback;
      Card_Enabled   : Boolean := False;
      Card_Interrupt : A0B.Callbacks.Callback;
   end Device;

   function Last_Error return Error_Kind is (Device.Last_Error);

   function Has_Error return Boolean is (Device.Last_Error /= No_Error);

end STM32.SDIO.DMA_SDIO;
