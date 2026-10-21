--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.Directories;
with Ada.Real_Time;
with Ada.Text_IO;
with GNAT.Expect;
with GNAT.OS_Lib;
with Interfaces.C;
with System;

procedure Test_UART is
   package C renames Interfaces.C;
   package OS renames GNAT.OS_Lib;
   use type C.int;
   use type C.unsigned_short;
   use type System.Address;
   use type OS.File_Descriptor;
   use type GNAT.Expect.Expect_Match;
   use type Ada.Real_Time.Time;

   function Open_PTY
     (Master, Slave : access C.int;
      Name, Settings, Window : System.Address) return C.int
     with Import, Convention => C, External_Name => "openpty";
   function Make_Temp_Dir (Template : in out C.char_array) return System.Address
     with Import, Convention => C, External_Name => "mkdtemp";
   function Set_FD_Flags (FD, Command, Flags : C.int) return C.int
     with Import, Convention => C, External_Name => "fcntl";
   function Symlink (Target, Name : C.char_array) return C.int
     with Import, Convention => C, External_Name => "symlink";

   type Poll_Descriptor is record
      FD      : C.int;
      Events  : C.unsigned_short;
      Revents : C.unsigned_short;
   end record with Convention => C;
   function Poll
     (FDs : System.Address; Count : C.unsigned_long; Timeout : C.int)
      return C.int
     with Import, Convention => C, External_Name => "poll";

   Root : constant String := Ada.Directories.Current_Directory;

   procedure Check (Condition : Boolean; Message : String) is
   begin
      if not Condition then
         raise Program_Error with Message;
      end if;
   end Check;

   procedure Read_Exact (FD : OS.File_Descriptor; Expected : String) is
      Buffer : String (1 .. 4_096);
      Count : Integer;
      Received : Natural := 0;
      Item : aliased Poll_Descriptor := (C.int (FD), 1, 0);
      Deadline : constant Ada.Real_Time.Time :=
        Ada.Real_Time.Clock + Ada.Real_Time.Seconds (5);
      Result : C.int;
   begin
      while Received < Expected'Length loop
         Check (Ada.Real_Time.Clock < Deadline, "UART receive timeout");
         Result := Poll (Item'Address, 1, 100);
         Check (Result >= 0, "UART poll failed");
         if Result > 0 then
            Check ((Item.Revents and 1) /= 0, "UART disconnected");
            Count := OS.Read
              (FD, Buffer'Address,
               Integer'Min (Buffer'Length, Expected'Length - Received));
            Check (Count > 0, "UART read failed");
            Check
              (Buffer (1 .. Count) =
                 Expected (Expected'First + Received ..
                           Expected'First + Received + Count - 1),
               "Unexpected UART data");
            Received := Received + Count;
         end if;
      end loop;
   end Read_Exact;

   procedure Send (FD : OS.File_Descriptor; Data : String) is
      Sent : Natural := 0;
      Count : Integer;
   begin
      while Sent < Data'Length loop
         Count := OS.Write
           (FD, Data (Data'First + Sent)'Address, Data'Length - Sent);
         Check (Count > 0, "UART write failed");
         Sent := Sent + Count;
      end loop;
   end Send;

   procedure Ready (Child : in out GNAT.Expect.Process_Descriptor) is
      Match : GNAT.Expect.Expect_Match;
   begin
      GNAT.Expect.Expect (Child, Match, "READY", Timeout => 5_000);
      Check (Match = 1, "No READY from test");
   end Ready;

   procedure Still_Running (Child : in out GNAT.Expect.Process_Descriptor) is
      Match : GNAT.Expect.Expect_Match;
   begin
      GNAT.Expect.Expect (Child, Match, "", Timeout => 200);
      Check (Match = GNAT.Expect.Expect_Timeout, "Unexpected test output");
   end Still_Running;

   procedure Run_Case (Mode : String) is
      Template : C.char_array := C.To_C ("/tmp/uart-test-XXXXXX");
      Master, Slave : aliased C.int := -1;
      Name : aliased C.char_array (0 .. 255) := (others => C.nul);
      Child : GNAT.Expect.Process_Descriptor;
      Started : Boolean := False;
      Created : Boolean := False;
      Argument : aliased String := (if Mode = "demo" then "2" else Mode);
      Args : OS.Argument_List := (1 => Argument'Unchecked_Access);
      Status : Integer;
      Match : GNAT.Expect.Expect_Match;
      Deleted : Boolean;

      procedure Cleanup is
      begin
         if Started then
            GNAT.Expect.Close (Child);
            Started := False;
         end if;
         if Master >= 0 then
            OS.Close (OS.File_Descriptor (Master));
            Master := -1;
         end if;
         if Slave >= 0 then
            OS.Close (OS.File_Descriptor (Slave));
            Slave := -1;
         end if;
         Ada.Directories.Set_Directory (Root);
         if Created then
            OS.Delete_File (C.To_Ada (Template) & "/uart_2_PA2_PA3", Deleted);
            OS.Delete_File (C.To_Ada (Template) & "/uart_2_PD5_PD6", Deleted);
            Ada.Directories.Delete_Directory (C.To_Ada (Template));
            Created := False;
         end if;
      end Cleanup;
   begin
      Check (Make_Temp_Dir (Template) /= System.Null_Address,
             "Cannot create temporary directory");
      Created := True;
      Ada.Directories.Set_Directory (C.To_Ada (Template));
      Check
        (Open_PTY (Master'Access, Slave'Access, Name'Address,
                   System.Null_Address, System.Null_Address) = 0,
         "Cannot open pseudo terminal");
      --  Child processes must not inherit either side of the pseudo terminal.
      Check (Set_FD_Flags (Master, 2, 1) = 0, "Cannot set master CLOEXEC");
      Check (Set_FD_Flags (Slave, 2, 1) = 0, "Cannot set slave CLOEXEC");
      if Mode /= "missing" then
         Check
           (Symlink
              (Name, C.To_C (if Mode = "alternate" then "uart_2_PD5_PD6"
                             else "uart_2_PA2_PA3")) = 0,
            "Cannot create UART symlink");
      end if;
      GNAT.Expect.Non_Blocking_Spawn
        (Child,
         Root & (if Mode = "demo" then "/demos/linux/bin/uart_irq"
                 else "/tests/bin/uart_tests"),
         Args, Err_To_Out => True);
      Started := True;
      if Mode /= "missing" and Mode /= "demo" then
         Ready (Child);
      end if;

      if Mode = "duplex" or Mode = "alternate" then
         Read_Exact (OS.File_Descriptor (Master), "Hello, World!");
         Send (OS.File_Descriptor (Master), "ab");
         Still_Running (Child);
         Send (OS.File_Descriptor (Master), "cde");
      elsif Mode = "idle" or Mode = "full" then
         Still_Running (Child);
         Send (OS.File_Descriptor (Master), "ab");
         delay 0.03;
         Send (OS.File_Descriptor (Master), "cde");
      elsif Mode = "cancel" then
         Ready (Child);
         Send (OS.File_Descriptor (Master), "abcde");
      elsif Mode = "rearm" or Mode = "demo" then
         Read_Exact (OS.File_Descriptor (Master), "Hello, World!Hello, World!");
      elsif Mode = "large" then
         Read_Exact (OS.File_Descriptor (Master), (1 .. 65_536 => 'X'));
      elsif Mode = "disconnect" then
         OS.Close (OS.File_Descriptor (Master));
         Master := -1;
      end if;

      begin
         GNAT.Expect.Expect (Child, Match, "", Timeout => 5_000);
         if Match = GNAT.Expect.Expect_Timeout then
            raise Program_Error with Mode & ": child exit timeout";
         else
            raise Program_Error with Mode & ": " & GNAT.Expect.Expect_Out (Child);
         end if;
      exception
         when GNAT.Expect.Process_Died => null;
      end;
      GNAT.Expect.Close (Child, Status);
      Started := False;
      Check (Status = 0, Mode & ": child failed, status" & Status'Image);
      Cleanup;
      Ada.Text_IO.Put_Line ("PASS " & Mode);
   exception
      when others =>
         Cleanup;
         raise;
   end Run_Case;
begin
   Run_Case ("missing");
   Run_Case ("duplex");
   Run_Case ("alternate");
   Run_Case ("idle");
   Run_Case ("full");
   Run_Case ("cancel");
   Run_Case ("rearm");
   Run_Case ("large");
   Run_Case ("disconnect");
   Run_Case ("demo");
end Test_UART;
