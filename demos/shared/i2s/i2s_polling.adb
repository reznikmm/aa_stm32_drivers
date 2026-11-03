--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with I2S_Board;
with STM32.I2S;
with STM32.Polling.I2S_2;

procedure I2S_POLLING is
   package Audio renames STM32.Polling.I2S_2;

   Buffer : STM32.I2S.Sample_Buffer renames I2S_Board.Buffer;
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
      Audio.Receive (Buffer'Address, Buffer'Length);

      if Audio.Has_Error then
         raise Program_Error;
      end if;

      --  Process Buffer here. Each stereo frame occupies four half-words.
      --  These finite captures have gaps between buffers.
      delay 0.1;
   end loop;
end I2S_POLLING;
