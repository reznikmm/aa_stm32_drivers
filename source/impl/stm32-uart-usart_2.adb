--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.Streams;
with GNAT.OS_Lib;
with GNAT.Serial_Communications;
with Interfaces.C;

package body STM32.UART.USART_2 is
   pragma Unreferenced (Priority);
   use type Interfaces.Unsigned_32;
   use type Interfaces.C.int;
   use type Interfaces.C.unsigned_short;
   use type Ada.Streams.Stream_Element_Offset;
   use type System.Address;

   package Serial renames GNAT.Serial_Communications;

   type Direction is (Input, Output);
   type Request is record
      Buffer     : System.Address := System.Null_Address;
      Length     : Natural := 0;
      Till_Idle  : Boolean := False;
      Done       : A0B.Callbacks.Callback;
   end record;
   type Requests is array (Direction) of Request;
   type Flags is array (Direction) of Boolean;

   Port       : Serial.Serial_Port;
   Opened     : Boolean := False;
   Baud       : Serial.Data_Rate := Serial.B115200;
   Stops      : Serial.Stop_Bits_Number := Serial.One;
   Check      : Serial.Parity_Check := Serial.None;

   function Ready (Kind : Direction) return Boolean;
   procedure Transfer
     (Kind : Direction; Job : Request; Count : out Natural;
      Error : out Boolean);
   function To_Rate (Rate : Interfaces.Unsigned_32) return Serial.Data_Rate;
   function To_Stops (Value : Extended_Stop_Bits)
     return Serial.Stop_Bits_Number;
   function Pin_Name (Value : Pin) return String;
   procedure Apply
     (Rate : Serial.Data_Rate;
      Stop_Bits : Serial.Stop_Bits_Number;
      Parity : Serial.Parity_Check);
   procedure Submit (Kind : Direction; Job : Request);

   protected State is
      procedure Set_Enabled (Value : Boolean);
      function Enabled return Boolean;
      function Busy return Boolean;
      function Failed return Boolean;
      function Count return Natural;
      procedure Submit
        (Kind : Direction; Job : Request; Wake : out Boolean);
      procedure Take
        (Kind : Direction; Job : in out Request; Available : out Boolean);
      procedure Complete
        (Kind : Direction; Count : Natural; Error : Boolean);
   private
      Active   : Boolean := False;
      Running  : Flags := (others => False);
      Pending  : Flags := (others => False);
      Sleeping : Flags := (others => False);
      Errors   : Flags := (others => False);
      Jobs     : Requests;
      Received : Natural := 0;
   end State;

   protected body State is
      procedure Set_Enabled (Value : Boolean) is
      begin
         Active := Value;
      end Set_Enabled;

      function Enabled return Boolean is (Active);
      function Busy return Boolean is (Running (Input) or Running (Output));
      function Failed return Boolean is (Errors (Input) or Errors (Output));
      function Count return Natural is (Received);

      procedure Submit
        (Kind : Direction; Job : Request; Wake : out Boolean) is
      begin
         if not Active or else Running (Kind) then
            raise Program_Error with "UART disabled or direction already busy";
         end if;
         Jobs (Kind) := Job;
         Running (Kind) := True;
         Pending (Kind) := True;
         Errors (Kind) := False;
         Wake := Sleeping (Kind);
         Sleeping (Kind) := False;
      end Submit;

      procedure Take
        (Kind : Direction; Job : in out Request; Available : out Boolean) is
      begin
         Available := Pending (Kind);
         if Available then
            Job := Jobs (Kind);
            Pending (Kind) := False;
         else
            Sleeping (Kind) := True;
         end if;
      end Take;

      procedure Complete
        (Kind : Direction; Count : Natural; Error : Boolean) is
      begin
         if Kind = Input then
            Received := Count;
         end if;
         Errors (Kind) := Error;
         Running (Kind) := False;
      end Complete;
   end State;

   --  Linux poll(2) keeps reads cancellable without changing termios into
   --  canonical mode. The timeout also defines the receive idle interval.
   type Poll_Descriptor is record
      FD      : Interfaces.C.int;
      Events  : Interfaces.C.unsigned_short;
      Revents : Interfaces.C.unsigned_short;
   end record with Convention => C;

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
      loop
         Result := Poll (FD'Address, 1, 100);
         exit when Result >= 0;
         if GNAT.OS_Lib.Errno /= 4 then  --  EINTR
            raise Serial.Serial_Error with "UART poll failed";
         end if;
         if not State.Enabled then
            return False;
         end if;
      end loop;
      if (FD.Revents and Events) /= 0 then
         return True;
      elsif FD.Revents /= 0 then
         raise Serial.Serial_Error with "UART disconnected";
      else
         return False;
      end if;
   end Ready;

   procedure Transfer
     (Kind : Direction; Job : Request; Count : out Natural;
      Error : out Boolean)
   is
      Data : Ada.Streams.Stream_Element_Array
        (1 .. Ada.Streams.Stream_Element_Offset (Job.Length))
        with Import, Address => Job.Buffer;
      Last : Ada.Streams.Stream_Element_Offset;
      Sent : Integer;
      Available : Boolean;
   begin
      Count := 0;
      Error := False;
      while Count < Job.Length loop
         if not State.Enabled then
            Error := True;
            exit;
         end if;
         Available := Ready (Kind);
         if not State.Enabled then
            Error := True;
            exit;
         elsif Available then
            if Kind = Input then
               Serial.Read
                 (Port, Data (Ada.Streams.Stream_Element_Offset (Count + 1)
                              .. Data'Last), Last);
               if Last <= Ada.Streams.Stream_Element_Offset (Count) then
                  raise Serial.Serial_Error with "UART end of input";
               end if;
               Count := Natural (Last);
            else
               --  Unlike Serial.Write, OS_Lib.Write reports short writes.
               --  Bound each write so cancellation can be checked regularly.
               Sent := GNAT.OS_Lib.Write
                 (GNAT.OS_Lib.File_Descriptor (Serial.To_C (Port)),
                  Data (Ada.Streams.Stream_Element_Offset (Count + 1))'Address,
                  Integer'Min (256, Job.Length - Count));
               if Sent > 0 then
                  Count := Count + Sent;
               elsif Sent = 0 or else GNAT.OS_Lib.Errno /= 4 then
                  raise Serial.Serial_Error with "UART write failed";
               end if;
            end if;
         elsif Kind = Input and then Job.Till_Idle and then Count > 0 then
            exit;
         end if;
      end loop;
   exception
      when Serial.Serial_Error =>
         Error := True;
   end Transfer;

   task type Worker (Kind : Direction) is
      entry Wake;
   end Worker;

   task body Worker is
      Job       : Request;
      Available : Boolean;
      Count     : Natural;
      Error     : Boolean;
   begin
      loop
         State.Take (Kind, Job, Available);
         if Available then
            Transfer (Kind, Job, Count, Error);
            State.Complete (Kind, Count, Error);
            --  Mark complete before invoking user code, permitting rearming.
            A0B.Callbacks.Emit (Job.Done);
         else
            select
               accept Wake;
            or
               terminate;
            end select;
         end if;
      end loop;
   end Worker;

   Reader : Worker (Input);
   Writer : Worker (Output);

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
      State.Set_Enabled (True);
   end Enable;

   procedure Disable is
   begin
      State.Set_Enabled (False);
   end Disable;

   procedure Close is
   begin
      Disable;
      while Is_Busy loop
         delay 0.001;
      end loop;
      Serial.Close (Port);
      Opened := False;
   end Close;

   function Is_Busy return Boolean is (State.Busy);
   function Has_Error return Boolean is (State.Failed);
   function Bytes_Read return Natural is (State.Count);

   procedure Submit (Kind : Direction; Job : Request) is
      Wake : Boolean;
   begin
      if Job.Buffer = System.Null_Address then
         raise Constraint_Error with "UART buffer is null";
      end if;
      State.Submit (Kind, Job, Wake);
      if Wake then
         if Kind = Input then
            Reader.Wake;
         else
            Writer.Wake;
         end if;
      end if;
   end Submit;

   procedure Start_Reading
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Submit (Input, (Buffer, Length, False, Done));
   end Start_Reading;

   procedure Start_Reading_Till_Idle
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Submit (Input, (Buffer, Length, True, Done));
   end Start_Reading_Till_Idle;

   procedure Start_Writing
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback) is
   begin
      Submit (Output, (Buffer, Length, False, Done));
   end Start_Writing;
end STM32.UART.USART_2;
