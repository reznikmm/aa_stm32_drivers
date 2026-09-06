
--  This spec has been automatically generated from STM32F411.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.RCC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   type CR_Register is record
      HSION          : Boolean;
      --   Internal high-speed clock enable
      HSIRDY         : Boolean;
      --   Internal high-speed clock ready flag
      Reserved_2_2   : Boolean := False;
      HSITRIM        : Interfaces.Unsigned_32 range 0 .. 31;
      --   Internal high-speed clock trimming
      HSICAL         : Interfaces.Unsigned_32 range 0 .. 255;
      --   Internal high-speed clock calibration
      HSEON          : Boolean;
      --   HSE clock enable
      HSERDY         : Boolean;
      --   HSE clock ready flag
      HSEBYP         : Boolean;
      --   HSE clock bypass
      CSSON          : Boolean;
      --   Clock security system enable
      Reserved_20_23 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      PLLON          : Boolean;
      --   Main PLL (PLL) enable
      PLLRDY         : Boolean;
      --   Main PLL (PLL) clock ready flag
      PLLI2SON       : Boolean;
      --   PLLI2S enable
      PLLI2SRDY      : Boolean;
      --   PLLI2S clock ready flag
      Reserved_28_31 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   clock control register
   --  Reset value: 0x00000083

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

   type PLLCFGR_Register is record
      PLLM           : Interfaces.Unsigned_32 range 0 .. 31;
      --   Division factor for the main PLL (PLL)
      PLLN           : Interfaces.Unsigned_32 range 0 .. 511;
      --   Main PLL (PLL) multiplication factor for VCO
      Reserved_15_15 : Boolean := False;
      PLLP           : Interfaces.Unsigned_32 range 0 .. 3;
      --   Main PLL (PLL) division factor for main system clock
      Reserved_18_21 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      PLLSRC         : Boolean;
      --   Main PLL(PLL) and audio PLL (PLLI2S) entry clock source
      Reserved_23_23 : Boolean := False;
      PLLQ           : Interfaces.Unsigned_32 range 0 .. 15;
      --   Main PLL (PLL) division factor for USB
      Reserved_28_31 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   PLL configuration register
   --  Access: read-write
   --  Reset value: 0x24003010

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

   type CFGR_Register is record
      SW           : Interfaces.Unsigned_32 range 0 .. 3;
      --   System clock switch
      SWS          : Interfaces.Unsigned_32 range 0 .. 3;
      --   System clock switch status
      HPRE         : Interfaces.Unsigned_32 range 0 .. 15;
      --   AHB prescaler
      Reserved_8_9 : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      PPRE1        : Interfaces.Unsigned_32 range 0 .. 7;
      --   APB Low speed prescaler (APB1)
      PPRE2        : Interfaces.Unsigned_32 range 0 .. 7;
      --   APB high-speed prescaler (APB2)
      RTCPRE       : Interfaces.Unsigned_32 range 0 .. 31;
      --   HSE division factor for RTC clock
      MCO1         : Interfaces.Unsigned_32 range 0 .. 3;
      --   Microcontroller clock output 1
      I2SSRC       : Boolean;
      --   I2S clock selection
      MCO1PRE      : Interfaces.Unsigned_32 range 0 .. 7;
      --   MCO1 prescaler
      MCO2PRE      : Interfaces.Unsigned_32 range 0 .. 7;
      --   MCO2 prescaler
      MCO2         : Interfaces.Unsigned_32 range 0 .. 3;
      --   Microcontroller clock output 2
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   clock configuration register
   --  Reset value: 0x00000000

   for CFGR_Register use record
      SW           at 0 range 0 .. 1;
      SWS          at 0 range 2 .. 3;
      HPRE         at 0 range 4 .. 7;
      Reserved_8_9 at 0 range 8 .. 9;
      PPRE1        at 0 range 10 .. 12;
      PPRE2        at 0 range 13 .. 15;
      RTCPRE       at 0 range 16 .. 20;
      MCO1         at 0 range 21 .. 22;
      I2SSRC       at 0 range 23 .. 23;
      MCO1PRE      at 0 range 24 .. 26;
      MCO2PRE      at 0 range 27 .. 29;
      MCO2         at 0 range 30 .. 31;
   end record;

   type CIR_Register is record
      LSIRDYF        : Boolean;
      --   LSI ready interrupt flag
      LSERDYF        : Boolean;
      --   LSE ready interrupt flag
      HSIRDYF        : Boolean;
      --   HSI ready interrupt flag
      HSERDYF        : Boolean;
      --   HSE ready interrupt flag
      PLLRDYF        : Boolean;
      --   Main PLL (PLL) ready interrupt flag
      PLLI2SRDYF     : Boolean;
      --   PLLI2S ready interrupt flag
      Reserved_6_6   : Boolean := False;
      CSSF           : Boolean;
      --   Clock security system interrupt flag
      LSIRDYIE       : Boolean;
      --   LSI ready interrupt enable
      LSERDYIE       : Boolean;
      --   LSE ready interrupt enable
      HSIRDYIE       : Boolean;
      --   HSI ready interrupt enable
      HSERDYIE       : Boolean;
      --   HSE ready interrupt enable
      PLLRDYIE       : Boolean;
      --   Main PLL (PLL) ready interrupt enable
      PLLI2SRDYIE    : Boolean;
      --   PLLI2S ready interrupt enable
      Reserved_14_15 : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      LSIRDYC        : Boolean;
      --   LSI ready interrupt clear
      LSERDYC        : Boolean;
      --   LSE ready interrupt clear
      HSIRDYC        : Boolean;
      --   HSI ready interrupt clear
      HSERDYC        : Boolean;
      --   HSE ready interrupt clear
      PLLRDYC        : Boolean;
      --   Main PLL(PLL) ready interrupt clear
      PLLI2SRDYC     : Boolean;
      --   PLLI2S ready interrupt clear
      Reserved_22_22 : Boolean := False;
      CSSC           : Boolean;
      --   Clock security system interrupt clear
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   clock interrupt register
   --  Reset value: 0x00000000

   for CIR_Register use record
      LSIRDYF        at 0 range 0 .. 0;
      LSERDYF        at 0 range 1 .. 1;
      HSIRDYF        at 0 range 2 .. 2;
      HSERDYF        at 0 range 3 .. 3;
      PLLRDYF        at 0 range 4 .. 4;
      PLLI2SRDYF     at 0 range 5 .. 5;
      Reserved_6_6   at 0 range 6 .. 6;
      CSSF           at 0 range 7 .. 7;
      LSIRDYIE       at 0 range 8 .. 8;
      LSERDYIE       at 0 range 9 .. 9;
      HSIRDYIE       at 0 range 10 .. 10;
      HSERDYIE       at 0 range 11 .. 11;
      PLLRDYIE       at 0 range 12 .. 12;
      PLLI2SRDYIE    at 0 range 13 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      LSIRDYC        at 0 range 16 .. 16;
      LSERDYC        at 0 range 17 .. 17;
      HSIRDYC        at 0 range 18 .. 18;
      HSERDYC        at 0 range 19 .. 19;
      PLLRDYC        at 0 range 20 .. 20;
      PLLI2SRDYC     at 0 range 21 .. 21;
      Reserved_22_22 at 0 range 22 .. 22;
      CSSC           at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   type AHB1RSTR_Register is record
      GPIOARST       : Boolean;
      --   IO port A reset
      GPIOBRST       : Boolean;
      --   IO port B reset
      GPIOCRST       : Boolean;
      --   IO port C reset
      GPIODRST       : Boolean;
      --   IO port D reset
      GPIOERST       : Boolean;
      --   IO port E reset
      Reserved_5_6   : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      GPIOHRST       : Boolean;
      --   IO port H reset
      Reserved_8_11  : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      CRCRST         : Boolean;
      --   CRC reset
      Reserved_13_20 : Interfaces.Unsigned_32 range 0 .. 255 := 0;
      DMA1RST        : Boolean;
      --   DMA1 reset
      DMA2RST        : Boolean;
      --   DMA2 reset
      Reserved_23_31 : Interfaces.Unsigned_32 range 0 .. 511 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   AHB1 peripheral reset register
   --  Access: read-write
   --  Reset value: 0x00000000

   for AHB1RSTR_Register use record
      GPIOARST       at 0 range 0 .. 0;
      GPIOBRST       at 0 range 1 .. 1;
      GPIOCRST       at 0 range 2 .. 2;
      GPIODRST       at 0 range 3 .. 3;
      GPIOERST       at 0 range 4 .. 4;
      Reserved_5_6   at 0 range 5 .. 6;
      GPIOHRST       at 0 range 7 .. 7;
      Reserved_8_11  at 0 range 8 .. 11;
      CRCRST         at 0 range 12 .. 12;
      Reserved_13_20 at 0 range 13 .. 20;
      DMA1RST        at 0 range 21 .. 21;
      DMA2RST        at 0 range 22 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   type AHB2RSTR_Register is record
      Reserved_0_6  : Interfaces.Unsigned_32 range 0 .. 127 := 0;
      OTGFSRST      : Boolean;
      --   USB OTG FS module reset
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   AHB2 peripheral reset register
   --  Access: read-write
   --  Reset value: 0x00000000

   for AHB2RSTR_Register use record
      Reserved_0_6  at 0 range 0 .. 6;
      OTGFSRST      at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   type Boolean_2_5 is array (2 .. 5) of Boolean
     with Component_Size => 1;

   type APB1RSTR_Register is record
      TIM_EN_2_7     : Boolean_2_5;
      --   TIM reset
      Reserved_4_10  : Interfaces.Unsigned_32 range 0 .. 127 := 0;
      WWDGRST        : Boolean;
      --   Window watchdog reset
      Reserved_12_13 : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      SPI2RST        : Boolean;
      --   SPI 2 reset
      SPI3RST        : Boolean;
      --   SPI 3 reset
      Reserved_16_16 : Boolean := False;
      UART2RST       : Boolean;
      --   USART 2 reset
      Reserved_18_20 : Interfaces.Unsigned_32 range 0 .. 7 := 0;
      I2C1RST        : Boolean;
      --   I2C 1 reset
      I2C2RST        : Boolean;
      --   I2C 2 reset
      I2C3RST        : Boolean;
      --   I2C3 reset
      Reserved_24_27 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      PWRRST         : Boolean;
      --   Power interface reset
      Reserved_29_31 : Interfaces.Unsigned_32 range 0 .. 7 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   APB1 peripheral reset register
   --  Access: read-write
   --  Reset value: 0x00000000

   for APB1RSTR_Register use record
      TIM_EN_2_7     at 0 range 0 .. 3;
      Reserved_4_10  at 0 range 4 .. 10;
      WWDGRST        at 0 range 11 .. 11;
      Reserved_12_13 at 0 range 12 .. 13;
      SPI2RST        at 0 range 14 .. 14;
      SPI3RST        at 0 range 15 .. 15;
      Reserved_16_16 at 0 range 16 .. 16;
      UART2RST       at 0 range 17 .. 17;
      Reserved_18_20 at 0 range 18 .. 20;
      I2C1RST        at 0 range 21 .. 21;
      I2C2RST        at 0 range 22 .. 22;
      I2C3RST        at 0 range 23 .. 23;
      Reserved_24_27 at 0 range 24 .. 27;
      PWRRST         at 0 range 28 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   type APB2RSTR_Register is record
      TIM1RST        : Boolean;
      --   TIM1 reset
      Reserved_1_3   : Interfaces.Unsigned_32 range 0 .. 7 := 0;
      USART1RST      : Boolean;
      --   USART1 reset
      USART6RST      : Boolean;
      --   USART6 reset
      Reserved_6_7   : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      ADCRST         : Boolean;
      --   ADC interface reset (common to all ADCs)
      Reserved_9_10  : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      SDIORST        : Boolean;
      --   SDIO reset
      SPI1RST        : Boolean;
      --   SPI 1 reset
      Reserved_13_13 : Boolean := False;
      SYSCFGRST      : Boolean;
      --   System configuration controller reset
      Reserved_15_15 : Boolean := False;
      TIM9RST        : Boolean;
      --   TIM9 reset
      TIM10RST       : Boolean;
      --   TIM10 reset
      TIM11RST       : Boolean;
      --   TIM11 reset
      Reserved_19_31 : Interfaces.Unsigned_32 range 0 .. 8191 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   APB2 peripheral reset register
   --  Access: read-write
   --  Reset value: 0x00000000

   for APB2RSTR_Register use record
      TIM1RST        at 0 range 0 .. 0;
      Reserved_1_3   at 0 range 1 .. 3;
      USART1RST      at 0 range 4 .. 4;
      USART6RST      at 0 range 5 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      ADCRST         at 0 range 8 .. 8;
      Reserved_9_10  at 0 range 9 .. 10;
      SDIORST        at 0 range 11 .. 11;
      SPI1RST        at 0 range 12 .. 12;
      Reserved_13_13 at 0 range 13 .. 13;
      SYSCFGRST      at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      TIM9RST        at 0 range 16 .. 16;
      TIM10RST       at 0 range 17 .. 17;
      TIM11RST       at 0 range 18 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   type Boolean_Port_Array is array (STM32.PA .. STM32.PE) of Boolean
     with Component_Size => 1, Size => 5;

   type AHB1ENR_Register is record
      GPIOxEN        : Boolean_Port_Array;
      --   IO port clock enable
      Reserved_5_6   : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      GPIOHEN        : Boolean;
      --   IO port H clock enable
      Reserved_8_11  : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      CRCEN          : Boolean;
      --   CRC clock enable
      Reserved_13_20 : Interfaces.Unsigned_32 range 0 .. 255 := 0;
      DMA1EN         : Boolean;
      --   DMA1 clock enable
      DMA2EN         : Boolean;
      --   DMA2 clock enable
      Reserved_23_31 : Interfaces.Unsigned_32 range 0 .. 511 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   AHB1 peripheral clock register
   --  Access: read-write
   --  Reset value: 0x00100000

   for AHB1ENR_Register use record
      GPIOxEN        at 0 range 0 .. 4;
      Reserved_5_6   at 0 range 5 .. 6;
      GPIOHEN        at 0 range 7 .. 7;
      Reserved_8_11  at 0 range 8 .. 11;
      CRCEN          at 0 range 12 .. 12;
      Reserved_13_20 at 0 range 13 .. 20;
      DMA1EN         at 0 range 21 .. 21;
      DMA2EN         at 0 range 22 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   type AHB2ENR_Register is record
      Reserved_0_6  : Interfaces.Unsigned_32 range 0 .. 127 := 0;
      OTGFSEN       : Boolean;
      --   USB OTG FS clock enable
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   AHB2 peripheral clock enable register
   --  Access: read-write
   --  Reset value: 0x00000000

   for AHB2ENR_Register use record
      Reserved_0_6  at 0 range 0 .. 6;
      OTGFSEN       at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   type APB1ENR_Register is record
      TIM_EN_2_7     : Boolean_2_5;
      --   TIM clock enable
      Reserved_4_10  : Interfaces.Unsigned_32 range 0 .. 127 := 0;
      WWDGEN         : Boolean;
      --   Window watchdog clock enable
      Reserved_12_13 : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      SPI2EN         : Boolean;
      --   SPI2 clock enable
      SPI3EN         : Boolean;
      --   SPI3 clock enable
      Reserved_16_16 : Boolean := False;
      USART2EN       : Boolean;
      --   USART 2 clock enable
      Reserved_18_20 : Interfaces.Unsigned_32 range 0 .. 7 := 0;
      I2C1EN         : Boolean;
      --   I2C1 clock enable
      I2C2EN         : Boolean;
      --   I2C2 clock enable
      I2C3EN         : Boolean;
      --   I2C3 clock enable
      Reserved_24_27 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      PWREN          : Boolean;
      --   Power interface clock enable
      Reserved_29_31 : Interfaces.Unsigned_32 range 0 .. 7 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   APB1 peripheral clock enable register
   --  Access: read-write
   --  Reset value: 0x00000000

   for APB1ENR_Register use record
      TIM_EN_2_7     at 0 range 0 .. 3;
      Reserved_4_10  at 0 range 4 .. 10;
      WWDGEN         at 0 range 11 .. 11;
      Reserved_12_13 at 0 range 12 .. 13;
      SPI2EN         at 0 range 14 .. 14;
      SPI3EN         at 0 range 15 .. 15;
      Reserved_16_16 at 0 range 16 .. 16;
      USART2EN       at 0 range 17 .. 17;
      Reserved_18_20 at 0 range 18 .. 20;
      I2C1EN         at 0 range 21 .. 21;
      I2C2EN         at 0 range 22 .. 22;
      I2C3EN         at 0 range 23 .. 23;
      Reserved_24_27 at 0 range 24 .. 27;
      PWREN          at 0 range 28 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   type APB2ENR_Register is record
      TIM1EN         : Boolean;
      --   TIM1 clock enable
      Reserved_1_3   : Interfaces.Unsigned_32 range 0 .. 7 := 0;
      USART1EN       : Boolean;
      --   USART1 clock enable
      USART6EN       : Boolean;
      --   USART6 clock enable
      Reserved_6_7   : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      ADC1EN         : Boolean;
      --   ADC1 clock enable
      Reserved_9_10  : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      SDIOEN         : Boolean;
      --   SDIO clock enable
      SPI1EN         : Boolean;
      --   SPI1 clock enable
      SPI4EN         : Boolean;
      --   SPI4 clock enable
      SYSCFGEN       : Boolean;
      --   System configuration controller clock enable
      Reserved_15_15 : Boolean := False;
      TIM9EN         : Boolean;
      --   TIM9 clock enable
      TIM10EN        : Boolean;
      --   TIM10 clock enable
      TIM11EN        : Boolean;
      --   TIM11 clock enable
      Reserved_19_31 : Interfaces.Unsigned_32 range 0 .. 8191 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   APB2 peripheral clock enable register
   --  Access: read-write
   --  Reset value: 0x00000000

   for APB2ENR_Register use record
      TIM1EN         at 0 range 0 .. 0;
      Reserved_1_3   at 0 range 1 .. 3;
      USART1EN       at 0 range 4 .. 4;
      USART6EN       at 0 range 5 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      ADC1EN         at 0 range 8 .. 8;
      Reserved_9_10  at 0 range 9 .. 10;
      SDIOEN         at 0 range 11 .. 11;
      SPI1EN         at 0 range 12 .. 12;
      SPI4EN         at 0 range 13 .. 13;
      SYSCFGEN       at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      TIM9EN         at 0 range 16 .. 16;
      TIM10EN        at 0 range 17 .. 17;
      TIM11EN        at 0 range 18 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   type AHB1LPENR_Register is record
      GPIOALPEN      : Boolean;
      --   IO port A clock enable during sleep mode
      GPIOBLPEN      : Boolean;
      --   IO port B clock enable during Sleep mode
      GPIOCLPEN      : Boolean;
      --   IO port C clock enable during Sleep mode
      GPIODLPEN      : Boolean;
      --   IO port D clock enable during Sleep mode
      GPIOELPEN      : Boolean;
      --   IO port E clock enable during Sleep mode
      Reserved_5_6   : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      GPIOHLPEN      : Boolean;
      --   IO port H clock enable during Sleep mode
      Reserved_8_11  : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      CRCLPEN        : Boolean;
      --   CRC clock enable during Sleep mode
      Reserved_13_14 : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      FLITFLPEN      : Boolean;
      --   Flash interface clock enable during Sleep mode
      SRAM1LPEN      : Boolean;
      --   SRAM 1interface clock enable during Sleep mode
      Reserved_17_20 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      DMA1LPEN       : Boolean;
      --   DMA1 clock enable during Sleep mode
      DMA2LPEN       : Boolean;
      --   DMA2 clock enable during Sleep mode
      Reserved_23_31 : Interfaces.Unsigned_32 range 0 .. 511 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   AHB1 peripheral clock enable in low power mode register
   --  Access: read-write
   --  Reset value: 0x7E6791FF

   for AHB1LPENR_Register use record
      GPIOALPEN      at 0 range 0 .. 0;
      GPIOBLPEN      at 0 range 1 .. 1;
      GPIOCLPEN      at 0 range 2 .. 2;
      GPIODLPEN      at 0 range 3 .. 3;
      GPIOELPEN      at 0 range 4 .. 4;
      Reserved_5_6   at 0 range 5 .. 6;
      GPIOHLPEN      at 0 range 7 .. 7;
      Reserved_8_11  at 0 range 8 .. 11;
      CRCLPEN        at 0 range 12 .. 12;
      Reserved_13_14 at 0 range 13 .. 14;
      FLITFLPEN      at 0 range 15 .. 15;
      SRAM1LPEN      at 0 range 16 .. 16;
      Reserved_17_20 at 0 range 17 .. 20;
      DMA1LPEN       at 0 range 21 .. 21;
      DMA2LPEN       at 0 range 22 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   type AHB2LPENR_Register is record
      Reserved_0_6  : Interfaces.Unsigned_32 range 0 .. 127 := 0;
      OTGFSLPEN     : Boolean;
      --   USB OTG FS clock enable during Sleep mode
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   AHB2 peripheral clock enable in low power mode register
   --  Access: read-write
   --  Reset value: 0x000000F1

   for AHB2LPENR_Register use record
      Reserved_0_6  at 0 range 0 .. 6;
      OTGFSLPEN     at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   type APB1LPENR_Register is record
      TIM2LPEN       : Boolean;
      --   TIM2 clock enable during Sleep mode
      TIM3LPEN       : Boolean;
      --   TIM3 clock enable during Sleep mode
      TIM4LPEN       : Boolean;
      --   TIM4 clock enable during Sleep mode
      TIM5LPEN       : Boolean;
      --   TIM5 clock enable during Sleep mode
      Reserved_4_10  : Interfaces.Unsigned_32 range 0 .. 127 := 0;
      WWDGLPEN       : Boolean;
      --   Window watchdog clock enable during Sleep mode
      Reserved_12_13 : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      SPI2LPEN       : Boolean;
      --   SPI2 clock enable during Sleep mode
      SPI3LPEN       : Boolean;
      --   SPI3 clock enable during Sleep mode
      Reserved_16_16 : Boolean := False;
      USART2LPEN     : Boolean;
      --   USART2 clock enable during Sleep mode
      Reserved_18_20 : Interfaces.Unsigned_32 range 0 .. 7 := 0;
      I2C1LPEN       : Boolean;
      --   I2C1 clock enable during Sleep mode
      I2C2LPEN       : Boolean;
      --   I2C2 clock enable during Sleep mode
      I2C3LPEN       : Boolean;
      --   I2C3 clock enable during Sleep mode
      Reserved_24_27 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      PWRLPEN        : Boolean;
      --   Power interface clock enable during Sleep mode
      Reserved_29_31 : Interfaces.Unsigned_32 range 0 .. 7 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   APB1 peripheral clock enable in low power mode register
   --  Access: read-write
   --  Reset value: 0x36FEC9FF

   for APB1LPENR_Register use record
      TIM2LPEN       at 0 range 0 .. 0;
      TIM3LPEN       at 0 range 1 .. 1;
      TIM4LPEN       at 0 range 2 .. 2;
      TIM5LPEN       at 0 range 3 .. 3;
      Reserved_4_10  at 0 range 4 .. 10;
      WWDGLPEN       at 0 range 11 .. 11;
      Reserved_12_13 at 0 range 12 .. 13;
      SPI2LPEN       at 0 range 14 .. 14;
      SPI3LPEN       at 0 range 15 .. 15;
      Reserved_16_16 at 0 range 16 .. 16;
      USART2LPEN     at 0 range 17 .. 17;
      Reserved_18_20 at 0 range 18 .. 20;
      I2C1LPEN       at 0 range 21 .. 21;
      I2C2LPEN       at 0 range 22 .. 22;
      I2C3LPEN       at 0 range 23 .. 23;
      Reserved_24_27 at 0 range 24 .. 27;
      PWRLPEN        at 0 range 28 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   type APB2LPENR_Register is record
      TIM1LPEN       : Boolean;
      --   TIM1 clock enable during Sleep mode
      Reserved_1_3   : Interfaces.Unsigned_32 range 0 .. 7 := 0;
      USART1LPEN     : Boolean;
      --   USART1 clock enable during Sleep mode
      USART6LPEN     : Boolean;
      --   USART6 clock enable during Sleep mode
      Reserved_6_7   : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      ADC1LPEN       : Boolean;
      --   ADC1 clock enable during Sleep mode
      Reserved_9_10  : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      SDIOLPEN       : Boolean;
      --   SDIO clock enable during Sleep mode
      SPI1LPEN       : Boolean;
      --   SPI 1 clock enable during Sleep mode
      SPI4LPEN       : Boolean;
      --   SPI4 clock enable during Sleep mode
      SYSCFGLPEN     : Boolean;
      --   System configuration controller clock enable during Sleep mode
      Reserved_15_15 : Boolean := False;
      TIM9LPEN       : Boolean;
      --   TIM9 clock enable during sleep mode
      TIM10LPEN      : Boolean;
      --   TIM10 clock enable during Sleep mode
      TIM11LPEN      : Boolean;
      --   TIM11 clock enable during Sleep mode
      Reserved_19_31 : Interfaces.Unsigned_32 range 0 .. 8191 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   APB2 peripheral clock enabled in low power mode register
   --  Access: read-write
   --  Reset value: 0x00075F33

   for APB2LPENR_Register use record
      TIM1LPEN       at 0 range 0 .. 0;
      Reserved_1_3   at 0 range 1 .. 3;
      USART1LPEN     at 0 range 4 .. 4;
      USART6LPEN     at 0 range 5 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      ADC1LPEN       at 0 range 8 .. 8;
      Reserved_9_10  at 0 range 9 .. 10;
      SDIOLPEN       at 0 range 11 .. 11;
      SPI1LPEN       at 0 range 12 .. 12;
      SPI4LPEN       at 0 range 13 .. 13;
      SYSCFGLPEN     at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      TIM9LPEN       at 0 range 16 .. 16;
      TIM10LPEN      at 0 range 17 .. 17;
      TIM11LPEN      at 0 range 18 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   type BDCR_Register is record
      LSEON          : Boolean;
      --   External low-speed oscillator enable
      LSERDY         : Boolean;
      --   External low-speed oscillator ready
      LSEBYP         : Boolean;
      --   External low-speed oscillator bypass
      Reserved_3_7   : Interfaces.Unsigned_32 range 0 .. 31 := 0;
      RTCSEL         : Interfaces.Unsigned_32 range 0 .. 3;
      --   RTC clock source selection
      Reserved_10_14 : Interfaces.Unsigned_32 range 0 .. 31 := 0;
      RTCEN          : Boolean;
      --   RTC clock enable
      BDRST          : Boolean;
      --   Backup domain software reset
      Reserved_17_31 : Interfaces.Unsigned_32 range 0 .. 32767 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Backup domain control register
   --  Reset value: 0x00000000

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

   type CSR_Register is record
      LSION         : Boolean;
      --   Internal low-speed oscillator enable
      LSIRDY        : Boolean;
      --   Internal low-speed oscillator ready
      Reserved_2_23 : Interfaces.Unsigned_32 range 0 .. 4194303 := 0;
      RMVF          : Boolean;
      --   Remove reset flag
      BORRSTF       : Boolean;
      --   BOR reset flag
      PADRSTF       : Boolean;
      --   PIN reset flag
      PORRSTF       : Boolean;
      --   POR/PDR reset flag
      SFTRSTF       : Boolean;
      --   Software reset flag
      WDGRSTF       : Boolean;
      --   Independent watchdog reset flag
      WWDGRSTF      : Boolean;
      --   Window watchdog reset flag
      LPWRRSTF      : Boolean;
      --   Low-power reset flag
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   clock control & status register
   --  Reset value: 0x0E000000

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

   type SSCGR_Register is record
      MODPER         : Interfaces.Unsigned_32 range 0 .. 8191;
      --   Modulation period
      INCSTEP        : Interfaces.Unsigned_32 range 0 .. 32767;
      --   Incrementation step
      Reserved_28_29 : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      SPREADSEL      : Boolean;
      --   Spread Select
      SSCGEN         : Boolean;
      --   Spread spectrum modulation enable
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   spread spectrum clock generation register
   --  Access: read-write
   --  Reset value: 0x00000000

   for SSCGR_Register use record
      MODPER         at 0 range 0 .. 12;
      INCSTEP        at 0 range 13 .. 27;
      Reserved_28_29 at 0 range 28 .. 29;
      SPREADSEL      at 0 range 30 .. 30;
      SSCGEN         at 0 range 31 .. 31;
   end record;

   type PLLI2SCFGR_Register is record
      Reserved_0_5   : Interfaces.Unsigned_32 range 0 .. 63 := 0;
      PLLI2SNx       : Interfaces.Unsigned_32 range 0 .. 511;
      --   PLLI2S multiplication factor for VCO
      Reserved_15_27 : Interfaces.Unsigned_32 range 0 .. 8191 := 0;
      PLLI2SRx       : Interfaces.Unsigned_32 range 0 .. 7;
      --   PLLI2S division factor for I2S clocks
      Reserved_31_31 : Boolean := False;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   PLLI2S configuration register
   --  Access: read-write
   --  Reset value: 0x20003000

   for PLLI2SCFGR_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      PLLI2SNx       at 0 range 6 .. 14;
      Reserved_15_27 at 0 range 15 .. 27;
      PLLI2SRx       at 0 range 28 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   type RCC_Peripheral is record
      CR         : aliased CR_Register;
      pragma Volatile_Full_Access (CR);
      --   clock control register
      PLLCFGR    : aliased PLLCFGR_Register;
      pragma Volatile_Full_Access (PLLCFGR);
      --   PLL configuration register
      CFGR       : aliased CFGR_Register;
      pragma Volatile_Full_Access (CFGR);
      --   clock configuration register
      CIR        : aliased CIR_Register;
      pragma Volatile_Full_Access (CIR);
      --   clock interrupt register
      AHB1RSTR   : aliased AHB1RSTR_Register;
      pragma Volatile_Full_Access (AHB1RSTR);
      --   AHB1 peripheral reset register
      AHB2RSTR   : aliased AHB2RSTR_Register;
      pragma Volatile_Full_Access (AHB2RSTR);
      --   AHB2 peripheral reset register
      APB1RSTR   : aliased APB1RSTR_Register;
      pragma Volatile_Full_Access (APB1RSTR);
      --   APB1 peripheral reset register
      APB2RSTR   : aliased APB2RSTR_Register;
      pragma Volatile_Full_Access (APB2RSTR);
      --   APB2 peripheral reset register
      AHB1ENR    : aliased AHB1ENR_Register;
      pragma Volatile_Full_Access (AHB1ENR);
      --   AHB1 peripheral clock register
      AHB2ENR    : aliased AHB2ENR_Register;
      pragma Volatile_Full_Access (AHB2ENR);
      --   AHB2 peripheral clock enable register
      APB1ENR    : aliased APB1ENR_Register;
      pragma Volatile_Full_Access (APB1ENR);
      --   APB1 peripheral clock enable register
      APB2ENR    : aliased APB2ENR_Register;
      pragma Volatile_Full_Access (APB2ENR);
      --   APB2 peripheral clock enable register
      AHB1LPENR  : aliased AHB1LPENR_Register;
      pragma Volatile_Full_Access (AHB1LPENR);
      --   AHB1 peripheral clock enable in low power mode register
      AHB2LPENR  : aliased AHB2LPENR_Register;
      pragma Volatile_Full_Access (AHB2LPENR);
      --   AHB2 peripheral clock enable in low power mode register
      APB1LPENR  : aliased APB1LPENR_Register;
      pragma Volatile_Full_Access (APB1LPENR);
      --   APB1 peripheral clock enable in low power mode register
      APB2LPENR  : aliased APB2LPENR_Register;
      pragma Volatile_Full_Access (APB2LPENR);
      --   APB2 peripheral clock enabled in low power mode register
      BDCR       : aliased BDCR_Register;
      pragma Volatile_Full_Access (BDCR);
      --   Backup domain control register
      CSR        : aliased CSR_Register;
      pragma Volatile_Full_Access (CSR);
      --   clock control & status register
      SSCGR      : aliased SSCGR_Register;
      pragma Volatile_Full_Access (SSCGR);
      --   spread spectrum clock generation register
      PLLI2SCFGR : aliased PLLI2SCFGR_Register;
      pragma Volatile_Full_Access (PLLI2SCFGR);
      --   PLLI2S configuration register
   end record
     with Volatile;

   --   Reset and clock control
   for RCC_Peripheral use record
      CR         at 16#0# range 0 .. 31;
      PLLCFGR    at 16#4# range 0 .. 31;
      CFGR       at 16#8# range 0 .. 31;
      CIR        at 16#C# range 0 .. 31;
      AHB1RSTR   at 16#10# range 0 .. 31;
      AHB2RSTR   at 16#14# range 0 .. 31;
      APB1RSTR   at 16#20# range 0 .. 31;
      APB2RSTR   at 16#24# range 0 .. 31;
      AHB1ENR    at 16#30# range 0 .. 31;
      AHB2ENR    at 16#34# range 0 .. 31;
      APB1ENR    at 16#40# range 0 .. 31;
      APB2ENR    at 16#44# range 0 .. 31;
      AHB1LPENR  at 16#50# range 0 .. 31;
      AHB2LPENR  at 16#54# range 0 .. 31;
      APB1LPENR  at 16#60# range 0 .. 31;
      APB2LPENR  at 16#64# range 0 .. 31;
      BDCR       at 16#70# range 0 .. 31;
      CSR        at 16#74# range 0 .. 31;
      SSCGR      at 16#80# range 0 .. 31;
      PLLI2SCFGR at 16#84# range 0 .. 31;
   end record;

   RCC_Periph : aliased RCC_Peripheral
     with Import, Address => RCC_Base;

end STM32.Registers.RCC;
