--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This package provides a simple API to modify STM32F427 flash memory.

with System.Storage_Elements;

with A0B.Callbacks;

package STM32.Flash is

   First_Bank  : constant System.Address := System'To_Address (16#0800_0000#);
   Second_Bank : constant System.Address := System'To_Address (16#0810_0000#);

   procedure Unlock;
   --  Unlock the flash for erase or programming

   procedure Lock;
   --  Lock the flash

   procedure Erase_Sector
     (Address : System.Address;
      Size    : out System.Storage_Elements.Storage_Count;
      Done    : A0B.Callbacks.Callback);
   --  Start erasing a sector enclosing the given address and return the
   --  sector size. When erase is complete a callback will be triggered.
   --  The flash should be unlocked.

   procedure Programming;
   --  Enable writing into the flash. Should be called before each write.

end STM32.Flash;
