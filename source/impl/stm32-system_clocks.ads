--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces;

package STM32.System_Clocks is
   pragma Preelaborate;

   function PCLK1 return Interfaces.Unsigned_32
     with Inline;
   --  APB1 frequency

   function PCLK2 return Interfaces.Unsigned_32
     with Inline;
   --  APB2 frequency

   function TIMCLK1 return Interfaces.Unsigned_32
     with Inline;
   --  Timer clock frequency

   function HSE return Interfaces.Unsigned_32
     with Inline;
   --  High speed external oscillator

end STM32.System_Clocks;
