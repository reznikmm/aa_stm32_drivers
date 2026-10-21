--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.Finalization;

package body STM32.Workers is

   type Work_Item;
   type Work_Access is access all Work_Item;
   type Step_Access is access function return Boolean;

   type Work_Item is record
      Process   : Step_Access;
      Next      : Work_Access := null;
      Queued    : Boolean := False;
      Executing : Boolean := False;
      Again     : Boolean := False;
   end record;

   protected Queue is
      procedure Schedule (Item : Work_Access; Wake : out Boolean);
      procedure Take (Item : out Work_Access);
      procedure Finish (Item : Work_Access; More : Boolean);
      function Active (Item : Work_Access) return Boolean;
   private
      procedure Append (Item : Work_Access);
      Head, Tail : Work_Access := null;
      Sleeping : Boolean := False;
   end Queue;

   protected body Queue is
      procedure Append (Item : Work_Access) is
      begin
         Item.Next := null;
         Item.Queued := True;
         if Tail = null then
            Head := Item;
         else
            Tail.Next := Item;
         end if;
         Tail := Item;
      end Append;

      procedure Schedule (Item : Work_Access; Wake : out Boolean) is
      begin
         if Item.Executing then
            --  A completion callback can submit the next request on its slot.
            Item.Again := True;
         elsif not Item.Queued then
            Append (Item);
         end if;
         Wake := Sleeping;
         Sleeping := False;
      end Schedule;

      procedure Take (Item : out Work_Access) is
      begin
         Item := Head;
         if Item = null then
            Sleeping := True;
         else
            Head := Item.Next;
            if Head = null then
               Tail := null;
            end if;
            Item.Next := null;
            Item.Queued := False;
            Item.Executing := True;
         end if;
      end Take;

      procedure Finish (Item : Work_Access; More : Boolean) is
      begin
         Item.Executing := False;
         if More or else Item.Again then
            Append (Item);
         end if;
         Item.Again := False;
      end Finish;

      function Active (Item : Work_Access) return Boolean is
        (Item.Queued or Item.Executing);
   end Queue;

   task Dispatcher is
      entry Wake;
   end Dispatcher;

   task body Dispatcher is
      Item : Work_Access;
      More : Boolean;
   begin
      loop
         Queue.Take (Item);
         if Item = null then
            select
               accept Wake;
            or
               terminate;
            end select;
         else
            More := Item.Process.all;
            Queue.Finish (Item, More);
            --  Round-robin scheduling with a short pause avoids spinning on
            --  devices with no IO ready. Each step must itself be nonblocking.
            delay 0.001;
         end if;
      end loop;
   end Dispatcher;

   package body Generic_Worker is

      protected State is
         procedure Enable;
         procedure Disable;
         function Is_Busy return Boolean;
         function Has_Error return Boolean;
         function Count return Natural;
         procedure Submit
           (Request : Request_Type; Done : A0B.Callbacks.Callback);
         procedure Get
           (Request : out Request_Type; Done : out A0B.Callbacks.Callback;
            Count : out Natural; Cancelled : out Boolean);
         procedure Update
           (Request : Request_Type; Count : Natural; Status : Step_Status);
      private
         Enabled  : Boolean := False;
         Running  : Boolean := False;
         Failed   : Boolean := False;
         Finished : Natural := 0;
         Progress : Natural := 0;
         Job      : Request_Type;
         Callback : A0B.Callbacks.Callback;
      end State;

      protected body State is
         procedure Enable is
         begin
            if Running then
               raise Program_Error with "Worker is busy";
            end if;
            Enabled := True;
         end Enable;

         procedure Disable is
         begin
            Enabled := False;
         end Disable;

         function Is_Busy return Boolean is (Running);
         function Has_Error return Boolean is (Failed);
         function Count return Natural is (Finished);

         procedure Submit
           (Request : Request_Type; Done : A0B.Callbacks.Callback) is
         begin
            if not Enabled or else Running then
               raise Program_Error with "Worker disabled or already busy";
            end if;
            Job := Request;
            Callback := Done;
            Running := True;
            Failed := False;
            Progress := 0;
         end Submit;

         procedure Get
           (Request : out Request_Type; Done : out A0B.Callbacks.Callback;
            Count : out Natural; Cancelled : out Boolean) is
         begin
            Request := Job;
            Done := Callback;
            Count := Progress;
            Cancelled := not Enabled;
         end Get;

         procedure Update
           (Request : Request_Type; Count : Natural; Status : Step_Status) is
         begin
            Job := Request;
            Progress := Count;
            if Status /= Pending then
               Finished := Count;
               Failed := Status = STM32.Workers.Failed;
               Running := False;
            end if;
         end Update;
      end State;

      function Process return Boolean;

      function Process return Boolean is
         Job       : Request_Type;
         Done      : A0B.Callbacks.Callback;
         Count     : Natural;
         Cancelled : Boolean;
         Status    : Step_Status := Failed;
      begin
         State.Get (Job, Done, Count, Cancelled);
         if not Cancelled then
            begin
               Step (Job, Count, Status);
            exception
               when others =>
                  Count := 0;
                  Status := Failed;
            end;
         end if;
         State.Update (Job, Count, Status);
         if Status /= Pending then
            begin
               A0B.Callbacks.Emit (Done);
            exception
               when others => null;
            end;
         end if;
         return Status = Pending;
      end Process;

      --  The guard drains the queue before the instance leaves scope, keeping
      --  this nested callback and the intrusive queue node alive during use.
      Item : aliased Work_Item :=
        (Process => Process'Unrestricted_Access, others => <>);

      type Lifetime_Guard is new Ada.Finalization.Limited_Controlled
        with null record;
      overriding procedure Finalize (Self : in out Lifetime_Guard);

      overriding procedure Finalize (Self : in out Lifetime_Guard) is
         pragma Unreferenced (Self);
      begin
         Disable;
         Wait_Until_Idle;
      end Finalize;

      Guard : Lifetime_Guard;
      pragma Unreferenced (Guard);

      procedure Enable is
      begin
         State.Enable;
      end Enable;

      procedure Disable is
      begin
         State.Disable;
      end Disable;

      procedure Start
        (Request : Request_Type;
         Done    : A0B.Callbacks.Callback)
      is
         Wake : Boolean;
      begin
         State.Submit (Request, Done);
         Queue.Schedule (Item'Unchecked_Access, Wake);
         if Wake then
            Dispatcher.Wake;
         end if;
      end Start;

      function Is_Busy return Boolean is (State.Is_Busy);
      function Has_Error return Boolean is (State.Has_Error);
      function Count return Natural is (State.Count);

      procedure Wait_Until_Idle is
      begin
         while State.Is_Busy or else Queue.Active (Item'Unchecked_Access) loop
            delay 0.001;
         end loop;
      end Wait_Until_Idle;

   end Generic_Worker;

end STM32.Workers;
