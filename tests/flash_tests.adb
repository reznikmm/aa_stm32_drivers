--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.Directories;
with Ada.IO_Exceptions;
with Ada.Real_Time;
with Ada.Streams.Stream_IO;
with Ada.Synchronous_Task_Control;
with Ada.Task_Identification;
with Ada.Text_IO;
with A0B.Callbacks;
with A0B.Callbacks.Generic_Parameterless;
with Interfaces;
with Interfaces.C;
with STM32.Flash;
with System.Storage_Elements;

procedure Flash_Tests is
   package Flash renames STM32.Flash;
   package IO renames Ada.Streams.Stream_IO;
   package C renames Interfaces.C;
   use System.Storage_Elements;
   use Ada.Synchronous_Task_Control;
   use type C.int;
   use type System.Address;
   use type IO.Count;
   use type Interfaces.Unsigned_8;
   use type Interfaces.Unsigned_32;
   use type Ada.Real_Time.Time;
   use type Ada.Task_Identification.Task_ID;

   function Make_Temp_Dir (Template : in out C.char_array) return System.Address
     with Import, Convention => C, External_Name => "mkdtemp";
   function Map
     (Address : System.Address; Length : C.size_t;
      Protection, Flags, FD : C.int; Offset : C.long) return System.Address
     with Import, Convention => C, External_Name => "mmap";
   function Unmap (Address : System.Address; Length : C.size_t) return C.int
     with Import, Convention => C, External_Name => "munmap";

   Root : constant String := Ada.Directories.Current_Directory;
   Template : C.char_array := C.To_C ("/tmp/flash-test-XXXXXX");
   Created : Boolean := False;
   Reserved : Boolean := False;
   Flash_Size : constant := 2_097_152;
   Bytes : array (Storage_Offset range 0 .. Flash_Size - 1)
     of Interfaces.Unsigned_8
     with Import, Address => Flash.First_Bank, Volatile;
   First_Word : Interfaces.Unsigned_32
     with Import, Address => Flash.First_Bank + 4, Volatile;
   Second_Word : Interfaces.Unsigned_32
     with Import, Address => Flash.Second_Bank + 4, Volatile;
   Signal : Suspension_Object;
   Calls : Natural := 0;
   Callback_Task : Ada.Task_Identification.Task_ID :=
     Ada.Task_Identification.Null_Task_Id;

   procedure On_Done is
   begin
      Calls := Calls + 1;
      Callback_Task := Ada.Task_Identification.Current_Task;
      Set_True (Signal);
   end On_Done;
   package Callbacks is new A0B.Callbacks.Generic_Parameterless (On_Done);
   Done : constant A0B.Callbacks.Callback := Callbacks.Create_Callback;

   procedure Wait_Done is
      Deadline : constant Ada.Real_Time.Time :=
        Ada.Real_Time.Clock + Ada.Real_Time.Seconds (5);
   begin
      while not Current_State (Signal) loop
         if Ada.Real_Time.Clock >= Deadline then
            raise Program_Error with "Erase callback timeout";
         end if;
         delay 0.001;
      end loop;
      Set_False (Signal);
      pragma Assert (not Flash.Is_Busy and not Flash.Has_Error);
      pragma Assert (Callback_Task /= Ada.Task_Identification.Current_Task);
   end Wait_Done;

   procedure Check_Disk_Word (Offset : IO.Positive_Count; Last : Natural) is
      File : IO.File_Type;
      Data : Ada.Streams.Stream_Element_Array (1 .. 4);
      Read_Last : Ada.Streams.Stream_Element_Offset;
   begin
      IO.Open (File, IO.In_File, "stm32-flash.bin");
      pragma Assert (IO.Size (File) = Flash_Size);
      IO.Set_Index (File, Offset);
      IO.Read (File, Data, Read_Last);
      IO.Close (File);
      pragma Assert
        (Natural (Data (1)) = Last and Natural (Data (2)) = 16#CC#
         and Natural (Data (3)) = 16#BB# and Natural (Data (4)) = 16#AA#);
   exception
      when others =>
         if IO.Is_Open (File) then
            IO.Close (File);
         end if;
         raise;
   end Check_Disk_Word;

   procedure Cleanup is
      Ignored : C.int;
   begin
      Flash.Close;
      if Reserved then
         Ignored := Unmap (Flash.First_Bank, Flash_Size);
         Reserved := False;
      end if;
      Ada.Directories.Set_Directory (Root);
      if Created then
         Ada.Directories.Delete_Tree (C.To_Ada (Template));
         Created := False;
      end if;
   end Cleanup;

   File : IO.File_Type;
   Short_Data : Ada.Streams.Stream_Element_Array (1 .. 1) := (others => 42);
   Rejected : Boolean;
   Address : System.Address;
   Size : Storage_Count;
   Offset : Storage_Offset := 0;
   Expected : Storage_Count;
begin
   if Make_Temp_Dir (Template) = System.Null_Address then
      raise Program_Error with "Cannot create temporary directory";
   end if;
   Created := True;
   Ada.Directories.Set_Directory (C.To_Ada (Template));
   Flash.Close;

   IO.Create (File, IO.Out_File, "stm32-flash.bin");
   IO.Write (File, Short_Data);
   IO.Close (File);
   Rejected := False;
   begin
      Flash.Unlock;
   exception
      when Ada.IO_Exceptions.Data_Error => Rejected := True;
   end;
   pragma Assert (Rejected);
   IO.Open (File, IO.In_File, "stm32-flash.bin");
   pragma Assert (IO.Size (File) = 1);
   IO.Close (File);
   Ada.Directories.Delete_File ("stm32-flash.bin");

   --  Reserving the range must make Unlock fail without overwriting it.
   Address := Map (Flash.First_Bank, Flash_Size, 3, 16#10_0022#, -1, 0);
   if Address /= Flash.First_Bank then
      raise Program_Error with "Cannot reserve flash address range for test";
   end if;
   Reserved := True;
   Bytes (0) := 16#5A#;
   Rejected := False;
   begin
      Flash.Unlock;
   exception
      when Ada.IO_Exceptions.Use_Error => Rejected := True;
   end;
   pragma Assert (Rejected and Bytes (0) = 16#5A#);
   pragma Assert (Unmap (Flash.First_Bank, Flash_Size) = 0);
   Reserved := False;

   Flash.Unlock;
   pragma Assert ((for all Item of Bytes => Item = 16#FF#));
   Flash.Programming;
   Bytes := (others => 0);

   --  All 24 sectors, addressed through interior pointers, in both banks.
   for Bank in 1 .. 2 loop
      for Sector in 0 .. 11 loop
         if Sector < 4 then
            Expected := 16 * 1_024;
         elsif Sector = 4 then
            Expected := 64 * 1_024;
         else
            Expected := 128 * 1_024;
         end if;
         Flash.Erase_Sector
           (Flash.First_Bank + Offset + Expected / 2, Size, Done);
         pragma Assert (Size = Expected);
         Wait_Done;
         for J in Offset .. Offset + Expected - 1 loop
            pragma Assert (Bytes (J) = 16#FF#);
         end loop;
         if Offset > 0 then
            pragma Assert (Bytes (Offset - 1) = 16#FF#);
         end if;
         Offset := Offset + Expected;
         if Offset < Flash_Size then
            pragma Assert (Bytes (Offset) = 0);
         end if;
      end loop;
   end loop;
   pragma Assert (Calls = 24 and Offset = Flash_Size);

   Rejected := False;
   begin
      Flash.Erase_Sector (Flash.First_Bank - 1, Size, Done);
   exception
      when Constraint_Error => Rejected := True;
   end;
   pragma Assert (Rejected);
   Rejected := False;
   begin
      Flash.Erase_Sector (Flash.First_Bank + Flash_Size, Size, Done);
   exception
      when Constraint_Error => Rejected := True;
   end;
   pragma Assert (Rejected);

   Flash.Programming;
   First_Word := 16#AABB_CCDD#;
   Flash.Programming;
   Second_Word := 16#AABB_CCEE#;
   Flash.Flush;
   Check_Disk_Word (5, 16#DD#);
   Check_Disk_Word (1_048_581, 16#EE#);
   Flash.Lock;
   pragma Assert (First_Word = 16#AABB_CCDD#);
   Rejected := False;
   begin
      Flash.Programming;
   exception
      when Program_Error => Rejected := True;
   end;
   pragma Assert (Rejected);
   Rejected := False;
   begin
      Flash.Erase_Sector (Flash.Second_Bank, Size, Done);
   exception
      when Program_Error => Rejected := True;
   end;
   pragma Assert (Rejected);
   Flash.Close;
   Flash.Close;

   Flash.Unlock;
   pragma Assert (First_Word = 16#AABB_CCDD#);
   pragma Assert (Second_Word = 16#AABB_CCEE#);
   --  Close also waits for a pending erase and persists its result.
   Flash.Erase_Sector (Flash.Second_Bank + 4, Size, Done);
   Flash.Close;
   pragma Assert (Calls = 25);
   Flash.Unlock;
   pragma Assert (Second_Word = 16#FFFF_FFFF#);
   pragma Assert (First_Word = 16#AABB_CCDD#);
   Cleanup;
   Ada.Text_IO.Put_Line
     ("PASS flash: mapping, 24 sectors, protection, persistence, callbacks");
exception
   when others =>
      if IO.Is_Open (File) then
         IO.Close (File);
      end if;
      Cleanup;
      raise;
end Flash_Tests;
