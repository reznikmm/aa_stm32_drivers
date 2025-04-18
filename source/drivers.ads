--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Root package for low level drivers (UART, etc).

package Drivers is
   pragma Pure;

   type Port is new Character range 'A' .. 'E';

   subtype Pin_Index is Natural range 0 .. 15;

   type Pin is record
      Port : Drivers.Port;
      Pin  : Drivers.Pin_Index;
   end record;

end Drivers;
