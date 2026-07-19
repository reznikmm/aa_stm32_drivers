--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

package body STM32.Timer.Basic_Implementation is

   procedure Configure (Setting : Basic_Settings) is
   begin
      Polling.Configure (Setting, (Is_Set => False));
   end Configure;

   procedure Update_Generation is
   begin
      Polling.Generate_Event (Update => True);
   end Update_Generation;

   ----------------------------
   -- Set_Callback --
   ----------------------------

   procedure Set_Callback (On_Update : A0B.Callbacks.Callback) is
   begin
      Device.Set_Callback (On_Update);
   end Set_Callback;

   ------------
   -- Device --
   ------------

   protected body Device is

      ----------------------------
      -- Set_Callback --
      ----------------------------

      procedure Set_Callback (On_Update : A0B.Callbacks.Callback)
      is
      begin
         Callback := On_Update;
         Periph.SR.UIF := False;
         Periph.DIER.UIE := A0B.Callbacks.Is_Set (Callback);
      end Set_Callback;

      -----------------------
      -- Interrupt_Handler --
      -----------------------

      procedure Interrupt_Handler is
      begin
         if Periph.SR.UIF then
            Periph.SR.UIF := False;

            if A0B.Callbacks.Is_Set (Callback) then
               A0B.Callbacks.Emit (Callback);
            end if;
         end if;
      end Interrupt_Handler;

   end Device;

end STM32.Timer.Basic_Implementation;
