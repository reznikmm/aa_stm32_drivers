--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  DMA2 Stream 3 device

with Ada.Interrupts.Names;
with Interfaces;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.DMA.Stream_2_3 is

   procedure Start_Transfer
     (Channel : Channel_Id;
      Source  : Location;
      Target  : Location;
      Count   : Interfaces.Unsigned_16;
      FIFO    : FIFO_Bytes;
      Prio    : Priority_Level;
      Done    : A0B.Callbacks.Callback)
     with Pre =>
        not (Is_Memory (Source.Address) and Is_Memory (Target.Address));

   function Has_Error return Boolean;

private

   package Implementation is new Stream_Implementation
     (Index  => 3,
      Periph => STM32.Registers.DMA.DMA2_Periph);

   protected Device
     with Interrupt_Priority => Priority
   is

      procedure Start_Transfer
        (Channel : Channel_Id;
         Source  : Location;
         Target  : Location;
         Count   : Interfaces.Unsigned_16;
         FIFO    : FIFO_Bytes;
         Prio    : Priority_Level;
         Done    : A0B.Callbacks.Callback);

      function Has_Error return Boolean;

   private
      procedure Interrupt;

      pragma Attach_Handler
        (Interrupt, Ada.Interrupts.Names.DMA2_Stream3_Interrupt);

      Data : Implementation.Internal_Data;
   end Device;

   function Has_Error return Boolean is (Device.Has_Error);

end STM32.DMA.Stream_2_3;
