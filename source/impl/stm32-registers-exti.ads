--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F40x.svd
--  then edited to be more handy.

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.EXTI is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   type Boolean_Array_23 is array (0 .. 31) of Boolean
     with Component_Size => 1, Size => 32;

   -----------------
   -- Peripherals --
   -----------------

   --  External interrupt/event controller
   type EXTI_Peripheral is record
      --  Interrupt mask register (EXTI_IMR)
      IMR   : aliased Boolean_Array_23;
      pragma Volatile_Full_Access (IMR);
      --  Event mask register (EXTI_EMR)
      EMR   : aliased Boolean_Array_23;
      pragma Volatile_Full_Access (EMR);
      --  Rising Trigger selection register (EXTI_RTSR)
      RTSR  : aliased Boolean_Array_23;
      pragma Volatile_Full_Access (RTSR);
      --  Falling Trigger selection register (EXTI_FTSR)
      FTSR  : aliased Boolean_Array_23;
      pragma Volatile_Full_Access (FTSR);
      --  Software interrupt event register (EXTI_SWIER)
      SWIER : aliased Boolean_Array_23;
      pragma Volatile_Full_Access (SWIER);
      --  Pending register (EXTI_PR)
      PR    : aliased Boolean_Array_23;
      pragma Volatile_Full_Access (PR);
   end record
     with Volatile;

   for EXTI_Peripheral use record
      IMR   at 16#0# range 0 .. 31;
      EMR   at 16#4# range 0 .. 31;
      RTSR  at 16#8# range 0 .. 31;
      FTSR  at 16#C# range 0 .. 31;
      SWIER at 16#10# range 0 .. 31;
      PR    at 16#14# range 0 .. 31;
   end record;

   --  External interrupt/event controller
   EXTI_Periph : aliased EXTI_Peripheral
     with Import, Address => EXTI_Base;

end STM32.Registers.EXTI;
