--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F429x.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.RNG is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  control register
   type CR_Register is record
      --  unspecified
      Reserved_0_1  : Interfaces.Unsigned_32 range 0 .. 3;
      --  Random number generator enable
      RNGEN         : Boolean;
      --  Interrupt enable
      IE            : Boolean;
      --  unspecified
      Reserved_4_31 : Interfaces.Unsigned_32 range 0 .. 268435455;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR_Register use record
      Reserved_0_1  at 0 range 0 .. 1;
      RNGEN         at 0 range 2 .. 2;
      IE            at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   --  status register
   type SR_Register is record
      --  Read-only. Data ready
      DRDY          : Boolean;
      --  Read-only. Clock error current status
      CECS          : Boolean;
      --  Read-only. Seed error current status
      SECS          : Boolean;
      --  unspecified
      Reserved_3_4  : Interfaces.Unsigned_32 range 0 .. 3;
      --  Clock error interrupt status
      CEIS          : Boolean;
      --  Seed error interrupt status
      SEIS          : Boolean;
      --  unspecified
      Reserved_7_31 : Interfaces.Unsigned_32 range 0 .. 33554431;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SR_Register use record
      DRDY          at 0 range 0 .. 0;
      CECS          at 0 range 1 .. 1;
      SECS          at 0 range 2 .. 2;
      Reserved_3_4  at 0 range 3 .. 4;
      CEIS          at 0 range 5 .. 5;
      SEIS          at 0 range 6 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Random number generator
   type RNG_Peripheral is record
      --  control register
      CR : aliased CR_Register;
      pragma Volatile_Full_Access (CR);
      --  status register
      SR : aliased SR_Register;
      pragma Volatile_Full_Access (SR);
      --  data register
      DR : aliased Interfaces.Unsigned_32;
   end record
     with Volatile;

   for RNG_Peripheral use record
      CR at 16#0# range 0 .. 31;
      SR at 16#4# range 0 .. 31;
      DR at 16#8# range 0 .. 31;
   end record;

   --  Random number generator
   RNG_Periph : aliased RNG_Peripheral
     with Import, Address => RNG_Base;

end STM32.Registers.RNG;
