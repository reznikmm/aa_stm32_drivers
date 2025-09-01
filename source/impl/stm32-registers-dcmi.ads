pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F40x.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.DCMI is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  control register 1
   type CR_Register is record
      --  Capture enable
      CAPTURE        : Boolean;
      --  Capture mode
      CM             : Boolean;
      --  Crop feature
      CROP           : Boolean;
      --  JPEG format
      JPEG           : Boolean;
      --  Embedded synchronization select
      ESS            : Boolean;
      --  Pixel clock polarity
      PCKPOL         : Boolean;
      --  Horizontal synchronization polarity
      HSPOL          : Boolean;
      --  Vertical synchronization polarity
      VSPOL          : Boolean;
      --  Frame capture rate control
      FCRC           : Interfaces.Unsigned_32 range 0 .. 3;
      --  Extended data mode
      EDM            : Interfaces.Unsigned_32 range 0 .. 3;
      --  unspecified
      Reserved_12_13 : Interfaces.Unsigned_32 range 0 .. 3;
      --  DCMI enable
      ENABLE         : Boolean;
      --  unspecified
      Reserved_15_31 : Interfaces.Unsigned_32 range 0 .. 131071;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR_Register use record
      CAPTURE        at 0 range 0 .. 0;
      CM             at 0 range 1 .. 1;
      CROP           at 0 range 2 .. 2;
      JPEG           at 0 range 3 .. 3;
      ESS            at 0 range 4 .. 4;
      PCKPOL         at 0 range 5 .. 5;
      HSPOL          at 0 range 6 .. 6;
      VSPOL          at 0 range 7 .. 7;
      FCRC           at 0 range 8 .. 9;
      EDM            at 0 range 10 .. 11;
      Reserved_12_13 at 0 range 12 .. 13;
      ENABLE         at 0 range 14 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   --  status register
   type SR_Register is record
      --  Read-only. HSYNC
      HSYNC         : Boolean;
      --  Read-only. VSYNC
      VSYNC         : Boolean;
      --  Read-only. FIFO not empty
      FNE           : Boolean;
      --  unspecified
      Reserved      : Interfaces.Unsigned_32 range 0 .. 536870911;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SR_Register use record
      HSYNC         at 0 range 0 .. 0;
      VSYNC         at 0 range 1 .. 1;
      FNE           at 0 range 2 .. 2;
      Reserved      at 0 range 3 .. 31;
   end record;

   --  raw interrupt status register
   type RIS_Register is record
      --  Read-only. Capture complete raw interrupt status
      FRAME_RIS     : Boolean;
      --  Read-only. Overrun raw interrupt status
      OVR_RIS       : Boolean;
      --  Read-only. Synchronization error raw interrupt status
      ERR_RIS       : Boolean;
      --  Read-only. VSYNC raw interrupt status
      VSYNC_RIS     : Boolean;
      --  Read-only. Line raw interrupt status
      LINE_RIS      : Boolean;
      --  unspecified
      Reserved      : Interfaces.Unsigned_32 range 0 .. 134217727;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for RIS_Register use record
      FRAME_RIS     at 0 range 0 .. 0;
      OVR_RIS       at 0 range 1 .. 1;
      ERR_RIS       at 0 range 2 .. 2;
      VSYNC_RIS     at 0 range 3 .. 3;
      LINE_RIS      at 0 range 4 .. 4;
      Reserved      at 0 range 5 .. 31;
   end record;

   --  interrupt enable register
   type IER_Register is record
      --  Capture complete interrupt enable
      FRAME_IE      : Boolean;
      --  Overrun interrupt enable
      OVR_IE        : Boolean;
      --  Synchronization error interrupt enable
      ERR_IE        : Boolean;
      --  VSYNC interrupt enable
      VSYNC_IE      : Boolean;
      --  Line interrupt enable
      LINE_IE       : Boolean;
      --  unspecified
      Reserved      : Interfaces.Unsigned_32 range 0 .. 134217727;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for IER_Register use record
      FRAME_IE      at 0 range 0 .. 0;
      OVR_IE        at 0 range 1 .. 1;
      ERR_IE        at 0 range 2 .. 2;
      VSYNC_IE      at 0 range 3 .. 3;
      LINE_IE       at 0 range 4 .. 4;
      Reserved      at 0 range 5 .. 31;
   end record;

   --  masked interrupt status register
   type MIS_Register is record
      --  Read-only. Capture complete masked interrupt status
      FRAME_MIS     : Boolean;
      --  Read-only. Overrun masked interrupt status
      OVR_MIS       : Boolean;
      --  Read-only. Synchronization error masked interrupt status
      ERR_MIS       : Boolean;
      --  Read-only. VSYNC masked interrupt status
      VSYNC_MIS     : Boolean;
      --  Read-only. Line masked interrupt status
      LINE_MIS      : Boolean;
      --  unspecified
      Reserved      : Interfaces.Unsigned_32 range 0 .. 134217727;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for MIS_Register use record
      FRAME_MIS     at 0 range 0 .. 0;
      OVR_MIS       at 0 range 1 .. 1;
      ERR_MIS       at 0 range 2 .. 2;
      VSYNC_MIS     at 0 range 3 .. 3;
      LINE_MIS      at 0 range 4 .. 4;
      Reserved      at 0 range 5 .. 31;
   end record;

   --  interrupt clear register
   type ICR_Register is record
      --  Write-only. Capture complete interrupt status clear
      FRAME_ISC     : Boolean;
      --  Write-only. Overrun interrupt status clear
      OVR_ISC       : Boolean;
      --  Write-only. Synchronization error interrupt status clear
      ERR_ISC       : Boolean;
      --  Write-only. Vertical synch interrupt status clear
      VSYNC_ISC     : Boolean;
      --  Write-only. line interrupt status clear
      LINE_ISC      : Boolean;
      --  unspecified
      Reserved      : Interfaces.Unsigned_32 range 0 .. 134217727;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for ICR_Register use record
      FRAME_ISC     at 0 range 0 .. 0;
      OVR_ISC       at 0 range 1 .. 1;
      ERR_ISC       at 0 range 2 .. 2;
      VSYNC_ISC     at 0 range 3 .. 3;
      LINE_ISC      at 0 range 4 .. 4;
      Reserved      at 0 range 5 .. 31;
   end record;

   --  embedded synchronization code register
   type ESCR_Register is record
      --  Frame start delimiter code
      FSC : Interfaces.Unsigned_32 range 0 .. 255;
      --  Line start delimiter code
      LSC : Interfaces.Unsigned_32 range 0 .. 255;
      --  Line end delimiter code
      LEC : Interfaces.Unsigned_32 range 0 .. 255;
      --  Frame end delimiter code
      FEC : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for ESCR_Register use record
      FSC at 0 range 0 .. 7;
      LSC at 0 range 8 .. 15;
      LEC at 0 range 16 .. 23;
      FEC at 0 range 24 .. 31;
   end record;

   --  embedded synchronization unmask register
   type ESUR_Register is record
      --  Frame start delimiter unmask
      FSU : Interfaces.Unsigned_32 range 0 .. 255;
      --  Line start delimiter unmask
      LSU : Interfaces.Unsigned_32 range 0 .. 255;
      --  Line end delimiter unmask
      LEU : Interfaces.Unsigned_32 range 0 .. 255;
      --  Frame end delimiter unmask
      FEU : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for ESUR_Register use record
      FSU at 0 range 0 .. 7;
      LSU at 0 range 8 .. 15;
      LEU at 0 range 16 .. 23;
      FEU at 0 range 24 .. 31;
   end record;

   --  crop window start
   type CWSTRT_Register is record
      --  Horizontal offset count
      HOFFCNT        : Interfaces.Unsigned_32 range 0 .. 16383;
      --  unspecified
      Reserved_14_15 : Interfaces.Unsigned_32 range 0 .. 3;
      --  Vertical start line count
      VST            : Interfaces.Unsigned_32 range 0 .. 8191;
      --  unspecified
      Reserved_29_31 : Interfaces.Unsigned_32 range 0 .. 7;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CWSTRT_Register use record
      HOFFCNT        at 0 range 0 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      VST            at 0 range 16 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   --  crop window size
   type CWSIZE_Register is record
      --  Capture count
      CAPCNT         : Interfaces.Unsigned_32 range 0 .. 16383;
      --  unspecified
      Reserved_14_15 : Interfaces.Unsigned_32 range 0 .. 3;
      --  Vertical line count
      VLINE          : Interfaces.Unsigned_32 range 0 .. 16383;
      --  unspecified
      Reserved_30_31 : Interfaces.Unsigned_32 range 0 .. 3;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CWSIZE_Register use record
      CAPCNT         at 0 range 0 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      VLINE          at 0 range 16 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Digital camera interface
   type DCMI_Peripheral is record
      --  control register 1
      CR     : aliased CR_Register;
      pragma Volatile_Full_Access (CR);
      --  status register
      SR     : aliased SR_Register;
      pragma Volatile_Full_Access (SR);
      --  raw interrupt status register
      RIS    : aliased RIS_Register;
      pragma Volatile_Full_Access (RIS);
      --  interrupt enable register
      IER    : aliased IER_Register;
      pragma Volatile_Full_Access (IER);
      --  masked interrupt status register
      MIS    : aliased MIS_Register;
      pragma Volatile_Full_Access (MIS);
      --  interrupt clear register
      ICR    : aliased ICR_Register;
      pragma Volatile_Full_Access (ICR);
      --  embedded synchronization code register
      ESCR   : aliased ESCR_Register;
      pragma Volatile_Full_Access (ESCR);
      --  embedded synchronization unmask register
      ESUR   : aliased ESUR_Register;
      pragma Volatile_Full_Access (ESUR);
      --  crop window start
      CWSTRT : aliased CWSTRT_Register;
      pragma Volatile_Full_Access (CWSTRT);
      --  crop window size
      CWSIZE : aliased CWSIZE_Register;
      pragma Volatile_Full_Access (CWSIZE);
      --  data register
      DR     : aliased Interfaces.Unsigned_32;
      pragma Volatile (DR);
   end record
     with Volatile;

   for DCMI_Peripheral use record
      CR     at 16#0# range 0 .. 31;
      SR     at 16#4# range 0 .. 31;
      RIS    at 16#8# range 0 .. 31;
      IER    at 16#C# range 0 .. 31;
      MIS    at 16#10# range 0 .. 31;
      ICR    at 16#14# range 0 .. 31;
      ESCR   at 16#18# range 0 .. 31;
      ESUR   at 16#1C# range 0 .. 31;
      CWSTRT at 16#20# range 0 .. 31;
      CWSIZE at 16#24# range 0 .. 31;
      DR     at 16#28# range 0 .. 31;
   end record;

   --  Digital camera interface
   DCMI_Periph : aliased DCMI_Peripheral
     with Import, Address => DCMI_Base;

end STM32.Registers.DCMI;
