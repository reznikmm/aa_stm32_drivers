--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.Real_Time;
with Ada.Synchronous_Task_Control;
with Ada.Text_IO;
with Ada.Task_Identification;
with A0B.Callbacks;
with STM32.Workers;
with Suspension_Object_Callbacks;
with System;

procedure Workers_Tests is
   use Ada.Synchronous_Task_Control;
   use type Ada.Real_Time.Time;
   use type Ada.Task_Identification.Task_ID;
   Observed_Task : Ada.Task_Identification.Task_ID :=
     Ada.Task_Identification.Null_Task_Id;

   --  A paired-buffer transaction, independent of the UART request format.
   type Operation_Kind is (Exchange, Wait_For_Cancel, Raise_Error);
   type Transaction is record
      TX, RX : System.Address;
      Length : Positive;
      Operation : Operation_Kind := Exchange;
      Visited : Boolean := False;
   end record;

   Begun, First_Done, Second_Done, Scope_Done : aliased Suspension_Object;
   First_Callback : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (First_Done);
   Second_Callback : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Second_Done);
   Scope_Callback : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Scope_Done);

   procedure Step
     (Job : in out Transaction; Count : in out Natural;
      Status : out STM32.Workers.Step_Status)
   is
      TX : String (1 .. Job.Length) with Import, Address => Job.TX;
      RX : String (1 .. Job.Length) with Import, Address => Job.RX;
   begin
      if Observed_Task = Ada.Task_Identification.Null_Task_Id then
         Observed_Task := Ada.Task_Identification.Current_Task;
      end if;
      pragma Assert (Observed_Task = Ada.Task_Identification.Current_Task);
      Status := STM32.Workers.Pending;
      case Job.Operation is
         when Exchange =>
            if Job.Visited then
               RX := TX;
               Count := Job.Length;
               Status := STM32.Workers.Completed;
            else
               Job.Visited := True;
            end if;
         when Wait_For_Cancel =>
            Set_True (Begun);
            Count := Count + 1;
         when Raise_Error =>
            raise Constraint_Error with "Simulated device failure";
      end case;
   end Step;

   package First is new STM32.Workers.Generic_Worker (Transaction, Step);
   package Second is new STM32.Workers.Generic_Worker (Transaction, Step);

   procedure Wait_For (Signal : in out Suspension_Object) is
      Deadline : constant Ada.Real_Time.Time :=
        Ada.Real_Time.Clock + Ada.Real_Time.Seconds (2);
   begin
      while not Current_State (Signal) loop
         if Ada.Real_Time.Clock >= Deadline then
            raise Program_Error with "Worker completion timeout";
         end if;
         delay 0.001;
      end loop;
      Set_False (Signal);
   end Wait_For;

   TX : String := "SPI transaction";
   RX : String (TX'Range);
   Job : Transaction := (TX'Address, RX'Address, TX'Length, Wait_For_Cancel, False);
   Rejected : Boolean := False;
begin
   begin
      First.Start (Job, First_Callback);
   exception
      when Program_Error => Rejected := True;
   end;
   pragma Assert (Rejected);
   First.Enable;
   Second.Enable;
   First.Start (Job, First_Callback);
   Wait_For (Begun);
   pragma Assert (First.Is_Busy);
   Rejected := False;
   begin
      First.Start (Job, First_Callback);
   exception
      when Program_Error => Rejected := True;
   end;
   pragma Assert (Rejected);
   Rejected := False;
   begin
      First.Enable;
   exception
      when Program_Error => Rejected := True;
   end;
   pragma Assert (Rejected);

   --  Second instance completes while the first remains blocked.
   Job.Operation := Exchange;
   Second.Start (Job, Second_Callback);
   Wait_For (Second_Done);
   pragma Assert
     (RX = TX and Second.Count = TX'Length and not Second.Has_Error);
   pragma Assert (First.Is_Busy);

   First.Disable;
   First.Wait_Until_Idle;
   Wait_For (First_Done);
   pragma Assert (First.Has_Error and First.Count > 0);
   pragma Assert (not Second.Has_Error);
   pragma Assert (Observed_Task /= Ada.Task_Identification.Current_Task);

   First.Enable;
   Job.Operation := Raise_Error;
   First.Start (Job, First_Callback);
   Wait_For (First_Done);
   pragma Assert (First.Has_Error and First.Count = 0);

   --  Leaving a local instance must drain its node before its state vanishes.
   Set_False (Begun);
   declare
      package Scoped is new STM32.Workers.Generic_Worker (Transaction, Step);
   begin
      Job.Operation := Wait_For_Cancel;
      Scoped.Enable;
      Scoped.Start (Job, Scope_Callback);
      Wait_For (Begun);
   end;
   Wait_For (Scope_Done);

   --  A failed Step must not kill the worker or poison later requests.
   Job.Operation := Exchange;
   First.Start (Job, First_Callback);
   Wait_For (First_Done);
   pragma Assert
     (RX = TX and First.Count = TX'Length and not First.Has_Error);
   First.Disable;
   Second.Disable;
   First.Wait_Until_Idle;
   Second.Wait_Until_Idle;
   Ada.Text_IO.Put_Line ("PASS workers: single dispatcher, isolation, cancellation, recovery");
exception
   when others =>
      First.Disable;
      Second.Disable;
      First.Wait_Until_Idle;
      Second.Wait_Until_Idle;
      raise;
end Workers_Tests;
