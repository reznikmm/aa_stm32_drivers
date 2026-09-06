
--  This spec has been automatically generated from STM32F411.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.ADC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------
   
   type CSR_ADC is record
      AWD      : Boolean;
      --   Analog watchdog flag of ADC 1
      EOC      : Boolean;
      --   End of conversion of ADC 1
      JEOC     : Boolean;
      --   Injected channel end of conversion of ADC 1
      JSTRT    : Boolean;
      --   Injected channel Start flag of ADC 1
      STRT     : Boolean;
      --   Regular channel Start flag of ADC 1
      OVR      : Boolean;
      --   Overrun flag of ADC 1
      Reserved : Interfaces.Unsigned_32 range 0 .. 3 := 0;
   end record
     with Bit_Order => System.Low_Order_First;

   for CSR_ADC use record
      AWD      at 0 range 0 .. 0;
      EOC      at 0 range 1 .. 1;
      JEOC     at 0 range 2 .. 2;
      JSTRT    at 0 range 3 .. 3;
      STRT     at 0 range 4 .. 4;
      OVR      at 0 range 5 .. 5;
      Reserved at 0 range 6 .. 7;
   end record;
   
   type CSR_ADC_Array is array (1 .. 3) of CSR_ADC
   with Component_Size => 8;
   
   type CSR_Register is record
      ADC            : CSR_ADC_Array;
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   ADC Common status register
   --  Access: read-only
   --  Reset value: 0x00000000
   
   for CSR_Register use record
      ADC            at 0 range 0 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;
   
   type CCR_Register is record
      Reserved_0_7   : Interfaces.Unsigned_32 range 0 .. 255 := 0;
      A_DELAY        : Interfaces.Unsigned_32 range 0 .. 15;
      --   Delay between 2 sampling phases
      Reserved_12_12 : Boolean := False;
      DDS            : Boolean;
      --   DMA disable selection for multi-ADC mode
      DMA            : Interfaces.Unsigned_32 range 0 .. 3;
      --   Direct memory access mode for multi ADC mode
      ADCPRE         : Interfaces.Unsigned_32 range 0 .. 3;
      --   ADC prescaler
      Reserved_18_21 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      VBATE          : Boolean;
      --   VBAT enable
      TSVREFE        : Boolean;
      --   Temperature sensor and VREFINT enable
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   ADC common control register
   --  Access: read-write
   --  Reset value: 0x00000000
   
   for CCR_Register use record
      Reserved_0_7   at 0 range 0 .. 7;
      A_DELAY        at 0 range 8 .. 11;
      Reserved_12_12 at 0 range 12 .. 12;
      DDS            at 0 range 13 .. 13;
      DMA            at 0 range 14 .. 15;
      ADCPRE         at 0 range 16 .. 17;
      Reserved_18_21 at 0 range 18 .. 21;
      VBATE          at 0 range 22 .. 22;
      TSVREFE        at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;
   
   type SR_Register is record
      AWD           : Boolean;
      --   Analog watchdog flag
      EOC           : Boolean;
      --   Regular channel end of conversion
      JEOC          : Boolean;
      --   Injected channel end of conversion
      JSTRT         : Boolean;
      --   Injected channel start flag
      STRT          : Boolean;
      --   Regular channel start flag
      OVR           : Boolean;
      --   Overrun
      Reserved_6_31 : Interfaces.Unsigned_32 range 0 .. 67108863 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   status register
   --  Access: read-write
   --  Reset value: 0x00000000
   
   for SR_Register use record
      AWD           at 0 range 0 .. 0;
      EOC           at 0 range 1 .. 1;
      JEOC          at 0 range 2 .. 2;
      JSTRT         at 0 range 3 .. 3;
      STRT          at 0 range 4 .. 4;
      OVR           at 0 range 5 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;
   
   type CR1_Register is record
      AWDCH          : Interfaces.Unsigned_32 range 0 .. 31;
      --   Analog watchdog channel select bits
      EOCIE          : Boolean;
      --   Interrupt enable for EOC
      AWDIE          : Boolean;
      --   Analog watchdog interrupt enable
      JEOCIE         : Boolean;
      --   Interrupt enable for injected channels
      SCAN           : Boolean;
      --   Scan mode
      AWDSGL         : Boolean;
      --   Enable the watchdog on a single channel in scan mode
      JAUTO          : Boolean;
      --   Automatic injected group conversion
      DISCEN         : Boolean;
      --   Discontinuous mode on regular channels
      JDISCEN        : Boolean;
      --   Discontinuous mode on injected channels
      DISCNUM        : Interfaces.Unsigned_32 range 0 .. 7;
      --   Discontinuous mode channel count
      Reserved_16_21 : Interfaces.Unsigned_32 range 0 .. 63 := 0;
      JAWDEN         : Boolean;
      --   Analog watchdog enable on injected channels
      AWDEN          : Boolean;
      --   Analog watchdog enable on regular channels
      RES            : Interfaces.Unsigned_32 range 0 .. 3;
      --   Resolution
      OVRIE          : Boolean;
      --   Overrun interrupt enable
      Reserved_27_31 : Interfaces.Unsigned_32 range 0 .. 31 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   control register 1
   --  Access: read-write
   --  Reset value: 0x00000000
   
   for CR1_Register use record
      AWDCH          at 0 range 0 .. 4;
      EOCIE          at 0 range 5 .. 5;
      AWDIE          at 0 range 6 .. 6;
      JEOCIE         at 0 range 7 .. 7;
      SCAN           at 0 range 8 .. 8;
      AWDSGL         at 0 range 9 .. 9;
      JAUTO          at 0 range 10 .. 10;
      DISCEN         at 0 range 11 .. 11;
      JDISCEN        at 0 range 12 .. 12;
      DISCNUM        at 0 range 13 .. 15;
      Reserved_16_21 at 0 range 16 .. 21;
      JAWDEN         at 0 range 22 .. 22;
      AWDEN          at 0 range 23 .. 23;
      RES            at 0 range 24 .. 25;
      OVRIE          at 0 range 26 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;
   
   type CR2_Register is record
      ADON           : Boolean;
      --   A/D Converter ON / OFF
      CONT           : Boolean;
      --   Continuous conversion
      Reserved_2_7   : Interfaces.Unsigned_32 range 0 .. 63 := 0;
      DMA            : Boolean;
      --   Direct memory access mode (for single ADC mode)
      DDS            : Boolean;
      --   DMA disable selection (for single ADC mode)
      EOCS           : Boolean;
      --   End of conversion selection
      ALIGN          : Boolean;
      --   Data alignment
      Reserved_12_15 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      JEXTSEL        : Interfaces.Unsigned_32 range 0 .. 15;
      --   External event select for injected group
      JEXTEN         : Interfaces.Unsigned_32 range 0 .. 3;
      --   External trigger enable for injected channels
      JSWSTART       : Boolean;
      --   Start conversion of injected channels
      Reserved_23_23 : Boolean := False;
      EXTSEL         : Interfaces.Unsigned_32 range 0 .. 15;
      --   External event select for regular group
      EXTEN          : Interfaces.Unsigned_32 range 0 .. 3;
      --   External trigger enable for regular channels
      SWSTART        : Boolean;
      --   Start conversion of regular channels
      Reserved_31_31 : Boolean := False;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   control register 2
   --  Access: read-write
   --  Reset value: 0x00000000
   
   for CR2_Register use record
      ADON           at 0 range 0 .. 0;
      CONT           at 0 range 1 .. 1;
      Reserved_2_7   at 0 range 2 .. 7;
      DMA            at 0 range 8 .. 8;
      DDS            at 0 range 9 .. 9;
      EOCS           at 0 range 10 .. 10;
      ALIGN          at 0 range 11 .. 11;
      Reserved_12_15 at 0 range 12 .. 15;
      JEXTSEL        at 0 range 16 .. 19;
      JEXTEN         at 0 range 20 .. 21;
      JSWSTART       at 0 range 22 .. 22;
      Reserved_23_23 at 0 range 23 .. 23;
      EXTSEL         at 0 range 24 .. 27;
      EXTEN          at 0 range 28 .. 29;
      SWSTART        at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;
   
   type JOFR_Register is record
      JOFFSET1       : Interfaces.Unsigned_32 range 0 .. 4095;
      --   Data offset for injected channel x
      Reserved_12_31 : Interfaces.Unsigned_32 range 0 .. 1048575 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   injected channel data offset register x
   --  Access: read-write
   --  Reset value: 0x00000000
   
   for JOFR_Register use record
      JOFFSET1       at 0 range 0 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;
   
   type HTR_Register is record
      HT             : Interfaces.Unsigned_32 range 0 .. 4095;
      --   Analog watchdog higher threshold
      Reserved_12_31 : Interfaces.Unsigned_32 range 0 .. 1048575 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   watchdog higher threshold register
   --  Access: read-write
   --  Reset value: 0x00000FFF
   
   for HTR_Register use record
      HT             at 0 range 0 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;
   
   type LTR_Register is record
      LT             : Interfaces.Unsigned_32 range 0 .. 4095;
      --   Analog watchdog lower threshold
      Reserved_12_31 : Interfaces.Unsigned_32 range 0 .. 1048575 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   watchdog lower threshold register
   --  Access: read-write
   --  Reset value: 0x00000000
   
   for LTR_Register use record
      LT             at 0 range 0 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;
   
   type SQR1_Register is record
      SQ13           : Interfaces.Unsigned_32 range 0 .. 31;
      --   13th conversion in regular sequence
      SQ14           : Interfaces.Unsigned_32 range 0 .. 31;
      --   14th conversion in regular sequence
      SQ15           : Interfaces.Unsigned_32 range 0 .. 31;
      --   15th conversion in regular sequence
      SQ16           : Interfaces.Unsigned_32 range 0 .. 31;
      --   16th conversion in regular sequence
      L              : Interfaces.Unsigned_32 range 0 .. 15;
      --   Regular channel sequence length
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   regular sequence register 1
   --  Access: read-write
   --  Reset value: 0x00000000
   
   for SQR1_Register use record
      SQ13           at 0 range 0 .. 4;
      SQ14           at 0 range 5 .. 9;
      SQ15           at 0 range 10 .. 14;
      SQ16           at 0 range 15 .. 19;
      L              at 0 range 20 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;
   
   type SQR2_Register is record
      SQ7            : Interfaces.Unsigned_32 range 0 .. 31;
      --   7th conversion in regular sequence
      SQ8            : Interfaces.Unsigned_32 range 0 .. 31;
      --   8th conversion in regular sequence
      SQ9            : Interfaces.Unsigned_32 range 0 .. 31;
      --   9th conversion in regular sequence
      SQ10           : Interfaces.Unsigned_32 range 0 .. 31;
      --   10th conversion in regular sequence
      SQ11           : Interfaces.Unsigned_32 range 0 .. 31;
      --   11th conversion in regular sequence
      SQ12           : Interfaces.Unsigned_32 range 0 .. 31;
      --   12th conversion in regular sequence
      Reserved_30_31 : Interfaces.Unsigned_32 range 0 .. 3 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   regular sequence register 2
   --  Access: read-write
   --  Reset value: 0x00000000
   
   for SQR2_Register use record
      SQ7            at 0 range 0 .. 4;
      SQ8            at 0 range 5 .. 9;
      SQ9            at 0 range 10 .. 14;
      SQ10           at 0 range 15 .. 19;
      SQ11           at 0 range 20 .. 24;
      SQ12           at 0 range 25 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;
   
   type SQR3_Register is record
      SQ1            : Interfaces.Unsigned_32 range 0 .. 31;
      --   1st conversion in regular sequence
      SQ2            : Interfaces.Unsigned_32 range 0 .. 31;
      --   2nd conversion in regular sequence
      SQ3            : Interfaces.Unsigned_32 range 0 .. 31;
      --   3rd conversion in regular sequence
      SQ4            : Interfaces.Unsigned_32 range 0 .. 31;
      --   4th conversion in regular sequence
      SQ5            : Interfaces.Unsigned_32 range 0 .. 31;
      --   5th conversion in regular sequence
      SQ6            : Interfaces.Unsigned_32 range 0 .. 31;
      --   6th conversion in regular sequence
      Reserved_30_31 : Interfaces.Unsigned_32 range 0 .. 3 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   regular sequence register 3
   --  Access: read-write
   --  Reset value: 0x00000000
   
   for SQR3_Register use record
      SQ1            at 0 range 0 .. 4;
      SQ2            at 0 range 5 .. 9;
      SQ3            at 0 range 10 .. 14;
      SQ4            at 0 range 15 .. 19;
      SQ5            at 0 range 20 .. 24;
      SQ6            at 0 range 25 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;
   
   type JSQR_Register is record
      JSQ1           : Interfaces.Unsigned_32 range 0 .. 31;
      --   1st conversion in injected sequence
      JSQ2           : Interfaces.Unsigned_32 range 0 .. 31;
      --   2nd conversion in injected sequence
      JSQ3           : Interfaces.Unsigned_32 range 0 .. 31;
      --   3rd conversion in injected sequence
      JSQ4           : Interfaces.Unsigned_32 range 0 .. 31;
      --   4th conversion in injected sequence
      JL             : Interfaces.Unsigned_32 range 0 .. 3;
      --   Injected sequence length
      Reserved_22_31 : Interfaces.Unsigned_32 range 0 .. 1023 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   injected sequence register
   --  Access: read-write
   --  Reset value: 0x00000000
   
   for JSQR_Register use record
      JSQ1           at 0 range 0 .. 4;
      JSQ2           at 0 range 5 .. 9;
      JSQ3           at 0 range 10 .. 14;
      JSQ4           at 0 range 15 .. 19;
      JL             at 0 range 20 .. 21;
      Reserved_22_31 at 0 range 22 .. 31;
   end record;
   
   type JDR_Register is record
      JDATA          : Interfaces.Unsigned_32 range 0 .. 65535;
      --   Injected data
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   injected data register x
   --  Access: read-only
   --  Reset value: 0x00000000
   
   for JDR_Register use record
      JDATA          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;
   
   type DR_Register is record
      DATA           : Interfaces.Unsigned_16;
      --   Regular data
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   regular data register
   --  Access: read-only
   --  Reset value: 0x00000000
   
   for DR_Register use record
      DATA           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;
   

   -----------------
   -- Peripherals --
   -----------------

   type ADC_Common_Peripheral is record
      CSR : aliased CSR_Register;
      pragma Volatile_Full_Access (CSR);
      --   ADC Common status register
      CCR : aliased CCR_Register;
      pragma Volatile_Full_Access (CCR);
      --   ADC common control register
   end record
     with Volatile;
   
   --   ADC common registers
   for ADC_Common_Peripheral use record
      CSR at 16#0# range 0 .. 31;
      CCR at 16#4# range 0 .. 31;
   end record;
   
   type ADC_Peripheral is record
      SR    : aliased SR_Register;
      pragma Volatile_Full_Access (SR);
      --   status register
      CR1   : aliased CR1_Register;
      pragma Volatile_Full_Access (CR1);
      --   control register 1
      CR2   : aliased CR2_Register;
      pragma Volatile_Full_Access (CR2);
      --   control register 2
      SMPR1 : aliased Interfaces.Unsigned_32 range 0 .. 4294967295;
      pragma Volatile_Full_Access (SMPR1);
      --   sample time register 1
      SMPR2 : aliased Interfaces.Unsigned_32 range 0 .. 4294967295;
      pragma Volatile_Full_Access (SMPR2);
      --   sample time register 2
      JOFR1 : aliased JOFR_Register;
      pragma Volatile_Full_Access (JOFR1);
      --   injected channel data offset register x
      JOFR2 : aliased JOFR_Register;
      pragma Volatile_Full_Access (JOFR2);
      --   injected channel data offset register x
      JOFR3 : aliased JOFR_Register;
      pragma Volatile_Full_Access (JOFR3);
      --   injected channel data offset register x
      JOFR4 : aliased JOFR_Register;
      pragma Volatile_Full_Access (JOFR4);
      --   injected channel data offset register x
      HTR   : aliased HTR_Register;
      pragma Volatile_Full_Access (HTR);
      --   watchdog higher threshold register
      LTR   : aliased LTR_Register;
      pragma Volatile_Full_Access (LTR);
      --   watchdog lower threshold register
      SQR1  : aliased SQR1_Register;
      pragma Volatile_Full_Access (SQR1);
      --   regular sequence register 1
      SQR2  : aliased SQR2_Register;
      pragma Volatile_Full_Access (SQR2);
      --   regular sequence register 2
      SQR3  : aliased SQR3_Register;
      pragma Volatile_Full_Access (SQR3);
      --   regular sequence register 3
      JSQR  : aliased JSQR_Register;
      pragma Volatile_Full_Access (JSQR);
      --   injected sequence register
      JDR1  : aliased JDR_Register;
      pragma Volatile_Full_Access (JDR1);
      --   injected data register x
      JDR2  : aliased JDR_Register;
      pragma Volatile_Full_Access (JDR2);
      --   injected data register x
      JDR3  : aliased JDR_Register;
      pragma Volatile_Full_Access (JDR3);
      --   injected data register x
      JDR4  : aliased JDR_Register;
      pragma Volatile_Full_Access (JDR4);
      --   injected data register x
      DR    : aliased DR_Register;
      pragma Volatile_Full_Access (DR);
      --   regular data register
   end record
     with Volatile;
   
   --   Analog-to-digital converter
   for ADC_Peripheral use record
      SR    at 16#0# range 0 .. 31;
      CR1   at 16#4# range 0 .. 31;
      CR2   at 16#8# range 0 .. 31;
      SMPR1 at 16#C# range 0 .. 31;
      SMPR2 at 16#10# range 0 .. 31;
      JOFR1 at 16#14# range 0 .. 31;
      JOFR2 at 16#18# range 0 .. 31;
      JOFR3 at 16#1C# range 0 .. 31;
      JOFR4 at 16#20# range 0 .. 31;
      HTR   at 16#24# range 0 .. 31;
      LTR   at 16#28# range 0 .. 31;
      SQR1  at 16#2C# range 0 .. 31;
      SQR2  at 16#30# range 0 .. 31;
      SQR3  at 16#34# range 0 .. 31;
      JSQR  at 16#38# range 0 .. 31;
      JDR1  at 16#3C# range 0 .. 31;
      JDR2  at 16#40# range 0 .. 31;
      JDR3  at 16#44# range 0 .. 31;
      JDR4  at 16#48# range 0 .. 31;
      DR    at 16#4C# range 0 .. 31;
   end record;
   
   ADC_Common_Periph : aliased ADC_Common_Peripheral
     with Import, Address => ADC_Common_Base;
   
   ADC1_Periph : aliased ADC_Peripheral
     with Import, Address => ADC1_Base;
   
end STM32.Registers.ADC;
