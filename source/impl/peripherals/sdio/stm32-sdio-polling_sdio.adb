--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

package body STM32.SDIO.Polling_SDIO is

   Periph : Registers.SDIO_Peripheral renames Registers.SDIO_Periph;

   procedure Wait (State : in out Transfer_State);

   --------------------------
   -- Clear_Card_Interrupt --
   --------------------------

   procedure Clear_Card_Interrupt is
   begin
      Clear_Card_Interrupt_Flag;
   end Clear_Card_Interrupt;

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

   ------------------------
   -- Has_Card_Interrupt --
   ------------------------

   function Has_Card_Interrupt return Boolean is (Periph.STA.SDIOIT);

   ------------------
   -- Send_Command --
   ------------------

   procedure Send_Command
     (Item  : Command;
      Error : out Error_Kind)
   is
      State : Transfer_State;
   begin
      Start_Transfer
        (State,
         Item,
         Has_Data => False,
         Data     => No_Data,
         Buffer   => System.Null_Address,
         Use_DMA  => False);

      Wait (State);
      Error := Result (State);
   end Send_Command;

   ------------------
   -- Send_Command --
   ------------------

   procedure Send_Command
     (Item   : Command;
      Data   : Data_Transfer;
      Buffer : System.Address;
      Error  : out Error_Kind)
   is
      State : Transfer_State;
   begin
      Start_Transfer
        (State,
         Item,
         Has_Data => True,
         Data     => Data,
         Buffer   => Buffer,
         Use_DMA  => False);

      Wait (State);
      Error := Result (State);
   end Send_Command;

   -------------
   -- Set_Bus --
   -------------

   procedure Set_Bus
     (Speed : Positive;
      Width : Bus_Width) renames STM32.SDIO.Set_Bus;

   ----------
   -- Wait --
   ----------

   procedure Wait (State : in out Transfer_State) is
   begin
      --  The command path has the hardware timeout (64 SDIO_CK periods),
      --  the data path has DTIMER, so the loop always terminates while
      --  SDIO_CK is running.
      while not Is_Finished (State) loop
         declare
            Status : constant Registers.STA_Register := Periph.STA;
         begin
            Step (State, Status);
         end;
      end loop;
   end Wait;

end STM32.SDIO.Polling_SDIO;
