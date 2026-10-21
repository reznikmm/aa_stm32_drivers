--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  File-backed device ID for the Linux drivers.

with Interfaces;

package STM32.UIDs is

   function UID return Interfaces.Unsigned_64;
   --  Read exactly 8 little-endian bytes from ./stm32-uid.bin on each call.
   --  The path is relative to the process working directory. A missing file
   --  raises Ada.IO_Exceptions.Name_Error; an invalid size raises Data_Error.

   subtype Device_UID_Image is String (1 .. 8);

   function UID_Image return Device_UID_Image;
   --  File bytes in their original order; bytes outside ASCII ! .. ~
   --  (including spaces) are replaced with a question mark.

end STM32.UIDs;
