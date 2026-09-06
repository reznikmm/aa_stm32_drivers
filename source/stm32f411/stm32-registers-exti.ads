
--  This spec has been automatically generated from STM32F411.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.EXTI is
   pragma Preelaborate;

   type Boolean_Array_23 is array (0 .. 22) of Boolean
     with Component_Size => 1, Size => 32;

   -----------------
   -- Peripherals --
   -----------------

   type EXTI_Peripheral is record
      IMR   : aliased Boolean_Array_23;
      pragma Volatile_Full_Access (IMR);
      --   Interrupt mask register (EXTI_IMR)
      EMR   : aliased Boolean_Array_23;
      pragma Volatile_Full_Access (EMR);
      --   Event mask register (EXTI_EMR)
      RTSR  : aliased Boolean_Array_23;
      pragma Volatile_Full_Access (RTSR);
      --   Rising Trigger selection register (EXTI_RTSR)
      FTSR  : aliased Boolean_Array_23;
      pragma Volatile_Full_Access (FTSR);
      --   Falling Trigger selection register (EXTI_FTSR)
      SWIER : aliased Boolean_Array_23;
      pragma Volatile_Full_Access (SWIER);
      --   Software interrupt event register (EXTI_SWIER)
      PR    : aliased Boolean_Array_23;
      pragma Volatile_Full_Access (PR);
      --   Pending register (EXTI_PR)
   end record
     with Volatile;
   
   --   External interrupt/event controller
   for EXTI_Peripheral use record
      IMR   at 16#0#  range 0 .. 31;
      EMR   at 16#4#  range 0 .. 31;
      RTSR  at 16#8#  range 0 .. 31;
      FTSR  at 16#C#  range 0 .. 31;
      SWIER at 16#10# range 0 .. 31;
      PR    at 16#14# range 0 .. 31;
   end record;
   
   EXTI_Periph : aliased EXTI_Peripheral
     with Import, Address => EXTI_Base;
   
end STM32.Registers.EXTI;
