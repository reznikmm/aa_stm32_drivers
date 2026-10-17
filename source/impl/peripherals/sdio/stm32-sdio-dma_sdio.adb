--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with System.Storage_Elements;

with A0B.Callbacks.Generic_Parameterless;

package body STM32.SDIO.DMA_SDIO is

   Periph : Registers.SDIO_Peripheral renames Registers.SDIO_Periph;

   SDIO_DMA_Channel : constant STM32.DMA.Channel_Id := 4;

   procedure On_DMA_Complete;

   package DMA_Callback is new A0B.Callbacks.Generic_Parameterless
     (On_DMA_Complete);

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Clock_Pin   : Pin;
      Command_Pin : Pin;
      Data_Pins   : Pin_Array;
      Speed       : Positive := 400_000;
      Width       : Bus_Width := 1) is
   begin
      Initialize (Clock_Pin, Command_Pin, Data_Pins, Speed, Width);
   end Configure;

   ------------
   -- Device --
   ------------

   protected body Device is

      ----------------------------
      -- Disable_Card_Interrupt --
      ----------------------------

      procedure Disable_Card_Interrupt is
      begin
         Card_Enabled := False;
         Periph.MASK := Interrupt_Mask (State, Card_Enabled);
      end Disable_Card_Interrupt;

      ------------------
      -- DMA_Complete --
      ------------------

      procedure DMA_Complete is
      begin
         if Wait_DMA then
            Wait_DMA := False;
            DMA_Failed := Stream_2_3.Has_Error;
            Try_To_Finish;
         end if;
      end DMA_Complete;

      ---------------------------
      -- Enable_Card_Interrupt --
      ---------------------------

      procedure Enable_Card_Interrupt (Done : A0B.Callbacks.Callback) is
      begin
         Card_Interrupt := Done;
         Card_Enabled := True;
         Periph.MASK := Interrupt_Mask (State, Card_Enabled);
      end Enable_Card_Interrupt;

      -----------------------
      -- Interrupt_Handler --
      -----------------------

      procedure Interrupt_Handler is
         Status : constant Registers.STA_Register := Periph.STA;
      begin
         if Card_Enabled and Status.SDIOIT then
            Clear_Card_Interrupt_Flag;
            Card_Enabled := False;
            A0B.Callbacks.Emit (Card_Interrupt);
         end if;

         if Busy then
            Step (State, Status);
            Try_To_Finish;
         else
            Periph.MASK := Interrupt_Mask (State, Card_Enabled);
         end if;
      end Interrupt_Handler;

      ----------------
      -- Last_Error --
      ----------------

      function Last_Error return Error_Kind is (Error);

      -------------------
      -- Start_Command --
      -------------------

      procedure Start_Command
        (Item     : Command;
         Has_Data : Boolean;
         Data     : Data_Transfer;
         Buffer   : System.Address;
         Done     : A0B.Callbacks.Callback)
      is
         Memory_Burst : constant STM32.DMA.Burst_Length :=
           (if System.Storage_Elements.To_Integer (Buffer) mod 16 = 0
            then 4 else 1);
         --  A burst must not cross 1KB boundary, so use 4-word bursts
         --  for 16-byte aligned buffers only.

         FIFO   : constant STM32.DMA.Location :=
           (Address     => Periph.FIFO'Address,
            Item_Length => 4,
            Increment   => 0,
            Burst       => 4);

         Memory : constant STM32.DMA.Location :=
           (Address     => Buffer,
            Item_Length => 4,
            Increment   => 4,
            Burst       => Memory_Burst);
      begin
         Device.Done := Done;
         Busy := True;
         Wait_DMA := Has_Data;
         DMA_Failed := False;
         Error := No_Error;

         if Has_Data then
            --  DMA request comes only when the data path is enabled, so
            --  the stream could be started before the command.
            Stream_2_3.Start_Transfer
              (Channel => SDIO_DMA_Channel,
               Source  =>
                 (if Data.Direction = Card_To_Host then FIFO else Memory),
               Target  =>
                 (if Data.Direction = Card_To_Host then Memory else FIFO),
               Count   => 0,  --  Peripheral flow control
               FIFO    => 16,
               Prio    => STM32.DMA.Very_High,
               Done    => DMA_Callback.Create_Callback);
         end if;

         Start_Transfer
           (State,
            Item,
            Has_Data => Has_Data,
            Data     => Data,
            Buffer   => Buffer,
            Use_DMA  => True);

         Periph.MASK := Interrupt_Mask (State, Card_Enabled);
      end Start_Command;

      -------------------
      -- Try_To_Finish --
      -------------------

      procedure Try_To_Finish is
         Ignore : Interfaces.Unsigned_16;
      begin
         if Is_Finished (State) and Wait_DMA
           and (Result (State) /= No_Error or not State.Data_Started)
         then
            --  SDIO has failed or the data path wasn't started, so DMA
            --  will never finish. Stop it.
            Wait_DMA := False;
            Stream_2_3.Stop_Transfer (Ignore);
         end if;

         if Busy and Is_Finished (State) and not Wait_DMA then
            Busy := False;
            Error :=
              (if Result (State) /= No_Error then Result (State)
               elsif DMA_Failed then DMA_Error
               else No_Error);

            Periph.DCTRL.DMAEN := False;
            Periph.MASK := Interrupt_Mask (State, Card_Enabled);
            A0B.Callbacks.Emit (Done);
         else
            Periph.MASK := Interrupt_Mask (State, Card_Enabled);
         end if;
      end Try_To_Finish;

   end Device;

   ----------------------------
   -- Disable_Card_Interrupt --
   ----------------------------

   procedure Disable_Card_Interrupt is
   begin
      Device.Disable_Card_Interrupt;
   end Disable_Card_Interrupt;

   ---------------------------
   -- Enable_Card_Interrupt --
   ---------------------------

   procedure Enable_Card_Interrupt (Done : A0B.Callbacks.Callback) is
   begin
      Device.Enable_Card_Interrupt (Done);
   end Enable_Card_Interrupt;

   ---------------------
   -- On_DMA_Complete --
   ---------------------

   procedure On_DMA_Complete is
   begin
      Device.DMA_Complete;
   end On_DMA_Complete;

   -------------
   -- Set_Bus --
   -------------

   procedure Set_Bus
     (Speed : Positive;
      Width : Bus_Width) is
   begin
      STM32.SDIO.Set_Bus (Speed, Width);
   end Set_Bus;

   -------------------
   -- Start_Command --
   -------------------

   procedure Start_Command
     (Item : Command;
      Done : A0B.Callbacks.Callback) is
   begin
      Device.Start_Command
        (Item, False, No_Data, System.Null_Address, Done);
   end Start_Command;

   -------------------
   -- Start_Command --
   -------------------

   procedure Start_Command
     (Item   : Command;
      Data   : Data_Transfer;
      Buffer : System.Address;
      Done   : A0B.Callbacks.Callback) is
   begin
      Device.Start_Command (Item, True, Data, Buffer, Done);
   end Start_Command;

end STM32.SDIO.DMA_SDIO;
