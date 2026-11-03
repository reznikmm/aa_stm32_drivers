--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.I2S.I2S_2;
with STM32.I2S.I2S_3;

package I2S_IRQ_Devices is

   package I2S_2 is new STM32.I2S.I2S_2 (Priority => 241);
   package I2S_3 is new STM32.I2S.I2S_3 (Priority => 241);

end I2S_IRQ_Devices;
