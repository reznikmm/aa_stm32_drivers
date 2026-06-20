--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Timer.DMA_TIM_5;

package Tim_Devices is

   package TIM_5 is new STM32.Timer.DMA_TIM_5 (Priority => 241);

end Tim_Devices;
