--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F40x.svd
--  then edited to be more handy.

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.FSMC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  SRAM/NOR-Flash chip-select control register
   type BCR_Register is record
      --  MBKEN
      MBKEN          : Boolean;
      --  MUXEN
      MUXEN          : Boolean;
      --  MTYP
      MTYP           : Interfaces.Unsigned_32 range 0 .. 3;
      --  MWID
      MWID           : Interfaces.Unsigned_32 range 0 .. 3;
      --  FACCEN
      FACCEN         : Boolean;
      --  unspecified
      Reserved_7_7   : Interfaces.Unsigned_32 range 0 .. 1;
      --  BURSTEN
      BURSTEN        : Boolean;
      --  WAITPOL
      WAITPOL        : Boolean;
      --  WRAPMOD
      WRAPMOD        : Boolean;
      --  WAITCFG
      WAITCFG        : Boolean;
      --  WREN
      WREN           : Boolean;
      --  WAITEN
      WAITEN         : Boolean;
      --  EXTMOD
      EXTMOD         : Boolean;
      --  ASYNCWAIT
      ASYNCWAIT      : Boolean;
      --  unspecified
      Reserved_16_18 : Interfaces.Unsigned_32 range 0 .. 7;
      --  CBURSTRW
      CBURSTRW       : Boolean;
      --  unspecified
      Reserved_20_31 : Interfaces.Unsigned_32 range 0 .. 4095;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for BCR_Register use record
      MBKEN          at 0 range 0 .. 0;
      MUXEN          at 0 range 1 .. 1;
      MTYP           at 0 range 2 .. 3;
      MWID           at 0 range 4 .. 5;
      FACCEN         at 0 range 6 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      BURSTEN        at 0 range 8 .. 8;
      WAITPOL        at 0 range 9 .. 9;
      WRAPMOD        at 0 range 10 .. 10;
      WAITCFG        at 0 range 11 .. 11;
      WREN           at 0 range 12 .. 12;
      WAITEN         at 0 range 13 .. 13;
      EXTMOD         at 0 range 14 .. 14;
      ASYNCWAIT      at 0 range 15 .. 15;
      Reserved_16_18 at 0 range 16 .. 18;
      CBURSTRW       at 0 range 19 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   --  SRAM/NOR-Flash chip-select timing register
   type BTR_Register is record
      --  ADDSET
      ADDSET         : Interfaces.Unsigned_32 range 0 .. 15;
      --  ADDHLD
      ADDHLD         : Interfaces.Unsigned_32 range 0 .. 15;
      --  DATAST
      DATAST         : Interfaces.Unsigned_32 range 0 .. 255;
      --  BUSTURN
      BUSTURN        : Interfaces.Unsigned_32 range 0 .. 15;
      --  CLKDIV
      CLKDIV         : Interfaces.Unsigned_32 range 0 .. 15;
      --  DATLAT
      DATLAT         : Interfaces.Unsigned_32 range 0 .. 15;
      --  ACCMOD
      ACCMOD         : Interfaces.Unsigned_32 range 0 .. 3;
      --  unspecified
      Reserved_30_31 : Interfaces.Unsigned_32 range 0 .. 3;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for BTR_Register use record
      ADDSET         at 0 range 0 .. 3;
      ADDHLD         at 0 range 4 .. 7;
      DATAST         at 0 range 8 .. 15;
      BUSTURN        at 0 range 16 .. 19;
      CLKDIV         at 0 range 20 .. 23;
      DATLAT         at 0 range 24 .. 27;
      ACCMOD         at 0 range 28 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   type BCR_BTR is record
      BCR  : BCR_Register;
      pragma Volatile_Full_Access (BCR);
      --  SRAM/NOR-Flash chip-select timing register
      BTR  : BTR_Register;
      pragma Volatile_Full_Access (BTR);
      --  SRAM/NOR-Flash chip-select control register
   end record
     with Object_Size => 64, Bit_Order => System.Low_Order_First;

   for BCR_BTR use record
      BCR at 16#0# range 0 .. 31;
      BTR at 16#4# range 0 .. 31;
   end record;

   type BCR_BTR_Array is array (1 .. 4) of aliased BCR_BTR;

   --  PC Card/NAND Flash control register 2
   type PCR_Register is record
      --  unspecified
      Reserved_0_0   : Interfaces.Unsigned_32 range 0 .. 1;
      --  PWAITEN
      PWAITEN        : Boolean;
      --  PBKEN
      PBKEN          : Boolean;
      --  PTYP
      PTYP           : Boolean;
      --  PWID
      PWID           : Interfaces.Unsigned_32 range 0 .. 3;
      --  ECCEN
      ECCEN          : Boolean;
      --  unspecified
      Reserved_7_8   : Interfaces.Unsigned_32 range 0 .. 3;
      --  TCLR
      TCLR           : Interfaces.Unsigned_32 range 0 .. 15;
      --  TAR
      TAR            : Interfaces.Unsigned_32 range 0 .. 15;
      --  ECCPS
      ECCPS          : Interfaces.Unsigned_32 range 0 .. 7;
      --  unspecified
      Reserved_20_31 : Interfaces.Unsigned_32 range 0 .. 4095;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for PCR_Register use record
      Reserved_0_0   at 0 range 0 .. 0;
      PWAITEN        at 0 range 1 .. 1;
      PBKEN          at 0 range 2 .. 2;
      PTYP           at 0 range 3 .. 3;
      PWID           at 0 range 4 .. 5;
      ECCEN          at 0 range 6 .. 6;
      Reserved_7_8   at 0 range 7 .. 8;
      TCLR           at 0 range 9 .. 12;
      TAR            at 0 range 13 .. 16;
      ECCPS          at 0 range 17 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   --  FIFO status and interrupt register 2
   type SR_Register is record
      --  IRS
      IRS           : Boolean;
      --  ILS
      ILS           : Boolean;
      --  IFS
      IFS           : Boolean;
      --  IREN
      IREN          : Boolean;
      --  ILEN
      ILEN          : Boolean;
      --  IFEN
      IFEN          : Boolean;
      --  Read-only. FEMPT
      FEMPT         : Boolean;
      --  unspecified
      Reserved_7_31 : Interfaces.Unsigned_32 range 0 .. 33554431;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SR_Register use record
      IRS           at 0 range 0 .. 0;
      ILS           at 0 range 1 .. 1;
      IFS           at 0 range 2 .. 2;
      IREN          at 0 range 3 .. 3;
      ILEN          at 0 range 4 .. 4;
      IFEN          at 0 range 5 .. 5;
      FEMPT         at 0 range 6 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   --  Common memory space timing register 2
   type PMEM_Register is record
      --  MEMSETx
      MEMSETx  : Interfaces.Unsigned_32 range 0 .. 255;
      --  MEMWAITx
      MEMWAITx : Interfaces.Unsigned_32 range 0 .. 255;
      --  MEMHOLDx
      MEMHOLDx : Interfaces.Unsigned_32 range 0 .. 255;
      --  MEMHIZx
      MEMHIZx  : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for PMEM_Register use record
      MEMSETx  at 0 range 0 .. 7;
      MEMWAITx at 0 range 8 .. 15;
      MEMHOLDx at 0 range 16 .. 23;
      MEMHIZx  at 0 range 24 .. 31;
   end record;

   --  Attribute memory space timing register 2
   type PATT_Register is record
      --  ATTSETx
      ATTSETx  : Interfaces.Unsigned_32 range 0 .. 255;
      --  ATTWAITx
      ATTWAITx : Interfaces.Unsigned_32 range 0 .. 255;
      --  ATTHOLDx
      ATTHOLDx : Interfaces.Unsigned_32 range 0 .. 255;
      --  ATTHIZx
      ATTHIZx  : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for PATT_Register use record
      ATTSETx  at 0 range 0 .. 7;
      ATTWAITx at 0 range 8 .. 15;
      ATTHOLDx at 0 range 16 .. 23;
      ATTHIZx  at 0 range 24 .. 31;
   end record;

   --  I/O space timing register 4
   type PIO_Register is record
      --  IOSETx
      IOSETx  : Interfaces.Unsigned_32 range 0 .. 255;
      --  IOWAITx
      IOWAITx : Interfaces.Unsigned_32 range 0 .. 255;
      --  IOHOLDx
      IOHOLDx : Interfaces.Unsigned_32 range 0 .. 255;
      --  IOHIZx
      IOHIZx  : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for PIO_Register use record
      IOSETx  at 0 range 0 .. 7;
      IOWAITx at 0 range 8 .. 15;
      IOHOLDx at 0 range 16 .. 23;
      IOHIZx  at 0 range 24 .. 31;
   end record;

   --  PC Card/NAND Flash registers
   type PC_NAND_Registers is record
      --  PC Card/NAND Flash control register
      PCR  : aliased PCR_Register;
      pragma Volatile_Full_Access (PCR);
      --  FIFO status and interrupt register
      SR   : aliased SR_Register;
      pragma Volatile_Full_Access (SR);
      --  Common memory space timing register
      PMEM : aliased PMEM_Register;
      pragma Volatile_Full_Access (PMEM);
      --  Attribute memory space timing register
      PATT : aliased PATT_Register;
      pragma Volatile_Full_Access (PATT);
      --  I/O space timing register (only 4)
      PIO   : aliased PIO_Register;
      pragma Volatile_Full_Access (PIO);
      --  ECC result register (only 2 and 3)
      ECCR : aliased Interfaces.Unsigned_32;
      Reserved : Interfaces.Unsigned_64;
   end record
     with Object_Size => 256, Bit_Order => System.Low_Order_First;

   for PC_NAND_Registers use record
      PCR  at 16#00# range 0 .. 31;
      SR   at 16#04# range 0 .. 31;
      PMEM at 16#08# range 0 .. 31;
      PATT at 16#0C# range 0 .. 31;
      PIO  at 16#10# range 0 .. 31;
      ECCR at 16#14# range 0 .. 31;
      Reserved at 16#18# range 0 .. 63;
   end record;

   type PC_NAND_Array is array (2 .. 4) of PC_NAND_Registers;

   --  SRAM/NOR-Flash write timing registers
   type BWTR_Register is record
      --  ADDSET
      ADDSET         : Interfaces.Unsigned_32 range 0 .. 15;
      --  ADDHLD
      ADDHLD         : Interfaces.Unsigned_32 range 0 .. 15;
      --  DATAST
      DATAST         : Interfaces.Unsigned_32 range 0 .. 255;
      --  unspecified
      Reserved_16_19 : Interfaces.Unsigned_32 range 0 .. 15;
      --  CLKDIV
      CLKDIV         : Interfaces.Unsigned_32 range 0 .. 15;
      --  DATLAT
      DATLAT         : Interfaces.Unsigned_32 range 0 .. 15;
      --  ACCMOD
      ACCMOD         : Interfaces.Unsigned_32 range 0 .. 3;
      --  unspecified
      Reserved_30_31 : Interfaces.Unsigned_32 range 0 .. 3;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for BWTR_Register use record
      ADDSET         at 0 range 0 .. 3;
      ADDHLD         at 0 range 4 .. 7;
      DATAST         at 0 range 8 .. 15;
      Reserved_16_19 at 0 range 16 .. 19;
      CLKDIV         at 0 range 20 .. 23;
      DATLAT         at 0 range 24 .. 27;
      ACCMOD         at 0 range 28 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   type BWTR_Reserved is record
      BWTR     : BWTR_Register;
      pragma Volatile_Full_Access (BWTR);
      Reserved : Interfaces.Unsigned_32;
   end record
     with Object_Size => 64, Bit_Order => System.Low_Order_First;

   for BWTR_Reserved use record
      BWTR     at 0 range 0 .. 31;
      Reserved at 4 range 0 .. 31;
   end record;

   type BWTR_Array is array (1 .. 4) of BWTR_Reserved;

   -----------------
   -- Peripherals --
   -----------------

   --  Flexible static memory controller
   type FSMC_Peripheral is record
      --  SRAM/NOR-Flash chip-select control/timing registers 1..4
      BCR_BTR  : BCR_BTR_Array;
      --  PC Card/NAND Flash registers 2 .. 4
      PC_NAND  : PC_NAND_Array;
      --  SRAM/NOR-Flash write timing registers 1..4
      BWTR : BWTR_Array;
   end record
     with Volatile;

   for FSMC_Peripheral use record
      BCR_BTR at 16#0# range 0 .. 255;
      PC_NAND at 16#60# range 0 .. 767;
      BWTR    at 16#104# range 0 .. 255;
   end record;

   --  Flexible static memory controller
   FSMC_Periph : aliased FSMC_Peripheral
     with Import, Address => FSMC_Base;

end STM32.Registers.FSMC;
