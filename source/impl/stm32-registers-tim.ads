--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F40x.svd
--  then edited to be more handy.

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.TIM is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  control register 1
   type CR1_Register is record
      --  Counter enable
      CEN            : Boolean;
      --  Update disable
      UDIS           : Boolean;
      --  Update request source
      URS            : Boolean;
      --  One-pulse mode
      OPM            : Boolean;
      --  Direction
      DIR            : Boolean;
      --  Center-aligned mode selection
      CMS            : Interfaces.Unsigned_32 range 0 .. 3;
      --  Auto-reload preload enable
      ARPE           : Boolean;
      --  Clock division
      CKD            : Interfaces.Unsigned_32 range 0 .. 3;
      --  unspecified
      Reserved_10_15 : Interfaces.Unsigned_32 range 0 .. 63;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for CR1_Register use record
      CEN            at 0 range 0 .. 0;
      UDIS           at 0 range 1 .. 1;
      URS            at 0 range 2 .. 2;
      OPM            at 0 range 3 .. 3;
      DIR            at 0 range 4 .. 4;
      CMS            at 0 range 5 .. 6;
      ARPE           at 0 range 7 .. 7;
      CKD            at 0 range 8 .. 9;
      Reserved_10_15 at 0 range 10 .. 15;
   end record;

   type OIS is record
      --  Output Idle state
      OIS   : Bit;
      OISxN : Bit;
   end record
     with Bit_Order => System.Low_Order_First;

   for OIS use record
      OIS   at 0 range 0 .. 0;
      OISxN at 0 range 1 .. 1;
   end record;

   type OIS_x4 is array (1 .. 4) of OIS
     with Component_Size => 2, Object_Size => 8;

   --  control register 2
   type CR2_Register is record
      --  Capture/compare preloaded control
      CCPC     : Boolean;
      --  unspecified
      Reserved : Interfaces.Unsigned_32 range 0 .. 1;
      --  Capture/compare control update selection
      CCUS     : Boolean;
      --  Capture/compare DMA selection
      CCDS     : Boolean;
      --  Master mode selection
      MMS      : Interfaces.Unsigned_32 range 0 .. 7;
      --  TI1 selection
      TI1S     : Boolean;
      --  Output Idle state 1
      OIS_x    : OIS_x4;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for CR2_Register use record
      CCPC     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 1;
      CCUS     at 0 range 2 .. 2;
      CCDS     at 0 range 3 .. 3;
      MMS      at 0 range 4 .. 6;
      TI1S     at 0 range 7 .. 7;
      OIS_x    at 0 range 8 .. 15;
   end record;

   --  slave mode control register
   type SMCR_Register is record
      --  Slave mode selection
      SMS      : Interfaces.Unsigned_32 range 0 .. 7;
      --  unspecified
      Reserved : Interfaces.Unsigned_32 range 0 .. 1;
      --  Trigger selection
      TS       : Interfaces.Unsigned_32 range 0 .. 7;
      --  Master/Slave mode
      MSM      : Boolean;
      --  External trigger filter
      ETF      : Interfaces.Unsigned_32 range 0 .. 15;
      --  External trigger prescaler
      ETPS     : Interfaces.Unsigned_32 range 0 .. 3;
      --  External clock enable
      ECE      : Boolean;
      --  External trigger polarity
      ETP      : Boolean;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for SMCR_Register use record
      SMS      at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 3;
      TS       at 0 range 4 .. 6;
      MSM      at 0 range 7 .. 7;
      ETF      at 0 range 8 .. 11;
      ETPS     at 0 range 12 .. 13;
      ECE      at 0 range 14 .. 14;
      ETP      at 0 range 15 .. 15;
   end record;

   type Boolean_x4 is array (1 .. 4) of Boolean
     with Component_Size => 1;

   --  DMA/Interrupt enable register
   type DIER_Register is record
      --  Update interrupt enable
      UIE   : Boolean;
      --  Capture/Compare x interrupt enable
      CCxIE : Boolean_x4;
      --  COM interrupt enable
      COMIE : Boolean;
      --  Trigger interrupt enable
      TIE   : Boolean;
      --  Break interrupt enable
      BIE   : Boolean;
      --  Update DMA request enable
      UDE   : Boolean;
      --  Capture/Compare x DMA request enable
      CCxDE : Boolean_x4;
      --  COM DMA request enable
      COMDE : Boolean;
      --  Trigger DMA request enable
      TDE   : Boolean;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for DIER_Register use record
      UIE   at 0 range 0 .. 0;
      CCxIE at 0 range 1 .. 4;
      COMIE at 0 range 5 .. 5;
      TIE   at 0 range 6 .. 6;
      BIE   at 0 range 7 .. 7;
      UDE   at 0 range 8 .. 8;
      CCxDE at 0 range 9 .. 12;
      COMDE at 0 range 13 .. 13;
      TDE   at 0 range 14 .. 14;
   end record;

   --  status register
   type SR_Register is record
      --  Update interrupt flag
      UIF            : Boolean;
      --  Capture/compare x interrupt flag
      CCxIF          : Boolean_x4;
      --  COM interrupt flag
      COMIF          : Boolean;
      --  Trigger interrupt flag
      TIF            : Boolean;
      --  Break interrupt flag
      BIF            : Boolean;
      --  unspecified
      Reserved_8_8   : Interfaces.Unsigned_32 range 0 .. 1;
      --  Capture/Compare x overcapture flag
      CCxOF          : Boolean_x4;
      --  unspecified
      Reserved_13_15 : Interfaces.Unsigned_32 range 0 .. 7;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for SR_Register use record
      UIF            at 0 range 0 .. 0;
      CCxIF          at 0 range 1 .. 4;
      COMIF          at 0 range 5 .. 5;
      TIF            at 0 range 6 .. 6;
      BIF            at 0 range 7 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      CCxOF          at 0 range 9 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
   end record;

   --  event generation register
   type EGR_Register is record
      --  Write-only. Update generation
      UG       : Boolean;
      --  Write-only. Capture/compare x generation
      CCxG     : Boolean_x4;
      --  Write-only. Capture/Compare control update generation
      COMG     : Boolean;
      --  Write-only. Trigger generation
      TG       : Boolean;
      --  Write-only. Break generation
      BG       : Boolean;
      --  unspecified
      Reserved : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for EGR_Register use record
      UG       at 0 range 0 .. 0;
      CCxG     at 0 range 1 .. 4;
      COMG     at 0 range 5 .. 5;
      TG       at 0 range 6 .. 6;
      BG       at 0 range 7 .. 7;
      Reserved at 0 range 8 .. 15;
   end record;

   --  capture/compare mode register x (output mode)
   type CCMR_Output is record
      --  Capture/Compare x selection
      CCxS  : Interfaces.Unsigned_32 range 0 .. 3;
      --  Output Compare x fast enable
      OCxFE : Boolean;
      --  Output Compare x preload enable
      OCxPE : Boolean;
      --  Output Compare x mode
      OCxM  : Interfaces.Unsigned_32 range 0 .. 7;
      --  Output Compare x clear enable
      OCxCE : Boolean;
   end record
     with Object_Size => 8, Bit_Order => System.Low_Order_First;

   for CCMR_Output use record
      CCxS  at 0 range 0 .. 1;
      OCxFE at 0 range 2 .. 2;
      OCxPE at 0 range 3 .. 3;
      OCxM  at 0 range 4 .. 6;
      OCxCE at 0 range 7 .. 7;
   end record;

   type CCMR_Output_x2 is array (0 .. 1) of CCMR_Output
     with Component_Size => 8, Object_Size => 16;

   --  capture/compare mode register 1 (input mode)
   type CCMR_Input is record
      --  Capture/Compare 1 selection
      CCxS   : Interfaces.Unsigned_32 range 0 .. 3;
      --  Input capture 1 prescaler
      ICxPCS : Interfaces.Unsigned_32 range 0 .. 3;
      --  Input capture 1 filter
      ICxF   : Interfaces.Unsigned_32 range 0 .. 15;
   end record
     with Object_Size => 8, Bit_Order => System.Low_Order_First;

   for CCMR_Input use record
      CCxS   at 0 range 0 .. 1;
      ICxPCS at 0 range 2 .. 3;
      ICxF   at 0 range 4 .. 7;
   end record;

   type CCMR_Input_x2 is array (0 .. 1) of CCMR_Input
     with Component_Size => 8, Object_Size => 16;

   type CCMR_x2 (Input : Boolean := False) is record
      Reserved : Interfaces.Unsigned_32 range 0 .. 65535;

      case Input is
         when False =>
            --  capture/compare mode register x (output mode)
            CCMR_Output : aliased CCMR_Output_x2;
            pragma Volatile_Full_Access (CCMR_Output);
         when True =>
            --  capture/compare mode register x (input mode)
            CCMR_Input : aliased CCMR_Input_x2;
            pragma Volatile_Full_Access (CCMR_Input);
      end case;
   end record
     with
       Unchecked_Union,
       Volatile,
       Object_Size => 32,
       Bit_Order => System.Low_Order_First;

   for CCMR_x2 use record
      CCMR_Output at 0 range 0 .. 15;
      CCMR_Input  at 0 range 0 .. 15;
      Reserved    at 0 range 16 .. 31;
   end record;

   type CCMR_x4 is array (0 .. 1) of CCMR_x2
     with Component_Size => 32;

   --  capture/compare enable register
   type CCER is record
      --  Capture/Compare x output enable
      CCxE           : Boolean;
      --  Capture/Compare x output Polarity
      CCxP           : Bit;
      --  Capture/Compare x complementary output enable
      CCxNE          : Boolean;
      --  Capture/Compare x output Polarity
      CCxNP          : Bit;
   end record
     with Bit_Order => System.Low_Order_First;

   for CCER use record
      CCxE  at 0 range 0 .. 0;
      CCxP  at 0 range 1 .. 1;
      CCxNE at 0 range 2 .. 2;
      CCxNP at 0 range 3 .. 3;
   end record;

   type CCER_x4 is array (1 .. 4) of CCER
     with Component_Size => 4, Object_Size => 16;

   --  repetition counter register
   type RCR_Register is record
      --  Repetition counter value
      REP      : Interfaces.Unsigned_32 range 0 .. 255;
      --  unspecified
      Reserved : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for RCR_Register use record
      REP      at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 15;
   end record;

   --  capture/compare register 1
   type CCR_x4 is array (1 .. 4) of aliased Interfaces.Unsigned_32;

   --  break and dead-time register
   type BDTR_Register is record
      --  Dead-time generator setup
      DTG  : Interfaces.Unsigned_32 range 0 .. 255;
      --  Lock configuration
      LOCK : Interfaces.Unsigned_32 range 0 .. 3;
      --  Off-state selection for Idle mode
      OSSI : Boolean;
      --  Off-state selection for Run mode
      OSSR : Boolean;
      --  Break enable
      BKE  : Boolean;
      --  Break polarity
      BKP  : Boolean;
      --  Automatic output enable
      AOE  : Boolean;
      --  Main output enable
      MOE  : Boolean;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for BDTR_Register use record
      DTG  at 0 range 0 .. 7;
      LOCK at 0 range 8 .. 9;
      OSSI at 0 range 10 .. 10;
      OSSR at 0 range 11 .. 11;
      BKE  at 0 range 12 .. 12;
      BKP  at 0 range 13 .. 13;
      AOE  at 0 range 14 .. 14;
      MOE  at 0 range 15 .. 15;
   end record;

   --  DMA control register
   type DCR_Register is record
      --  DMA base address
      DBA            : Interfaces.Unsigned_32 range 0 .. 31;
      --  unspecified
      Reserved_5_7   : Interfaces.Unsigned_32 range 0 .. 7;
      --  DMA burst length
      DBL            : Interfaces.Unsigned_32 range 0 .. 31;
      --  unspecified
      Reserved_13_15 : Interfaces.Unsigned_32 range 0 .. 7;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for DCR_Register use record
      DBA            at 0 range 0 .. 4;
      Reserved_5_7   at 0 range 5 .. 7;
      DBL            at 0 range 8 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
   end record;

   --  option register
   type OR_x8 is array (1 .. 8) of Interfaces.Unsigned_32 range 0 .. 3
     with Component_Size => 2, Object_Size => 16;

   -----------------
   -- Peripherals --
   -----------------

   --  Advanced-timers
   type TIM_Peripheral is record
      --  control register 1
      CR1  : aliased CR1_Register;
      pragma Volatile_Full_Access (CR1);
      --  control register 2
      CR2  : aliased CR2_Register;
      pragma Volatile_Full_Access (CR2);
      --  slave mode control register
      SMCR : aliased SMCR_Register;
      pragma Volatile_Full_Access (SMCR);
      --  DMA/Interrupt enable register
      DIER : aliased DIER_Register;
      pragma Volatile_Full_Access (DIER);
      --  status register
      SR   : aliased SR_Register;
      pragma Volatile_Full_Access (SR);
      --  event generation register
      EGR  : aliased EGR_Register;
      pragma Volatile_Full_Access (EGR);
      --  capture/compare mode register x
      CCMR : aliased CCMR_x4;
      --  capture/compare enable register
      CCER : aliased CCER_x4;
      pragma Volatile_Full_Access (CCER);
      --  counter
      CNT  : aliased Interfaces.Unsigned_32 range 0 .. 65535;
      --  prescaler
      PSC  : aliased Interfaces.Unsigned_32 range 0 .. 65535;
      --  auto-reload register
      ARR  : aliased Interfaces.Unsigned_32 range 0 .. 65535;
      --  repetition counter register
      RCR  : aliased RCR_Register;
      pragma Volatile_Full_Access (RCR);
      --  capture/compare register x
      CCR  : CCR_x4;
      --  break and dead-time register
      BDTR : aliased BDTR_Register;
      pragma Volatile_Full_Access (BDTR);
      --  DMA control register
      DCR  : aliased DCR_Register;
      pragma Volatile_Full_Access (DCR);
      --  DMA address for full transfer
      DMAR : aliased Interfaces.Unsigned_32;
      pragma Volatile_Full_Access (DMAR);
      --  option register
      OR_x : aliased OR_x8;
      pragma Volatile_Full_Access (OR_x);
   end record
     with Volatile;

   for TIM_Peripheral use record
      CR1  at 16#0# range 0 .. 15;
      CR2  at 16#4# range 0 .. 15;
      SMCR at 16#8# range 0 .. 15;
      DIER at 16#C# range 0 .. 15;
      SR   at 16#10# range 0 .. 15;
      EGR  at 16#14# range 0 .. 15;
      CCMR at 16#18# range 0 .. 63;
      CCER at 16#20# range 0 .. 15;
      CNT  at 16#24# range 0 .. 31;
      PSC  at 16#28# range 0 .. 31;
      ARR  at 16#2C# range 0 .. 31;
      RCR  at 16#30# range 0 .. 15;
      CCR  at 16#34# range 0 .. 127;
      BDTR at 16#44# range 0 .. 15;
      DCR  at 16#48# range 0 .. 15;
      DMAR at 16#4C# range 0 .. 31;
      OR_x at 16#50# range 0 .. 15;
   end record;

   --  Advanced-timers
   TIM1_Periph : aliased TIM_Peripheral
     with Import, Address => TIM1_Base;

   --  General purpose timers
   TIM2_Periph : aliased TIM_Peripheral
     with Import, Address => TIM2_Base;

   --  General purpose timers
   TIM3_Periph : aliased TIM_Peripheral
     with Import, Address => TIM3_Base;

   --  General purpose timers
   TIM4_Periph : aliased TIM_Peripheral
     with Import, Address => TIM4_Base;

   --  General-purpose-timers
   TIM5_Periph : aliased TIM_Peripheral
     with Import, Address => TIM5_Base;

   --  Basic timers
   TIM6_Periph : aliased TIM_Peripheral
     with Import, Address => TIM6_Base;

   --  Basic timers
   TIM7_Periph : aliased TIM_Peripheral
     with Import, Address => TIM7_Base;

   --  Advanced-timers
   TIM8_Periph : aliased TIM_Peripheral
     with Import, Address => TIM8_Base;

   --  General purpose timers
   TIM9_Periph : aliased TIM_Peripheral
     with Import, Address => TIM9_Base;

   --  General-purpose-timers
   TIM11_Periph : aliased TIM_Peripheral
     with Import, Address => TIM11_Base;

   --  General-purpose-timers
   TIM10_Periph : aliased TIM_Peripheral
     with Import, Address => TIM10_Base;

   --  General purpose timers
   TIM12_Periph : aliased TIM_Peripheral
     with Import, Address => TIM12_Base;

   --  General-purpose-timers
   TIM13_Periph : aliased TIM_Peripheral
     with Import, Address => TIM13_Base;

   --  General-purpose-timers
   TIM14_Periph : aliased TIM_Peripheral
     with Import, Address => TIM14_Base;

end STM32.Registers.TIM;
