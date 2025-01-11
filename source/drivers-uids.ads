--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This package provides unique chip id.

with Interfaces;

package Drivers.UIDs is

   function UID return Interfaces.Unsigned_64;
   --  Device ID

   subtype Device_UID_Image is String (1 .. 8);

   function UID_Image return Device_UID_Image;
   --  ASCII representation of Device ID

end Drivers.UIDs;
