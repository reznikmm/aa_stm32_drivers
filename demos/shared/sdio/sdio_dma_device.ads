--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.SDIO.DMA_SDIO;

package SDIO_DMA_Device is new STM32.SDIO.DMA_SDIO (Priority => 241);
