--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

package body STM32.DMA.Stream_2_2 is

   -----------------------------
   -- Start_Circular_Transfer --
   -----------------------------

   procedure Start_Circular_Transfer
     (Channel : Channel_Id;
      Source  : Location;
      Target  : Location;
      Count   : Interfaces.Unsigned_16;
      FIFO    : FIFO_Bytes;
      Prio    : Priority_Level;
      On_Half : A0B.Callbacks.Callback) is
   begin
      Implementation.Device.Start_Transfer
        (Channel, Source, Target, Count, FIFO, Prio, True, On_Half);
   end Start_Circular_Transfer;

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
      Implementation.Device.Start_Transfer
        (Channel, Source, Target, Count, FIFO, Prio, False, Done);
   end Start_Transfer;

   -------------------
   -- Stop_Transfer --
   -------------------

   procedure Stop_Transfer (Count : out Interfaces.Unsigned_16) is
   begin
      Implementation.Device.Stop_Transfer (Count);
   end Stop_Transfer;

begin
   Enable_DMA2;
end STM32.DMA.Stream_2_2;
