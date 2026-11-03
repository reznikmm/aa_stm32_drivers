--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Board settings for I2S demos. Supply a 49.152 MHz external clock on
--  I2S_CKIN (PC9) and connect a slave audio source to CK/WS/SD below.
--  Alternatively, configure PLLI2S and update Clock/Configure_Clock.

with STM32.I2S;

package I2S_Board is

   CK : constant STM32.Pin := (STM32.PB, 13);
   WS : constant STM32.Pin := (STM32.PB, 12);
   SD : constant STM32.Pin := (STM32.PB, 15);

   Clock : constant Positive := 86_000_000;

   procedure Configure_Clock;

   Buffer : STM32.I2S.Sample_Buffer (1 .. 256 * 64);

end I2S_Board;
