--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F40x.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.PWR is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  power control register
   type CR_Register is record
      --  Low-power deep sleep
      LPDS           : Boolean;
      --  Power down deepsleep
      PDDS           : Boolean;
      --  Clear wakeup flag
      CWUF           : Boolean;
      --  Clear standby flag
      CSBF           : Boolean;
      --  Power voltage detector enable
      PVDE           : Boolean;
      --  PVD level selection
      PLS            : Interfaces.Unsigned_32 range 0 .. 7;
      --  Disable backup domain write protection
      DBP            : Boolean;
      --  Flash power down in Stop mode
      FPDS           : Boolean;
      --  unspecified
      Reserved_10_13 : Interfaces.Unsigned_32 range 0 .. 15;
      --  Regulator voltage scaling mode
      VOS            : Boolean;
      --  unspecified
      Reserved_15_31 : Interfaces.Unsigned_32 range 0 .. 131071;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR_Register use record
      LPDS           at 0 range 0 .. 0;
      PDDS           at 0 range 1 .. 1;
      CWUF           at 0 range 2 .. 2;
      CSBF           at 0 range 3 .. 3;
      PVDE           at 0 range 4 .. 4;
      PLS            at 0 range 5 .. 7;
      DBP            at 0 range 8 .. 8;
      FPDS           at 0 range 9 .. 9;
      Reserved_10_13 at 0 range 10 .. 13;
      VOS            at 0 range 14 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   --  power control/status register
   type CSR_Register is record
      --  Read-only. Wakeup flag
      WUF            : Boolean;
      --  Read-only. Standby flag
      SBF            : Boolean;
      --  Read-only. PVD output
      PVDO           : Boolean;
      --  Read-only. Backup regulator ready
      BRR            : Boolean;
      --  unspecified
      Reserved_4_7   : Interfaces.Unsigned_32 range 0 .. 15;
      --  Enable WKUP pin
      EWUP           : Boolean;
      --  Backup regulator enable
      BRE            : Boolean;
      --  unspecified
      Reserved_10_13 : Interfaces.Unsigned_32 range 0 .. 15;
      --  Regulator voltage scaling output selection ready bit
      VOSRDY         : Boolean;
      --  unspecified
      Reserved_15_31 : Interfaces.Unsigned_32 range 0 .. 131071;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CSR_Register use record
      WUF            at 0 range 0 .. 0;
      SBF            at 0 range 1 .. 1;
      PVDO           at 0 range 2 .. 2;
      BRR            at 0 range 3 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      EWUP           at 0 range 8 .. 8;
      BRE            at 0 range 9 .. 9;
      Reserved_10_13 at 0 range 10 .. 13;
      VOSRDY         at 0 range 14 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Power control
   type PWR_Peripheral is record
      --  power control register
      CR  : aliased CR_Register;
      pragma Volatile_Full_Access (CR);
      --  power control/status register
      CSR : aliased CSR_Register;
      pragma Volatile_Full_Access (CSR);
   end record
     with Volatile;

   for PWR_Peripheral use record
      CR  at 16#0# range 0 .. 31;
      CSR at 16#4# range 0 .. 31;
   end record;

   --  Power control
   PWR_Periph : aliased PWR_Peripheral
     with Import, Address => PWR_Base;

end STM32.Registers.PWR;
