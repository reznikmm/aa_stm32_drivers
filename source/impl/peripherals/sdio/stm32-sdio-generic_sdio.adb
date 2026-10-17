--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

package body STM32.SDIO.Generic_SDIO is

   Periph : Registers.SDIO_Peripheral renames Registers.SDIO_Periph;

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

            if Is_Finished (State) then
               Busy := False;
               Error := Result (State);
               Periph.MASK := Interrupt_Mask (State, Card_Enabled);
               A0B.Callbacks.Emit (Done);
               return;
            end if;
         end if;

         Periph.MASK := Interrupt_Mask (State, Card_Enabled);
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
         Done     : A0B.Callbacks.Callback) is
      begin
         Device.Done := Done;
         Busy := True;
         Error := No_Error;

         Start_Transfer
           (State,
            Item,
            Has_Data => Has_Data,
            Data     => Data,
            Buffer   => Buffer,
            Use_DMA  => False);

         Periph.MASK := Interrupt_Mask (State, Card_Enabled);
      end Start_Command;

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

   -------------
   -- Set_Bus --
   -------------

   procedure Set_Bus
     (Speed : Positive;
      Width : Bus_Width) renames STM32.SDIO.Set_Bus;

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

end STM32.SDIO.Generic_SDIO;
