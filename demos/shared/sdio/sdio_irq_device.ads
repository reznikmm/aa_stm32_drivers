--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.SDIO.Generic_SDIO;

package SDIO_IRQ_Device is new STM32.SDIO.Generic_SDIO (Priority => 255);
--  Use a high priority: the interrupt handler serves the FIFO
