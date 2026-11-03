--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with A0B.Callbacks;
with Ada.Synchronous_Task_Control;
with I2S_Board;
with STM32.I2S;
with I2S_IRQ_Devices;
with Suspension_Object_Callbacks;

procedure I2S_IRQ is
   package Audio renames I2S_IRQ_Devices.I2S_2;

   Buffer : STM32.I2S.Sample_Buffer (1 .. 256);
   Signal : aliased Ada.Synchronous_Task_Control.Suspension_Object;
   Done   : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Signal);
begin
   I2S_Board.Configure_Clock;
   Audio.Configure
     (CK        => I2S_Board.CK,
      WS        => I2S_Board.WS,
      SD        => I2S_Board.SD,
      Frequency => 48_000,
      Clock     => I2S_Board.Clock,
      Format    => STM32.I2S.Data_24);

   loop
      Audio.Start_Reading (Buffer'Address, Buffer'Length, Done);
      Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);

      if Audio.Has_Error then
         raise Program_Error;
      end if;

      --  Process Buffer here. Each stereo frame occupies four half-words.
      --  These finite captures have gaps between buffers.
      delay 0.1;
   end loop;
end I2S_IRQ;
