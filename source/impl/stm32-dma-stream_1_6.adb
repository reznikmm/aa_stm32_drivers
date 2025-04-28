--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Interrupts.Names;

package body STM32.DMA.Stream_1_6 is

   protected body Device is

      --------------------
      -- Start_Transfer --
      --------------------

      procedure Start_Transfer
        (Channel : Channel_Id;
         Source  : Location;
         Target  : Location;
         Count   : Interfaces.Unsigned_16;
         FIFO    : FIFO_Bytes;
         Prio    : Priority_Level;
         Done    : A0B.Callbacks.Callback) is
      begin
         Implementation.Start_Transfer
           (Data, Channel, Source, Target, Count, FIFO, Prio, Done);
      end Start_Transfer;

      -------------------
      -- Stop_Transfer --
      -------------------

      procedure Stop_Transfer (Count : out Interfaces.Unsigned_16) is
      begin
         Implementation.Stop_Transfer (Data, Count);
      end Stop_Transfer;

      ---------------
      -- Has_Error --
      ---------------

      function Has_Error return Boolean is
         (Implementation.Has_Error (Data));

      ---------------
      -- Interrupt --
      ---------------

      procedure Interrupt is
      begin
         Implementation.On_Interrupt (Data);
      end Interrupt;

   end Device;

   --------------------
   -- Start_Transfer --
   --------------------

   procedure Start_Transfer
     (Channel : Channel_Id;
      Source  : Location;
      Target  : Location;
      Count   : Interfaces.Unsigned_16;
      FIFO    : FIFO_Bytes;
      Prio    : Priority_Level;
      Done    : A0B.Callbacks.Callback) is
   begin
      Device.Start_Transfer
        (Channel, Source, Target, Count, FIFO, Prio, Done);
   end Start_Transfer;

   -------------------
   -- Stop_Transfer --
   -------------------

   procedure Stop_Transfer (Count : out Interfaces.Unsigned_16) is
   begin
      Device.Stop_Transfer (Count);
   end Stop_Transfer;

begin
   Enable_DMA1;
end STM32.DMA.Stream_1_6;
