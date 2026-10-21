--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.IO_Exceptions;
with Interfaces;
with Interfaces.C;
with GNAT.OS_Lib;
with STM32.Workers;

package body STM32.Flash is
   package C renames Interfaces.C;
   package OS renames GNAT.OS_Lib;
   use System.Storage_Elements;
   use type C.int;
   use type System.Address;
   use type OS.File_Descriptor;

   File_Name : constant String := "stm32-flash.bin";
   Bank_Size : constant := 1_048_576;
   Flash_Size : constant := 2 * Bank_Size;
   Chunk_Size : constant := 4_096;
   Base : constant Integer_Address := To_Integer (First_Bank);
   Mapped : Boolean := False;
   Unlocked : Boolean := False;

   --  Linux mmap/mprotect constants. NOREPLACE preserves unrelated mappings.
   Read_Only : constant := 1;
   Read_Write : constant := 3;
   Shared_No_Replace : constant := 1 + 16#10_0000#;
   Sync : constant := 4;

   function Open (Name : C.char_array; Flags : C.int; Mode : C.unsigned)
     return C.int
     with Import, Convention => C, External_Name => "open";
   function Map
     (Address : System.Address; Length : C.size_t;
      Protection, Flags, FD : C.int; Offset : C.long) return System.Address
     with Import, Convention => C, External_Name => "mmap";
   function Protect
     (Address : System.Address; Length : C.size_t; Mode : C.int) return C.int
     with Import, Convention => C, External_Name => "mprotect";
   function Persist
     (Address : System.Address; Length : C.size_t; Flags : C.int) return C.int
     with Import, Convention => C, External_Name => "msync";
   function Unmap (Address : System.Address; Length : C.size_t) return C.int
     with Import, Convention => C, External_Name => "munmap";

   procedure Set_Protection (Mode : C.int);
   procedure Initialize;
   procedure Check_Idle;
   procedure Check_Unlocked;

   type Erase_Request is record
      Offset : Storage_Offset;
      Size   : Positive;
   end record;
   procedure Erase_Step
     (Request : in out Erase_Request; Count : in out Natural;
      Status : out STM32.Workers.Step_Status);

   procedure Set_Protection (Mode : C.int) is
   begin
      if Protect (First_Bank, Flash_Size, Mode) /= 0 then
         raise Ada.IO_Exceptions.Use_Error with "Cannot protect flash mapping";
      end if;
   end Set_Protection;

   procedure Erase_Step
     (Request : in out Erase_Request; Count : in out Natural;
      Status : out STM32.Workers.Step_Status)
   is
      Length : constant Positive :=
        Integer'Min (Chunk_Size, Request.Size - Count);
      Data : array (1 .. Length) of Interfaces.Unsigned_8
        with Import, Address => First_Bank + Request.Offset
          + Storage_Offset (Count), Volatile;
   begin
      Data := (others => 16#FF#);
      Count := Count + Length;
      if Count = Request.Size then
         Set_Protection (Read_Only);
         Status := STM32.Workers.Completed;
      else
         Status := STM32.Workers.Pending;
      end if;
   end Erase_Step;

   package Eraser is new STM32.Workers.Generic_Worker
     (Erase_Request, Erase_Step);

   procedure Initialize is
      FD : OS.File_Descriptor := OS.Invalid_FD;
      Created : Boolean := False;
      Valid_File : Boolean := False;
      Deleted : Boolean;
      Data : constant array (1 .. Chunk_Size) of Interfaces.Unsigned_8 :=
        (others => 16#FF#);
      Written : Natural := 0;
      Count : Integer;
      Address : System.Address;
      Ignored : C.int;
   begin
      if Mapped then
         return;
      end if;
      --  O_RDWR | O_CREAT | O_EXCL, mode 0600. Never truncate existing data.
      FD := OS.File_Descriptor (Open (C.To_C (File_Name), 194, 8#600#));
      if FD = OS.Invalid_FD then
         if OS.Errno /= 17 then  --  EEXIST
            raise Ada.IO_Exceptions.Use_Error with "Cannot create flash file";
         end if;
         FD := OS.File_Descriptor (Open (C.To_C (File_Name), 2, 0));
      else
         Created := True;
      end if;
      if FD = OS.Invalid_FD then
         raise Ada.IO_Exceptions.Use_Error with "Cannot open flash file";
      end if;
      if Created then
         while Written < Flash_Size loop
            Count := OS.Write
              (FD, Data (Written mod Chunk_Size + 1)'Address,
               Chunk_Size - Written mod Chunk_Size);
            if Count > 0 then
               Written := Written + Count;
            elsif Count = 0 or else OS.Errno /= 4 then  --  EINTR
               raise Ada.IO_Exceptions.Use_Error with
                 "Cannot initialize flash";
            end if;
         end loop;
      end if;
      if OS.File_Length (FD) /= Flash_Size then
         raise Ada.IO_Exceptions.Data_Error with
           "stm32-flash.bin must contain exactly 2 MiB";
      end if;
      Valid_File := True;
      Address := Map
        (First_Bank, Flash_Size, Read_Only, Shared_No_Replace, C.int (FD), 0);
      if Address /= First_Bank then
         if Address /= To_Address (Integer_Address'Last) then
            --  Old kernels may ignore NOREPLACE and map at another address.
            Ignored := Unmap (Address, Flash_Size);
         end if;
         raise Ada.IO_Exceptions.Use_Error with
           "Cannot map flash at 0x08000000 without replacing process memory";
      end if;
      OS.Close (FD);
      FD := OS.Invalid_FD;
      Mapped := True;
   exception
      when others =>
         if FD /= OS.Invalid_FD then
            OS.Close (FD);
         end if;
         if Created and not Valid_File then
            OS.Delete_File (File_Name, Deleted);
         end if;
         raise;
   end Initialize;

   procedure Check_Idle is
   begin
      if Eraser.Is_Busy then
         raise Program_Error with "Flash erase is busy";
      end if;
   end Check_Idle;

   procedure Check_Unlocked is
   begin
      if not Unlocked then
         raise Program_Error with "Flash is locked";
      end if;
      Check_Idle;
   end Check_Unlocked;

   procedure Unlock is
   begin
      Check_Idle;
      Initialize;
      Eraser.Enable;
      Unlocked := True;
   end Unlock;

   procedure Flush is
   begin
      Check_Idle;
      if Mapped and then Persist (First_Bank, Flash_Size, Sync) /= 0 then
         raise Ada.IO_Exceptions.Use_Error with "Cannot flush flash file";
      end if;
   end Flush;

   procedure Lock is
   begin
      Check_Idle;
      if Mapped then
         Set_Protection (Read_Only);
         Unlocked := False;
         Flush;
      end if;
   end Lock;

   procedure Programming is
   begin
      Check_Unlocked;
      Set_Protection (Read_Write);
   end Programming;

   procedure Erase_Sector
     (Address : System.Address;
      Size    : out Storage_Count;
      Done    : A0B.Callbacks.Callback)
   is
      Offset, Local, Start : Integer_Address;
   begin
      Check_Unlocked;
      if To_Integer (Address) not in Base .. Base + Flash_Size - 1 then
         raise Constraint_Error with "Address is outside STM32 flash";
      end if;
      Offset := To_Integer (Address) - Base;
      Local := Offset mod Bank_Size;
      if Local < 16#1_0000# then
         Size := 16 * 1_024;
      elsif Local < 16#2_0000# then
         Size := 64 * 1_024;
      else
         Size := 128 * 1_024;
      end if;
      Start := Offset - Local + (Local / Integer_Address (Size))
        * Integer_Address (Size);
      Set_Protection (Read_Write);
      Eraser.Start ((Storage_Offset (Start), Positive (Size)), Done);
   end Erase_Sector;

   function Is_Busy return Boolean is (Eraser.Is_Busy);
   function Has_Error return Boolean is (Eraser.Has_Error);

   procedure Close is
   begin
      Eraser.Wait_Until_Idle;
      Flush;
      if Mapped then
         if Unmap (First_Bank, Flash_Size) /= 0 then
            raise Ada.IO_Exceptions.Use_Error with "Cannot unmap flash";
         end if;
         Mapped := False;
      end if;
      Unlocked := False;
      Eraser.Disable;
   end Close;

end STM32.Flash;
