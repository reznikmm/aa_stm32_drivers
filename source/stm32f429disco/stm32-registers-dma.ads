--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F40x.svd
--  then edited to be more handy.

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.DMA is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   type ISR is record
      --  Read-only. Stream x FIFO error interrupt flag (x=7..0)
      FEIF     : Boolean := False;
      --  unspecified
      Reserved : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      --  Read-only. Stream x direct mode error interrupt flag (x=3..0)
      DMEIF    : Boolean := False;
      --  Read-only. Stream x transfer error interrupt flag (x=3..0)
      TEIF     : Boolean := False;
      --  Read-only. Stream x half transfer interrupt flag (x=3..0)
      HTIF     : Boolean := False;
      --  Read-only. Stream x transfer complete interrupt flag (x = 3..0)
      TCIF     : Boolean := False;
      --  Read-only. Stream x FIFO error interrupt flag (x=3..0)
   end record
     with Bit_Order => System.Low_Order_First;

   for ISR use record
      FEIF     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 1;
      DMEIF    at 0 range 2 .. 2;
      TEIF     at 0 range 3 .. 3;
      HTIF     at 0 range 4 .. 4;
      TCIF     at 0 range 5 .. 5;
   end record;

   type ISR_Array is array (0 .. 1) of ISR
   with Component_Size => 6;

   type ISR_x2 is record
      Item     : ISR_Array;
      Reserved : Interfaces.Unsigned_32 range 0 .. 1 := 0;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for ISR_x2 use record
      Item     at 0 range 0 .. 11;
      Reserved at 0 range 12 .. 15;
   end record;

   type ISR_x4 is array (0 .. 1) of ISR_x2
     with Component_Size => 16, Object_Size => 32;

   type ISR_x4_VFA is record
      List : ISR_x4;
      pragma Volatile_Full_Access (List);
   end record
     with Object_Size => 32;
   --  Can't set Volatile_Full_Access on ISR_x4 type. Let's wrap it in a record

   type ISR_x8 is array (0 .. 1) of ISR_x4_VFA
     with Component_Size => 32, Object_Size => 64;

   --  stream x configuration register
   type SxCR_Register is record
      --  Stream enable / flag stream ready when read low
      EN             : Boolean;
      --  Direct mode error interrupt enable
      DMEIE          : Boolean;
      --  Transfer error interrupt enable
      TEIE           : Boolean;
      --  Half transfer interrupt enable
      HTIE           : Boolean;
      --  Transfer complete interrupt enable
      TCIE           : Boolean;
      --  Peripheral flow controller
      PFCTRL         : Boolean;
      --  Data transfer direction
      DIR            : Interfaces.Unsigned_32 range 0 .. 3;
      --  Circular mode
      CIRC           : Boolean;
      --  Peripheral increment mode
      PINC           : Boolean;
      --  Memory increment mode
      MINC           : Boolean;
      --  Peripheral data size
      PSIZE          : Interfaces.Unsigned_32 range 0 .. 3;
      --  Memory data size
      MSIZE          : Interfaces.Unsigned_32 range 0 .. 3;
      --  Peripheral increment offset size
      PINCOS         : Boolean;
      --  Priority level
      PL             : Interfaces.Unsigned_32 range 0 .. 3;
      --  Double buffer mode
      DBM            : Boolean;
      --  Current target (only in double buffer mode)
      CT             : Bit;
      --  unspecified
      Reserved_20_20 : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      --  Peripheral burst transfer configuration
      PBURST         : Interfaces.Unsigned_32 range 0 .. 3;
      --  Memory burst transfer configuration
      MBURST         : Interfaces.Unsigned_32 range 0 .. 3;
      --  Channel selection
      CHSEL          : Interfaces.Unsigned_32 range 0 .. 7;
      --  unspecified
      Reserved_28_31 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SxCR_Register use record
      EN             at 0 range 0 .. 0;
      DMEIE          at 0 range 1 .. 1;
      TEIE           at 0 range 2 .. 2;
      HTIE           at 0 range 3 .. 3;
      TCIE           at 0 range 4 .. 4;
      PFCTRL         at 0 range 5 .. 5;
      DIR            at 0 range 6 .. 7;
      CIRC           at 0 range 8 .. 8;
      PINC           at 0 range 9 .. 9;
      MINC           at 0 range 10 .. 10;
      PSIZE          at 0 range 11 .. 12;
      MSIZE          at 0 range 13 .. 14;
      PINCOS         at 0 range 15 .. 15;
      PL             at 0 range 16 .. 17;
      DBM            at 0 range 18 .. 18;
      CT             at 0 range 19 .. 19;
      Reserved_20_20 at 0 range 20 .. 20;
      PBURST         at 0 range 21 .. 22;
      MBURST         at 0 range 23 .. 24;
      CHSEL          at 0 range 25 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  stream x number of data register
   type SxNDTR_Register is record
      --  Number of data items to transfer
      NDT      : Interfaces.Unsigned_32 range 0 .. 65535;
      --  unspecified
      Reserved : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SxNDTR_Register use record
      NDT      at 0 range 0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   --  stream x FIFO control register
   type SxFCR_Register is record
      --  FIFO threshold selection
      FTH           : Interfaces.Unsigned_32 range 0 .. 3;
      --  Direct mode disable
      DMDIS         : Boolean;
      --  Read-only. FIFO status
      FS            : Interfaces.Unsigned_32 range 0 .. 7;
      --  unspecified
      Reserved_6_6  : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      --  FIFO error interrupt enable
      FEIE          : Boolean;
      --  unspecified
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SxFCR_Register use record
      FTH           at 0 range 0 .. 1;
      DMDIS         at 0 range 2 .. 2;
      FS            at 0 range 3 .. 5;
      Reserved_6_6  at 0 range 6 .. 6;
      FEIE          at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   type Stream is record
      SxCR   : aliased SxCR_Register;
      pragma Volatile_Full_Access (SxCR);
      --  stream x number of data register
      SxNDTR : aliased SxNDTR_Register;
      pragma Volatile_Full_Access (SxNDTR);
      --  stream x peripheral address register
      SxPAR  : aliased System.Address;
      --  stream x memory 0 address register
      SxM0AR : aliased System.Address;
      --  stream x memory 1 address register
      SxM1AR : aliased System.Address;
      --  stream x FIFO control register
      SxFCR  : aliased SxFCR_Register;
      pragma Volatile_Full_Access (SxFCR);
   end record
     with Object_Size => 24 * 8, Bit_Order => System.Low_Order_First;

   for Stream use record
      SxCR   at 16#00# range 0 .. 31;
      SxNDTR at 16#04# range 0 .. 31;
      SxPAR  at 16#08# range 0 .. 31;
      SxM0AR at 16#0C# range 0 .. 31;
      SxM1AR at 16#10# range 0 .. 31;
      SxFCR  at 16#14# range 0 .. 31;
   end record;

   type Stream_x8 is array (0 .. 7) of Stream
     with Component_Size => 24 * 8;

   -----------------
   -- Peripherals --
   -----------------

   --  DMA controller
   type DMA_Peripheral is record
      --  interrupt status registers
      ISR  : aliased ISR_x8;
      --  interrupt flag clear registers
      IFCR : aliased ISR_x8;
      --  stream x configuration registers
      List : Stream_x8;
   end record
     with Volatile;

   for DMA_Peripheral use record
      ISR  at 16#0#  range 0 .. 63;
      IFCR at 16#8#  range 0 .. 63;
      List at 16#10# range 0 .. 1535;
   end record;

   --  DMA controller
   DMA1_Periph : aliased DMA_Peripheral
     with Import, Address => DMA1_Base;

   --  DMA controller
   DMA2_Periph : aliased DMA_Peripheral
     with Import, Address => DMA2_Base;

end STM32.Registers.DMA;
