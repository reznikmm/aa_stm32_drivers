--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F429x.svd


with System;

package Interfaces.STM32.TIM is
   pragma Preelaborate;
   pragma No_Elaboration_Code_All;

   ---------------
   -- Registers --
   ---------------

   subtype CR1_CMS_Field is Interfaces.STM32.UInt2;
   subtype CR1_CKD_Field is Interfaces.STM32.UInt2;

   --  control register 1
   type CR1_Register is record
      --  Counter enable
      CEN            : Boolean := False;
      --  Update disable
      UDIS           : Boolean := False;
      --  Update request source
      URS            : Boolean := False;
      --  One-pulse mode
      OPM            : Boolean := False;
      --  Direction
      DIR            : Boolean := False;
      --  Center-aligned mode selection
      CMS            : CR1_CMS_Field := 16#0#;
      --  Auto-reload preload enable
      ARPE           : Boolean := False;
      --  Clock division
      CKD            : CR1_CKD_Field := 16#0#;
      --  unspecified
      Reserved_10_31 : Interfaces.STM32.UInt22 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR1_Register use record
      CEN            at 0 range 0 .. 0;
      UDIS           at 0 range 1 .. 1;
      URS            at 0 range 2 .. 2;
      OPM            at 0 range 3 .. 3;
      DIR            at 0 range 4 .. 4;
      CMS            at 0 range 5 .. 6;
      ARPE           at 0 range 7 .. 7;
      CKD            at 0 range 8 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   subtype CR2_MMS_Field is Interfaces.STM32.UInt3;

   --  control register 2
   type CR2_Register is record
      --  Capture/compare preloaded control
      CCPC           : Boolean := False;
      --  unspecified
      Reserved_1_1   : Interfaces.STM32.Bit := 16#0#;
      --  Capture/compare control update selection
      CCUS           : Boolean := False;
      --  Capture/compare DMA selection
      CCDS           : Boolean := False;
      --  Master mode selection
      MMS            : CR2_MMS_Field := 16#0#;
      --  TI1 selection
      TI1S           : Boolean := False;
      --  Output Idle state 1
      OIS1           : Boolean := False;
      --  Output Idle state 1
      OIS1N          : Boolean := False;
      --  Output Idle state 2
      OIS2           : Boolean := False;
      --  Output Idle state 2
      OIS2N          : Boolean := False;
      --  Output Idle state 3
      OIS3           : Boolean := False;
      --  Output Idle state 3
      OIS3N          : Boolean := False;
      --  Output Idle state 4
      OIS4           : Boolean := False;
      --  unspecified
      Reserved_15_31 : Interfaces.STM32.UInt17 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR2_Register use record
      CCPC           at 0 range 0 .. 0;
      Reserved_1_1   at 0 range 1 .. 1;
      CCUS           at 0 range 2 .. 2;
      CCDS           at 0 range 3 .. 3;
      MMS            at 0 range 4 .. 6;
      TI1S           at 0 range 7 .. 7;
      OIS1           at 0 range 8 .. 8;
      OIS1N          at 0 range 9 .. 9;
      OIS2           at 0 range 10 .. 10;
      OIS2N          at 0 range 11 .. 11;
      OIS3           at 0 range 12 .. 12;
      OIS3N          at 0 range 13 .. 13;
      OIS4           at 0 range 14 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   subtype SMCR_SMS_Field is Interfaces.STM32.UInt3;
   subtype SMCR_TS_Field is Interfaces.STM32.UInt3;
   subtype SMCR_ETF_Field is Interfaces.STM32.UInt4;
   subtype SMCR_ETPS_Field is Interfaces.STM32.UInt2;

   --  slave mode control register
   type SMCR_Register is record
      --  Slave mode selection
      SMS            : SMCR_SMS_Field := 16#0#;
      --  unspecified
      Reserved_3_3   : Interfaces.STM32.Bit := 16#0#;
      --  Trigger selection
      TS             : SMCR_TS_Field := 16#0#;
      --  Master/Slave mode
      MSM            : Boolean := False;
      --  External trigger filter
      ETF            : SMCR_ETF_Field := 16#0#;
      --  External trigger prescaler
      ETPS           : SMCR_ETPS_Field := 16#0#;
      --  External clock enable
      ECE            : Boolean := False;
      --  External trigger polarity
      ETP            : Boolean := False;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SMCR_Register use record
      SMS            at 0 range 0 .. 2;
      Reserved_3_3   at 0 range 3 .. 3;
      TS             at 0 range 4 .. 6;
      MSM            at 0 range 7 .. 7;
      ETF            at 0 range 8 .. 11;
      ETPS           at 0 range 12 .. 13;
      ECE            at 0 range 14 .. 14;
      ETP            at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  DMA/Interrupt enable register
   type DIER_Register is record
      --  Update interrupt enable
      UIE            : Boolean := False;
      --  Capture/Compare 1 interrupt enable
      CC1IE          : Boolean := False;
      --  Capture/Compare 2 interrupt enable
      CC2IE          : Boolean := False;
      --  Capture/Compare 3 interrupt enable
      CC3IE          : Boolean := False;
      --  Capture/Compare 4 interrupt enable
      CC4IE          : Boolean := False;
      --  COM interrupt enable
      COMIE          : Boolean := False;
      --  Trigger interrupt enable
      TIE            : Boolean := False;
      --  Break interrupt enable
      BIE            : Boolean := False;
      --  Update DMA request enable
      UDE            : Boolean := False;
      --  Capture/Compare 1 DMA request enable
      CC1DE          : Boolean := False;
      --  Capture/Compare 2 DMA request enable
      CC2DE          : Boolean := False;
      --  Capture/Compare 3 DMA request enable
      CC3DE          : Boolean := False;
      --  Capture/Compare 4 DMA request enable
      CC4DE          : Boolean := False;
      --  COM DMA request enable
      COMDE          : Boolean := False;
      --  Trigger DMA request enable
      TDE            : Boolean := False;
      --  unspecified
      Reserved_15_31 : Interfaces.STM32.UInt17 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DIER_Register use record
      UIE            at 0 range 0 .. 0;
      CC1IE          at 0 range 1 .. 1;
      CC2IE          at 0 range 2 .. 2;
      CC3IE          at 0 range 3 .. 3;
      CC4IE          at 0 range 4 .. 4;
      COMIE          at 0 range 5 .. 5;
      TIE            at 0 range 6 .. 6;
      BIE            at 0 range 7 .. 7;
      UDE            at 0 range 8 .. 8;
      CC1DE          at 0 range 9 .. 9;
      CC2DE          at 0 range 10 .. 10;
      CC3DE          at 0 range 11 .. 11;
      CC4DE          at 0 range 12 .. 12;
      COMDE          at 0 range 13 .. 13;
      TDE            at 0 range 14 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   --  status register
   type SR_Register is record
      --  Update interrupt flag
      UIF            : Boolean := False;
      --  Capture/compare 1 interrupt flag
      CC1IF          : Boolean := False;
      --  Capture/Compare 2 interrupt flag
      CC2IF          : Boolean := False;
      --  Capture/Compare 3 interrupt flag
      CC3IF          : Boolean := False;
      --  Capture/Compare 4 interrupt flag
      CC4IF          : Boolean := False;
      --  COM interrupt flag
      COMIF          : Boolean := False;
      --  Trigger interrupt flag
      TIF            : Boolean := False;
      --  Break interrupt flag
      BIF            : Boolean := False;
      --  unspecified
      Reserved_8_8   : Interfaces.STM32.Bit := 16#0#;
      --  Capture/Compare 1 overcapture flag
      CC1OF          : Boolean := False;
      --  Capture/compare 2 overcapture flag
      CC2OF          : Boolean := False;
      --  Capture/Compare 3 overcapture flag
      CC3OF          : Boolean := False;
      --  Capture/Compare 4 overcapture flag
      CC4OF          : Boolean := False;
      --  unspecified
      Reserved_13_31 : Interfaces.STM32.UInt19 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SR_Register use record
      UIF            at 0 range 0 .. 0;
      CC1IF          at 0 range 1 .. 1;
      CC2IF          at 0 range 2 .. 2;
      CC3IF          at 0 range 3 .. 3;
      CC4IF          at 0 range 4 .. 4;
      COMIF          at 0 range 5 .. 5;
      TIF            at 0 range 6 .. 6;
      BIF            at 0 range 7 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      CC1OF          at 0 range 9 .. 9;
      CC2OF          at 0 range 10 .. 10;
      CC3OF          at 0 range 11 .. 11;
      CC4OF          at 0 range 12 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   --  event generation register
   type EGR_Register is record
      --  Write-only. Update generation
      UG            : Boolean := False;
      --  Write-only. Capture/compare 1 generation
      CC1G          : Boolean := False;
      --  Write-only. Capture/compare 2 generation
      CC2G          : Boolean := False;
      --  Write-only. Capture/compare 3 generation
      CC3G          : Boolean := False;
      --  Write-only. Capture/compare 4 generation
      CC4G          : Boolean := False;
      --  Write-only. Capture/Compare control update generation
      COMG          : Boolean := False;
      --  Write-only. Trigger generation
      TG            : Boolean := False;
      --  Write-only. Break generation
      BG            : Boolean := False;
      --  unspecified
      Reserved_8_31 : Interfaces.STM32.UInt24 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for EGR_Register use record
      UG            at 0 range 0 .. 0;
      CC1G          at 0 range 1 .. 1;
      CC2G          at 0 range 2 .. 2;
      CC3G          at 0 range 3 .. 3;
      CC4G          at 0 range 4 .. 4;
      COMG          at 0 range 5 .. 5;
      TG            at 0 range 6 .. 6;
      BG            at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CCMR1_Output_CC1S_Field is Interfaces.STM32.UInt2;
   subtype CCMR1_Output_OC1M_Field is Interfaces.STM32.UInt3;
   subtype CCMR1_Output_CC2S_Field is Interfaces.STM32.UInt2;
   subtype CCMR1_Output_OC2M_Field is Interfaces.STM32.UInt3;

   --  capture/compare mode register 1 (output mode)
   type CCMR1_Output_Register is record
      --  Capture/Compare 1 selection
      CC1S           : CCMR1_Output_CC1S_Field := 16#0#;
      --  Output Compare 1 fast enable
      OC1FE          : Boolean := False;
      --  Output Compare 1 preload enable
      OC1PE          : Boolean := False;
      --  Output Compare 1 mode
      OC1M           : CCMR1_Output_OC1M_Field := 16#0#;
      --  Output Compare 1 clear enable
      OC1CE          : Boolean := False;
      --  Capture/Compare 2 selection
      CC2S           : CCMR1_Output_CC2S_Field := 16#0#;
      --  Output Compare 2 fast enable
      OC2FE          : Boolean := False;
      --  Output Compare 2 preload enable
      OC2PE          : Boolean := False;
      --  Output Compare 2 mode
      OC2M           : CCMR1_Output_OC2M_Field := 16#0#;
      --  Output Compare 2 clear enable
      OC2CE          : Boolean := False;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCMR1_Output_Register use record
      CC1S           at 0 range 0 .. 1;
      OC1FE          at 0 range 2 .. 2;
      OC1PE          at 0 range 3 .. 3;
      OC1M           at 0 range 4 .. 6;
      OC1CE          at 0 range 7 .. 7;
      CC2S           at 0 range 8 .. 9;
      OC2FE          at 0 range 10 .. 10;
      OC2PE          at 0 range 11 .. 11;
      OC2M           at 0 range 12 .. 14;
      OC2CE          at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CCMR1_Input_CC1S_Field is Interfaces.STM32.UInt2;
   subtype CCMR1_Input_ICPCS_Field is Interfaces.STM32.UInt2;
   subtype CCMR1_Input_IC1F_Field is Interfaces.STM32.UInt4;
   subtype CCMR1_Input_CC2S_Field is Interfaces.STM32.UInt2;
   subtype CCMR1_Input_IC2PCS_Field is Interfaces.STM32.UInt2;
   subtype CCMR1_Input_IC2F_Field is Interfaces.STM32.UInt4;

   --  capture/compare mode register 1 (input mode)
   type CCMR1_Input_Register is record
      --  Capture/Compare 1 selection
      CC1S           : CCMR1_Input_CC1S_Field := 16#0#;
      --  Input capture 1 prescaler
      ICPCS          : CCMR1_Input_ICPCS_Field := 16#0#;
      --  Input capture 1 filter
      IC1F           : CCMR1_Input_IC1F_Field := 16#0#;
      --  Capture/Compare 2 selection
      CC2S           : CCMR1_Input_CC2S_Field := 16#0#;
      --  Input capture 2 prescaler
      IC2PCS         : CCMR1_Input_IC2PCS_Field := 16#0#;
      --  Input capture 2 filter
      IC2F           : CCMR1_Input_IC2F_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCMR1_Input_Register use record
      CC1S           at 0 range 0 .. 1;
      ICPCS          at 0 range 2 .. 3;
      IC1F           at 0 range 4 .. 7;
      CC2S           at 0 range 8 .. 9;
      IC2PCS         at 0 range 10 .. 11;
      IC2F           at 0 range 12 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CCMR2_Output_CC3S_Field is Interfaces.STM32.UInt2;
   subtype CCMR2_Output_OC3M_Field is Interfaces.STM32.UInt3;
   subtype CCMR2_Output_CC4S_Field is Interfaces.STM32.UInt2;
   subtype CCMR2_Output_OC4M_Field is Interfaces.STM32.UInt3;

   --  capture/compare mode register 2 (output mode)
   type CCMR2_Output_Register is record
      --  Capture/Compare 3 selection
      CC3S           : CCMR2_Output_CC3S_Field := 16#0#;
      --  Output compare 3 fast enable
      OC3FE          : Boolean := False;
      --  Output compare 3 preload enable
      OC3PE          : Boolean := False;
      --  Output compare 3 mode
      OC3M           : CCMR2_Output_OC3M_Field := 16#0#;
      --  Output compare 3 clear enable
      OC3CE          : Boolean := False;
      --  Capture/Compare 4 selection
      CC4S           : CCMR2_Output_CC4S_Field := 16#0#;
      --  Output compare 4 fast enable
      OC4FE          : Boolean := False;
      --  Output compare 4 preload enable
      OC4PE          : Boolean := False;
      --  Output compare 4 mode
      OC4M           : CCMR2_Output_OC4M_Field := 16#0#;
      --  Output compare 4 clear enable
      OC4CE          : Boolean := False;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCMR2_Output_Register use record
      CC3S           at 0 range 0 .. 1;
      OC3FE          at 0 range 2 .. 2;
      OC3PE          at 0 range 3 .. 3;
      OC3M           at 0 range 4 .. 6;
      OC3CE          at 0 range 7 .. 7;
      CC4S           at 0 range 8 .. 9;
      OC4FE          at 0 range 10 .. 10;
      OC4PE          at 0 range 11 .. 11;
      OC4M           at 0 range 12 .. 14;
      OC4CE          at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CCMR2_Input_CC3S_Field is Interfaces.STM32.UInt2;
   subtype CCMR2_Input_IC3PSC_Field is Interfaces.STM32.UInt2;
   subtype CCMR2_Input_IC3F_Field is Interfaces.STM32.UInt4;
   subtype CCMR2_Input_CC4S_Field is Interfaces.STM32.UInt2;
   subtype CCMR2_Input_IC4PSC_Field is Interfaces.STM32.UInt2;
   subtype CCMR2_Input_IC4F_Field is Interfaces.STM32.UInt4;

   --  capture/compare mode register 2 (input mode)
   type CCMR2_Input_Register is record
      --  Capture/compare 3 selection
      CC3S           : CCMR2_Input_CC3S_Field := 16#0#;
      --  Input capture 3 prescaler
      IC3PSC         : CCMR2_Input_IC3PSC_Field := 16#0#;
      --  Input capture 3 filter
      IC3F           : CCMR2_Input_IC3F_Field := 16#0#;
      --  Capture/Compare 4 selection
      CC4S           : CCMR2_Input_CC4S_Field := 16#0#;
      --  Input capture 4 prescaler
      IC4PSC         : CCMR2_Input_IC4PSC_Field := 16#0#;
      --  Input capture 4 filter
      IC4F           : CCMR2_Input_IC4F_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCMR2_Input_Register use record
      CC3S           at 0 range 0 .. 1;
      IC3PSC         at 0 range 2 .. 3;
      IC3F           at 0 range 4 .. 7;
      CC4S           at 0 range 8 .. 9;
      IC4PSC         at 0 range 10 .. 11;
      IC4F           at 0 range 12 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  capture/compare enable register
   type CCER_Register is record
      --  Capture/Compare 1 output enable
      CC1E           : Boolean := False;
      --  Capture/Compare 1 output Polarity
      CC1P           : Boolean := False;
      --  Capture/Compare 1 complementary output enable
      CC1NE          : Boolean := False;
      --  Capture/Compare 1 output Polarity
      CC1NP          : Boolean := False;
      --  Capture/Compare 2 output enable
      CC2E           : Boolean := False;
      --  Capture/Compare 2 output Polarity
      CC2P           : Boolean := False;
      --  Capture/Compare 2 complementary output enable
      CC2NE          : Boolean := False;
      --  Capture/Compare 2 output Polarity
      CC2NP          : Boolean := False;
      --  Capture/Compare 3 output enable
      CC3E           : Boolean := False;
      --  Capture/Compare 3 output Polarity
      CC3P           : Boolean := False;
      --  Capture/Compare 3 complementary output enable
      CC3NE          : Boolean := False;
      --  Capture/Compare 3 output Polarity
      CC3NP          : Boolean := False;
      --  Capture/Compare 4 output enable
      CC4E           : Boolean := False;
      --  Capture/Compare 3 output Polarity
      CC4P           : Boolean := False;
      --  unspecified
      Reserved_14_31 : Interfaces.STM32.UInt18 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCER_Register use record
      CC1E           at 0 range 0 .. 0;
      CC1P           at 0 range 1 .. 1;
      CC1NE          at 0 range 2 .. 2;
      CC1NP          at 0 range 3 .. 3;
      CC2E           at 0 range 4 .. 4;
      CC2P           at 0 range 5 .. 5;
      CC2NE          at 0 range 6 .. 6;
      CC2NP          at 0 range 7 .. 7;
      CC3E           at 0 range 8 .. 8;
      CC3P           at 0 range 9 .. 9;
      CC3NE          at 0 range 10 .. 10;
      CC3NP          at 0 range 11 .. 11;
      CC4E           at 0 range 12 .. 12;
      CC4P           at 0 range 13 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   subtype CNT_CNT_Field is Interfaces.STM32.UInt16;

   --  counter
   type CNT_Register is record
      --  counter value
      CNT            : CNT_CNT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CNT_Register use record
      CNT            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype PSC_PSC_Field is Interfaces.STM32.UInt16;

   --  prescaler
   type PSC_Register is record
      --  Prescaler value
      PSC            : PSC_PSC_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for PSC_Register use record
      PSC            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype ARR_ARR_Field is Interfaces.STM32.UInt16;

   --  auto-reload register
   type ARR_Register is record
      --  Auto-reload value
      ARR            : ARR_ARR_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for ARR_Register use record
      ARR            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RCR_REP_Field is Interfaces.STM32.Byte;

   --  repetition counter register
   type RCR_Register is record
      --  Repetition counter value
      REP           : RCR_REP_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : Interfaces.STM32.UInt24 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for RCR_Register use record
      REP           at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CCR1_CCR1_Field is Interfaces.STM32.UInt16;

   --  capture/compare register 1
   type CCR1_Register is record
      --  Capture/Compare 1 value
      CCR1           : CCR1_CCR1_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCR1_Register use record
      CCR1           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CCR2_CCR2_Field is Interfaces.STM32.UInt16;

   --  capture/compare register 2
   type CCR2_Register is record
      --  Capture/Compare 2 value
      CCR2           : CCR2_CCR2_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCR2_Register use record
      CCR2           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CCR3_CCR3_Field is Interfaces.STM32.UInt16;

   --  capture/compare register 3
   type CCR3_Register is record
      --  Capture/Compare value
      CCR3           : CCR3_CCR3_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCR3_Register use record
      CCR3           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CCR4_CCR4_Field is Interfaces.STM32.UInt16;

   --  capture/compare register 4
   type CCR4_Register is record
      --  Capture/Compare value
      CCR4           : CCR4_CCR4_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCR4_Register use record
      CCR4           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype BDTR_DTG_Field is Interfaces.STM32.Byte;
   subtype BDTR_LOCK_Field is Interfaces.STM32.UInt2;

   --  break and dead-time register
   type BDTR_Register is record
      --  Dead-time generator setup
      DTG            : BDTR_DTG_Field := 16#0#;
      --  Lock configuration
      LOCK           : BDTR_LOCK_Field := 16#0#;
      --  Off-state selection for Idle mode
      OSSI           : Boolean := False;
      --  Off-state selection for Run mode
      OSSR           : Boolean := False;
      --  Break enable
      BKE            : Boolean := False;
      --  Break polarity
      BKP            : Boolean := False;
      --  Automatic output enable
      AOE            : Boolean := False;
      --  Main output enable
      MOE            : Boolean := False;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for BDTR_Register use record
      DTG            at 0 range 0 .. 7;
      LOCK           at 0 range 8 .. 9;
      OSSI           at 0 range 10 .. 10;
      OSSR           at 0 range 11 .. 11;
      BKE            at 0 range 12 .. 12;
      BKP            at 0 range 13 .. 13;
      AOE            at 0 range 14 .. 14;
      MOE            at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype DCR_DBA_Field is Interfaces.STM32.UInt5;
   subtype DCR_DBL_Field is Interfaces.STM32.UInt5;

   --  DMA control register
   type DCR_Register is record
      --  DMA base address
      DBA            : DCR_DBA_Field := 16#0#;
      --  unspecified
      Reserved_5_7   : Interfaces.STM32.UInt3 := 16#0#;
      --  DMA burst length
      DBL            : DCR_DBL_Field := 16#0#;
      --  unspecified
      Reserved_13_31 : Interfaces.STM32.UInt19 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DCR_Register use record
      DBA            at 0 range 0 .. 4;
      Reserved_5_7   at 0 range 5 .. 7;
      DBL            at 0 range 8 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   subtype DMAR_DMAB_Field is Interfaces.STM32.UInt16;

   --  DMA address for full transfer
   type DMAR_Register is record
      --  DMA register for burst accesses
      DMAB           : DMAR_DMAB_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DMAR_Register use record
      DMAB           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  control register 2
   type CR2_Register_1 is record
      --  unspecified
      Reserved_0_2  : Interfaces.STM32.UInt3 := 16#0#;
      --  Capture/compare DMA selection
      CCDS          : Boolean := False;
      --  Master mode selection
      MMS           : CR2_MMS_Field := 16#0#;
      --  TI1 selection
      TI1S          : Boolean := False;
      --  unspecified
      Reserved_8_31 : Interfaces.STM32.UInt24 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR2_Register_1 use record
      Reserved_0_2  at 0 range 0 .. 2;
      CCDS          at 0 range 3 .. 3;
      MMS           at 0 range 4 .. 6;
      TI1S          at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  DMA/Interrupt enable register
   type DIER_Register_1 is record
      --  Update interrupt enable
      UIE            : Boolean := False;
      --  Capture/Compare 1 interrupt enable
      CC1IE          : Boolean := False;
      --  Capture/Compare 2 interrupt enable
      CC2IE          : Boolean := False;
      --  Capture/Compare 3 interrupt enable
      CC3IE          : Boolean := False;
      --  Capture/Compare 4 interrupt enable
      CC4IE          : Boolean := False;
      --  unspecified
      Reserved_5_5   : Interfaces.STM32.Bit := 16#0#;
      --  Trigger interrupt enable
      TIE            : Boolean := False;
      --  unspecified
      Reserved_7_7   : Interfaces.STM32.Bit := 16#0#;
      --  Update DMA request enable
      UDE            : Boolean := False;
      --  Capture/Compare 1 DMA request enable
      CC1DE          : Boolean := False;
      --  Capture/Compare 2 DMA request enable
      CC2DE          : Boolean := False;
      --  Capture/Compare 3 DMA request enable
      CC3DE          : Boolean := False;
      --  Capture/Compare 4 DMA request enable
      CC4DE          : Boolean := False;
      --  unspecified
      Reserved_13_13 : Interfaces.STM32.Bit := 16#0#;
      --  Trigger DMA request enable
      TDE            : Boolean := False;
      --  unspecified
      Reserved_15_31 : Interfaces.STM32.UInt17 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DIER_Register_1 use record
      UIE            at 0 range 0 .. 0;
      CC1IE          at 0 range 1 .. 1;
      CC2IE          at 0 range 2 .. 2;
      CC3IE          at 0 range 3 .. 3;
      CC4IE          at 0 range 4 .. 4;
      Reserved_5_5   at 0 range 5 .. 5;
      TIE            at 0 range 6 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      UDE            at 0 range 8 .. 8;
      CC1DE          at 0 range 9 .. 9;
      CC2DE          at 0 range 10 .. 10;
      CC3DE          at 0 range 11 .. 11;
      CC4DE          at 0 range 12 .. 12;
      Reserved_13_13 at 0 range 13 .. 13;
      TDE            at 0 range 14 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   --  status register
   type SR_Register_1 is record
      --  Update interrupt flag
      UIF            : Boolean := False;
      --  Capture/compare 1 interrupt flag
      CC1IF          : Boolean := False;
      --  Capture/Compare 2 interrupt flag
      CC2IF          : Boolean := False;
      --  Capture/Compare 3 interrupt flag
      CC3IF          : Boolean := False;
      --  Capture/Compare 4 interrupt flag
      CC4IF          : Boolean := False;
      --  unspecified
      Reserved_5_5   : Interfaces.STM32.Bit := 16#0#;
      --  Trigger interrupt flag
      TIF            : Boolean := False;
      --  unspecified
      Reserved_7_8   : Interfaces.STM32.UInt2 := 16#0#;
      --  Capture/Compare 1 overcapture flag
      CC1OF          : Boolean := False;
      --  Capture/compare 2 overcapture flag
      CC2OF          : Boolean := False;
      --  Capture/Compare 3 overcapture flag
      CC3OF          : Boolean := False;
      --  Capture/Compare 4 overcapture flag
      CC4OF          : Boolean := False;
      --  unspecified
      Reserved_13_31 : Interfaces.STM32.UInt19 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SR_Register_1 use record
      UIF            at 0 range 0 .. 0;
      CC1IF          at 0 range 1 .. 1;
      CC2IF          at 0 range 2 .. 2;
      CC3IF          at 0 range 3 .. 3;
      CC4IF          at 0 range 4 .. 4;
      Reserved_5_5   at 0 range 5 .. 5;
      TIF            at 0 range 6 .. 6;
      Reserved_7_8   at 0 range 7 .. 8;
      CC1OF          at 0 range 9 .. 9;
      CC2OF          at 0 range 10 .. 10;
      CC3OF          at 0 range 11 .. 11;
      CC4OF          at 0 range 12 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   --  event generation register
   type EGR_Register_1 is record
      --  Write-only. Update generation
      UG            : Boolean := False;
      --  Write-only. Capture/compare 1 generation
      CC1G          : Boolean := False;
      --  Write-only. Capture/compare 2 generation
      CC2G          : Boolean := False;
      --  Write-only. Capture/compare 3 generation
      CC3G          : Boolean := False;
      --  Write-only. Capture/compare 4 generation
      CC4G          : Boolean := False;
      --  unspecified
      Reserved_5_5  : Interfaces.STM32.Bit := 16#0#;
      --  Write-only. Trigger generation
      TG            : Boolean := False;
      --  unspecified
      Reserved_7_31 : Interfaces.STM32.UInt25 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for EGR_Register_1 use record
      UG            at 0 range 0 .. 0;
      CC1G          at 0 range 1 .. 1;
      CC2G          at 0 range 2 .. 2;
      CC3G          at 0 range 3 .. 3;
      CC4G          at 0 range 4 .. 4;
      Reserved_5_5  at 0 range 5 .. 5;
      TG            at 0 range 6 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   --  capture/compare mode register 2 (output mode)
   type CCMR2_Output_Register_1 is record
      --  CC3S
      CC3S           : CCMR2_Output_CC3S_Field := 16#0#;
      --  OC3FE
      OC3FE          : Boolean := False;
      --  OC3PE
      OC3PE          : Boolean := False;
      --  OC3M
      OC3M           : CCMR2_Output_OC3M_Field := 16#0#;
      --  OC3CE
      OC3CE          : Boolean := False;
      --  CC4S
      CC4S           : CCMR2_Output_CC4S_Field := 16#0#;
      --  OC4FE
      OC4FE          : Boolean := False;
      --  OC4PE
      OC4PE          : Boolean := False;
      --  OC4M
      OC4M           : CCMR2_Output_OC4M_Field := 16#0#;
      --  O24CE
      O24CE          : Boolean := False;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCMR2_Output_Register_1 use record
      CC3S           at 0 range 0 .. 1;
      OC3FE          at 0 range 2 .. 2;
      OC3PE          at 0 range 3 .. 3;
      OC3M           at 0 range 4 .. 6;
      OC3CE          at 0 range 7 .. 7;
      CC4S           at 0 range 8 .. 9;
      OC4FE          at 0 range 10 .. 10;
      OC4PE          at 0 range 11 .. 11;
      OC4M           at 0 range 12 .. 14;
      O24CE          at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  capture/compare enable register
   type CCER_Register_1 is record
      --  Capture/Compare 1 output enable
      CC1E           : Boolean := False;
      --  Capture/Compare 1 output Polarity
      CC1P           : Boolean := False;
      --  unspecified
      Reserved_2_2   : Interfaces.STM32.Bit := 16#0#;
      --  Capture/Compare 1 output Polarity
      CC1NP          : Boolean := False;
      --  Capture/Compare 2 output enable
      CC2E           : Boolean := False;
      --  Capture/Compare 2 output Polarity
      CC2P           : Boolean := False;
      --  unspecified
      Reserved_6_6   : Interfaces.STM32.Bit := 16#0#;
      --  Capture/Compare 2 output Polarity
      CC2NP          : Boolean := False;
      --  Capture/Compare 3 output enable
      CC3E           : Boolean := False;
      --  Capture/Compare 3 output Polarity
      CC3P           : Boolean := False;
      --  unspecified
      Reserved_10_10 : Interfaces.STM32.Bit := 16#0#;
      --  Capture/Compare 3 output Polarity
      CC3NP          : Boolean := False;
      --  Capture/Compare 4 output enable
      CC4E           : Boolean := False;
      --  Capture/Compare 3 output Polarity
      CC4P           : Boolean := False;
      --  unspecified
      Reserved_14_14 : Interfaces.STM32.Bit := 16#0#;
      --  Capture/Compare 4 output Polarity
      CC4NP          : Boolean := False;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCER_Register_1 use record
      CC1E           at 0 range 0 .. 0;
      CC1P           at 0 range 1 .. 1;
      Reserved_2_2   at 0 range 2 .. 2;
      CC1NP          at 0 range 3 .. 3;
      CC2E           at 0 range 4 .. 4;
      CC2P           at 0 range 5 .. 5;
      Reserved_6_6   at 0 range 6 .. 6;
      CC2NP          at 0 range 7 .. 7;
      CC3E           at 0 range 8 .. 8;
      CC3P           at 0 range 9 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      CC3NP          at 0 range 11 .. 11;
      CC4E           at 0 range 12 .. 12;
      CC4P           at 0 range 13 .. 13;
      Reserved_14_14 at 0 range 14 .. 14;
      CC4NP          at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CNT_CNT_L_Field is Interfaces.STM32.UInt16;
   subtype CNT_CNT_H_Field is Interfaces.STM32.UInt16;

   --  counter
   type CNT_Register_1 is record
      --  Low counter value
      CNT_L : CNT_CNT_L_Field := 16#0#;
      --  High counter value
      CNT_H : CNT_CNT_H_Field := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CNT_Register_1 use record
      CNT_L at 0 range 0 .. 15;
      CNT_H at 0 range 16 .. 31;
   end record;

   subtype ARR_ARR_L_Field is Interfaces.STM32.UInt16;
   subtype ARR_ARR_H_Field is Interfaces.STM32.UInt16;

   --  auto-reload register
   type ARR_Register_1 is record
      --  Low Auto-reload value
      ARR_L : ARR_ARR_L_Field := 16#0#;
      --  High Auto-reload value
      ARR_H : ARR_ARR_H_Field := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for ARR_Register_1 use record
      ARR_L at 0 range 0 .. 15;
      ARR_H at 0 range 16 .. 31;
   end record;

   subtype CCR1_CCR1_L_Field is Interfaces.STM32.UInt16;
   subtype CCR1_CCR1_H_Field is Interfaces.STM32.UInt16;

   --  capture/compare register 1
   type CCR1_Register_1 is record
      --  Low Capture/Compare 1 value
      CCR1_L : CCR1_CCR1_L_Field := 16#0#;
      --  High Capture/Compare 1 value
      CCR1_H : CCR1_CCR1_H_Field := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCR1_Register_1 use record
      CCR1_L at 0 range 0 .. 15;
      CCR1_H at 0 range 16 .. 31;
   end record;

   subtype CCR2_CCR2_L_Field is Interfaces.STM32.UInt16;
   subtype CCR2_CCR2_H_Field is Interfaces.STM32.UInt16;

   --  capture/compare register 2
   type CCR2_Register_1 is record
      --  Low Capture/Compare 2 value
      CCR2_L : CCR2_CCR2_L_Field := 16#0#;
      --  High Capture/Compare 2 value
      CCR2_H : CCR2_CCR2_H_Field := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCR2_Register_1 use record
      CCR2_L at 0 range 0 .. 15;
      CCR2_H at 0 range 16 .. 31;
   end record;

   subtype CCR3_CCR3_L_Field is Interfaces.STM32.UInt16;
   subtype CCR3_CCR3_H_Field is Interfaces.STM32.UInt16;

   --  capture/compare register 3
   type CCR3_Register_1 is record
      --  Low Capture/Compare value
      CCR3_L : CCR3_CCR3_L_Field := 16#0#;
      --  High Capture/Compare value
      CCR3_H : CCR3_CCR3_H_Field := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCR3_Register_1 use record
      CCR3_L at 0 range 0 .. 15;
      CCR3_H at 0 range 16 .. 31;
   end record;

   subtype CCR4_CCR4_L_Field is Interfaces.STM32.UInt16;
   subtype CCR4_CCR4_H_Field is Interfaces.STM32.UInt16;

   --  capture/compare register 4
   type CCR4_Register_1 is record
      --  Low Capture/Compare value
      CCR4_L : CCR4_CCR4_L_Field := 16#0#;
      --  High Capture/Compare value
      CCR4_H : CCR4_CCR4_H_Field := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCR4_Register_1 use record
      CCR4_L at 0 range 0 .. 15;
      CCR4_H at 0 range 16 .. 31;
   end record;

   subtype OR_ITR1_RMP_Field is Interfaces.STM32.UInt2;

   --  TIM5 option register
   type OR_Register is record
      --  unspecified
      Reserved_0_9   : Interfaces.STM32.UInt10 := 16#0#;
      --  Timer Input 4 remap
      ITR1_RMP       : OR_ITR1_RMP_Field := 16#0#;
      --  unspecified
      Reserved_12_31 : Interfaces.STM32.UInt20 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for OR_Register use record
      Reserved_0_9   at 0 range 0 .. 9;
      ITR1_RMP       at 0 range 10 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   subtype OR_IT4_RMP_Field is Interfaces.STM32.UInt2;

   --  TIM5 option register
   type OR_Register_1 is record
      --  unspecified
      Reserved_0_5  : Interfaces.STM32.UInt6 := 16#0#;
      --  Timer Input 4 remap
      IT4_RMP       : OR_IT4_RMP_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : Interfaces.STM32.UInt24 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for OR_Register_1 use record
      Reserved_0_5  at 0 range 0 .. 5;
      IT4_RMP       at 0 range 6 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  control register 1
   type CR1_Register_1 is record
      --  Counter enable
      CEN           : Boolean := False;
      --  Update disable
      UDIS          : Boolean := False;
      --  Update request source
      URS           : Boolean := False;
      --  One-pulse mode
      OPM           : Boolean := False;
      --  unspecified
      Reserved_4_6  : Interfaces.STM32.UInt3 := 16#0#;
      --  Auto-reload preload enable
      ARPE          : Boolean := False;
      --  unspecified
      Reserved_8_31 : Interfaces.STM32.UInt24 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR1_Register_1 use record
      CEN           at 0 range 0 .. 0;
      UDIS          at 0 range 1 .. 1;
      URS           at 0 range 2 .. 2;
      OPM           at 0 range 3 .. 3;
      Reserved_4_6  at 0 range 4 .. 6;
      ARPE          at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  control register 2
   type CR2_Register_2 is record
      --  unspecified
      Reserved_0_3  : Interfaces.STM32.UInt4 := 16#0#;
      --  Master mode selection
      MMS           : CR2_MMS_Field := 16#0#;
      --  unspecified
      Reserved_7_31 : Interfaces.STM32.UInt25 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR2_Register_2 use record
      Reserved_0_3  at 0 range 0 .. 3;
      MMS           at 0 range 4 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   --  DMA/Interrupt enable register
   type DIER_Register_2 is record
      --  Update interrupt enable
      UIE           : Boolean := False;
      --  unspecified
      Reserved_1_7  : Interfaces.STM32.UInt7 := 16#0#;
      --  Update DMA request enable
      UDE           : Boolean := False;
      --  unspecified
      Reserved_9_31 : Interfaces.STM32.UInt23 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DIER_Register_2 use record
      UIE           at 0 range 0 .. 0;
      Reserved_1_7  at 0 range 1 .. 7;
      UDE           at 0 range 8 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   --  status register
   type SR_Register_2 is record
      --  Update interrupt flag
      UIF           : Boolean := False;
      --  unspecified
      Reserved_1_31 : Interfaces.STM32.UInt31 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SR_Register_2 use record
      UIF           at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  event generation register
   type EGR_Register_2 is record
      --  Write-only. Update generation
      UG            : Boolean := False;
      --  unspecified
      Reserved_1_31 : Interfaces.STM32.UInt31 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for EGR_Register_2 use record
      UG            at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  control register 1
   type CR1_Register_2 is record
      --  Counter enable
      CEN            : Boolean := False;
      --  Update disable
      UDIS           : Boolean := False;
      --  Update request source
      URS            : Boolean := False;
      --  One-pulse mode
      OPM            : Boolean := False;
      --  unspecified
      Reserved_4_6   : Interfaces.STM32.UInt3 := 16#0#;
      --  Auto-reload preload enable
      ARPE           : Boolean := False;
      --  Clock division
      CKD            : CR1_CKD_Field := 16#0#;
      --  unspecified
      Reserved_10_31 : Interfaces.STM32.UInt22 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR1_Register_2 use record
      CEN            at 0 range 0 .. 0;
      UDIS           at 0 range 1 .. 1;
      URS            at 0 range 2 .. 2;
      OPM            at 0 range 3 .. 3;
      Reserved_4_6   at 0 range 4 .. 6;
      ARPE           at 0 range 7 .. 7;
      CKD            at 0 range 8 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   --  slave mode control register
   type SMCR_Register_1 is record
      --  Slave mode selection
      SMS           : SMCR_SMS_Field := 16#0#;
      --  unspecified
      Reserved_3_3  : Interfaces.STM32.Bit := 16#0#;
      --  Trigger selection
      TS            : SMCR_TS_Field := 16#0#;
      --  Master/Slave mode
      MSM           : Boolean := False;
      --  unspecified
      Reserved_8_31 : Interfaces.STM32.UInt24 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SMCR_Register_1 use record
      SMS           at 0 range 0 .. 2;
      Reserved_3_3  at 0 range 3 .. 3;
      TS            at 0 range 4 .. 6;
      MSM           at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  DMA/Interrupt enable register
   type DIER_Register_3 is record
      --  Update interrupt enable
      UIE           : Boolean := False;
      --  Capture/Compare 1 interrupt enable
      CC1IE         : Boolean := False;
      --  Capture/Compare 2 interrupt enable
      CC2IE         : Boolean := False;
      --  unspecified
      Reserved_3_5  : Interfaces.STM32.UInt3 := 16#0#;
      --  Trigger interrupt enable
      TIE           : Boolean := False;
      --  unspecified
      Reserved_7_31 : Interfaces.STM32.UInt25 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DIER_Register_3 use record
      UIE           at 0 range 0 .. 0;
      CC1IE         at 0 range 1 .. 1;
      CC2IE         at 0 range 2 .. 2;
      Reserved_3_5  at 0 range 3 .. 5;
      TIE           at 0 range 6 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   --  status register
   type SR_Register_3 is record
      --  Update interrupt flag
      UIF            : Boolean := False;
      --  Capture/compare 1 interrupt flag
      CC1IF          : Boolean := False;
      --  Capture/Compare 2 interrupt flag
      CC2IF          : Boolean := False;
      --  unspecified
      Reserved_3_5   : Interfaces.STM32.UInt3 := 16#0#;
      --  Trigger interrupt flag
      TIF            : Boolean := False;
      --  unspecified
      Reserved_7_8   : Interfaces.STM32.UInt2 := 16#0#;
      --  Capture/Compare 1 overcapture flag
      CC1OF          : Boolean := False;
      --  Capture/compare 2 overcapture flag
      CC2OF          : Boolean := False;
      --  unspecified
      Reserved_11_31 : Interfaces.STM32.UInt21 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SR_Register_3 use record
      UIF            at 0 range 0 .. 0;
      CC1IF          at 0 range 1 .. 1;
      CC2IF          at 0 range 2 .. 2;
      Reserved_3_5   at 0 range 3 .. 5;
      TIF            at 0 range 6 .. 6;
      Reserved_7_8   at 0 range 7 .. 8;
      CC1OF          at 0 range 9 .. 9;
      CC2OF          at 0 range 10 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   --  event generation register
   type EGR_Register_3 is record
      --  Write-only. Update generation
      UG            : Boolean := False;
      --  Write-only. Capture/compare 1 generation
      CC1G          : Boolean := False;
      --  Write-only. Capture/compare 2 generation
      CC2G          : Boolean := False;
      --  unspecified
      Reserved_3_5  : Interfaces.STM32.UInt3 := 16#0#;
      --  Write-only. Trigger generation
      TG            : Boolean := False;
      --  unspecified
      Reserved_7_31 : Interfaces.STM32.UInt25 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for EGR_Register_3 use record
      UG            at 0 range 0 .. 0;
      CC1G          at 0 range 1 .. 1;
      CC2G          at 0 range 2 .. 2;
      Reserved_3_5  at 0 range 3 .. 5;
      TG            at 0 range 6 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   --  capture/compare mode register 1 (output mode)
   type CCMR1_Output_Register_1 is record
      --  Capture/Compare 1 selection
      CC1S           : CCMR1_Output_CC1S_Field := 16#0#;
      --  Output Compare 1 fast enable
      OC1FE          : Boolean := False;
      --  Output Compare 1 preload enable
      OC1PE          : Boolean := False;
      --  Output Compare 1 mode
      OC1M           : CCMR1_Output_OC1M_Field := 16#0#;
      --  unspecified
      Reserved_7_7   : Interfaces.STM32.Bit := 16#0#;
      --  Capture/Compare 2 selection
      CC2S           : CCMR1_Output_CC2S_Field := 16#0#;
      --  Output Compare 2 fast enable
      OC2FE          : Boolean := False;
      --  Output Compare 2 preload enable
      OC2PE          : Boolean := False;
      --  Output Compare 2 mode
      OC2M           : CCMR1_Output_OC2M_Field := 16#0#;
      --  unspecified
      Reserved_15_31 : Interfaces.STM32.UInt17 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCMR1_Output_Register_1 use record
      CC1S           at 0 range 0 .. 1;
      OC1FE          at 0 range 2 .. 2;
      OC1PE          at 0 range 3 .. 3;
      OC1M           at 0 range 4 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      CC2S           at 0 range 8 .. 9;
      OC2FE          at 0 range 10 .. 10;
      OC2PE          at 0 range 11 .. 11;
      OC2M           at 0 range 12 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   subtype CCMR1_Input_IC1F_Field_1 is Interfaces.STM32.UInt3;
   subtype CCMR1_Input_IC2F_Field_1 is Interfaces.STM32.UInt3;

   --  capture/compare mode register 1 (input mode)
   type CCMR1_Input_Register_1 is record
      --  Capture/Compare 1 selection
      CC1S           : CCMR1_Input_CC1S_Field := 16#0#;
      --  Input capture 1 prescaler
      ICPCS          : CCMR1_Input_ICPCS_Field := 16#0#;
      --  Input capture 1 filter
      IC1F           : CCMR1_Input_IC1F_Field_1 := 16#0#;
      --  unspecified
      Reserved_7_7   : Interfaces.STM32.Bit := 16#0#;
      --  Capture/Compare 2 selection
      CC2S           : CCMR1_Input_CC2S_Field := 16#0#;
      --  Input capture 2 prescaler
      IC2PCS         : CCMR1_Input_IC2PCS_Field := 16#0#;
      --  Input capture 2 filter
      IC2F           : CCMR1_Input_IC2F_Field_1 := 16#0#;
      --  unspecified
      Reserved_15_31 : Interfaces.STM32.UInt17 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCMR1_Input_Register_1 use record
      CC1S           at 0 range 0 .. 1;
      ICPCS          at 0 range 2 .. 3;
      IC1F           at 0 range 4 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      CC2S           at 0 range 8 .. 9;
      IC2PCS         at 0 range 10 .. 11;
      IC2F           at 0 range 12 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   --  capture/compare enable register
   type CCER_Register_2 is record
      --  Capture/Compare 1 output enable
      CC1E          : Boolean := False;
      --  Capture/Compare 1 output Polarity
      CC1P          : Boolean := False;
      --  unspecified
      Reserved_2_2  : Interfaces.STM32.Bit := 16#0#;
      --  Capture/Compare 1 output Polarity
      CC1NP         : Boolean := False;
      --  Capture/Compare 2 output enable
      CC2E          : Boolean := False;
      --  Capture/Compare 2 output Polarity
      CC2P          : Boolean := False;
      --  unspecified
      Reserved_6_6  : Interfaces.STM32.Bit := 16#0#;
      --  Capture/Compare 2 output Polarity
      CC2NP         : Boolean := False;
      --  unspecified
      Reserved_8_31 : Interfaces.STM32.UInt24 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCER_Register_2 use record
      CC1E          at 0 range 0 .. 0;
      CC1P          at 0 range 1 .. 1;
      Reserved_2_2  at 0 range 2 .. 2;
      CC1NP         at 0 range 3 .. 3;
      CC2E          at 0 range 4 .. 4;
      CC2P          at 0 range 5 .. 5;
      Reserved_6_6  at 0 range 6 .. 6;
      CC2NP         at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  control register 1
   type CR1_Register_3 is record
      --  Counter enable
      CEN            : Boolean := False;
      --  Update disable
      UDIS           : Boolean := False;
      --  Update request source
      URS            : Boolean := False;
      --  unspecified
      Reserved_3_6   : Interfaces.STM32.UInt4 := 16#0#;
      --  Auto-reload preload enable
      ARPE           : Boolean := False;
      --  Clock division
      CKD            : CR1_CKD_Field := 16#0#;
      --  unspecified
      Reserved_10_31 : Interfaces.STM32.UInt22 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR1_Register_3 use record
      CEN            at 0 range 0 .. 0;
      UDIS           at 0 range 1 .. 1;
      URS            at 0 range 2 .. 2;
      Reserved_3_6   at 0 range 3 .. 6;
      ARPE           at 0 range 7 .. 7;
      CKD            at 0 range 8 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   --  DMA/Interrupt enable register
   type DIER_Register_4 is record
      --  Update interrupt enable
      UIE           : Boolean := False;
      --  Capture/Compare 1 interrupt enable
      CC1IE         : Boolean := False;
      --  unspecified
      Reserved_2_31 : Interfaces.STM32.UInt30 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DIER_Register_4 use record
      UIE           at 0 range 0 .. 0;
      CC1IE         at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   --  status register
   type SR_Register_4 is record
      --  Update interrupt flag
      UIF            : Boolean := False;
      --  Capture/compare 1 interrupt flag
      CC1IF          : Boolean := False;
      --  unspecified
      Reserved_2_8   : Interfaces.STM32.UInt7 := 16#0#;
      --  Capture/Compare 1 overcapture flag
      CC1OF          : Boolean := False;
      --  unspecified
      Reserved_10_31 : Interfaces.STM32.UInt22 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SR_Register_4 use record
      UIF            at 0 range 0 .. 0;
      CC1IF          at 0 range 1 .. 1;
      Reserved_2_8   at 0 range 2 .. 8;
      CC1OF          at 0 range 9 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   --  event generation register
   type EGR_Register_4 is record
      --  Write-only. Update generation
      UG            : Boolean := False;
      --  Write-only. Capture/compare 1 generation
      CC1G          : Boolean := False;
      --  unspecified
      Reserved_2_31 : Interfaces.STM32.UInt30 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for EGR_Register_4 use record
      UG            at 0 range 0 .. 0;
      CC1G          at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   --  capture/compare mode register 1 (output mode)
   type CCMR1_Output_Register_2 is record
      --  Capture/Compare 1 selection
      CC1S          : CCMR1_Output_CC1S_Field := 16#0#;
      --  Output Compare 1 fast enable
      OC1FE         : Boolean := False;
      --  Output Compare 1 preload enable
      OC1PE         : Boolean := False;
      --  Output Compare 1 mode
      OC1M          : CCMR1_Output_OC1M_Field := 16#0#;
      --  unspecified
      Reserved_7_31 : Interfaces.STM32.UInt25 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCMR1_Output_Register_2 use record
      CC1S          at 0 range 0 .. 1;
      OC1FE         at 0 range 2 .. 2;
      OC1PE         at 0 range 3 .. 3;
      OC1M          at 0 range 4 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   --  capture/compare mode register 1 (input mode)
   type CCMR1_Input_Register_2 is record
      --  Capture/Compare 1 selection
      CC1S          : CCMR1_Input_CC1S_Field := 16#0#;
      --  Input capture 1 prescaler
      ICPCS         : CCMR1_Input_ICPCS_Field := 16#0#;
      --  Input capture 1 filter
      IC1F          : CCMR1_Input_IC1F_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : Interfaces.STM32.UInt24 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCMR1_Input_Register_2 use record
      CC1S          at 0 range 0 .. 1;
      ICPCS         at 0 range 2 .. 3;
      IC1F          at 0 range 4 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  capture/compare enable register
   type CCER_Register_3 is record
      --  Capture/Compare 1 output enable
      CC1E          : Boolean := False;
      --  Capture/Compare 1 output Polarity
      CC1P          : Boolean := False;
      --  unspecified
      Reserved_2_2  : Interfaces.STM32.Bit := 16#0#;
      --  Capture/Compare 1 output Polarity
      CC1NP         : Boolean := False;
      --  unspecified
      Reserved_4_31 : Interfaces.STM32.UInt28 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCER_Register_3 use record
      CC1E          at 0 range 0 .. 0;
      CC1P          at 0 range 1 .. 1;
      Reserved_2_2  at 0 range 2 .. 2;
      CC1NP         at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype OR_RMP_Field is Interfaces.STM32.UInt2;

   --  option register
   type OR_Register_2 is record
      --  Input 1 remapping capability
      RMP           : OR_RMP_Field := 16#0#;
      --  unspecified
      Reserved_2_31 : Interfaces.STM32.UInt30 := 16#0#;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for OR_Register_2 use record
      RMP           at 0 range 0 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   type TIM1_Disc is
     (Output,
      Input);

   --  Advanced-timers
   type TIM1_Peripheral
     (Discriminent : TIM1_Disc := Output)
   is record
      --  control register 1
      CR1          : aliased CR1_Register;
      pragma Volatile_Full_Access (CR1);
      --  control register 2
      CR2          : aliased CR2_Register;
      pragma Volatile_Full_Access (CR2);
      --  slave mode control register
      SMCR         : aliased SMCR_Register;
      pragma Volatile_Full_Access (SMCR);
      --  DMA/Interrupt enable register
      DIER         : aliased DIER_Register;
      pragma Volatile_Full_Access (DIER);
      --  status register
      SR           : aliased SR_Register;
      pragma Volatile_Full_Access (SR);
      --  event generation register
      EGR          : aliased EGR_Register;
      pragma Volatile_Full_Access (EGR);
      --  capture/compare enable register
      CCER         : aliased CCER_Register;
      pragma Volatile_Full_Access (CCER);
      --  counter
      CNT          : aliased CNT_Register;
      pragma Volatile_Full_Access (CNT);
      --  prescaler
      PSC          : aliased PSC_Register;
      pragma Volatile_Full_Access (PSC);
      --  auto-reload register
      ARR          : aliased ARR_Register;
      pragma Volatile_Full_Access (ARR);
      --  repetition counter register
      RCR          : aliased RCR_Register;
      pragma Volatile_Full_Access (RCR);
      --  capture/compare register 1
      CCR1         : aliased CCR1_Register;
      pragma Volatile_Full_Access (CCR1);
      --  capture/compare register 2
      CCR2         : aliased CCR2_Register;
      pragma Volatile_Full_Access (CCR2);
      --  capture/compare register 3
      CCR3         : aliased CCR3_Register;
      pragma Volatile_Full_Access (CCR3);
      --  capture/compare register 4
      CCR4         : aliased CCR4_Register;
      pragma Volatile_Full_Access (CCR4);
      --  break and dead-time register
      BDTR         : aliased BDTR_Register;
      pragma Volatile_Full_Access (BDTR);
      --  DMA control register
      DCR          : aliased DCR_Register;
      pragma Volatile_Full_Access (DCR);
      --  DMA address for full transfer
      DMAR         : aliased DMAR_Register;
      pragma Volatile_Full_Access (DMAR);
      case Discriminent is
         when Output =>
            --  capture/compare mode register 1 (output mode)
            CCMR1_Output : aliased CCMR1_Output_Register;
            pragma Volatile_Full_Access (CCMR1_Output);
            --  capture/compare mode register 2 (output mode)
            CCMR2_Output : aliased CCMR2_Output_Register;
            pragma Volatile_Full_Access (CCMR2_Output);
         when Input =>
            --  capture/compare mode register 1 (input mode)
            CCMR1_Input : aliased CCMR1_Input_Register;
            pragma Volatile_Full_Access (CCMR1_Input);
            --  capture/compare mode register 2 (input mode)
            CCMR2_Input : aliased CCMR2_Input_Register;
            pragma Volatile_Full_Access (CCMR2_Input);
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TIM1_Peripheral use record
      CR1          at 16#0# range 0 .. 31;
      CR2          at 16#4# range 0 .. 31;
      SMCR         at 16#8# range 0 .. 31;
      DIER         at 16#C# range 0 .. 31;
      SR           at 16#10# range 0 .. 31;
      EGR          at 16#14# range 0 .. 31;
      CCER         at 16#20# range 0 .. 31;
      CNT          at 16#24# range 0 .. 31;
      PSC          at 16#28# range 0 .. 31;
      ARR          at 16#2C# range 0 .. 31;
      RCR          at 16#30# range 0 .. 31;
      CCR1         at 16#34# range 0 .. 31;
      CCR2         at 16#38# range 0 .. 31;
      CCR3         at 16#3C# range 0 .. 31;
      CCR4         at 16#40# range 0 .. 31;
      BDTR         at 16#44# range 0 .. 31;
      DCR          at 16#48# range 0 .. 31;
      DMAR         at 16#4C# range 0 .. 31;
      CCMR1_Output at 16#18# range 0 .. 31;
      CCMR2_Output at 16#1C# range 0 .. 31;
      CCMR1_Input  at 16#18# range 0 .. 31;
      CCMR2_Input  at 16#1C# range 0 .. 31;
   end record;

   --  Advanced-timers
   TIM1_Periph : aliased TIM1_Peripheral
     with Import, Address => TIM1_Base;

   --  Advanced-timers
   TIM8_Periph : aliased TIM1_Peripheral
     with Import, Address => TIM8_Base;

   type TIM2_Disc is
     (Output,
      Input);

   --  General purpose timers
   type TIM2_Peripheral
     (Discriminent : TIM2_Disc := Output)
   is record
      --  control register 1
      CR1          : aliased CR1_Register;
      pragma Volatile_Full_Access (CR1);
      --  control register 2
      CR2          : aliased CR2_Register_1;
      pragma Volatile_Full_Access (CR2);
      --  slave mode control register
      SMCR         : aliased SMCR_Register;
      pragma Volatile_Full_Access (SMCR);
      --  DMA/Interrupt enable register
      DIER         : aliased DIER_Register_1;
      pragma Volatile_Full_Access (DIER);
      --  status register
      SR           : aliased SR_Register_1;
      pragma Volatile_Full_Access (SR);
      --  event generation register
      EGR          : aliased EGR_Register_1;
      pragma Volatile_Full_Access (EGR);
      --  capture/compare enable register
      CCER         : aliased CCER_Register_1;
      pragma Volatile_Full_Access (CCER);
      --  counter
      CNT          : aliased CNT_Register_1;
      pragma Volatile_Full_Access (CNT);
      --  prescaler
      PSC          : aliased PSC_Register;
      pragma Volatile_Full_Access (PSC);
      --  auto-reload register
      ARR          : aliased ARR_Register_1;
      pragma Volatile_Full_Access (ARR);
      --  capture/compare register 1
      CCR1         : aliased CCR1_Register_1;
      pragma Volatile_Full_Access (CCR1);
      --  capture/compare register 2
      CCR2         : aliased CCR2_Register_1;
      pragma Volatile_Full_Access (CCR2);
      --  capture/compare register 3
      CCR3         : aliased CCR3_Register_1;
      pragma Volatile_Full_Access (CCR3);
      --  capture/compare register 4
      CCR4         : aliased CCR4_Register_1;
      pragma Volatile_Full_Access (CCR4);
      --  DMA control register
      DCR          : aliased DCR_Register;
      pragma Volatile_Full_Access (DCR);
      --  DMA address for full transfer
      DMAR         : aliased DMAR_Register;
      pragma Volatile_Full_Access (DMAR);
      --  TIM5 option register
      OR_k         : aliased OR_Register;
      pragma Volatile_Full_Access (OR_k);
      case Discriminent is
         when Output =>
            --  capture/compare mode register 1 (output mode)
            CCMR1_Output : aliased CCMR1_Output_Register;
            pragma Volatile_Full_Access (CCMR1_Output);
            --  capture/compare mode register 2 (output mode)
            CCMR2_Output : aliased CCMR2_Output_Register_1;
            pragma Volatile_Full_Access (CCMR2_Output);
         when Input =>
            --  capture/compare mode register 1 (input mode)
            CCMR1_Input : aliased CCMR1_Input_Register;
            pragma Volatile_Full_Access (CCMR1_Input);
            --  capture/compare mode register 2 (input mode)
            CCMR2_Input : aliased CCMR2_Input_Register;
            pragma Volatile_Full_Access (CCMR2_Input);
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TIM2_Peripheral use record
      CR1          at 16#0# range 0 .. 31;
      CR2          at 16#4# range 0 .. 31;
      SMCR         at 16#8# range 0 .. 31;
      DIER         at 16#C# range 0 .. 31;
      SR           at 16#10# range 0 .. 31;
      EGR          at 16#14# range 0 .. 31;
      CCER         at 16#20# range 0 .. 31;
      CNT          at 16#24# range 0 .. 31;
      PSC          at 16#28# range 0 .. 31;
      ARR          at 16#2C# range 0 .. 31;
      CCR1         at 16#34# range 0 .. 31;
      CCR2         at 16#38# range 0 .. 31;
      CCR3         at 16#3C# range 0 .. 31;
      CCR4         at 16#40# range 0 .. 31;
      DCR          at 16#48# range 0 .. 31;
      DMAR         at 16#4C# range 0 .. 31;
      OR_k         at 16#50# range 0 .. 31;
      CCMR1_Output at 16#18# range 0 .. 31;
      CCMR2_Output at 16#1C# range 0 .. 31;
      CCMR1_Input  at 16#18# range 0 .. 31;
      CCMR2_Input  at 16#1C# range 0 .. 31;
   end record;

   --  General purpose timers
   TIM2_Periph : aliased TIM2_Peripheral
     with Import, Address => TIM2_Base;

   type TIM3_Disc is
     (Output,
      Input);

   --  General purpose timers
   type TIM3_Peripheral
     (Discriminent : TIM3_Disc := Output)
   is record
      --  control register 1
      CR1          : aliased CR1_Register;
      pragma Volatile_Full_Access (CR1);
      --  control register 2
      CR2          : aliased CR2_Register_1;
      pragma Volatile_Full_Access (CR2);
      --  slave mode control register
      SMCR         : aliased SMCR_Register;
      pragma Volatile_Full_Access (SMCR);
      --  DMA/Interrupt enable register
      DIER         : aliased DIER_Register_1;
      pragma Volatile_Full_Access (DIER);
      --  status register
      SR           : aliased SR_Register_1;
      pragma Volatile_Full_Access (SR);
      --  event generation register
      EGR          : aliased EGR_Register_1;
      pragma Volatile_Full_Access (EGR);
      --  capture/compare enable register
      CCER         : aliased CCER_Register_1;
      pragma Volatile_Full_Access (CCER);
      --  counter
      CNT          : aliased CNT_Register_1;
      pragma Volatile_Full_Access (CNT);
      --  prescaler
      PSC          : aliased PSC_Register;
      pragma Volatile_Full_Access (PSC);
      --  auto-reload register
      ARR          : aliased ARR_Register_1;
      pragma Volatile_Full_Access (ARR);
      --  capture/compare register 1
      CCR1         : aliased CCR1_Register_1;
      pragma Volatile_Full_Access (CCR1);
      --  capture/compare register 2
      CCR2         : aliased CCR2_Register_1;
      pragma Volatile_Full_Access (CCR2);
      --  capture/compare register 3
      CCR3         : aliased CCR3_Register_1;
      pragma Volatile_Full_Access (CCR3);
      --  capture/compare register 4
      CCR4         : aliased CCR4_Register_1;
      pragma Volatile_Full_Access (CCR4);
      --  DMA control register
      DCR          : aliased DCR_Register;
      pragma Volatile_Full_Access (DCR);
      --  DMA address for full transfer
      DMAR         : aliased DMAR_Register;
      pragma Volatile_Full_Access (DMAR);
      case Discriminent is
         when Output =>
            --  capture/compare mode register 1 (output mode)
            CCMR1_Output : aliased CCMR1_Output_Register;
            pragma Volatile_Full_Access (CCMR1_Output);
            --  capture/compare mode register 2 (output mode)
            CCMR2_Output : aliased CCMR2_Output_Register_1;
            pragma Volatile_Full_Access (CCMR2_Output);
         when Input =>
            --  capture/compare mode register 1 (input mode)
            CCMR1_Input : aliased CCMR1_Input_Register;
            pragma Volatile_Full_Access (CCMR1_Input);
            --  capture/compare mode register 2 (input mode)
            CCMR2_Input : aliased CCMR2_Input_Register;
            pragma Volatile_Full_Access (CCMR2_Input);
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TIM3_Peripheral use record
      CR1          at 16#0# range 0 .. 31;
      CR2          at 16#4# range 0 .. 31;
      SMCR         at 16#8# range 0 .. 31;
      DIER         at 16#C# range 0 .. 31;
      SR           at 16#10# range 0 .. 31;
      EGR          at 16#14# range 0 .. 31;
      CCER         at 16#20# range 0 .. 31;
      CNT          at 16#24# range 0 .. 31;
      PSC          at 16#28# range 0 .. 31;
      ARR          at 16#2C# range 0 .. 31;
      CCR1         at 16#34# range 0 .. 31;
      CCR2         at 16#38# range 0 .. 31;
      CCR3         at 16#3C# range 0 .. 31;
      CCR4         at 16#40# range 0 .. 31;
      DCR          at 16#48# range 0 .. 31;
      DMAR         at 16#4C# range 0 .. 31;
      CCMR1_Output at 16#18# range 0 .. 31;
      CCMR2_Output at 16#1C# range 0 .. 31;
      CCMR1_Input  at 16#18# range 0 .. 31;
      CCMR2_Input  at 16#1C# range 0 .. 31;
   end record;

   --  General purpose timers
   TIM3_Periph : aliased TIM3_Peripheral
     with Import, Address => TIM3_Base;

   --  General purpose timers
   TIM4_Periph : aliased TIM3_Peripheral
     with Import, Address => TIM4_Base;

   type TIM5_Disc is
     (Output,
      Input);

   --  General-purpose-timers
   type TIM5_Peripheral
     (Discriminent : TIM5_Disc := Output)
   is record
      --  control register 1
      CR1          : aliased CR1_Register;
      pragma Volatile_Full_Access (CR1);
      --  control register 2
      CR2          : aliased CR2_Register_1;
      pragma Volatile_Full_Access (CR2);
      --  slave mode control register
      SMCR         : aliased SMCR_Register;
      pragma Volatile_Full_Access (SMCR);
      --  DMA/Interrupt enable register
      DIER         : aliased DIER_Register_1;
      pragma Volatile_Full_Access (DIER);
      --  status register
      SR           : aliased SR_Register_1;
      pragma Volatile_Full_Access (SR);
      --  event generation register
      EGR          : aliased EGR_Register_1;
      pragma Volatile_Full_Access (EGR);
      --  capture/compare enable register
      CCER         : aliased CCER_Register_1;
      pragma Volatile_Full_Access (CCER);
      --  counter
      CNT          : aliased CNT_Register_1;
      pragma Volatile_Full_Access (CNT);
      --  prescaler
      PSC          : aliased PSC_Register;
      pragma Volatile_Full_Access (PSC);
      --  auto-reload register
      ARR          : aliased ARR_Register_1;
      pragma Volatile_Full_Access (ARR);
      --  capture/compare register 1
      CCR1         : aliased CCR1_Register_1;
      pragma Volatile_Full_Access (CCR1);
      --  capture/compare register 2
      CCR2         : aliased CCR2_Register_1;
      pragma Volatile_Full_Access (CCR2);
      --  capture/compare register 3
      CCR3         : aliased CCR3_Register_1;
      pragma Volatile_Full_Access (CCR3);
      --  capture/compare register 4
      CCR4         : aliased CCR4_Register_1;
      pragma Volatile_Full_Access (CCR4);
      --  DMA control register
      DCR          : aliased DCR_Register;
      pragma Volatile_Full_Access (DCR);
      --  DMA address for full transfer
      DMAR         : aliased DMAR_Register;
      pragma Volatile_Full_Access (DMAR);
      --  TIM5 option register
      OR_k         : aliased OR_Register_1;
      pragma Volatile_Full_Access (OR_k);
      case Discriminent is
         when Output =>
            --  capture/compare mode register 1 (output mode)
            CCMR1_Output : aliased CCMR1_Output_Register;
            pragma Volatile_Full_Access (CCMR1_Output);
            --  capture/compare mode register 2 (output mode)
            CCMR2_Output : aliased CCMR2_Output_Register_1;
            pragma Volatile_Full_Access (CCMR2_Output);
         when Input =>
            --  capture/compare mode register 1 (input mode)
            CCMR1_Input : aliased CCMR1_Input_Register;
            pragma Volatile_Full_Access (CCMR1_Input);
            --  capture/compare mode register 2 (input mode)
            CCMR2_Input : aliased CCMR2_Input_Register;
            pragma Volatile_Full_Access (CCMR2_Input);
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TIM5_Peripheral use record
      CR1          at 16#0# range 0 .. 31;
      CR2          at 16#4# range 0 .. 31;
      SMCR         at 16#8# range 0 .. 31;
      DIER         at 16#C# range 0 .. 31;
      SR           at 16#10# range 0 .. 31;
      EGR          at 16#14# range 0 .. 31;
      CCER         at 16#20# range 0 .. 31;
      CNT          at 16#24# range 0 .. 31;
      PSC          at 16#28# range 0 .. 31;
      ARR          at 16#2C# range 0 .. 31;
      CCR1         at 16#34# range 0 .. 31;
      CCR2         at 16#38# range 0 .. 31;
      CCR3         at 16#3C# range 0 .. 31;
      CCR4         at 16#40# range 0 .. 31;
      DCR          at 16#48# range 0 .. 31;
      DMAR         at 16#4C# range 0 .. 31;
      OR_k         at 16#50# range 0 .. 31;
      CCMR1_Output at 16#18# range 0 .. 31;
      CCMR2_Output at 16#1C# range 0 .. 31;
      CCMR1_Input  at 16#18# range 0 .. 31;
      CCMR2_Input  at 16#1C# range 0 .. 31;
   end record;

   --  General-purpose-timers
   TIM5_Periph : aliased TIM5_Peripheral
     with Import, Address => TIM5_Base;

   --  Basic timers
   type TIM6_Peripheral is record
      --  control register 1
      CR1  : aliased CR1_Register_1;
      pragma Volatile_Full_Access (CR1);
      --  control register 2
      CR2  : aliased CR2_Register_2;
      pragma Volatile_Full_Access (CR2);
      --  DMA/Interrupt enable register
      DIER : aliased DIER_Register_2;
      pragma Volatile_Full_Access (DIER);
      --  status register
      SR   : aliased SR_Register_2;
      pragma Volatile_Full_Access (SR);
      --  event generation register
      EGR  : aliased EGR_Register_2;
      pragma Volatile_Full_Access (EGR);
      --  counter
      CNT  : aliased CNT_Register;
      pragma Volatile_Full_Access (CNT);
      --  prescaler
      PSC  : aliased PSC_Register;
      pragma Volatile_Full_Access (PSC);
      --  auto-reload register
      ARR  : aliased ARR_Register;
      pragma Volatile_Full_Access (ARR);
   end record
     with Volatile;

   for TIM6_Peripheral use record
      CR1  at 16#0# range 0 .. 31;
      CR2  at 16#4# range 0 .. 31;
      DIER at 16#C# range 0 .. 31;
      SR   at 16#10# range 0 .. 31;
      EGR  at 16#14# range 0 .. 31;
      CNT  at 16#24# range 0 .. 31;
      PSC  at 16#28# range 0 .. 31;
      ARR  at 16#2C# range 0 .. 31;
   end record;

   --  Basic timers
   TIM6_Periph : aliased TIM6_Peripheral
     with Import, Address => TIM6_Base;

   --  Basic timers
   TIM7_Periph : aliased TIM6_Peripheral
     with Import, Address => TIM7_Base;

   type TIM9_Disc is
     (Output,
      Input);

   --  General purpose timers
   type TIM9_Peripheral
     (Discriminent : TIM9_Disc := Output)
   is record
      --  control register 1
      CR1          : aliased CR1_Register_2;
      pragma Volatile_Full_Access (CR1);
      --  control register 2
      CR2          : aliased CR2_Register_2;
      pragma Volatile_Full_Access (CR2);
      --  slave mode control register
      SMCR         : aliased SMCR_Register_1;
      pragma Volatile_Full_Access (SMCR);
      --  DMA/Interrupt enable register
      DIER         : aliased DIER_Register_3;
      pragma Volatile_Full_Access (DIER);
      --  status register
      SR           : aliased SR_Register_3;
      pragma Volatile_Full_Access (SR);
      --  event generation register
      EGR          : aliased EGR_Register_3;
      pragma Volatile_Full_Access (EGR);
      --  capture/compare enable register
      CCER         : aliased CCER_Register_2;
      pragma Volatile_Full_Access (CCER);
      --  counter
      CNT          : aliased CNT_Register;
      pragma Volatile_Full_Access (CNT);
      --  prescaler
      PSC          : aliased PSC_Register;
      pragma Volatile_Full_Access (PSC);
      --  auto-reload register
      ARR          : aliased ARR_Register;
      pragma Volatile_Full_Access (ARR);
      --  capture/compare register 1
      CCR1         : aliased CCR1_Register;
      pragma Volatile_Full_Access (CCR1);
      --  capture/compare register 2
      CCR2         : aliased CCR2_Register;
      pragma Volatile_Full_Access (CCR2);
      case Discriminent is
         when Output =>
            --  capture/compare mode register 1 (output mode)
            CCMR1_Output : aliased CCMR1_Output_Register_1;
            pragma Volatile_Full_Access (CCMR1_Output);
         when Input =>
            --  capture/compare mode register 1 (input mode)
            CCMR1_Input : aliased CCMR1_Input_Register_1;
            pragma Volatile_Full_Access (CCMR1_Input);
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TIM9_Peripheral use record
      CR1          at 16#0# range 0 .. 31;
      CR2          at 16#4# range 0 .. 31;
      SMCR         at 16#8# range 0 .. 31;
      DIER         at 16#C# range 0 .. 31;
      SR           at 16#10# range 0 .. 31;
      EGR          at 16#14# range 0 .. 31;
      CCER         at 16#20# range 0 .. 31;
      CNT          at 16#24# range 0 .. 31;
      PSC          at 16#28# range 0 .. 31;
      ARR          at 16#2C# range 0 .. 31;
      CCR1         at 16#34# range 0 .. 31;
      CCR2         at 16#38# range 0 .. 31;
      CCMR1_Output at 16#18# range 0 .. 31;
      CCMR1_Input  at 16#18# range 0 .. 31;
   end record;

   --  General purpose timers
   TIM9_Periph : aliased TIM9_Peripheral
     with Import, Address => TIM9_Base;

   --  General purpose timers
   TIM12_Periph : aliased TIM9_Peripheral
     with Import, Address => TIM12_Base;

   type TIM10_Disc is
     (Output,
      Input);

   --  General-purpose-timers
   type TIM10_Peripheral
     (Discriminent : TIM10_Disc := Output)
   is record
      --  control register 1
      CR1          : aliased CR1_Register_3;
      pragma Volatile_Full_Access (CR1);
      --  DMA/Interrupt enable register
      DIER         : aliased DIER_Register_4;
      pragma Volatile_Full_Access (DIER);
      --  status register
      SR           : aliased SR_Register_4;
      pragma Volatile_Full_Access (SR);
      --  event generation register
      EGR          : aliased EGR_Register_4;
      pragma Volatile_Full_Access (EGR);
      --  capture/compare enable register
      CCER         : aliased CCER_Register_3;
      pragma Volatile_Full_Access (CCER);
      --  counter
      CNT          : aliased CNT_Register;
      pragma Volatile_Full_Access (CNT);
      --  prescaler
      PSC          : aliased PSC_Register;
      pragma Volatile_Full_Access (PSC);
      --  auto-reload register
      ARR          : aliased ARR_Register;
      pragma Volatile_Full_Access (ARR);
      --  capture/compare register 1
      CCR1         : aliased CCR1_Register;
      pragma Volatile_Full_Access (CCR1);
      case Discriminent is
         when Output =>
            --  capture/compare mode register 1 (output mode)
            CCMR1_Output : aliased CCMR1_Output_Register_2;
            pragma Volatile_Full_Access (CCMR1_Output);
         when Input =>
            --  capture/compare mode register 1 (input mode)
            CCMR1_Input : aliased CCMR1_Input_Register_2;
            pragma Volatile_Full_Access (CCMR1_Input);
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TIM10_Peripheral use record
      CR1          at 16#0# range 0 .. 31;
      DIER         at 16#C# range 0 .. 31;
      SR           at 16#10# range 0 .. 31;
      EGR          at 16#14# range 0 .. 31;
      CCER         at 16#20# range 0 .. 31;
      CNT          at 16#24# range 0 .. 31;
      PSC          at 16#28# range 0 .. 31;
      ARR          at 16#2C# range 0 .. 31;
      CCR1         at 16#34# range 0 .. 31;
      CCMR1_Output at 16#18# range 0 .. 31;
      CCMR1_Input  at 16#18# range 0 .. 31;
   end record;

   --  General-purpose-timers
   TIM10_Periph : aliased TIM10_Peripheral
     with Import, Address => TIM10_Base;

   --  General-purpose-timers
   TIM13_Periph : aliased TIM10_Peripheral
     with Import, Address => TIM13_Base;

   --  General-purpose-timers
   TIM14_Periph : aliased TIM10_Peripheral
     with Import, Address => TIM14_Base;

   type TIM11_Disc is
     (Output,
      Input);

   --  General-purpose-timers
   type TIM11_Peripheral
     (Discriminent : TIM11_Disc := Output)
   is record
      --  control register 1
      CR1          : aliased CR1_Register_3;
      pragma Volatile_Full_Access (CR1);
      --  DMA/Interrupt enable register
      DIER         : aliased DIER_Register_4;
      pragma Volatile_Full_Access (DIER);
      --  status register
      SR           : aliased SR_Register_4;
      pragma Volatile_Full_Access (SR);
      --  event generation register
      EGR          : aliased EGR_Register_4;
      pragma Volatile_Full_Access (EGR);
      --  capture/compare enable register
      CCER         : aliased CCER_Register_3;
      pragma Volatile_Full_Access (CCER);
      --  counter
      CNT          : aliased CNT_Register;
      pragma Volatile_Full_Access (CNT);
      --  prescaler
      PSC          : aliased PSC_Register;
      pragma Volatile_Full_Access (PSC);
      --  auto-reload register
      ARR          : aliased ARR_Register;
      pragma Volatile_Full_Access (ARR);
      --  capture/compare register 1
      CCR1         : aliased CCR1_Register;
      pragma Volatile_Full_Access (CCR1);
      --  option register
      OR_k         : aliased OR_Register_2;
      pragma Volatile_Full_Access (OR_k);
      case Discriminent is
         when Output =>
            --  capture/compare mode register 1 (output mode)
            CCMR1_Output : aliased CCMR1_Output_Register_2;
            pragma Volatile_Full_Access (CCMR1_Output);
         when Input =>
            --  capture/compare mode register 1 (input mode)
            CCMR1_Input : aliased CCMR1_Input_Register_2;
            pragma Volatile_Full_Access (CCMR1_Input);
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TIM11_Peripheral use record
      CR1          at 16#0# range 0 .. 31;
      DIER         at 16#C# range 0 .. 31;
      SR           at 16#10# range 0 .. 31;
      EGR          at 16#14# range 0 .. 31;
      CCER         at 16#20# range 0 .. 31;
      CNT          at 16#24# range 0 .. 31;
      PSC          at 16#28# range 0 .. 31;
      ARR          at 16#2C# range 0 .. 31;
      CCR1         at 16#34# range 0 .. 31;
      OR_k         at 16#50# range 0 .. 31;
      CCMR1_Output at 16#18# range 0 .. 31;
      CCMR1_Input  at 16#18# range 0 .. 31;
   end record;

   --  General-purpose-timers
   TIM11_Periph : aliased TIM11_Peripheral
     with Import, Address => TIM11_Base;

end Interfaces.STM32.TIM;
