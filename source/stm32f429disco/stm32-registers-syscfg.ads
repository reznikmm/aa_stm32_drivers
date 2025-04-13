--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F429x.svd
--  then edited to be more handy.

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.SYSCFG is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  memory remap register
   type MEMRM_Register is record
      --  Memory mapping selection
      MEM_MODE       : Interfaces.Unsigned_32 range 0 .. 7;
      --  unspecified
      Reserved_3_7   : Interfaces.Unsigned_32 range 0 .. 31;
      --  Flash bank mode selection
      FB_MODE        : Boolean;
      --  unspecified
      Reserved_9_9   : Interfaces.Unsigned_32 range 0 .. 1;
      --  FMC memory mapping swap
      SWP_FMC        : Interfaces.Unsigned_32 range 0 .. 3;
      --  unspecified
      Reserved_12_31 : Interfaces.Unsigned_32 range 0 .. 1048575;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for MEMRM_Register use record
      MEM_MODE       at 0 range 0 .. 2;
      Reserved_3_7   at 0 range 3 .. 7;
      FB_MODE        at 0 range 8 .. 8;
      Reserved_9_9   at 0 range 9 .. 9;
      SWP_FMC        at 0 range 10 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   --  peripheral mode configuration register
   type PMC_Register is record
      --  unspecified
      Reserved_0_15  : Interfaces.Unsigned_32 range 0 .. 65535;
      --  ADC1DC2
      ADC1DC2        : Boolean;
      --  ADC2DC2
      ADC2DC2        : Boolean;
      --  ADC3DC2
      ADC3DC2        : Boolean;
      --  unspecified
      Reserved_19_22 : Interfaces.Unsigned_32 range 0 .. 15;
      --  Ethernet PHY interface selection
      MII_RMII_SEL   : Boolean;
      --  unspecified
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for PMC_Register use record
      Reserved_0_15  at 0 range 0 .. 15;
      ADC1DC2        at 0 range 16 .. 16;
      ADC2DC2        at 0 range 17 .. 17;
      ADC3DC2        at 0 range 18 .. 18;
      Reserved_19_22 at 0 range 19 .. 22;
      MII_RMII_SEL   at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  EXTICRx_EXTI array
   type EXTICRx_EXTI_Field_Array is array (STM32.Pin_Index range 0 .. 3)
     of Interfaces.Unsigned_32 range 0 .. 15
       with Component_Size => 4, Size => 16;

   --  external interrupt configuration register 1
   type EXTICRx_Register is record
      --  EXTI x configuration (x = 0 to 3)
      EXTI     : EXTICRx_EXTI_Field_Array;
      --  unspecified
      Reserved : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with
       Object_Size => 32,
       Bit_Order => System.Low_Order_First,
       Volatile_Full_Access;

   for EXTICRx_Register use record
      EXTI     at 0 range 0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   type EXTICRx_Register_Array is
     array (STM32.Pin_Index range 0 .. 3) of EXTICRx_Register
       with Component_Size => 32, Size => 128;

   --  Compensation cell control register
   type CMPCR_Register is record
      --  Read-only. Compensation cell power-down
      CMP_PD        : Boolean;
      --  unspecified
      Reserved_1_7  : Interfaces.Unsigned_32 range 0 .. 127;
      --  Read-only. READY
      READY         : Boolean;
      --  unspecified
      Reserved_9_31 : Interfaces.Unsigned_32 range 0 .. 8388607;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CMPCR_Register use record
      CMP_PD        at 0 range 0 .. 0;
      Reserved_1_7  at 0 range 1 .. 7;
      READY         at 0 range 8 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  System configuration controller
   type SYSCFG_Peripheral is record
      --  memory remap register
      MEMRM   : aliased MEMRM_Register;
      pragma Volatile_Full_Access (MEMRM);
      --  peripheral mode configuration register
      PMC     : aliased PMC_Register;
      pragma Volatile_Full_Access (PMC);
      --  external interrupt configuration register 1 .. 4
      EXTICR : aliased EXTICRx_Register_Array;
      --  Compensation cell control register
      CMPCR   : aliased CMPCR_Register;
      pragma Volatile_Full_Access (CMPCR);
   end record
     with Volatile;

   for SYSCFG_Peripheral use record
      MEMRM   at 16#0# range 0 .. 31;
      PMC     at 16#4# range 0 .. 31;
      EXTICR  at 16#8# range 0 .. 127;
      CMPCR   at 16#20# range 0 .. 31;
   end record;

   --  System configuration controller
   SYSCFG_Periph : aliased SYSCFG_Peripheral
     with Import, Address => SYSCFG_Base;

end STM32.Registers.SYSCFG;
