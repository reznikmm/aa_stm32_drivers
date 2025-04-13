--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F40x.svd
--  then edited to be more handy.

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.GPIO is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   type Unsigned_2_Array is array (Pin_Index)
     of Interfaces.Unsigned_32 range 0 .. 3
       with Component_Size => 2, Size => 32;
   --  array of 2 bits unsigned integer

   type Boolean_Array_16 is array (Pin_Index) of Boolean
     with Component_Size => 1, Size => 16;

   type Unsigned_16_Or_Array
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  Register as a value
            Val : Interfaces.Unsigned_32 range 0 .. 65535;
         when True =>
            --  Register as an array
            Arr : Boolean_Array_16;
      end case;
   end record
     with Unchecked_Union, Size => 16;

   for Unsigned_16_Or_Array use record
      Val at 0 range 0 .. 15;
      Arr at 0 range 0 .. 15;
   end record;

   --  GPIO port bit set/reset register
   type BSRR_Register is record
      --  Write-only. Port x set bit y (y= 0..15)
      BS : Boolean_Array_16;
      pragma Volatile_Full_Access (BS);
      --  Write-only. Port x set bit y (y= 0..15)
      BR : Boolean_Array_16;
      pragma Volatile_Full_Access (BR);
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for BSRR_Register use record
      BS at 0 range 0 .. 15;
      BR at 0 range 16 .. 31;
   end record;

   --  GPIO port configuration lock register
   type LCKR_Register is record
      --  Port x lock bit y (y= 0..15)
      LCK            : Boolean_Array_16;
      --  Port x lock bit y (y= 0..15)
      LCKK           : Boolean;
      --  unspecified
      Reserved_17_31 : Interfaces.Unsigned_32 range 0 .. 32767;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for LCKR_Register use record
      LCK            at 0 range 0 .. 15;
      LCKK           at 0 range 16 .. 16;
      Reserved_17_31 at 0 range 17 .. 31;
   end record;

   type Unsigned_4_Array is array (Pin_Index)
     of Interfaces.Unsigned_32 range 0 .. 15
       with Component_Size => 4, Size => 64;

   type Reserved_Array is array (1 .. 246) of Interfaces.Unsigned_32;

   -----------------
   -- Peripherals --
   -----------------

   --  General-purpose I/Os
   type GPIO_Peripheral is record
      --  GPIO port mode register
      MODER   : aliased Unsigned_2_Array;
      pragma Volatile (MODER);
      --  GPIO port output type register
      OTYPER  : aliased Boolean_Array_16;
      pragma Volatile (OTYPER);
      --  GPIO port output speed register
      OSPEEDR : aliased Unsigned_2_Array;
      pragma Volatile (OSPEEDR);
      --  GPIO port pull-up/pull-down register
      PUPDR   : aliased Unsigned_2_Array;
      pragma Volatile (PUPDR);
      --  GPIO port input data register
      IDR     : aliased Unsigned_16_Or_Array;
      --  GPIO port output data register
      ODR     : aliased Unsigned_16_Or_Array;
      --  GPIO port bit set/reset register
      BSRR    : aliased BSRR_Register;
      --  No pragma Volatile_Full_Access (BSRR) required as we can r/w 16 bits
      --  GPIO port configuration lock register
      LCKR    : aliased LCKR_Register;
      pragma Volatile_Full_Access (LCKR);
      --  GPIO alternate function low register
      AFR     : aliased Unsigned_4_Array;
      pragma Volatile (AFR);
      Reserved : aliased Reserved_Array;
   end record
     with Size => 16#400# * 8;

   for GPIO_Peripheral use record
      MODER    at 16#0# range 0 .. 31;
      OTYPER   at 16#4# range 0 .. 15;
      OSPEEDR  at 16#8# range 0 .. 31;
      PUPDR    at 16#C# range 0 .. 31;
      IDR      at 16#10# range 0 .. 15;
      ODR      at 16#14# range 0 .. 15;
      BSRR     at 16#18# range 0 .. 31;
      LCKR     at 16#1C# range 0 .. 31;
      AFR      at 16#20# range 0 .. 63;
      Reserved at 16#28# range 0 .. 7871;
   end record;

   type GPIO_Peripheral_Array is array (Port) of aliased GPIO_Peripheral
     with Component_Size => 16#400# * 8;

   GPIO_Periph : GPIO_Peripheral_Array
     with
       Import, Address => STM32.Registers.GPIOA_Base;

   Mode_IN  : constant := 0;
   Mode_OUT : constant := 1;
   Mode_AF  : constant := 2;
   Mode_AN  : constant := 3;

   --  OTYPER constants
   Push_Pull  : constant Boolean := False;
   Open_Drain : constant Boolean := True;

   --  OSPEEDR constants
   Speed_2MHz   : constant := 0; -- Low speed
   Speed_25MHz  : constant := 1; -- Medium speed
   Speed_50MHz  : constant := 2; -- Fast speed
   Speed_100MHz : constant := 3; -- High speed

   --  PUPDR constants
   No_Pull   : constant := 0;
   Pull_Up   : constant := 1;
   Pull_Down : constant := 2;

end STM32.Registers.GPIO;
