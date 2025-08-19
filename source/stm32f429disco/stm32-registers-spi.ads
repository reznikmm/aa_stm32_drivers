--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F429x.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.SPI is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  control register 1
   type CR1_Register is record
      --  Clock phase
      CPHA           : Boolean;
      --  Clock polarity
      CPOL           : Boolean;
      --  Master selection
      MSTR           : Boolean;
      --  Baud rate control
      BR             : Interfaces.Unsigned_32 range 0 .. 7;
      --  SPI enable
      SPE            : Boolean;
      --  Frame format
      LSBFIRST       : Boolean;
      --  Internal slave select
      SSI            : Boolean;
      --  Software slave management
      SSM            : Boolean;
      --  Receive only
      RXONLY         : Boolean;
      --  Data frame format
      DFF            : Boolean;
      --  CRC transfer next
      CRCNEXT        : Boolean;
      --  Hardware CRC calculation enable
      CRCEN          : Boolean;
      --  Output enable in bidirectional mode
      BIDIOE         : Boolean;
      --  Bidirectional data mode enable
      BIDIMODE       : Boolean;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

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

   --  control register 2
   type CR2_Register is record
      --  Rx buffer DMA enable
      RXDMAEN       : Boolean;
      --  Tx buffer DMA enable
      TXDMAEN       : Boolean;
      --  SS output enable
      SSOE          : Boolean;
      --  unspecified
      Reserved_3_3  : Interfaces.Unsigned_32 range 0 .. 1;
      --  Frame format
      FRF           : Boolean;
      --  Error interrupt enable
      ERRIE         : Boolean;
      --  RX buffer not empty interrupt enable
      RXNEIE        : Boolean;
      --  Tx buffer empty interrupt enable
      TXEIE         : Boolean;
      --  unspecified
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

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

   --  status register
   type SR_Register is record
      --  Read-only. Receive buffer not empty
      RXNE          : Boolean;
      --  Read-only. Transmit buffer empty
      TXE           : Boolean;
      --  Read-only. Channel side
      CHSIDE        : Boolean;
      --  Read-only. Underrun flag
      UDR           : Boolean;
      --  CRC error flag
      CRCERR        : Boolean;
      --  Read-only. Mode fault
      MODF          : Boolean;
      --  Read-only. Overrun flag
      OVR           : Boolean;
      --  Read-only. Busy flag
      BSY           : Boolean;
      --  Read-only. TI frame format error
      TIFRFE        : Boolean;
      --  unspecified
      Reserved_9_31 : Interfaces.Unsigned_32 range 0 .. 8388607;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

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

   --  data register
   type DR_Register is record
      --  Data register
      DR             : Interfaces.Unsigned_32 range 0 .. 65535;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DR_Register use record
      DR             at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  CRC polynomial register
   type CRCPR_Register is record
      --  CRC polynomial register
      CRCPOLY        : Interfaces.Unsigned_32 range 0 .. 65535;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CRCPR_Register use record
      CRCPOLY        at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  RX CRC register
   type RXCRCR_Register is record
      --  Read-only. Rx CRC register
      RxCRC          : Interfaces.Unsigned_32 range 0 .. 65535;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for RXCRCR_Register use record
      RxCRC          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  TX CRC register
   type TXCRCR_Register is record
      --  Read-only. Tx CRC register
      TxCRC          : Interfaces.Unsigned_32 range 0 .. 65535;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for TXCRCR_Register use record
      TxCRC          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  I2S configuration register
   type I2SCFGR_Register is record
      --  Channel length (number of bits per audio channel)
      CHLEN          : Boolean;
      --  Data length to be transferred
      DATLEN         : Interfaces.Unsigned_32 range 0 .. 3;
      --  Steady state clock polarity
      CKPOL          : Boolean;
      --  I2S standard selection
      I2SSTD         : Interfaces.Unsigned_32 range 0 .. 3;
      --  unspecified
      Reserved_6_6   : Interfaces.Unsigned_32 range 0 .. 1;
      --  PCM frame synchronization
      PCMSYNC        : Boolean;
      --  I2S configuration mode
      I2SCFG         : Interfaces.Unsigned_32 range 0 .. 3;
      --  I2S Enable
      I2SE           : Boolean;
      --  I2S mode selection
      I2SMOD         : Boolean;
      --  unspecified
      Reserved_12_31 : Interfaces.Unsigned_32 range 0 .. 1048575;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

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

   --  I2S prescaler register
   type I2SPR_Register is record
      --  I2S Linear prescaler
      I2SDIV         : Interfaces.Unsigned_32 range 0 .. 255;
      --  Odd factor for the prescaler
      ODD            : Boolean;
      --  Master clock output enable
      MCKOE          : Boolean;
      --  unspecified
      Reserved_10_31 : Interfaces.Unsigned_32 range 0 .. 4194303;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for I2SPR_Register use record
      I2SDIV         at 0 range 0 .. 7;
      ODD            at 0 range 8 .. 8;
      MCKOE          at 0 range 9 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Serial peripheral interface
   type SPI_Peripheral is record
      --  control register 1
      CR1     : aliased CR1_Register;
      pragma Volatile_Full_Access (CR1);
      --  control register 2
      CR2     : aliased CR2_Register;
      pragma Volatile_Full_Access (CR2);
      --  status register
      SR      : aliased SR_Register;
      pragma Volatile_Full_Access (SR);
      --  data register
      DR      : aliased DR_Register;
      pragma Volatile_Full_Access (DR);
      --  CRC polynomial register
      CRCPR   : aliased CRCPR_Register;
      pragma Volatile_Full_Access (CRCPR);
      --  RX CRC register
      RXCRCR  : aliased RXCRCR_Register;
      pragma Volatile_Full_Access (RXCRCR);
      --  TX CRC register
      TXCRCR  : aliased TXCRCR_Register;
      pragma Volatile_Full_Access (TXCRCR);
      --  I2S configuration register
      I2SCFGR : aliased I2SCFGR_Register;
      pragma Volatile_Full_Access (I2SCFGR);
      --  I2S prescaler register
      I2SPR   : aliased I2SPR_Register;
      pragma Volatile_Full_Access (I2SPR);
   end record
     with Volatile;

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

   --  Serial peripheral interface
   I2S2ext_Periph : aliased SPI_Peripheral
     with Import, Address => I2S2ext_Base;

   --  Serial peripheral interface
   I2S3ext_Periph : aliased SPI_Peripheral
     with Import, Address => I2S3ext_Base;

   --  Serial peripheral interface
   SPI1_Periph : aliased SPI_Peripheral
     with Import, Address => SPI1_Base;

   --  Serial peripheral interface
   SPI2_Periph : aliased SPI_Peripheral
     with Import, Address => SPI2_Base;

   --  Serial peripheral interface
   SPI3_Periph : aliased SPI_Peripheral
     with Import, Address => SPI3_Base;

   --  Serial peripheral interface
   SPI4_Periph : aliased SPI_Peripheral
     with Import, Address => SPI4_Base;

   --  Serial peripheral interface
   SPI5_Periph : aliased SPI_Peripheral
     with Import, Address => SPI5_Base;

   --  Serial peripheral interface
   SPI6_Periph : aliased SPI_Peripheral
     with Import, Address => SPI6_Base;

end STM32.Registers.SPI;
