--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with System;

package body Drivers.UIDs is

   ---------
   -- UID --
   ---------

   function UID return Interfaces.Unsigned_64 is
      use type Interfaces.Unsigned_32;
      use type Interfaces.Unsigned_64;

      Device : constant array (1 .. 3) of Interfaces.Unsigned_32
        with Import, Address => System'To_Address (16#1FFF_7A10#);

      Low : constant Interfaces.Unsigned_32 :=
        (Device (1) and 16#FF#) +
        (Device (1) and 16#FF_00_00#) / 256 +
        (Device (2) and 16#FF_FF_00_00#);

      High : Interfaces.Unsigned_32 renames Device (3);
   begin
      return Interfaces.Unsigned_64 (Low) +
        Interfaces.Shift_Left (Interfaces.Unsigned_64 (High), 32);
   end UID;

   ---------------
   -- UID_Image --
   ---------------

   function UID_Image return Device_UID_Image is
      Raw       : constant Interfaces.Unsigned_64 := UID;
      Raw_Image : Device_UID_Image
        with Import, Address => Raw'Address;
      Result    : Device_UID_Image := Raw_Image;
   begin
      for Item of Result loop
         if Item not in '!' .. '~' then
            Item := '?';
         end if;
      end loop;

      return Result;
   end UID_Image;

end Drivers.UIDs;
