--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  DMA2 Stream 2 device

with Ada.Interrupts.Names;
with Interfaces;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.DMA.Stream_2_2 is

   procedure Start_Transfer
     (Channel : Channel_Id;
      Source  : Location;
      Target  : Location;
      Count   : Interfaces.Unsigned_16;
      FIFO    : FIFO_Bytes;
      Prio    : Priority_Level;
      Done    : A0B.Callbacks.Callback);

   procedure Stop_Transfer (Count : out Interfaces.Unsigned_16);

   function Has_Error return Boolean;

   package Stream is new STM32.DMA.Generic_DMA_Stream
     (Index   => 2,
      Is_DMA1 => False);

private

   package Implementation is new Stream_Implementation
     (Index     => 2,
      Periph    => STM32.Registers.DMA.DMA2_Periph,
      Interrupt => Ada.Interrupts.Names.DMA2_Stream2_Interrupt,
      Priority  => Priority);

   function Has_Error return Boolean is (Implementation.Device.Has_Error);

end STM32.DMA.Stream_2_2;
