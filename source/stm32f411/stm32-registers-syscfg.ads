
--  This spec has been automatically generated from STM32F411.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.SYSCFG is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   type MEMRM_Register is record
      MEM_MODE      : Interfaces.Unsigned_32 range 0 .. 3;
      --   MEM_MODE
      Reserved_2_31 : Interfaces.Unsigned_32 range 0 .. 1073741823 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   memory remap register
   --  Access: read-write
   --  Reset value: 0x00000000

   for MEMRM_Register use record
      MEM_MODE      at 0 range 0 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   type PMC_Register is record
      Reserved_0_15  : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
      ADC1DC2        : Boolean;
      --   ADC1DC2
      Reserved_17_31 : Interfaces.Unsigned_32 range 0 .. 32767 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   peripheral mode configuration register
   --  Access: read-write
   --  Reset value: 0x00000000

   for PMC_Register use record
      Reserved_0_15  at 0 range 0 .. 15;
      ADC1DC2        at 0 range 16 .. 16;
      Reserved_17_31 at 0 range 17 .. 31;
   end record;

   --  EXTICRx_EXTI array
   type EXTICRx_EXTI_Field_Array is array (STM32.Pin_Index range 0 .. 3)
     of Interfaces.Unsigned_32 range 0 .. 15
       with Component_Size => 4, Size => 16;

   type EXTICRx_Register is record
      EXTI           : EXTICRx_EXTI_Field_Array;
      --   EXTI x configuration (x = 0 to 3)
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with
       Object_Size => 32,
       Bit_Order => System.Low_Order_First,
       Volatile_Full_Access;
   --   external interrupt configuration register 1
   --  Access: read-write
   --  Reset value: 0x0000

   for EXTICRx_Register use record
      EXTI           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   type EXTICRx_Register_Array is
     array (STM32.Pin_Index range 0 .. 3) of EXTICRx_Register
       with Component_Size => 32, Size => 128;

   type CMPCR_Register is record
      CMP_PD        : Boolean;
      --   Compensation cell power-down
      Reserved_1_7  : Interfaces.Unsigned_32 range 0 .. 127 := 0;
      READY         : Boolean;
      --   READY
      Reserved_9_31 : Interfaces.Unsigned_32 range 0 .. 8388607 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Compensation cell control register
   --  Access: read-only
   --  Reset value: 0x00000000

   for CMPCR_Register use record
      CMP_PD        at 0 range 0 .. 0;
      Reserved_1_7  at 0 range 1 .. 7;
      READY         at 0 range 8 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   type SYSCFG_Peripheral is record
      MEMRM   : aliased MEMRM_Register;
      pragma Volatile_Full_Access (MEMRM);
      --   memory remap register
      PMC     : aliased PMC_Register;
      pragma Volatile_Full_Access (PMC);
      --   peripheral mode configuration register
      EXTICR  : aliased EXTICRx_Register_Array;
      --   external interrupt configuration registers
      CMPCR   : aliased CMPCR_Register;
      pragma Volatile_Full_Access (CMPCR);
      --   Compensation cell control register
   end record
     with Volatile;

   --   System configuration controller
   for SYSCFG_Peripheral use record
      MEMRM   at 16#0#  range 0 .. 31;
      PMC     at 16#4#  range 0 .. 31;
      EXTICR  at 16#8#  range 0 .. 127;
      CMPCR   at 16#20# range 0 .. 31;
   end record;

   SYSCFG_Periph : aliased SYSCFG_Peripheral
     with Import, Address => SYSCFG_Base;

end STM32.Registers.SYSCFG;
