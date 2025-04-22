--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Warnings (Off, "is an internal GNAT unit");
with System.STM32;
pragma Warnings (On, "is an internal GNAT unit");

package body STM32.System_Clocks is

   function PCLK1 return Interfaces.Unsigned_32 is
     (Interfaces.Unsigned_32 (System.STM32.System_Clocks.PCLK1));

   function PCLK2 return Interfaces.Unsigned_32 is
     (Interfaces.Unsigned_32 (System.STM32.System_Clocks.PCLK2));

   function TIMCLK1 return Interfaces.Unsigned_32 is
     (Interfaces.Unsigned_32 (System.STM32.System_Clocks.TIMCLK1));

end STM32.System_Clocks;
