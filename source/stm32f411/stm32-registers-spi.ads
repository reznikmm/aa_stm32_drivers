
--  This spec has been automatically generated from STM32F411.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.SPI is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   type CR1_Register is record
      CPHA           : Boolean;
      --   Clock phase
      CPOL           : Boolean;
      --   Clock polarity
      MSTR           : Boolean;
      --   Master selection
      BR             : Interfaces.Unsigned_32 range 0 .. 7;
      --   Baud rate control
      SPE            : Boolean;
      --   SPI enable
      LSBFIRST       : Boolean;
      --   Frame format
      SSI            : Boolean;
      --   Internal slave select
      SSM            : Boolean;
      --   Software slave management
      RXONLY         : Boolean;
      --   Receive only
      DFF            : Boolean;
      --   Data frame format
      CRCNEXT        : Boolean;
      --   CRC transfer next
      CRCEN          : Boolean;
      --   Hardware CRC calculation enable
      BIDIOE         : Boolean;
      --   Output enable in bidirectional mode
      BIDIMODE       : Boolean;
      --   Bidirectional data mode enable
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   control register 1
   --  Access: read-write
   --  Reset value: 0x0000
   
   for CR1_Register use record
      CPHA           at 0 range 0 .. 0;
      CPOL           at 0 range 1 .. 1;
      MSTR           at 0 range 2 .. 2;
      BR             at 0 range 3 .. 5;
      SPE            at 0 range 6 .. 6;
      LSBFIRST       at 0 range 7 .. 7;
      SSI            at 0 range 8 .. 8;
      SSM            at 0 range 9 .. 9;
      RXONLY         at 0 range 10 .. 10;
      DFF            at 0 range 11 .. 11;
      CRCNEXT        at 0 range 12 .. 12;
      CRCEN          at 0 range 13 .. 13;
      BIDIOE         at 0 range 14 .. 14;
      BIDIMODE       at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;
   
   type CR2_Register is record
      RXDMAEN       : Boolean;
      --   Rx buffer DMA enable
      TXDMAEN       : Boolean;
      --   Tx buffer DMA enable
      SSOE          : Boolean;
      --   SS output enable
      Reserved_3_3  : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      FRF           : Boolean;
      --   Frame format
      ERRIE         : Boolean;
      --   Error interrupt enable
      RXNEIE        : Boolean;
      --   RX buffer not empty interrupt enable
      TXEIE         : Boolean;
      --   Tx buffer empty interrupt enable
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   control register 2
   --  Access: read-write
   --  Reset value: 0x0000
   
   for CR2_Register use record
      RXDMAEN       at 0 range 0 .. 0;
      TXDMAEN       at 0 range 1 .. 1;
      SSOE          at 0 range 2 .. 2;
      Reserved_3_3  at 0 range 3 .. 3;
      FRF           at 0 range 4 .. 4;
      ERRIE         at 0 range 5 .. 5;
      RXNEIE        at 0 range 6 .. 6;
      TXEIE         at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;
   
   type SR_Register is record
      RXNE          : Boolean;
      --   Receive buffer not empty
      TXE           : Boolean;
      --   Transmit buffer empty
      CHSIDE        : Boolean;
      --   Channel side
      UDR           : Boolean;
      --   Underrun flag
      CRCERR        : Boolean;
      --   CRC error flag
      MODF          : Boolean;
      --   Mode fault
      OVR           : Boolean;
      --   Overrun flag
      BSY           : Boolean;
      --   Busy flag
      TIFRFE        : Boolean;
      --   TI frame format error
      Reserved_9_31 : Interfaces.Unsigned_32 range 0 .. 8388607 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   status register
   --  Reset value: 0x0002
   
   for SR_Register use record
      RXNE          at 0 range 0 .. 0;
      TXE           at 0 range 1 .. 1;
      CHSIDE        at 0 range 2 .. 2;
      UDR           at 0 range 3 .. 3;
      CRCERR        at 0 range 4 .. 4;
      MODF          at 0 range 5 .. 5;
      OVR           at 0 range 6 .. 6;
      BSY           at 0 range 7 .. 7;
      TIFRFE        at 0 range 8 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;
   
   type DR_Register is record
      DR             : Interfaces.Unsigned_32 range 0 .. 65535;
      --   Data register
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   data register
   --  Access: read-write
   --  Reset value: 0x0000
   
   for DR_Register use record
      DR             at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;
   
   type CRCPR_Register is record
      CRCPOLY        : Interfaces.Unsigned_32 range 0 .. 65535;
      --   CRC polynomial register
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   CRC polynomial register
   --  Access: read-write
   --  Reset value: 0x0007
   
   for CRCPR_Register use record
      CRCPOLY        at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;
   
   type RXCRCR_Register is record
      RxCRC          : Interfaces.Unsigned_32 range 0 .. 65535;
      --   Rx CRC register
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   RX CRC register
   --  Access: read-only
   --  Reset value: 0x0000
   
   for RXCRCR_Register use record
      RxCRC          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;
   
   type TXCRCR_Register is record
      TxCRC          : Interfaces.Unsigned_32 range 0 .. 65535;
      --   Tx CRC register
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   TX CRC register
   --  Access: read-only
   --  Reset value: 0x0000
   
   for TXCRCR_Register use record
      TxCRC          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;
   
   type I2SCFGR_Register is record
      CHLEN          : Boolean;
      --   Channel length (number of bits per audio channel)
      DATLEN         : Interfaces.Unsigned_32 range 0 .. 3;
      --   Data length to be transferred
      CKPOL          : Boolean;
      --   Steady state clock polarity
      I2SSTD         : Interfaces.Unsigned_32 range 0 .. 3;
      --   I2S standard selection
      Reserved_6_6   : Boolean := False;
      PCMSYNC        : Boolean;
      --   PCM frame synchronization
      I2SCFG         : Interfaces.Unsigned_32 range 0 .. 3;
      --   I2S configuration mode
      I2SE           : Boolean;
      --   I2S Enable
      I2SMOD         : Boolean;
      --   I2S mode selection
      Reserved_12_31 : Interfaces.Unsigned_32 range 0 .. 1048575 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   I2S configuration register
   --  Access: read-write
   --  Reset value: 0x0000
   
   for I2SCFGR_Register use record
      CHLEN          at 0 range 0 .. 0;
      DATLEN         at 0 range 1 .. 2;
      CKPOL          at 0 range 3 .. 3;
      I2SSTD         at 0 range 4 .. 5;
      Reserved_6_6   at 0 range 6 .. 6;
      PCMSYNC        at 0 range 7 .. 7;
      I2SCFG         at 0 range 8 .. 9;
      I2SE           at 0 range 10 .. 10;
      I2SMOD         at 0 range 11 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;
   
   type I2SPR_Register is record
      I2SDIV         : Interfaces.Unsigned_32 range 0 .. 255;
      --   I2S Linear prescaler
      ODD            : Boolean;
      --   Odd factor for the prescaler
      MCKOE          : Boolean;
      --   Master clock output enable
      Reserved_10_31 : Interfaces.Unsigned_32 range 0 .. 4194303 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   I2S prescaler register
   --  Access: read-write
   --  Reset value: 00000010
   
   for I2SPR_Register use record
      I2SDIV         at 0 range 0 .. 7;
      ODD            at 0 range 8 .. 8;
      MCKOE          at 0 range 9 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;
   

   -----------------
   -- Peripherals --
   -----------------

   type SPI_Peripheral is record
      CR1     : aliased CR1_Register;
      pragma Volatile_Full_Access (CR1);
      --   control register 1
      CR2     : aliased CR2_Register;
      pragma Volatile_Full_Access (CR2);
      --   control register 2
      SR      : aliased SR_Register;
      pragma Volatile_Full_Access (SR);
      --   status register
      DR      : aliased DR_Register;
      pragma Volatile_Full_Access (DR);
      --   data register
      CRCPR   : aliased CRCPR_Register;
      pragma Volatile_Full_Access (CRCPR);
      --   CRC polynomial register
      RXCRCR  : aliased RXCRCR_Register;
      pragma Volatile_Full_Access (RXCRCR);
      --   RX CRC register
      TXCRCR  : aliased TXCRCR_Register;
      pragma Volatile_Full_Access (TXCRCR);
      --   TX CRC register
      I2SCFGR : aliased I2SCFGR_Register;
      pragma Volatile_Full_Access (I2SCFGR);
      --   I2S configuration register
      I2SPR   : aliased I2SPR_Register;
      pragma Volatile_Full_Access (I2SPR);
      --   I2S prescaler register
   end record
     with Volatile;
   
   --   Serial peripheral interface
   for SPI_Peripheral use record
      CR1     at 16#0# range 0 .. 31;
      CR2     at 16#4# range 0 .. 31;
      SR      at 16#8# range 0 .. 31;
      DR      at 16#C# range 0 .. 31;
      CRCPR   at 16#10# range 0 .. 31;
      RXCRCR  at 16#14# range 0 .. 31;
      TXCRCR  at 16#18# range 0 .. 31;
      I2SCFGR at 16#1C# range 0 .. 31;
      I2SPR   at 16#20# range 0 .. 31;
   end record;
   
   I2S2ext_Periph : aliased SPI_Peripheral
     with Import, Address => I2S2ext_Base;
   
   I2S3ext_Periph : aliased SPI_Peripheral
     with Import, Address => I2S3ext_Base;
   
   SPI1_Periph : aliased SPI_Peripheral
     with Import, Address => SPI1_Base;
   
   SPI2_Periph : aliased SPI_Peripheral
     with Import, Address => SPI2_Base;
   
   SPI3_Periph : aliased SPI_Peripheral
     with Import, Address => SPI3_Base;
   
   SPI4_Periph : aliased SPI_Peripheral
     with Import, Address => SPI4_Base;
   
   SPI5_Periph : aliased SPI_Peripheral
     with Import, Address => SPI5_Base;
   
end STM32.Registers.SPI;
