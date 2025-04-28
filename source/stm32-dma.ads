--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Common code for DMA STM32.
--
--  Child packages provide generics with operations for a particular DMA
--  stream. The stream generic package is instantinated with the priority. Its
--  Start_Transfer operation initialise the IO operation and
--  return. When the operation is completed, it triggers a callback provided
--  as a parameter.

with Interfaces;
with System;

with A0B.Callbacks;

private with STM32.Registers.DMA;

package STM32.DMA is
   pragma Preelaborate;

   type Length_In_Bytes is range 0 .. 4
     with Static_Predicate => Length_In_Bytes /= 3;

   type Burst_Length is range 1 .. 16
     with Static_Predicate => Burst_Length in 1 | 4 | 8 | 16;

   type FIFO_Bytes is range 0 .. 16
     with Static_Predicate => FIFO_Bytes in 0 | 4 | 8 | 12 | 16;

   type Location is record
      Address     : System.Address;
      Item_Length : Length_In_Bytes range 1 .. 4;
      Increment   : Length_In_Bytes := 0;
      Burst       : Burst_Length := 1;
   end record
     with Predicate =>
       Location.Increment in 0 | 4
         or Location.Item_Length = Location.Increment;

   type Channel_Id is range 0 .. 7;
   subtype Stream_Index is Natural range 0 .. 7;

   type Priority_Level is (Low, Medium, High, Very_High);

   function Is_Memory (Value : System.Address) return Boolean is
     (System."<" (Value, System'To_Address (16#4000_0000#)));

   function Is_Peripheral (Value : System.Address) return Boolean is
     (not Is_Memory (Value));

   generic
      Index  : Stream_Index;

      Is_DMA1 : Boolean;

      with procedure Start_Transfer
        (Channel : Channel_Id;
         Source  : Location;
         Target  : Location;
         Count   : Interfaces.Unsigned_16;
         FIFO    : FIFO_Bytes;
         Prio    : Priority_Level;
         Done    : A0B.Callbacks.Callback) is <>;

      with procedure Stop_Transfer (Count : out Interfaces.Unsigned_16) is <>;

      with function Has_Error return Boolean is <>;

   package Generic_DMA_Stream is

      Is_DMA2 : constant Boolean := not Is_DMA1;

   end Generic_DMA_Stream;

private

   generic
      Index  : Stream_Index;
      Periph : in out STM32.Registers.DMA.DMA_Peripheral;
   package Stream_Implementation is

      type Internal_Data is limited private;

      procedure On_Interrupt (Self : in out Internal_Data);

      function Has_Error (Self : Internal_Data) return Boolean;

      procedure Start_Transfer
        (Self    : in out Internal_Data;
         Channel : Channel_Id;
         Source  : Location;
         Target  : Location;
         Count   : Interfaces.Unsigned_16;
         FIFO    : FIFO_Bytes;
         Prio    : Priority_Level;
         Done    : A0B.Callbacks.Callback);

      procedure Stop_Transfer
        (Self  : in out Internal_Data;
         Count : out Interfaces.Unsigned_16);

      --  How to stop circular?
      --  How to provide next buffer?
      --  How to return transfered bytes in periph contr flow?
   private

      type Internal_Data is limited record
         Error : Boolean;
         Done  : A0B.Callbacks.Callback;
      end record;

      function Has_Error (Self : Internal_Data) return Boolean is
         (Self.Error);

   end Stream_Implementation;

   procedure Enable_DMA1;
   procedure Enable_DMA2;

end STM32.DMA;
