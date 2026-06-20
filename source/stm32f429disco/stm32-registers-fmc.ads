--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F429x.svd
--  then edited to be more handy.

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.FMC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  SDRAM Control Register 1
   type SDCR_Register is record
      --  Number of column address bits
      NC             : Interfaces.Unsigned_32 range 0 .. 3;
      --  Number of row address bits
      NR             : Interfaces.Unsigned_32 range 0 .. 3;
      --  Memory data bus width
      MWID           : Interfaces.Unsigned_32 range 0 .. 3;
      --  Number of internal banks
      NB             : Boolean;
      --  CAS latency
      CAS            : Interfaces.Unsigned_32 range 0 .. 3;
      --  Write protection
      WP             : Boolean;
      --  SDRAM clock configuration
      SDCLK          : Interfaces.Unsigned_32 range 0 .. 3;
      --  Burst read
      RBURST         : Boolean;
      --  Read pipe
      RPIPE          : Interfaces.Unsigned_32 range 0 .. 3;
      --  unspecified
      Reserved_15_31 : Interfaces.Unsigned_32 range 0 .. 131071;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SDCR_Register use record
      NC             at 0 range 0 .. 1;
      NR             at 0 range 2 .. 3;
      MWID           at 0 range 4 .. 5;
      NB             at 0 range 6 .. 6;
      CAS            at 0 range 7 .. 8;
      WP             at 0 range 9 .. 9;
      SDCLK          at 0 range 10 .. 11;
      RBURST         at 0 range 12 .. 12;
      RPIPE          at 0 range 13 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   --  SDRAM Timing register 1
   type SDTR_Register is record
      --  Load Mode Register to Active
      TMRD           : Interfaces.Unsigned_32 range 0 .. 15;
      --  Exit self-refresh delay
      TXSR           : Interfaces.Unsigned_32 range 0 .. 15;
      --  Self refresh time
      TRAS           : Interfaces.Unsigned_32 range 0 .. 15;
      --  Row cycle delay
      TRC            : Interfaces.Unsigned_32 range 0 .. 15;
      --  Recovery delay
      TWR            : Interfaces.Unsigned_32 range 0 .. 15;
      --  Row precharge delay
      TRP            : Interfaces.Unsigned_32 range 0 .. 15;
      --  Row to column delay
      TRCD           : Interfaces.Unsigned_32 range 0 .. 15;
      --  unspecified
      Reserved_28_31 : Interfaces.Unsigned_32 range 0 .. 15;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SDTR_Register use record
      TMRD           at 0 range 0 .. 3;
      TXSR           at 0 range 4 .. 7;
      TRAS           at 0 range 8 .. 11;
      TRC            at 0 range 12 .. 15;
      TWR            at 0 range 16 .. 19;
      TRP            at 0 range 20 .. 23;
      TRCD           at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  SDRAM Command Mode register
   type SDCMR_Register is record
      --  Write-only. Command mode
      MODE           : Interfaces.Unsigned_32 range 0 .. 7;
      --  Write-only. Command target bank 2
      CTB2           : Boolean;
      --  Write-only. Command target bank 1
      CTB1           : Boolean;
      --  Number of Auto-refresh
      NRFS           : Interfaces.Unsigned_32 range 0 .. 15;
      --  Mode Register definition
      MRD            : Interfaces.Unsigned_32 range 0 .. 8191;
      --  unspecified
      Reserved_22_31 : Interfaces.Unsigned_32 range 0 .. 1023;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SDCMR_Register use record
      MODE           at 0 range 0 .. 2;
      CTB2           at 0 range 3 .. 3;
      CTB1           at 0 range 4 .. 4;
      NRFS           at 0 range 5 .. 8;
      MRD            at 0 range 9 .. 21;
      Reserved_22_31 at 0 range 22 .. 31;
   end record;

   --  SDRAM Refresh Timer register
   type SDRTR_Register is record
      --  Write-only. Clear Refresh error flag
      CRE            : Boolean;
      --  Refresh Timer Count
      COUNT          : Interfaces.Unsigned_32 range 0 .. 8191;
      --  RES Interrupt Enable
      REIE           : Boolean;
      --  unspecified
      Reserved_15_31 : Interfaces.Unsigned_32 range 0 .. 131071;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SDRTR_Register use record
      CRE            at 0 range 0 .. 0;
      COUNT          at 0 range 1 .. 13;
      REIE           at 0 range 14 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   --  SDSR_MODES array
   type SDSR_MODES_Field_Array is array (1 .. 2)
     of Interfaces.Unsigned_32 range 0 .. 3
     with Component_Size => 2, Size => 4;

   --  SDRAM Status register
   type SDSR_Register is record
      --  Read-only. Refresh error flag
      RE            : Boolean;
      --  Read-only. Status Mode for Bank 1
      MODES         : SDSR_MODES_Field_Array;
      --  Read-only. Busy status
      BUSY          : Boolean;
      --  unspecified
      Reserved_6_31 : Interfaces.Unsigned_32 range 0 .. 67108863;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SDSR_Register use record
      RE            at 0 range 0 .. 0;
      MODES         at 0 range 1 .. 4;
      BUSY          at 0 range 5 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Flexible memory controller
   type FMC_Peripheral is record
      Reserved  : aliased Interfaces.Unsigned_32;
      --  SDRAM Control Register 1
      SDCR1 : aliased SDCR_Register;
      pragma Volatile_Full_Access (SDCR1);
      --  SDRAM Control Register 2
      SDCR2 : aliased SDCR_Register;
      pragma Volatile_Full_Access (SDCR2);
      --  SDRAM Timing register 1
      SDTR1 : aliased SDTR_Register;
      pragma Volatile_Full_Access (SDTR1);
      --  SDRAM Timing register 2
      SDTR2 : aliased SDTR_Register;
      pragma Volatile_Full_Access (SDTR2);
      --  SDRAM Command Mode register
      SDCMR : aliased SDCMR_Register;
      pragma Volatile_Full_Access (SDCMR);
      --  SDRAM Refresh Timer register
      SDRTR : aliased SDRTR_Register;
      pragma Volatile_Full_Access (SDRTR);
      --  SDRAM Status register
      SDSR  : aliased SDSR_Register;
      pragma Volatile_Full_Access (SDSR);
   end record
     with Volatile;

   for FMC_Peripheral use record
      Reserved at 16#0# range 0 .. 31;
      SDCR1 at 16#140# range 0 .. 31;
      SDCR2 at 16#144# range 0 .. 31;
      SDTR1 at 16#148# range 0 .. 31;
      SDTR2 at 16#14C# range 0 .. 31;
      SDCMR at 16#150# range 0 .. 31;
      SDRTR at 16#154# range 0 .. 31;
      SDSR  at 16#158# range 0 .. 31;
   end record;

   --  Flexible memory controller
   FMC_Periph : aliased FMC_Peripheral
     with Import, Address => FMC_Base;

end STM32.Registers.FMC;
