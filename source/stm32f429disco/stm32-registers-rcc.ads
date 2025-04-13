--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F429x.svd
--  then edited to be more handy.

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.RCC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  clock control register
   type CR_Register is record
      --  Internal high-speed clock enable
      HSION          : Boolean;
      --  Read-only. Internal high-speed clock ready flag
      HSIRDY         : Boolean;
      --  unspecified
      Reserved_2_2   : Interfaces.Unsigned_32 range 0 .. 1;
      --  Internal high-speed clock trimming
      HSITRIM        : Interfaces.Unsigned_32 range 0 .. 31;
      --  Read-only. Internal high-speed clock calibration
      HSICAL         : Interfaces.Unsigned_32 range 0 .. 255;
      --  HSE clock enable
      HSEON          : Boolean;
      --  Read-only. HSE clock ready flag
      HSERDY         : Boolean;
      --  HSE clock bypass
      HSEBYP         : Boolean;
      --  Clock security system enable
      CSSON          : Boolean;
      --  unspecified
      Reserved_20_23 : Interfaces.Unsigned_32 range 0 .. 15;
      --  Main PLL (PLL) enable
      PLLON          : Boolean;
      --  Read-only. Main PLL (PLL) clock ready flag
      PLLRDY         : Boolean;
      --  PLLI2S enable
      PLLI2SON       : Boolean;
      --  Read-only. PLLI2S clock ready flag
      PLLI2SRDY      : Boolean;
      --  unspecified
      Reserved_28_31 : Interfaces.Unsigned_32 range 0 .. 15;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR_Register use record
      HSION          at 0 range 0 .. 0;
      HSIRDY         at 0 range 1 .. 1;
      Reserved_2_2   at 0 range 2 .. 2;
      HSITRIM        at 0 range 3 .. 7;
      HSICAL         at 0 range 8 .. 15;
      HSEON          at 0 range 16 .. 16;
      HSERDY         at 0 range 17 .. 17;
      HSEBYP         at 0 range 18 .. 18;
      CSSON          at 0 range 19 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      PLLON          at 0 range 24 .. 24;
      PLLRDY         at 0 range 25 .. 25;
      PLLI2SON       at 0 range 26 .. 26;
      PLLI2SRDY      at 0 range 27 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  PLL configuration register
   type PLLCFGR_Register is record
      --  Division factor for the main PLL (PLL) and audio PLL (PLLI2S) input
      --  clock
      PLLM           : Interfaces.Unsigned_32 range 0 .. 63;
      --  Main PLL (PLL) multiplication factor for VCO
      PLLN           : Interfaces.Unsigned_32 range 0 .. 511;
      --  unspecified
      Reserved_15_15 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Main PLL (PLL) division factor for main system clock
      PLLP           : Interfaces.Unsigned_32 range 0 .. 3;
      --  unspecified
      Reserved_18_21 : Interfaces.Unsigned_32 range 0 .. 15;
      --  Main PLL(PLL) and audio PLL (PLLI2S) entry clock source
      PLLSRC         : Boolean;
      --  unspecified
      Reserved_23_23 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Main PLL (PLL) division factor for USB OTG FS, SDIO and random number
      --  generator clocks
      PLLQ           : Interfaces.Unsigned_32 range 0 .. 15;
      --  unspecified
      Reserved_28_31 : Interfaces.Unsigned_32 range 0 .. 15;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for PLLCFGR_Register use record
      PLLM           at 0 range 0 .. 5;
      PLLN           at 0 range 6 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      PLLP           at 0 range 16 .. 17;
      Reserved_18_21 at 0 range 18 .. 21;
      PLLSRC         at 0 range 22 .. 22;
      Reserved_23_23 at 0 range 23 .. 23;
      PLLQ           at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  CFGR_PPRE array
   type CFGR_PPRE_Field_Array is array (1 .. 2)
     of Interfaces.Unsigned_32 range 0 .. 7
     with Component_Size => 3, Size => 6;

   --  Type definition for CFGR_PPRE
   type CFGR_PPRE_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PPRE as a value
            Val : Interfaces.Unsigned_32 range 0 .. 63;
         when True =>
            --  PPRE as an array
            Arr : CFGR_PPRE_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 6;

   for CFGR_PPRE_Field use record
      Val at 0 range 0 .. 5;
      Arr at 0 range 0 .. 5;
   end record;

   --  clock configuration register
   type CFGR_Register is record
      --  System clock switch
      SW           : Interfaces.Unsigned_32 range 0 .. 3;
      --  Read-only. System clock switch status
      SWS          : Interfaces.Unsigned_32 range 0 .. 3;
      --  AHB prescaler
      HPRE         : Interfaces.Unsigned_32 range 0 .. 15;
      --  unspecified
      Reserved_8_9 : Interfaces.Unsigned_32 range 0 .. 3;
      --  APB Low speed prescaler (APB1)
      PPRE         : CFGR_PPRE_Field;
      --  HSE division factor for RTC clock
      RTCPRE       : Interfaces.Unsigned_32 range 0 .. 31;
      --  Microcontroller clock output 1
      MCO1         : Interfaces.Unsigned_32 range 0 .. 3;
      --  I2S clock selection
      I2SSRC       : Boolean;
      --  MCO1 prescaler
      MCO1PRE      : Interfaces.Unsigned_32 range 0 .. 7;
      --  MCO2 prescaler
      MCO2PRE      : Interfaces.Unsigned_32 range 0 .. 7;
      --  Microcontroller clock output 2
      MCO2         : Interfaces.Unsigned_32 range 0 .. 3;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CFGR_Register use record
      SW           at 0 range 0 .. 1;
      SWS          at 0 range 2 .. 3;
      HPRE         at 0 range 4 .. 7;
      Reserved_8_9 at 0 range 8 .. 9;
      PPRE         at 0 range 10 .. 15;
      RTCPRE       at 0 range 16 .. 20;
      MCO1         at 0 range 21 .. 22;
      I2SSRC       at 0 range 23 .. 23;
      MCO1PRE      at 0 range 24 .. 26;
      MCO2PRE      at 0 range 27 .. 29;
      MCO2         at 0 range 30 .. 31;
   end record;

   --  clock interrupt register
   type CIR_Register is record
      --  Read-only. LSI ready interrupt flag
      LSIRDYF        : Boolean;
      --  Read-only. LSE ready interrupt flag
      LSERDYF        : Boolean;
      --  Read-only. HSI ready interrupt flag
      HSIRDYF        : Boolean;
      --  Read-only. HSE ready interrupt flag
      HSERDYF        : Boolean;
      --  Read-only. Main PLL (PLL) ready interrupt flag
      PLLRDYF        : Boolean;
      --  Read-only. PLLI2S ready interrupt flag
      PLLI2SRDYF     : Boolean;
      --  Read-only. PLLSAI ready interrupt flag
      PLLSAIRDYF     : Boolean;
      --  Read-only. Clock security system interrupt flag
      CSSF           : Boolean;
      --  LSI ready interrupt enable
      LSIRDYIE       : Boolean;
      --  LSE ready interrupt enable
      LSERDYIE       : Boolean;
      --  HSI ready interrupt enable
      HSIRDYIE       : Boolean;
      --  HSE ready interrupt enable
      HSERDYIE       : Boolean;
      --  Main PLL (PLL) ready interrupt enable
      PLLRDYIE       : Boolean;
      --  PLLI2S ready interrupt enable
      PLLI2SRDYIE    : Boolean;
      --  PLLSAI Ready Interrupt Enable
      PLLSAIRDYIE    : Boolean;
      --  unspecified
      Reserved_15_15 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Write-only. LSI ready interrupt clear
      LSIRDYC        : Boolean;
      --  Write-only. LSE ready interrupt clear
      LSERDYC        : Boolean;
      --  Write-only. HSI ready interrupt clear
      HSIRDYC        : Boolean;
      --  Write-only. HSE ready interrupt clear
      HSERDYC        : Boolean;
      --  Write-only. Main PLL(PLL) ready interrupt clear
      PLLRDYC        : Boolean;
      --  Write-only. PLLI2S ready interrupt clear
      PLLI2SRDYC     : Boolean;
      --  Write-only. PLLSAI Ready Interrupt Clear
      PLLSAIRDYC     : Boolean;
      --  Write-only. Clock security system interrupt clear
      CSSC           : Boolean;
      --  unspecified
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CIR_Register use record
      LSIRDYF        at 0 range 0 .. 0;
      LSERDYF        at 0 range 1 .. 1;
      HSIRDYF        at 0 range 2 .. 2;
      HSERDYF        at 0 range 3 .. 3;
      PLLRDYF        at 0 range 4 .. 4;
      PLLI2SRDYF     at 0 range 5 .. 5;
      PLLSAIRDYF     at 0 range 6 .. 6;
      CSSF           at 0 range 7 .. 7;
      LSIRDYIE       at 0 range 8 .. 8;
      LSERDYIE       at 0 range 9 .. 9;
      HSIRDYIE       at 0 range 10 .. 10;
      HSERDYIE       at 0 range 11 .. 11;
      PLLRDYIE       at 0 range 12 .. 12;
      PLLI2SRDYIE    at 0 range 13 .. 13;
      PLLSAIRDYIE    at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      LSIRDYC        at 0 range 16 .. 16;
      LSERDYC        at 0 range 17 .. 17;
      HSIRDYC        at 0 range 18 .. 18;
      HSERDYC        at 0 range 19 .. 19;
      PLLRDYC        at 0 range 20 .. 20;
      PLLI2SRDYC     at 0 range 21 .. 21;
      PLLSAIRDYC     at 0 range 22 .. 22;
      CSSC           at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  AHB1 peripheral reset register
   type AHB1RSTR_Register is record
      --  IO port A reset
      GPIOARST       : Boolean;
      --  IO port B reset
      GPIOBRST       : Boolean;
      --  IO port C reset
      GPIOCRST       : Boolean;
      --  IO port D reset
      GPIODRST       : Boolean;
      --  IO port E reset
      GPIOERST       : Boolean;
      --  IO port F reset
      GPIOFRST       : Boolean;
      --  IO port G reset
      GPIOGRST       : Boolean;
      --  IO port H reset
      GPIOHRST       : Boolean;
      --  IO port I reset
      GPIOIRST       : Boolean;
      --  IO port J reset
      GPIOJRST       : Boolean;
      --  IO port K reset
      GPIOKRST       : Boolean;
      --  unspecified
      Reserved_11_11 : Interfaces.Unsigned_32 range 0 .. 1;
      --  CRC reset
      CRCRST         : Boolean;
      --  unspecified
      Reserved_13_20 : Interfaces.Unsigned_32 range 0 .. 255;
      --  DMA2 reset
      DMA1RST        : Boolean;
      --  DMA2 reset
      DMA2RST        : Boolean;
      --  DMA2D reset
      DMA2DRST       : Boolean;
      --  unspecified
      Reserved_24_24 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Ethernet MAC reset
      ETHMACRST      : Boolean;
      --  unspecified
      Reserved_26_28 : Interfaces.Unsigned_32 range 0 .. 7;
      --  USB OTG HS module reset
      OTGHSRST       : Boolean;
      --  unspecified
      Reserved_30_31 : Interfaces.Unsigned_32 range 0 .. 3;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for AHB1RSTR_Register use record
      GPIOARST       at 0 range 0 .. 0;
      GPIOBRST       at 0 range 1 .. 1;
      GPIOCRST       at 0 range 2 .. 2;
      GPIODRST       at 0 range 3 .. 3;
      GPIOERST       at 0 range 4 .. 4;
      GPIOFRST       at 0 range 5 .. 5;
      GPIOGRST       at 0 range 6 .. 6;
      GPIOHRST       at 0 range 7 .. 7;
      GPIOIRST       at 0 range 8 .. 8;
      GPIOJRST       at 0 range 9 .. 9;
      GPIOKRST       at 0 range 10 .. 10;
      Reserved_11_11 at 0 range 11 .. 11;
      CRCRST         at 0 range 12 .. 12;
      Reserved_13_20 at 0 range 13 .. 20;
      DMA1RST        at 0 range 21 .. 21;
      DMA2RST        at 0 range 22 .. 22;
      DMA2DRST       at 0 range 23 .. 23;
      Reserved_24_24 at 0 range 24 .. 24;
      ETHMACRST      at 0 range 25 .. 25;
      Reserved_26_28 at 0 range 26 .. 28;
      OTGHSRST       at 0 range 29 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   --  AHB2 peripheral reset register
   type AHB2RSTR_Register is record
      --  Camera interface reset
      DCMIRST       : Boolean;
      --  unspecified
      Reserved_1_5  : Interfaces.Unsigned_32 range 0 .. 31;
      --  Random number generator module reset
      RNGRST        : Boolean;
      --  USB OTG FS module reset
      OTGFSRST      : Boolean;
      --  unspecified
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for AHB2RSTR_Register use record
      DCMIRST       at 0 range 0 .. 0;
      Reserved_1_5  at 0 range 1 .. 5;
      RNGRST        at 0 range 6 .. 6;
      OTGFSRST      at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  AHB3 peripheral reset register
   type AHB3RSTR_Register is record
      --  Flexible memory controller module reset
      FMCRST        : Boolean;
      --  unspecified
      Reserved_1_31 : Interfaces.Unsigned_32 range 0 .. 2147483647;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for AHB3RSTR_Register use record
      FMCRST        at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  APB1 peripheral reset register
   type APB1RSTR_Register is record
      --  TIM2 reset
      TIM2RST        : Boolean;
      --  TIM3 reset
      TIM3RST        : Boolean;
      --  TIM4 reset
      TIM4RST        : Boolean;
      --  TIM5 reset
      TIM5RST        : Boolean;
      --  TIM6 reset
      TIM6RST        : Boolean;
      --  TIM7 reset
      TIM7RST        : Boolean;
      --  TIM12 reset
      TIM12RST       : Boolean;
      --  TIM13 reset
      TIM13RST       : Boolean;
      --  TIM14 reset
      TIM14RST       : Boolean;
      --  unspecified
      Reserved_9_10  : Interfaces.Unsigned_32 range 0 .. 3;
      --  Window watchdog reset
      WWDGRST        : Boolean;
      --  unspecified
      Reserved_12_13 : Interfaces.Unsigned_32 range 0 .. 3;
      --  SPI 2 reset
      SPI2RST        : Boolean;
      --  SPI 3 reset
      SPI3RST        : Boolean;
      --  unspecified
      Reserved_16_16 : Interfaces.Unsigned_32 range 0 .. 1;
      --  USART 2 reset
      UART2RST       : Boolean;
      --  USART 3 reset
      UART3RST       : Boolean;
      --  USART 4 reset
      UART4RST       : Boolean;
      --  USART 5 reset
      UART5RST       : Boolean;
      --  I2C 1 reset
      I2C1RST        : Boolean;
      --  I2C 2 reset
      I2C2RST        : Boolean;
      --  I2C3 reset
      I2C3RST        : Boolean;
      --  unspecified
      Reserved_24_24 : Interfaces.Unsigned_32 range 0 .. 1;
      --  CAN1 reset
      CAN1RST        : Boolean;
      --  CAN2 reset
      CAN2RST        : Boolean;
      --  unspecified
      Reserved_27_27 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Power interface reset
      PWRRST         : Boolean;
      --  DAC reset
      DACRST         : Boolean;
      --  UART7 reset
      UART7RST       : Boolean;
      --  UART8 reset
      UART8RST       : Boolean;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for APB1RSTR_Register use record
      TIM2RST        at 0 range 0 .. 0;
      TIM3RST        at 0 range 1 .. 1;
      TIM4RST        at 0 range 2 .. 2;
      TIM5RST        at 0 range 3 .. 3;
      TIM6RST        at 0 range 4 .. 4;
      TIM7RST        at 0 range 5 .. 5;
      TIM12RST       at 0 range 6 .. 6;
      TIM13RST       at 0 range 7 .. 7;
      TIM14RST       at 0 range 8 .. 8;
      Reserved_9_10  at 0 range 9 .. 10;
      WWDGRST        at 0 range 11 .. 11;
      Reserved_12_13 at 0 range 12 .. 13;
      SPI2RST        at 0 range 14 .. 14;
      SPI3RST        at 0 range 15 .. 15;
      Reserved_16_16 at 0 range 16 .. 16;
      UART2RST       at 0 range 17 .. 17;
      UART3RST       at 0 range 18 .. 18;
      UART4RST       at 0 range 19 .. 19;
      UART5RST       at 0 range 20 .. 20;
      I2C1RST        at 0 range 21 .. 21;
      I2C2RST        at 0 range 22 .. 22;
      I2C3RST        at 0 range 23 .. 23;
      Reserved_24_24 at 0 range 24 .. 24;
      CAN1RST        at 0 range 25 .. 25;
      CAN2RST        at 0 range 26 .. 26;
      Reserved_27_27 at 0 range 27 .. 27;
      PWRRST         at 0 range 28 .. 28;
      DACRST         at 0 range 29 .. 29;
      UART7RST       at 0 range 30 .. 30;
      UART8RST       at 0 range 31 .. 31;
   end record;

   --  APB2 peripheral reset register
   type APB2RSTR_Register is record
      --  TIM1 reset
      TIM1RST        : Boolean;
      --  TIM8 reset
      TIM8RST        : Boolean;
      --  unspecified
      Reserved_2_3   : Interfaces.Unsigned_32 range 0 .. 3;
      --  USART1 reset
      USART1RST      : Boolean;
      --  USART6 reset
      USART6RST      : Boolean;
      --  unspecified
      Reserved_6_7   : Interfaces.Unsigned_32 range 0 .. 3;
      --  ADC interface reset (common to all ADCs)
      ADCRST         : Boolean;
      --  unspecified
      Reserved_9_10  : Interfaces.Unsigned_32 range 0 .. 3;
      --  SDIO reset
      SDIORST        : Boolean;
      --  SPI 1 reset
      SPI1RST        : Boolean;
      --  SPI4 reset
      SPI4RST        : Boolean;
      --  System configuration controller reset
      SYSCFGRST      : Boolean;
      --  unspecified
      Reserved_15_15 : Interfaces.Unsigned_32 range 0 .. 1;
      --  TIM9 reset
      TIM9RST        : Boolean;
      --  TIM10 reset
      TIM10RST       : Boolean;
      --  TIM11 reset
      TIM11RST       : Boolean;
      --  unspecified
      Reserved_19_19 : Interfaces.Unsigned_32 range 0 .. 1;
      --  SPI5 reset
      SPI5RST        : Boolean;
      --  SPI6 reset
      SPI6RST        : Boolean;
      --  SAI1 reset
      SAI1RST        : Boolean;
      --  unspecified
      Reserved_23_25 : Interfaces.Unsigned_32 range 0 .. 7;
      --  LTDC reset
      LTDCRST        : Boolean;
      --  unspecified
      Reserved_27_31 : Interfaces.Unsigned_32 range 0 .. 31;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for APB2RSTR_Register use record
      TIM1RST        at 0 range 0 .. 0;
      TIM8RST        at 0 range 1 .. 1;
      Reserved_2_3   at 0 range 2 .. 3;
      USART1RST      at 0 range 4 .. 4;
      USART6RST      at 0 range 5 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      ADCRST         at 0 range 8 .. 8;
      Reserved_9_10  at 0 range 9 .. 10;
      SDIORST        at 0 range 11 .. 11;
      SPI1RST        at 0 range 12 .. 12;
      SPI4RST        at 0 range 13 .. 13;
      SYSCFGRST      at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      TIM9RST        at 0 range 16 .. 16;
      TIM10RST       at 0 range 17 .. 17;
      TIM11RST       at 0 range 18 .. 18;
      Reserved_19_19 at 0 range 19 .. 19;
      SPI5RST        at 0 range 20 .. 20;
      SPI6RST        at 0 range 21 .. 21;
      SAI1RST        at 0 range 22 .. 22;
      Reserved_23_25 at 0 range 23 .. 25;
      LTDCRST        at 0 range 26 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   type Boolean_Array_5 is array (STM32.PA .. STM32.PE) of Boolean
     with Component_Size => 1, Size => 5;

   --  AHB1 peripheral clock register
   type AHB1ENR_Register is record
      --  IO port A clock enable
      GPIOxEN        : Boolean_Array_5;
      --  IO port F clock enable
      GPIOFEN        : Boolean;
      --  IO port G clock enable
      GPIOGEN        : Boolean;
      --  IO port H clock enable
      GPIOHEN        : Boolean;
      --  IO port I clock enable
      GPIOIEN        : Boolean;
      --  IO port J clock enable
      GPIOJEN        : Boolean;
      --  IO port K clock enable
      GPIOKEN        : Boolean;
      --  unspecified
      Reserved_11_11 : Interfaces.Unsigned_32 range 0 .. 1;
      --  CRC clock enable
      CRCEN          : Boolean;
      --  unspecified
      Reserved_13_17 : Interfaces.Unsigned_32 range 0 .. 31;
      --  Backup SRAM interface clock enable
      BKPSRAMEN      : Boolean;
      --  unspecified
      Reserved_19_19 : Interfaces.Unsigned_32 range 0 .. 1;
      --  CCM data RAM clock enable
      CCMDATARAMEN   : Boolean;
      --  DMA1 clock enable
      DMA1EN         : Boolean;
      --  DMA2 clock enable
      DMA2EN         : Boolean;
      --  DMA2D clock enable
      DMA2DEN        : Boolean;
      --  unspecified
      Reserved_24_24 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Ethernet MAC clock enable
      ETHMACEN       : Boolean;
      --  Ethernet Transmission clock enable
      ETHMACTXEN     : Boolean;
      --  Ethernet Reception clock enable
      ETHMACRXEN     : Boolean;
      --  Ethernet PTP clock enable
      ETHMACPTPEN    : Boolean;
      --  USB OTG HS clock enable
      OTGHSEN        : Boolean;
      --  USB OTG HSULPI clock enable
      OTGHSULPIEN    : Boolean;
      --  unspecified
      Reserved_31_31 : Interfaces.Unsigned_32 range 0 .. 1;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for AHB1ENR_Register use record
      GPIOxEN        at 0 range 0 .. 4;
      GPIOFEN        at 0 range 5 .. 5;
      GPIOGEN        at 0 range 6 .. 6;
      GPIOHEN        at 0 range 7 .. 7;
      GPIOIEN        at 0 range 8 .. 8;
      GPIOJEN        at 0 range 9 .. 9;
      GPIOKEN        at 0 range 10 .. 10;
      Reserved_11_11 at 0 range 11 .. 11;
      CRCEN          at 0 range 12 .. 12;
      Reserved_13_17 at 0 range 13 .. 17;
      BKPSRAMEN      at 0 range 18 .. 18;
      Reserved_19_19 at 0 range 19 .. 19;
      CCMDATARAMEN   at 0 range 20 .. 20;
      DMA1EN         at 0 range 21 .. 21;
      DMA2EN         at 0 range 22 .. 22;
      DMA2DEN        at 0 range 23 .. 23;
      Reserved_24_24 at 0 range 24 .. 24;
      ETHMACEN       at 0 range 25 .. 25;
      ETHMACTXEN     at 0 range 26 .. 26;
      ETHMACRXEN     at 0 range 27 .. 27;
      ETHMACPTPEN    at 0 range 28 .. 28;
      OTGHSEN        at 0 range 29 .. 29;
      OTGHSULPIEN    at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   --  AHB2 peripheral clock enable register
   type AHB2ENR_Register is record
      --  Camera interface enable
      DCMIEN        : Boolean;
      --  unspecified
      Reserved_1_5  : Interfaces.Unsigned_32 range 0 .. 31;
      --  Random number generator clock enable
      RNGEN         : Boolean;
      --  USB OTG FS clock enable
      OTGFSEN       : Boolean;
      --  unspecified
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for AHB2ENR_Register use record
      DCMIEN        at 0 range 0 .. 0;
      Reserved_1_5  at 0 range 1 .. 5;
      RNGEN         at 0 range 6 .. 6;
      OTGFSEN       at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  AHB3 peripheral clock enable register
   type AHB3ENR_Register is record
      --  Flexible memory controller module clock enable
      FMCEN         : Boolean;
      --  unspecified
      Reserved_1_31 : Interfaces.Unsigned_32 range 0 .. 2147483647;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for AHB3ENR_Register use record
      FMCEN         at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  APB1 peripheral clock enable register
   type APB1ENR_Register is record
      --  TIM2 clock enable
      TIM2EN         : Boolean;
      --  TIM3 clock enable
      TIM3EN         : Boolean;
      --  TIM4 clock enable
      TIM4EN         : Boolean;
      --  TIM5 clock enable
      TIM5EN         : Boolean;
      --  TIM6 clock enable
      TIM6EN         : Boolean;
      --  TIM7 clock enable
      TIM7EN         : Boolean;
      --  TIM12 clock enable
      TIM12EN        : Boolean;
      --  TIM13 clock enable
      TIM13EN        : Boolean;
      --  TIM14 clock enable
      TIM14EN        : Boolean;
      --  unspecified
      Reserved_9_10  : Interfaces.Unsigned_32 range 0 .. 3;
      --  Window watchdog clock enable
      WWDGEN         : Boolean;
      --  unspecified
      Reserved_12_13 : Interfaces.Unsigned_32 range 0 .. 3;
      --  SPI2 clock enable
      SPI2EN         : Boolean;
      --  SPI3 clock enable
      SPI3EN         : Boolean;
      --  unspecified
      Reserved_16_16 : Interfaces.Unsigned_32 range 0 .. 1;
      --  USART 2 clock enable
      USART2EN       : Boolean;
      --  USART3 clock enable
      USART3EN       : Boolean;
      --  UART4 clock enable
      UART4EN        : Boolean;
      --  UART5 clock enable
      UART5EN        : Boolean;
      --  I2C1 clock enable
      I2C1EN         : Boolean;
      --  I2C2 clock enable
      I2C2EN         : Boolean;
      --  I2C3 clock enable
      I2C3EN         : Boolean;
      --  unspecified
      Reserved_24_24 : Interfaces.Unsigned_32 range 0 .. 1;
      --  CAN 1 clock enable
      CAN1EN         : Boolean;
      --  CAN 2 clock enable
      CAN2EN         : Boolean;
      --  unspecified
      Reserved_27_27 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Power interface clock enable
      PWREN          : Boolean;
      --  DAC interface clock enable
      DACEN          : Boolean;
      --  UART7 clock enable
      UART7ENR       : Boolean;
      --  UART8 clock enable
      UART8ENR       : Boolean;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for APB1ENR_Register use record
      TIM2EN         at 0 range 0 .. 0;
      TIM3EN         at 0 range 1 .. 1;
      TIM4EN         at 0 range 2 .. 2;
      TIM5EN         at 0 range 3 .. 3;
      TIM6EN         at 0 range 4 .. 4;
      TIM7EN         at 0 range 5 .. 5;
      TIM12EN        at 0 range 6 .. 6;
      TIM13EN        at 0 range 7 .. 7;
      TIM14EN        at 0 range 8 .. 8;
      Reserved_9_10  at 0 range 9 .. 10;
      WWDGEN         at 0 range 11 .. 11;
      Reserved_12_13 at 0 range 12 .. 13;
      SPI2EN         at 0 range 14 .. 14;
      SPI3EN         at 0 range 15 .. 15;
      Reserved_16_16 at 0 range 16 .. 16;
      USART2EN       at 0 range 17 .. 17;
      USART3EN       at 0 range 18 .. 18;
      UART4EN        at 0 range 19 .. 19;
      UART5EN        at 0 range 20 .. 20;
      I2C1EN         at 0 range 21 .. 21;
      I2C2EN         at 0 range 22 .. 22;
      I2C3EN         at 0 range 23 .. 23;
      Reserved_24_24 at 0 range 24 .. 24;
      CAN1EN         at 0 range 25 .. 25;
      CAN2EN         at 0 range 26 .. 26;
      Reserved_27_27 at 0 range 27 .. 27;
      PWREN          at 0 range 28 .. 28;
      DACEN          at 0 range 29 .. 29;
      UART7ENR       at 0 range 30 .. 30;
      UART8ENR       at 0 range 31 .. 31;
   end record;

   --  APB2 peripheral clock enable register
   type APB2ENR_Register is record
      --  TIM1 clock enable
      TIM1EN         : Boolean;
      --  TIM8 clock enable
      TIM8EN         : Boolean;
      --  unspecified
      Reserved_2_3   : Interfaces.Unsigned_32 range 0 .. 3;
      --  USART1 clock enable
      USART1EN       : Boolean;
      --  USART6 clock enable
      USART6EN       : Boolean;
      --  unspecified
      Reserved_6_7   : Interfaces.Unsigned_32 range 0 .. 3;
      --  ADC1 clock enable
      ADC1EN         : Boolean;
      --  ADC2 clock enable
      ADC2EN         : Boolean;
      --  ADC3 clock enable
      ADC3EN         : Boolean;
      --  SDIO clock enable
      SDIOEN         : Boolean;
      --  SPI1 clock enable
      SPI1EN         : Boolean;
      --  SPI4 clock enable
      SPI4ENR        : Boolean;
      --  System configuration controller clock enable
      SYSCFGEN       : Boolean;
      --  unspecified
      Reserved_15_15 : Interfaces.Unsigned_32 range 0 .. 1;
      --  TIM9 clock enable
      TIM9EN         : Boolean;
      --  TIM10 clock enable
      TIM10EN        : Boolean;
      --  TIM11 clock enable
      TIM11EN        : Boolean;
      --  unspecified
      Reserved_19_19 : Interfaces.Unsigned_32 range 0 .. 1;
      --  SPI5 clock enable
      SPI5ENR        : Boolean;
      --  SPI6 clock enable
      SPI6ENR        : Boolean;
      --  SAI1 clock enable
      SAI1EN         : Boolean;
      --  unspecified
      Reserved_23_25 : Interfaces.Unsigned_32 range 0 .. 7;
      --  LTDC clock enable
      LTDCEN         : Boolean;
      --  unspecified
      Reserved_27_31 : Interfaces.Unsigned_32 range 0 .. 31;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for APB2ENR_Register use record
      TIM1EN         at 0 range 0 .. 0;
      TIM8EN         at 0 range 1 .. 1;
      Reserved_2_3   at 0 range 2 .. 3;
      USART1EN       at 0 range 4 .. 4;
      USART6EN       at 0 range 5 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      ADC1EN         at 0 range 8 .. 8;
      ADC2EN         at 0 range 9 .. 9;
      ADC3EN         at 0 range 10 .. 10;
      SDIOEN         at 0 range 11 .. 11;
      SPI1EN         at 0 range 12 .. 12;
      SPI4ENR        at 0 range 13 .. 13;
      SYSCFGEN       at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      TIM9EN         at 0 range 16 .. 16;
      TIM10EN        at 0 range 17 .. 17;
      TIM11EN        at 0 range 18 .. 18;
      Reserved_19_19 at 0 range 19 .. 19;
      SPI5ENR        at 0 range 20 .. 20;
      SPI6ENR        at 0 range 21 .. 21;
      SAI1EN         at 0 range 22 .. 22;
      Reserved_23_25 at 0 range 23 .. 25;
      LTDCEN         at 0 range 26 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  AHB1 peripheral clock enable in low power mode register
   type AHB1LPENR_Register is record
      --  IO port A clock enable during sleep mode
      GPIOALPEN      : Boolean;
      --  IO port B clock enable during Sleep mode
      GPIOBLPEN      : Boolean;
      --  IO port C clock enable during Sleep mode
      GPIOCLPEN      : Boolean;
      --  IO port D clock enable during Sleep mode
      GPIODLPEN      : Boolean;
      --  IO port E clock enable during Sleep mode
      GPIOELPEN      : Boolean;
      --  IO port F clock enable during Sleep mode
      GPIOFLPEN      : Boolean;
      --  IO port G clock enable during Sleep mode
      GPIOGLPEN      : Boolean;
      --  IO port H clock enable during Sleep mode
      GPIOHLPEN      : Boolean;
      --  IO port I clock enable during Sleep mode
      GPIOILPEN      : Boolean;
      --  IO port J clock enable during Sleep mode
      GPIOJLPEN      : Boolean;
      --  IO port K clock enable during Sleep mode
      GPIOKLPEN      : Boolean;
      --  unspecified
      Reserved_11_11 : Interfaces.Unsigned_32 range 0 .. 1;
      --  CRC clock enable during Sleep mode
      CRCLPEN        : Boolean;
      --  unspecified
      Reserved_13_14 : Interfaces.Unsigned_32 range 0 .. 3;
      --  Flash interface clock enable during Sleep mode
      FLITFLPEN      : Boolean;
      --  SRAM 1interface clock enable during Sleep mode
      SRAM1LPEN      : Boolean;
      --  SRAM 2 interface clock enable during Sleep mode
      SRAM2LPEN      : Boolean;
      --  Backup SRAM interface clock enable during Sleep mode
      BKPSRAMLPEN    : Boolean;
      --  SRAM 3 interface clock enable during Sleep mode
      SRAM3LPEN      : Boolean;
      --  unspecified
      Reserved_20_20 : Interfaces.Unsigned_32 range 0 .. 1;
      --  DMA1 clock enable during Sleep mode
      DMA1LPEN       : Boolean;
      --  DMA2 clock enable during Sleep mode
      DMA2LPEN       : Boolean;
      --  DMA2D clock enable during Sleep mode
      DMA2DLPEN      : Boolean;
      --  unspecified
      Reserved_24_24 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Ethernet MAC clock enable during Sleep mode
      ETHMACLPEN     : Boolean;
      --  Ethernet transmission clock enable during Sleep mode
      ETHMACTXLPEN   : Boolean;
      --  Ethernet reception clock enable during Sleep mode
      ETHMACRXLPEN   : Boolean;
      --  Ethernet PTP clock enable during Sleep mode
      ETHMACPTPLPEN  : Boolean;
      --  USB OTG HS clock enable during Sleep mode
      OTGHSLPEN      : Boolean;
      --  USB OTG HS ULPI clock enable during Sleep mode
      OTGHSULPILPEN  : Boolean;
      --  unspecified
      Reserved_31_31 : Interfaces.Unsigned_32 range 0 .. 1;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for AHB1LPENR_Register use record
      GPIOALPEN      at 0 range 0 .. 0;
      GPIOBLPEN      at 0 range 1 .. 1;
      GPIOCLPEN      at 0 range 2 .. 2;
      GPIODLPEN      at 0 range 3 .. 3;
      GPIOELPEN      at 0 range 4 .. 4;
      GPIOFLPEN      at 0 range 5 .. 5;
      GPIOGLPEN      at 0 range 6 .. 6;
      GPIOHLPEN      at 0 range 7 .. 7;
      GPIOILPEN      at 0 range 8 .. 8;
      GPIOJLPEN      at 0 range 9 .. 9;
      GPIOKLPEN      at 0 range 10 .. 10;
      Reserved_11_11 at 0 range 11 .. 11;
      CRCLPEN        at 0 range 12 .. 12;
      Reserved_13_14 at 0 range 13 .. 14;
      FLITFLPEN      at 0 range 15 .. 15;
      SRAM1LPEN      at 0 range 16 .. 16;
      SRAM2LPEN      at 0 range 17 .. 17;
      BKPSRAMLPEN    at 0 range 18 .. 18;
      SRAM3LPEN      at 0 range 19 .. 19;
      Reserved_20_20 at 0 range 20 .. 20;
      DMA1LPEN       at 0 range 21 .. 21;
      DMA2LPEN       at 0 range 22 .. 22;
      DMA2DLPEN      at 0 range 23 .. 23;
      Reserved_24_24 at 0 range 24 .. 24;
      ETHMACLPEN     at 0 range 25 .. 25;
      ETHMACTXLPEN   at 0 range 26 .. 26;
      ETHMACRXLPEN   at 0 range 27 .. 27;
      ETHMACPTPLPEN  at 0 range 28 .. 28;
      OTGHSLPEN      at 0 range 29 .. 29;
      OTGHSULPILPEN  at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   --  AHB2 peripheral clock enable in low power mode register
   type AHB2LPENR_Register is record
      --  Camera interface enable during Sleep mode
      DCMILPEN      : Boolean;
      --  unspecified
      Reserved_1_5  : Interfaces.Unsigned_32 range 0 .. 31;
      --  Random number generator clock enable during Sleep mode
      RNGLPEN       : Boolean;
      --  USB OTG FS clock enable during Sleep mode
      OTGFSLPEN     : Boolean;
      --  unspecified
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for AHB2LPENR_Register use record
      DCMILPEN      at 0 range 0 .. 0;
      Reserved_1_5  at 0 range 1 .. 5;
      RNGLPEN       at 0 range 6 .. 6;
      OTGFSLPEN     at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  AHB3 peripheral clock enable in low power mode register
   type AHB3LPENR_Register is record
      --  Flexible memory controller module clock enable during Sleep mode
      FMCLPEN       : Boolean;
      --  unspecified
      Reserved_1_31 : Interfaces.Unsigned_32 range 0 .. 2147483647;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for AHB3LPENR_Register use record
      FMCLPEN       at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  APB1 peripheral clock enable in low power mode register
   type APB1LPENR_Register is record
      --  TIM2 clock enable during Sleep mode
      TIM2LPEN       : Boolean;
      --  TIM3 clock enable during Sleep mode
      TIM3LPEN       : Boolean;
      --  TIM4 clock enable during Sleep mode
      TIM4LPEN       : Boolean;
      --  TIM5 clock enable during Sleep mode
      TIM5LPEN       : Boolean;
      --  TIM6 clock enable during Sleep mode
      TIM6LPEN       : Boolean;
      --  TIM7 clock enable during Sleep mode
      TIM7LPEN       : Boolean;
      --  TIM12 clock enable during Sleep mode
      TIM12LPEN      : Boolean;
      --  TIM13 clock enable during Sleep mode
      TIM13LPEN      : Boolean;
      --  TIM14 clock enable during Sleep mode
      TIM14LPEN      : Boolean;
      --  unspecified
      Reserved_9_10  : Interfaces.Unsigned_32 range 0 .. 3;
      --  Window watchdog clock enable during Sleep mode
      WWDGLPEN       : Boolean;
      --  unspecified
      Reserved_12_13 : Interfaces.Unsigned_32 range 0 .. 3;
      --  SPI2 clock enable during Sleep mode
      SPI2LPEN       : Boolean;
      --  SPI3 clock enable during Sleep mode
      SPI3LPEN       : Boolean;
      --  unspecified
      Reserved_16_16 : Interfaces.Unsigned_32 range 0 .. 1;
      --  USART2 clock enable during Sleep mode
      USART2LPEN     : Boolean;
      --  USART3 clock enable during Sleep mode
      USART3LPEN     : Boolean;
      --  UART4 clock enable during Sleep mode
      UART4LPEN      : Boolean;
      --  UART5 clock enable during Sleep mode
      UART5LPEN      : Boolean;
      --  I2C1 clock enable during Sleep mode
      I2C1LPEN       : Boolean;
      --  I2C2 clock enable during Sleep mode
      I2C2LPEN       : Boolean;
      --  I2C3 clock enable during Sleep mode
      I2C3LPEN       : Boolean;
      --  unspecified
      Reserved_24_24 : Interfaces.Unsigned_32 range 0 .. 1;
      --  CAN 1 clock enable during Sleep mode
      CAN1LPEN       : Boolean;
      --  CAN 2 clock enable during Sleep mode
      CAN2LPEN       : Boolean;
      --  unspecified
      Reserved_27_27 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Power interface clock enable during Sleep mode
      PWRLPEN        : Boolean;
      --  DAC interface clock enable during Sleep mode
      DACLPEN        : Boolean;
      --  UART7 clock enable during Sleep mode
      UART7LPEN      : Boolean;
      --  UART8 clock enable during Sleep mode
      UART8LPEN      : Boolean;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for APB1LPENR_Register use record
      TIM2LPEN       at 0 range 0 .. 0;
      TIM3LPEN       at 0 range 1 .. 1;
      TIM4LPEN       at 0 range 2 .. 2;
      TIM5LPEN       at 0 range 3 .. 3;
      TIM6LPEN       at 0 range 4 .. 4;
      TIM7LPEN       at 0 range 5 .. 5;
      TIM12LPEN      at 0 range 6 .. 6;
      TIM13LPEN      at 0 range 7 .. 7;
      TIM14LPEN      at 0 range 8 .. 8;
      Reserved_9_10  at 0 range 9 .. 10;
      WWDGLPEN       at 0 range 11 .. 11;
      Reserved_12_13 at 0 range 12 .. 13;
      SPI2LPEN       at 0 range 14 .. 14;
      SPI3LPEN       at 0 range 15 .. 15;
      Reserved_16_16 at 0 range 16 .. 16;
      USART2LPEN     at 0 range 17 .. 17;
      USART3LPEN     at 0 range 18 .. 18;
      UART4LPEN      at 0 range 19 .. 19;
      UART5LPEN      at 0 range 20 .. 20;
      I2C1LPEN       at 0 range 21 .. 21;
      I2C2LPEN       at 0 range 22 .. 22;
      I2C3LPEN       at 0 range 23 .. 23;
      Reserved_24_24 at 0 range 24 .. 24;
      CAN1LPEN       at 0 range 25 .. 25;
      CAN2LPEN       at 0 range 26 .. 26;
      Reserved_27_27 at 0 range 27 .. 27;
      PWRLPEN        at 0 range 28 .. 28;
      DACLPEN        at 0 range 29 .. 29;
      UART7LPEN      at 0 range 30 .. 30;
      UART8LPEN      at 0 range 31 .. 31;
   end record;

   --  APB2 peripheral clock enabled in low power mode register
   type APB2LPENR_Register is record
      --  TIM1 clock enable during Sleep mode
      TIM1LPEN       : Boolean;
      --  TIM8 clock enable during Sleep mode
      TIM8LPEN       : Boolean;
      --  unspecified
      Reserved_2_3   : Interfaces.Unsigned_32 range 0 .. 3;
      --  USART1 clock enable during Sleep mode
      USART1LPEN     : Boolean;
      --  USART6 clock enable during Sleep mode
      USART6LPEN     : Boolean;
      --  unspecified
      Reserved_6_7   : Interfaces.Unsigned_32 range 0 .. 3;
      --  ADC1 clock enable during Sleep mode
      ADC1LPEN       : Boolean;
      --  ADC2 clock enable during Sleep mode
      ADC2LPEN       : Boolean;
      --  ADC 3 clock enable during Sleep mode
      ADC3LPEN       : Boolean;
      --  SDIO clock enable during Sleep mode
      SDIOLPEN       : Boolean;
      --  SPI 1 clock enable during Sleep mode
      SPI1LPEN       : Boolean;
      --  SPI 4 clock enable during Sleep mode
      SPI4LPEN       : Boolean;
      --  System configuration controller clock enable during Sleep mode
      SYSCFGLPEN     : Boolean;
      --  unspecified
      Reserved_15_15 : Interfaces.Unsigned_32 range 0 .. 1;
      --  TIM9 clock enable during sleep mode
      TIM9LPEN       : Boolean;
      --  TIM10 clock enable during Sleep mode
      TIM10LPEN      : Boolean;
      --  TIM11 clock enable during Sleep mode
      TIM11LPEN      : Boolean;
      --  unspecified
      Reserved_19_19 : Interfaces.Unsigned_32 range 0 .. 1;
      --  SPI 5 clock enable during Sleep mode
      SPI5LPEN       : Boolean;
      --  SPI 6 clock enable during Sleep mode
      SPI6LPEN       : Boolean;
      --  SAI1 clock enable
      SAI1LPEN       : Boolean;
      --  unspecified
      Reserved_23_25 : Interfaces.Unsigned_32 range 0 .. 7;
      --  LTDC clock enable
      LTDCLPEN       : Boolean;
      --  unspecified
      Reserved_27_31 : Interfaces.Unsigned_32 range 0 .. 31;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for APB2LPENR_Register use record
      TIM1LPEN       at 0 range 0 .. 0;
      TIM8LPEN       at 0 range 1 .. 1;
      Reserved_2_3   at 0 range 2 .. 3;
      USART1LPEN     at 0 range 4 .. 4;
      USART6LPEN     at 0 range 5 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      ADC1LPEN       at 0 range 8 .. 8;
      ADC2LPEN       at 0 range 9 .. 9;
      ADC3LPEN       at 0 range 10 .. 10;
      SDIOLPEN       at 0 range 11 .. 11;
      SPI1LPEN       at 0 range 12 .. 12;
      SPI4LPEN       at 0 range 13 .. 13;
      SYSCFGLPEN     at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      TIM9LPEN       at 0 range 16 .. 16;
      TIM10LPEN      at 0 range 17 .. 17;
      TIM11LPEN      at 0 range 18 .. 18;
      Reserved_19_19 at 0 range 19 .. 19;
      SPI5LPEN       at 0 range 20 .. 20;
      SPI6LPEN       at 0 range 21 .. 21;
      SAI1LPEN       at 0 range 22 .. 22;
      Reserved_23_25 at 0 range 23 .. 25;
      LTDCLPEN       at 0 range 26 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  BDCR_RTCSEL array
   type BDCR_RTCSEL_Field_Array is array (0 .. 1) of Boolean
     with Component_Size => 1, Size => 2;

   --  Type definition for BDCR_RTCSEL
   type BDCR_RTCSEL_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  RTCSEL as a value
            Val : Interfaces.Unsigned_32 range 0 .. 3;
         when True =>
            --  RTCSEL as an array
            Arr : BDCR_RTCSEL_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for BDCR_RTCSEL_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  Backup domain control register
   type BDCR_Register is record
      --  External low-speed oscillator enable
      LSEON          : Boolean;
      --  Read-only. External low-speed oscillator ready
      LSERDY         : Boolean;
      --  External low-speed oscillator bypass
      LSEBYP         : Boolean;
      --  unspecified
      Reserved_3_7   : Interfaces.Unsigned_32 range 0 .. 31;
      --  RTC clock source selection
      RTCSEL         : BDCR_RTCSEL_Field;
      --  unspecified
      Reserved_10_14 : Interfaces.Unsigned_32 range 0 .. 31;
      --  RTC clock enable
      RTCEN          : Boolean;
      --  Backup domain software reset
      BDRST          : Boolean;
      --  unspecified
      Reserved_17_31 : Interfaces.Unsigned_32 range 0 .. 32767;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for BDCR_Register use record
      LSEON          at 0 range 0 .. 0;
      LSERDY         at 0 range 1 .. 1;
      LSEBYP         at 0 range 2 .. 2;
      Reserved_3_7   at 0 range 3 .. 7;
      RTCSEL         at 0 range 8 .. 9;
      Reserved_10_14 at 0 range 10 .. 14;
      RTCEN          at 0 range 15 .. 15;
      BDRST          at 0 range 16 .. 16;
      Reserved_17_31 at 0 range 17 .. 31;
   end record;

   --  clock control & status register
   type CSR_Register is record
      --  Internal low-speed oscillator enable
      LSION         : Boolean;
      --  Read-only. Internal low-speed oscillator ready
      LSIRDY        : Boolean;
      --  unspecified
      Reserved_2_23 : Interfaces.Unsigned_32 range 0 .. 4194303;
      --  Remove reset flag
      RMVF          : Boolean;
      --  BOR reset flag
      BORRSTF       : Boolean;
      --  PIN reset flag
      PADRSTF       : Boolean;
      --  POR/PDR reset flag
      PORRSTF       : Boolean;
      --  Software reset flag
      SFTRSTF       : Boolean;
      --  Independent watchdog reset flag
      WDGRSTF       : Boolean;
      --  Window watchdog reset flag
      WWDGRSTF      : Boolean;
      --  Low-power reset flag
      LPWRRSTF      : Boolean;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CSR_Register use record
      LSION         at 0 range 0 .. 0;
      LSIRDY        at 0 range 1 .. 1;
      Reserved_2_23 at 0 range 2 .. 23;
      RMVF          at 0 range 24 .. 24;
      BORRSTF       at 0 range 25 .. 25;
      PADRSTF       at 0 range 26 .. 26;
      PORRSTF       at 0 range 27 .. 27;
      SFTRSTF       at 0 range 28 .. 28;
      WDGRSTF       at 0 range 29 .. 29;
      WWDGRSTF      at 0 range 30 .. 30;
      LPWRRSTF      at 0 range 31 .. 31;
   end record;

   --  spread spectrum clock generation register
   type SSCGR_Register is record
      --  Modulation period
      MODPER         : Interfaces.Unsigned_32 range 0 .. 8191;
      --  Incrementation step
      INCSTEP        : Interfaces.Unsigned_32 range 0 .. 32767;
      --  unspecified
      Reserved_28_29 : Interfaces.Unsigned_32 range 0 .. 3;
      --  Spread Select
      SPREADSEL      : Boolean;
      --  Spread spectrum modulation enable
      SSCGEN         : Boolean;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SSCGR_Register use record
      MODPER         at 0 range 0 .. 12;
      INCSTEP        at 0 range 13 .. 27;
      Reserved_28_29 at 0 range 28 .. 29;
      SPREADSEL      at 0 range 30 .. 30;
      SSCGEN         at 0 range 31 .. 31;
   end record;

   --  PLLI2S configuration register
   type PLLI2SCFGR_Register is record
      --  unspecified
      Reserved_0_5   : Interfaces.Unsigned_32 range 0 .. 63;
      --  PLLI2S multiplication factor for VCO
      PLLI2SN        : Interfaces.Unsigned_32 range 0 .. 511;
      --  unspecified
      Reserved_15_23 : Interfaces.Unsigned_32 range 0 .. 511;
      --  PLLI2S division factor for SAI1 clock
      PLLI2SQ        : Interfaces.Unsigned_32 range 0 .. 15;
      --  PLLI2S division factor for I2S clocks
      PLLI2SR        : Interfaces.Unsigned_32 range 0 .. 7;
      --  unspecified
      Reserved_31_31 : Interfaces.Unsigned_32 range 0 .. 1;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for PLLI2SCFGR_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      PLLI2SN        at 0 range 6 .. 14;
      Reserved_15_23 at 0 range 15 .. 23;
      PLLI2SQ        at 0 range 24 .. 27;
      PLLI2SR        at 0 range 28 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   --  PLLSAICFGR
   type PLLSAICFGR_Register is record
      --  unspecified
      Reserved_0_5   : Interfaces.Unsigned_32 range 0 .. 63;
      --  PLLSAIN
      PLLSAIN        : Interfaces.Unsigned_32 range 0 .. 511;
      --  unspecified
      Reserved_15_23 : Interfaces.Unsigned_32 range 0 .. 511;
      --  PLLSAIN
      PLLSAIQ        : Interfaces.Unsigned_32 range 0 .. 15;
      --  PLLSAIN
      PLLSAIR        : Interfaces.Unsigned_32 range 0 .. 7;
      --  unspecified
      Reserved_31_31 : Interfaces.Unsigned_32 range 0 .. 1;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for PLLSAICFGR_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      PLLSAIN        at 0 range 6 .. 14;
      Reserved_15_23 at 0 range 15 .. 23;
      PLLSAIQ        at 0 range 24 .. 27;
      PLLSAIR        at 0 range 28 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   --  DCKCFGR
   type DCKCFGR_Register is record
      --  PLLI2SDIVQ
      PLLI2SDIVQ     : Interfaces.Unsigned_32 range 0 .. 31;
      --  unspecified
      Reserved_5_7   : Interfaces.Unsigned_32 range 0 .. 7;
      --  PLLSAIDIVQ
      PLLSAIDIVQ     : Interfaces.Unsigned_32 range 0 .. 31;
      --  unspecified
      Reserved_13_15 : Interfaces.Unsigned_32 range 0 .. 7;
      --  PLLSAIDIVR
      PLLSAIDIVR     : Interfaces.Unsigned_32 range 0 .. 3;
      --  unspecified
      Reserved_18_19 : Interfaces.Unsigned_32 range 0 .. 3;
      --  SAI1ASRC
      SAI1ASRC       : Interfaces.Unsigned_32 range 0 .. 3;
      --  SAI1BSRC
      SAI1BSRC       : Interfaces.Unsigned_32 range 0 .. 3;
      --  TIMPRE
      TIMPRE         : Boolean;
      --  unspecified
      Reserved_25_31 : Interfaces.Unsigned_32 range 0 .. 127;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DCKCFGR_Register use record
      PLLI2SDIVQ     at 0 range 0 .. 4;
      Reserved_5_7   at 0 range 5 .. 7;
      PLLSAIDIVQ     at 0 range 8 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      PLLSAIDIVR     at 0 range 16 .. 17;
      Reserved_18_19 at 0 range 18 .. 19;
      SAI1ASRC       at 0 range 20 .. 21;
      SAI1BSRC       at 0 range 22 .. 23;
      TIMPRE         at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Reset and clock control
   type RCC_Peripheral is record
      --  clock control register
      CR         : aliased CR_Register;
      pragma Volatile_Full_Access (CR);
      --  PLL configuration register
      PLLCFGR    : aliased PLLCFGR_Register;
      pragma Volatile_Full_Access (PLLCFGR);
      --  clock configuration register
      CFGR       : aliased CFGR_Register;
      pragma Volatile_Full_Access (CFGR);
      --  clock interrupt register
      CIR        : aliased CIR_Register;
      pragma Volatile_Full_Access (CIR);
      --  AHB1 peripheral reset register
      AHB1RSTR   : aliased AHB1RSTR_Register;
      pragma Volatile_Full_Access (AHB1RSTR);
      --  AHB2 peripheral reset register
      AHB2RSTR   : aliased AHB2RSTR_Register;
      pragma Volatile_Full_Access (AHB2RSTR);
      --  AHB3 peripheral reset register
      AHB3RSTR   : aliased AHB3RSTR_Register;
      pragma Volatile_Full_Access (AHB3RSTR);
      --  APB1 peripheral reset register
      APB1RSTR   : aliased APB1RSTR_Register;
      pragma Volatile_Full_Access (APB1RSTR);
      --  APB2 peripheral reset register
      APB2RSTR   : aliased APB2RSTR_Register;
      pragma Volatile_Full_Access (APB2RSTR);
      --  AHB1 peripheral clock register
      AHB1ENR    : aliased AHB1ENR_Register;
      pragma Volatile_Full_Access (AHB1ENR);
      --  AHB2 peripheral clock enable register
      AHB2ENR    : aliased AHB2ENR_Register;
      pragma Volatile_Full_Access (AHB2ENR);
      --  AHB3 peripheral clock enable register
      AHB3ENR    : aliased AHB3ENR_Register;
      pragma Volatile_Full_Access (AHB3ENR);
      --  APB1 peripheral clock enable register
      APB1ENR    : aliased APB1ENR_Register;
      pragma Volatile_Full_Access (APB1ENR);
      --  APB2 peripheral clock enable register
      APB2ENR    : aliased APB2ENR_Register;
      pragma Volatile_Full_Access (APB2ENR);
      --  AHB1 peripheral clock enable in low power mode register
      AHB1LPENR  : aliased AHB1LPENR_Register;
      pragma Volatile_Full_Access (AHB1LPENR);
      --  AHB2 peripheral clock enable in low power mode register
      AHB2LPENR  : aliased AHB2LPENR_Register;
      pragma Volatile_Full_Access (AHB2LPENR);
      --  AHB3 peripheral clock enable in low power mode register
      AHB3LPENR  : aliased AHB3LPENR_Register;
      pragma Volatile_Full_Access (AHB3LPENR);
      --  APB1 peripheral clock enable in low power mode register
      APB1LPENR  : aliased APB1LPENR_Register;
      pragma Volatile_Full_Access (APB1LPENR);
      --  APB2 peripheral clock enabled in low power mode register
      APB2LPENR  : aliased APB2LPENR_Register;
      pragma Volatile_Full_Access (APB2LPENR);
      --  Backup domain control register
      BDCR       : aliased BDCR_Register;
      pragma Volatile_Full_Access (BDCR);
      --  clock control & status register
      CSR        : aliased CSR_Register;
      pragma Volatile_Full_Access (CSR);
      --  spread spectrum clock generation register
      SSCGR      : aliased SSCGR_Register;
      pragma Volatile_Full_Access (SSCGR);
      --  PLLI2S configuration register
      PLLI2SCFGR : aliased PLLI2SCFGR_Register;
      pragma Volatile_Full_Access (PLLI2SCFGR);
      --  PLLSAICFGR
      PLLSAICFGR : aliased PLLSAICFGR_Register;
      pragma Volatile_Full_Access (PLLSAICFGR);
      --  DCKCFGR
      DCKCFGR    : aliased DCKCFGR_Register;
      pragma Volatile_Full_Access (DCKCFGR);
   end record
     with Volatile;

   for RCC_Peripheral use record
      CR         at 16#0# range 0 .. 31;
      PLLCFGR    at 16#4# range 0 .. 31;
      CFGR       at 16#8# range 0 .. 31;
      CIR        at 16#C# range 0 .. 31;
      AHB1RSTR   at 16#10# range 0 .. 31;
      AHB2RSTR   at 16#14# range 0 .. 31;
      AHB3RSTR   at 16#18# range 0 .. 31;
      APB1RSTR   at 16#20# range 0 .. 31;
      APB2RSTR   at 16#24# range 0 .. 31;
      AHB1ENR    at 16#30# range 0 .. 31;
      AHB2ENR    at 16#34# range 0 .. 31;
      AHB3ENR    at 16#38# range 0 .. 31;
      APB1ENR    at 16#40# range 0 .. 31;
      APB2ENR    at 16#44# range 0 .. 31;
      AHB1LPENR  at 16#50# range 0 .. 31;
      AHB2LPENR  at 16#54# range 0 .. 31;
      AHB3LPENR  at 16#58# range 0 .. 31;
      APB1LPENR  at 16#60# range 0 .. 31;
      APB2LPENR  at 16#64# range 0 .. 31;
      BDCR       at 16#70# range 0 .. 31;
      CSR        at 16#74# range 0 .. 31;
      SSCGR      at 16#80# range 0 .. 31;
      PLLI2SCFGR at 16#84# range 0 .. 31;
      PLLSAICFGR at 16#88# range 0 .. 31;
      DCKCFGR    at 16#8C# range 0 .. 31;
   end record;

   --  Reset and clock control
   RCC_Periph : aliased RCC_Peripheral
     with Import, Address => RCC_Base;

end STM32.Registers.RCC;
