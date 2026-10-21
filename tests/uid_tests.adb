--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.Directories;
with Ada.IO_Exceptions;
with Ada.Streams.Stream_IO;
with Ada.Text_IO;
with Interfaces;
with Interfaces.C;
with STM32.UIDs;
with System;

procedure UID_Tests is
   use type Interfaces.Unsigned_64;
   use type System.Address;
   package IO renames Ada.Streams.Stream_IO;
   package C renames Interfaces.C;

   function Make_Temp_Dir (Template : in out C.char_array) return System.Address
     with Import, Convention => C, External_Name => "mkdtemp";

   Root : constant String := Ada.Directories.Current_Directory;
   Template : C.char_array := C.To_C ("/tmp/uid-test-XXXXXX");
   Created : Boolean := False;

   procedure Write_File (Value : String) is
      File : IO.File_Type;
      Data : Ada.Streams.Stream_Element_Array
        (1 .. Ada.Streams.Stream_Element_Offset (Value'Length));
   begin
      for J in Value'Range loop
         Data (Ada.Streams.Stream_Element_Offset (J - Value'First + 1)) :=
           Character'Pos (Value (J));
      end loop;
      IO.Create (File, IO.Out_File, "stm32-uid.bin");
      IO.Write (File, Data);
      IO.Close (File);
   exception
      when others =>
         if IO.Is_Open (File) then
            IO.Close (File);
         end if;
         raise;
   end Write_File;

   procedure Cleanup is
   begin
      Ada.Directories.Set_Directory (Root);
      if Created then
         Ada.Directories.Delete_Tree (C.To_Ada (Template));
         Created := False;
      end if;
   end Cleanup;

   Rejected : Boolean;
   Value : Interfaces.Unsigned_64;
begin
   if Make_Temp_Dir (Template) = System.Null_Address then
      raise Program_Error with "Cannot create temporary directory";
   end if;
   Created := True;
   Ada.Directories.Set_Directory (C.To_Ada (Template));

   Rejected := False;
   begin
      Value := STM32.UIDs.UID;
   exception
      when Ada.IO_Exceptions.Name_Error => Rejected := True;
   end;
   pragma Assert (Rejected);

   Write_File ("ABCDEFGH");
   pragma Assert (STM32.UIDs.UID = 16#4847_4645_4443_4241#);
   pragma Assert (STM32.UIDs.UID_Image = "ABCDEFGH");

   --  Reads reflect file changes; image conversion filters nonprintable bytes.
   Write_File (ASCII.NUL & " !~" & ASCII.DEL & Character'Val (255) & ASCII.LF & "A");
   pragma Assert (STM32.UIDs.UID_Image = "??!~???A");
   Write_File ((1 .. 8 => Character'Val (255)));
   pragma Assert (STM32.UIDs.UID = Interfaces.Unsigned_64'Last);
   Write_File ((1 .. 8 => ASCII.NUL));
   pragma Assert (STM32.UIDs.UID = 0);

   for Size in 0 .. 12 loop
      if Size /= 8 then
         Write_File ((1 .. Size => 'X'));
         Rejected := False;
         begin
            Value := STM32.UIDs.UID;
         exception
            when Ada.IO_Exceptions.Data_Error => Rejected := True;
         end;
         pragma Assert (Rejected);
      end if;
   end loop;
   Cleanup;
   Ada.Text_IO.Put_Line ("PASS UID: file IO, little endian, image, invalid files");
exception
   when others =>
      Cleanup;
      raise;
end UID_Tests;
