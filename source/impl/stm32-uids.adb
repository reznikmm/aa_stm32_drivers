--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.IO_Exceptions;
with Ada.Streams.Stream_IO;

package body STM32.UIDs is

   function UID return Interfaces.Unsigned_64 is
      use type Interfaces.Unsigned_64;
      use type Ada.Streams.Stream_Element_Offset;
      use type Ada.Streams.Stream_IO.Count;

      File   : Ada.Streams.Stream_IO.File_Type;
      Data   : Ada.Streams.Stream_Element_Array (1 .. 8);
      Last   : Ada.Streams.Stream_Element_Offset;
      Result : Interfaces.Unsigned_64 := 0;
   begin
      Ada.Streams.Stream_IO.Open
        (File, Ada.Streams.Stream_IO.In_File, "stm32-uid.bin");
      if Ada.Streams.Stream_IO.Size (File) /= 8 then
         raise Ada.IO_Exceptions.Data_Error with
           "stm32-uid.bin must contain exactly 8 bytes";
      end if;
      Ada.Streams.Stream_IO.Read (File, Data, Last);
      Ada.Streams.Stream_IO.Close (File);
      if Last /= Data'Last then
         raise Ada.IO_Exceptions.End_Error with "Incomplete stm32-uid.bin";
      end if;

      for J in Data'Range loop
         Result := Result or Interfaces.Shift_Left
           (Interfaces.Unsigned_64 (Data (J)), Natural (J - 1) * 8);
      end loop;
      return Result;
   exception
      when others =>
         if Ada.Streams.Stream_IO.Is_Open (File) then
            Ada.Streams.Stream_IO.Close (File);
         end if;
         raise;
   end UID;

   function UID_Image return Device_UID_Image is
      use type Interfaces.Unsigned_64;
      Raw    : Interfaces.Unsigned_64 := UID;
      Result : Device_UID_Image;
   begin
      for Item of Result loop
         Item := Character'Val (Raw and 16#FF#);
         if Item not in '!' .. '~' then
            Item := '?';
         end if;
         Raw := Interfaces.Shift_Right (Raw, 8);
      end loop;
      return Result;
   end UID_Image;

end STM32.UIDs;
