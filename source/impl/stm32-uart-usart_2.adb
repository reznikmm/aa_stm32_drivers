--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.Streams;
with Ada.Real_Time;
with GNAT.OS_Lib;
with GNAT.Serial_Communications;
with Interfaces.C;
with STM32.Workers;

package body STM32.UART.USART_2 is
   pragma Unreferenced (Priority);
   use type Interfaces.Unsigned_32;
   use type Interfaces.C.int;
   use type Interfaces.C.unsigned_short;
   use type System.Address;

   use type Ada.Real_Time.Time;

   package Serial renames GNAT.Serial_Communications;

   type Direction is (Input, Output);
   type Request is record
      Buffer     : System.Address := System.Null_Address;
      Length     : Natural := 0;
      Till_Idle  : Boolean := False;
      Last_Input : Ada.Real_Time.Time := Ada.Real_Time.Time_First;
   end record;

   Port       : Serial.Serial_Port;
   Opened     : Boolean := False;
   Baud       : Serial.Data_Rate := Serial.B115200;
   Stops      : Serial.Stop_Bits_Number := Serial.One;
   Check      : Serial.Parity_Check := Serial.None;

   function Ready (Kind : Direction) return Boolean;
   procedure Transfer_Step
     (Kind : Direction; Job : in out Request; Count : in out Natural;
      Status : out STM32.Workers.Step_Status);
   function To_Rate (Rate : Interfaces.Unsigned_32) return Serial.Data_Rate;
   function To_Stops (Value : Extended_Stop_Bits)
     return Serial.Stop_Bits_Number;
   function Pin_Name (Value : Pin) return String;
   procedure Apply
     (Rate : Serial.Data_Rate;
      Stop_Bits : Serial.Stop_Bits_Number;
      Parity : Serial.Parity_Check);
   procedure Read_Step
     (Job : in out Request; Count : in out Natural;
      Status : out STM32.Workers.Step_Status);
   procedure Write_Step
     (Job : in out Request; Count : in out Natural;
      Status : out STM32.Workers.Step_Status);
   procedure Check_Buffer (Buffer : System.Address);

   --  Poll readiness without blocking the shared dispatcher. Idle reception
   --  uses a monotonic timestamp carried by the request between steps.
   type Poll_Descriptor is record
      FD      : Interfaces.C.int;
      Events  : Interfaces.C.unsigned_short;
      Revents : Interfaces.C.unsigned_short;
   end record with Convention => C;

   F_Setfl : constant := 4;
   Nonblocking : constant := 2_048;

   function Set_Flags
     (FD, Command, Flags : Interfaces.C.int) return Interfaces.C.int
     with Import, Convention => C, External_Name => "fcntl";

   function Poll
     (FDs : System.Address;
      Count : Interfaces.C.unsigned_long;
      Timeout : Interfaces.C.int) return Interfaces.C.int
     with Import, Convention => C, External_Name => "poll";

   function Ready (Kind : Direction) return Boolean is
      Events : constant Interfaces.C.unsigned_short :=
        (if Kind = Input then 1 else 4);
      FD : aliased Poll_Descriptor :=
        (Interfaces.C.int (Serial.To_C (Port)), Events, 0);
      Result : Interfaces.C.int;
   begin
      Result := Poll (FD'Address, 1, 0);
      if Result < 0 then
         if GNAT.OS_Lib.Errno = 4 then  --  EINTR
            return False;
         end if;
         raise Serial.Serial_Error with "UART poll failed";
      end if;
      if (FD.Revents and Events) /= 0 then
         return True;
      elsif FD.Revents /= 0 then
         raise Serial.Serial_Error with "UART disconnected";
      else
         return False;
      end if;
   end Ready;

   procedure Transfer_Step
     (Kind : Direction; Job : in out Request; Count : in out Natural;
      Status : out STM32.Workers.Step_Status)
   is
      Data : Ada.Streams.Stream_Element_Array
        (1 .. Ada.Streams.Stream_Element_Offset (Job.Length))
        with Import, Address => Job.Buffer;
      Read_Count : Integer;
      Sent : Integer;
   begin
      Status := STM32.Workers.Pending;
      if Ready (Kind) then
         if Kind = Input then
            Read_Count := GNAT.OS_Lib.Read
              (GNAT.OS_Lib.File_Descriptor (Serial.To_C (Port)),
               Data (Ada.Streams.Stream_Element_Offset (Count + 1))'Address,
               Job.Length - Count);
            if Read_Count > 0 then
               Count := Count + Read_Count;
               Job.Last_Input := Ada.Real_Time.Clock;
            elsif Read_Count = 0 then
               raise Serial.Serial_Error with "UART end of input";
            elsif GNAT.OS_Lib.Errno not in 4 | 11 then  --  EINTR, EAGAIN
               raise Serial.Serial_Error with "UART read failed";
            end if;
         else
            Sent := GNAT.OS_Lib.Write
              (GNAT.OS_Lib.File_Descriptor (Serial.To_C (Port)),
               Data (Ada.Streams.Stream_Element_Offset (Count + 1))'Address,
               Integer'Min (256, Job.Length - Count));
            if Sent > 0 then
               Count := Count + Sent;
            elsif Sent = 0 or else GNAT.OS_Lib.Errno not in 4 | 11 then
               raise Serial.Serial_Error with "UART write failed";
            end if;
         end if;
         if Count = Job.Length then
            Status := STM32.Workers.Completed;
         end if;
      elsif Kind = Input and then Job.Till_Idle and then Count > 0
        and then Ada.Real_Time.Clock >=
          Job.Last_Input + Ada.Real_Time.Milliseconds (100)
      then
         Status := STM32.Workers.Completed;
      end if;
   exception
      when Serial.Serial_Error =>
         Status := STM32.Workers.Failed;
   end Transfer_Step;

   procedure Read_Step
     (Job : in out Request; Count : in out Natural;
      Status : out STM32.Workers.Step_Status) is
   begin
      Transfer_Step (Input, Job, Count, Status);
   end Read_Step;

   procedure Write_Step
     (Job : in out Request; Count : in out Natural;
      Status : out STM32.Workers.Step_Status) is
   begin
      Transfer_Step (Output, Job, Count, Status);
   end Write_Step;

   package Reader is new STM32.Workers.Generic_Worker (Request, Read_Step);
   package Writer is new STM32.Workers.Generic_Worker (Request, Write_Step);

   function To_Rate (Rate : Interfaces.Unsigned_32) return Serial.Data_Rate is
   begin
      for Item in Serial.Data_Rate loop
         if Interfaces.Unsigned_32'Value
           (Serial.Data_Rate'Image (Item) (2 ..
              Serial.Data_Rate'Image (Item)'Last)) = Rate
         then
            return Item;
         end if;
      end loop;
      raise Constraint_Error with "Unsupported UART baud rate";
   end To_Rate;

   function To_Stops (Value : Extended_Stop_Bits)
     return Serial.Stop_Bits_Number is
   begin
      if Value = 1.0 then
         return Serial.One;
      elsif Value = 2.0 then
         return Serial.Two;
      else
         raise Constraint_Error with "Linux supports 1 or 2 stop bits";
      end if;
   end To_Stops;

   function To_Parity (Value : Parity) return Serial.Parity_Check is
     (case Value is
         when None => Serial.None,
         when Even => Serial.Even,
         when Odd => Serial.Odd);

   function Pin_Name (Value : Pin) return String is
      Index : constant String := Pin_Index'Image (Value.Pin);
   begin
      return STM32.Port'Image (Value.Port) & Index (2 .. Index'Last);
   end Pin_Name;

   procedure Apply
     (Rate : Serial.Data_Rate;
      Stop_Bits : Serial.Stop_Bits_Number;
      Parity : Serial.Parity_Check) is
   begin
      if not Opened or else Is_Busy then
         raise Program_Error with "UART must be open and idle to configure";
      end if;
      Serial.Set
        (Port, Rate => Rate, Bits => Serial.CS8, Stop_Bits => Stop_Bits,
         Parity => Parity, Block => True, Timeout => 0.0);
      --  Serial.Set configures raw input; then enforce nonblocking IO so
      --  even a full output queue cannot stall unrelated devices.
      if Set_Flags
        (Interfaces.C.int (Serial.To_C (Port)), F_Setfl, Nonblocking) < 0
      then
         raise Serial.Serial_Error with "Cannot enable nonblocking UART IO";
      end if;
      Baud := Rate;
      Stops := Stop_Bits;
      Check := Parity;
   end Apply;

   procedure Configure
     (TX        : Pin;
      RX        : Pin;
      Rate      : Interfaces.Unsigned_32;
      Parity    : STM32.UART.Parity := None;
      Stop_Bits : Extended_Stop_Bits := 1.0)
   is
      New_Rate : constant Serial.Data_Rate := To_Rate (Rate);
      New_Stops : constant Serial.Stop_Bits_Number := To_Stops (Stop_Bits);
   begin
      if Is_Busy then
         raise Program_Error with "UART is busy";
      end if;
      Close;
      Serial.Open
        (Port, Serial.Port_Name
           ("./uart_2_" & Pin_Name (TX) & "_" & Pin_Name (RX)));
      Opened := True;
      begin
         Apply (New_Rate, New_Stops, To_Parity (Parity));
      exception
         when others =>
            Close;
            raise;
      end;
      Enable;
   end Configure;

   procedure Set_Baud_Rate (Rate : Interfaces.Unsigned_32) is
   begin
      Apply (To_Rate (Rate), Stops, Check);
   end Set_Baud_Rate;

   procedure Set_Stop_Bits (Value : Extended_Stop_Bits) is
   begin
      Apply (Baud, To_Stops (Value), Check);
   end Set_Stop_Bits;

   procedure Set_Stop_Bits (Value : Standard_Stop_Bits) is
   begin
      Set_Stop_Bits (Extended_Stop_Bits'(+Value));
   end Set_Stop_Bits;

   procedure Set_Parity (Value : Parity) is
   begin
      Apply (Baud, Stops, To_Parity (Value));
   end Set_Parity;

   procedure Enable is
   begin
      if not Opened or else Is_Busy then
         raise Program_Error with "UART must be open and idle to enable";
      end if;
      Reader.Enable;
      Writer.Enable;
   end Enable;

   procedure Disable is
   begin
      Reader.Disable;
      Writer.Disable;
   end Disable;

   procedure Close is
   begin
      Disable;
      Reader.Wait_Until_Idle;
      Writer.Wait_Until_Idle;
      Serial.Close (Port);
      Opened := False;
   end Close;

   function Is_Busy return Boolean is (Reader.Is_Busy or Writer.Is_Busy);
   function Has_Error return Boolean is (Reader.Has_Error or Writer.Has_Error);
   function Bytes_Read return Natural is (Reader.Count);

   procedure Check_Buffer (Buffer : System.Address) is
   begin
      if Buffer = System.Null_Address then
         raise Constraint_Error with "UART buffer is null";
      end if;
   end Check_Buffer;

   procedure Start_Reading
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Check_Buffer (Buffer);
      Reader.Start ((Buffer, Length, False, others => <>), Done);
   end Start_Reading;

   procedure Start_Reading_Till_Idle
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Check_Buffer (Buffer);
      Reader.Start ((Buffer, Length, True, others => <>), Done);
   end Start_Reading_Till_Idle;

   procedure Start_Writing
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Check_Buffer (Buffer);
      Writer.Start ((Buffer, Length, False, others => <>), Done);
   end Start_Writing;
end STM32.UART.USART_2;
