
pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F40x.svd

pragma Restrictions (No_Elaboration_Code);

with System;

--  STM32F411 version: 1.9
package STM32.Registers is
   pragma Pure;

   --------------------
   -- Base addresses --
   --------------------

   ADC1_Base          : constant System.Address := System'To_Address (16#40012000#);
   ADC_Common_Base    : constant System.Address := System'To_Address (16#40012300#);
   CRC_Base           : constant System.Address := System'To_Address (16#40023000#);
   DBG_Base           : constant System.Address := System'To_Address (16#E0042000#);
   DMA1_Base          : constant System.Address := System'To_Address (16#40026000#);
   DMA2_Base          : constant System.Address := System'To_Address (16#40026400#);
   EXTI_Base          : constant System.Address := System'To_Address (16#40013C00#);
   FLASH_Base         : constant System.Address := System'To_Address (16#40023C00#);
   GPIOA_Base         : constant System.Address := System'To_Address (16#40020000#);
   GPIOB_Base         : constant System.Address := System'To_Address (16#40020400#);
   GPIOC_Base         : constant System.Address := System'To_Address (16#40020800#);
   GPIOD_Base         : constant System.Address := System'To_Address (16#40020C00#);
   GPIOE_Base         : constant System.Address := System'To_Address (16#40021000#);
   GPIOH_Base         : constant System.Address := System'To_Address (16#40021C00#);
   I2C1_Base          : constant System.Address := System'To_Address (16#40005400#);
   I2C2_Base          : constant System.Address := System'To_Address (16#40005800#);
   I2C3_Base          : constant System.Address := System'To_Address (16#40005C00#);
   I2S2ext_Base       : constant System.Address := System'To_Address (16#40003400#);
   I2S3ext_Base       : constant System.Address := System'To_Address (16#40004000#);
   IWDG_Base          : constant System.Address := System'To_Address (16#40003000#);
   OTG_FS_DEVICE_Base : constant System.Address := System'To_Address (16#50000800#);
   OTG_FS_GLOBAL_Base : constant System.Address := System'To_Address (16#50000000#);
   OTG_FS_HOST_Base   : constant System.Address := System'To_Address (16#50000400#);
   OTG_FS_PWRCLK_Base : constant System.Address := System'To_Address (16#50000E00#);
   PWR_Base           : constant System.Address := System'To_Address (16#40007000#);
   RCC_Base           : constant System.Address := System'To_Address (16#40023800#);
   RTC_Base           : constant System.Address := System'To_Address (16#40002800#);
   SDIO_Base          : constant System.Address := System'To_Address (16#40012C00#);
   SPI1_Base          : constant System.Address := System'To_Address (16#40013000#);
   SPI2_Base          : constant System.Address := System'To_Address (16#40003800#);
   SPI3_Base          : constant System.Address := System'To_Address (16#40003C00#);
   SPI4_Base          : constant System.Address := System'To_Address (16#40013400#);
   SPI5_Base          : constant System.Address := System'To_Address (16#40015000#);
   SYSCFG_Base        : constant System.Address := System'To_Address (16#40013800#);
   TIM1_Base          : constant System.Address := System'To_Address (16#40010000#);
   TIM10_Base         : constant System.Address := System'To_Address (16#40014400#);
   TIM11_Base         : constant System.Address := System'To_Address (16#40014800#);
   TIM2_Base          : constant System.Address := System'To_Address (16#40000000#);
   TIM3_Base          : constant System.Address := System'To_Address (16#40000400#);
   TIM4_Base          : constant System.Address := System'To_Address (16#40000800#);
   TIM5_Base          : constant System.Address := System'To_Address (16#40000C00#);
   TIM8_Base          : constant System.Address := System'To_Address (16#40010400#);
   TIM9_Base          : constant System.Address := System'To_Address (16#40014000#);
   USART1_Base        : constant System.Address := System'To_Address (16#40011000#);
   USART2_Base        : constant System.Address := System'To_Address (16#40004400#);
   USART6_Base        : constant System.Address := System'To_Address (16#40011400#);
   WWDG_Base          : constant System.Address := System'To_Address (16#40002C00#);

   -- absent

   TIM6_Base  : constant System.Address := System'To_Address (16#0#);
   TIM7_Base  : constant System.Address := System'To_Address (16#0#);
   TIM12_Base : constant System.Address := System'To_Address (16#0#);
   TIM13_Base : constant System.Address := System'To_Address (16#0#);
   TIM14_Base : constant System.Address := System'To_Address (16#0#);

end STM32.Registers;
