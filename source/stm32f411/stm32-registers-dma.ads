
--  This spec has been automatically generated from STM32F411.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.DMA is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   type ISR is record
      FEIF     : Boolean := False;
      --   Stream x FIFO error interrupt flag (x=3..0)
      Reserved : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      DMEIF    : Boolean := False;
      --   Stream x direct mode error interrupt flag (x=3..0)
      TEIF     : Boolean := False;
      --   Stream x transfer error interrupt flag (x=3..0)
      HTIF     : Boolean := False;
      --   Stream x half transfer interrupt flag (x=3..0)
      TCIF     : Boolean := False;
      --   Stream x transfer complete interrupt flag (x = 3..0)
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
      Reserved : Interfaces.Unsigned_32 range 0 .. 15 := 0;
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
   
   type SxCR_Register is record
      EN             : Boolean;
      --   Stream enable / flag stream ready when read low
      DMEIE          : Boolean;
      --   Direct mode error interrupt enable
      TEIE           : Boolean;
      --   Transfer error interrupt enable
      HTIE           : Boolean;
      --   Half transfer interrupt enable
      TCIE           : Boolean;
      --   Transfer complete interrupt enable
      PFCTRL         : Boolean;
      --   Peripheral flow controller
      DIR            : Interfaces.Unsigned_32 range 0 .. 3;
      --   Data transfer direction
      CIRC           : Boolean;
      --   Circular mode
      PINC           : Boolean;
      --   Peripheral increment mode
      MINC           : Boolean;
      --   Memory increment mode
      PSIZE          : Interfaces.Unsigned_32 range 0 .. 3;
      --   Peripheral data size
      MSIZE          : Interfaces.Unsigned_32 range 0 .. 3;
      --   Memory data size
      PINCOS         : Boolean;
      --   Peripheral increment offset size
      PL             : Interfaces.Unsigned_32 range 0 .. 3;
      --   Priority level
      DBM            : Boolean;
      --   Double buffer mode
      CT             : Bit;
      --   Current target (only in double buffer mode)
      Reserved_20_20 : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      PBURST         : Interfaces.Unsigned_32 range 0 .. 3;
      --   Peripheral burst transfer configuration
      MBURST         : Interfaces.Unsigned_32 range 0 .. 3;
      --   Memory burst transfer configuration
      CHSEL          : Interfaces.Unsigned_32 range 0 .. 7;
      --   Channel selection
      Reserved_28_31 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   stream x configuration register
   --  Access: read-write
   --  Reset value: 0x00000000
   
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
   
   type SxNDTR_Register is record
      NDT      : Interfaces.Unsigned_32 range 0 .. 65535;
      --   Number of data items to transfer
      Reserved : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   stream x number of data register
   --  Access: read-write
   --  Reset value: 0x00000000
   
   for SxNDTR_Register use record
      NDT      at 0 range 0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;
   
   type SxFCR_Register is record
      FTH           : Interfaces.Unsigned_32 range 0 .. 3;
      --   FIFO threshold selection
      DMDIS         : Boolean;
      --   Direct mode disable
      FS            : Interfaces.Unsigned_32 range 0 .. 7;
      --   FIFO status
      Reserved_6_6  : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      FEIE          : Boolean;
      --   FIFO error interrupt enable
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   stream x FIFO control register
   --  Reset value: 0x00000021
   
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

   type Stream_x7 is array (0 .. 6) of Stream
     with Component_Size => 24 * 8;
   
   -----------------
   -- Peripherals --
   -----------------

   type DMA_Peripheral is record
      ISR  : aliased ISR_x8;
      --   interrupt status register
      IFCR : aliased ISR_x8;
      --   interrupt flag clear register
      List : Stream_x7;
   end record
     with Volatile;
   
   --   DMA controller
   for DMA_Peripheral use record
      ISR  at 16#0#  range 0 .. 63;
      IFCR at 16#8#  range 0 .. 63;
      List at 16#10# range 0 .. 1343;
   end record;
   
   DMA2_Periph : aliased DMA_Peripheral
     with Import, Address => DMA2_Base;
   
   DMA1_Periph : aliased DMA_Peripheral
     with Import, Address => DMA1_Base;
   
end STM32.Registers.DMA;
