
--  This spec has been automatically generated from STM32F411.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.PWR is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   type CR_Register is record
      LPDS           : Boolean;
      --   Low-power deep sleep
      PDDS           : Boolean;
      --   Power down deepsleep
      CWUF           : Boolean;
      --   Clear wakeup flag
      CSBF           : Boolean;
      --   Clear standby flag
      PVDE           : Boolean;
      --   Power voltage detector enable
      PLS            : Interfaces.Unsigned_32 range 0 .. 7;
      --   PVD level selection
      DBP            : Boolean;
      --   Disable backup domain write protection
      FPDS           : Boolean;
      --   Flash power down in Stop mode
      Reserved_10_12 : Interfaces.Unsigned_32 range 0 .. 7 := 0;
      ADCDC1         : Boolean;
      --   ADCDC1
      VOS            : Interfaces.Unsigned_32 range 0 .. 3;
      --   Regulator voltage scaling output selection
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   power control register
   --  Access: read-write
   --  Reset value: 0x00000000

   for CR_Register use record
      LPDS           at 0 range 0 .. 0;
      PDDS           at 0 range 1 .. 1;
      CWUF           at 0 range 2 .. 2;
      CSBF           at 0 range 3 .. 3;
      PVDE           at 0 range 4 .. 4;
      PLS            at 0 range 5 .. 7;
      DBP            at 0 range 8 .. 8;
      FPDS           at 0 range 9 .. 9;
      Reserved_10_12 at 0 range 10 .. 12;
      ADCDC1         at 0 range 13 .. 13;
      VOS            at 0 range 14 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   type CSR_Register is record
      WUF            : Boolean;
      --   Wakeup flag
      SBF            : Boolean;
      --   Standby flag
      PVDO           : Boolean;
      --   PVD output
      BRR            : Boolean;
      --   Backup regulator ready
      Reserved_4_7   : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      EWUP           : Boolean;
      --   Enable WKUP pin
      BRE            : Boolean;
      --   Backup regulator enable
      Reserved_10_13 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      VOSRDY         : Boolean;
      --   Regulator voltage scaling output selection ready bit
      Reserved_15_31 : Interfaces.Unsigned_32 range 0 .. 131071 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   power control/status register
   --  Reset value: 0x00000000

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

   type PWR_Peripheral is record
      CR  : aliased CR_Register;
      pragma Volatile_Full_Access (CR);
      --   power control register
      CSR : aliased CSR_Register;
      pragma Volatile_Full_Access (CSR);
      --   power control/status register
   end record
     with Volatile;

   --   Power control
   for PWR_Peripheral use record
      CR  at 16#0# range 0 .. 31;
      CSR at 16#4# range 0 .. 31;
   end record;

   PWR_Periph : aliased PWR_Peripheral
     with Import, Address => PWR_Base;

end STM32.Registers.PWR;
