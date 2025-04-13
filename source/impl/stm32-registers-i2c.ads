--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F429x.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.I2C is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Control register 1
   type CR1_Register is record
      --  Peripheral enable
      PE             : Boolean;
      --  SMBus mode
      SMBUS          : Boolean;
      --  unspecified
      Reserved_2_2   : Interfaces.Unsigned_32 range 0 .. 1;
      --  SMBus type
      SMBTYPE        : Boolean;
      --  ARP enable
      ENARP          : Boolean;
      --  PEC enable
      ENPEC          : Boolean;
      --  General call enable
      ENGC           : Boolean;
      --  Clock stretching disable (Slave mode)
      NOSTRETCH      : Boolean;
      --  Start generation
      START          : Boolean;
      --  Stop generation
      STOP           : Boolean;
      --  Acknowledge enable
      ACK            : Boolean;
      --  Acknowledge/PEC Position (for data reception)
      POS            : Boolean;
      --  Packet error checking
      PEC            : Boolean;
      --  SMBus alert
      ALERT          : Boolean;
      --  unspecified
      Reserved_14_14 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Software reset
      SWRST          : Boolean;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR1_Register use record
      PE             at 0 range 0 .. 0;
      SMBUS          at 0 range 1 .. 1;
      Reserved_2_2   at 0 range 2 .. 2;
      SMBTYPE        at 0 range 3 .. 3;
      ENARP          at 0 range 4 .. 4;
      ENPEC          at 0 range 5 .. 5;
      ENGC           at 0 range 6 .. 6;
      NOSTRETCH      at 0 range 7 .. 7;
      START          at 0 range 8 .. 8;
      STOP           at 0 range 9 .. 9;
      ACK            at 0 range 10 .. 10;
      POS            at 0 range 11 .. 11;
      PEC            at 0 range 12 .. 12;
      ALERT          at 0 range 13 .. 13;
      Reserved_14_14 at 0 range 14 .. 14;
      SWRST          at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Control register 2
   type CR2_Register is record
      --  Peripheral clock frequency
      FREQ           : Interfaces.Unsigned_32 range 0 .. 63;
      --  unspecified
      Reserved_6_7   : Interfaces.Unsigned_32 range 0 .. 3;
      --  Error interrupt enable
      ITERREN        : Boolean;
      --  Event interrupt enable
      ITEVTEN        : Boolean;
      --  Buffer interrupt enable
      ITBUFEN        : Boolean;
      --  DMA requests enable
      DMAEN          : Boolean;
      --  DMA last transfer
      LAST           : Boolean;
      --  unspecified
      Reserved_13_31 : Interfaces.Unsigned_32 range 0 .. 524287;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CR2_Register use record
      FREQ           at 0 range 0 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      ITERREN        at 0 range 8 .. 8;
      ITEVTEN        at 0 range 9 .. 9;
      ITBUFEN        at 0 range 10 .. 10;
      DMAEN          at 0 range 11 .. 11;
      LAST           at 0 range 12 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   --  Own address register 1
   type OAR1_Register is record
      --  Interface address
      ADD0           : Boolean;
      --  Interface address
      ADD7           : Interfaces.Unsigned_32 range 0 .. 127;
      --  Interface address
      ADD10          : Interfaces.Unsigned_32 range 0 .. 3;
      --  unspecified
      Reserved_10_14 : Interfaces.Unsigned_32 range 0 .. 31;
      --  Addressing mode (slave mode)
      ADDMODE        : Boolean;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for OAR1_Register use record
      ADD0           at 0 range 0 .. 0;
      ADD7           at 0 range 1 .. 7;
      ADD10          at 0 range 8 .. 9;
      Reserved_10_14 at 0 range 10 .. 14;
      ADDMODE        at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Own address register 2
   type OAR2_Register is record
      --  Dual addressing mode enable
      ENDUAL        : Boolean;
      --  Interface address
      ADD2          : Interfaces.Unsigned_32 range 0 .. 127;
      --  unspecified
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for OAR2_Register use record
      ENDUAL        at 0 range 0 .. 0;
      ADD2          at 0 range 1 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Data register
   type DR_Register is record
      --  8-bit data register
      DR            : Interfaces.Unsigned_32 range 0 .. 255;
      --  unspecified
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DR_Register use record
      DR            at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Status register 1
   type SR1_Register is record
      --  Read-only. Start bit (Master mode)
      SB             : Boolean;
      --  Read-only. Address sent (master mode)/matched (slave mode)
      ADDR           : Boolean;
      --  Read-only. Byte transfer finished
      BTF            : Boolean;
      --  Read-only. 10-bit header sent (Master mode)
      ADD10          : Boolean;
      --  Read-only. Stop detection (slave mode)
      STOPF          : Boolean;
      --  unspecified
      Reserved_5_5   : Interfaces.Unsigned_32 range 0 .. 1;
      --  Read-only. Data register not empty (receivers)
      RxNE           : Boolean;
      --  Read-only. Data register empty (transmitters)
      TxE            : Boolean;
      --  Bus error
      BERR           : Boolean;
      --  Arbitration lost (master mode)
      ARLO           : Boolean;
      --  Acknowledge failure
      AF             : Boolean;
      --  Overrun/Underrun
      OVR            : Boolean;
      --  PEC Error in reception
      PECERR         : Boolean;
      --  unspecified
      Reserved_13_13 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Timeout or Tlow error
      TIMEOUT        : Boolean;
      --  SMBus alert
      SMBALERT       : Boolean;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SR1_Register use record
      SB             at 0 range 0 .. 0;
      ADDR           at 0 range 1 .. 1;
      BTF            at 0 range 2 .. 2;
      ADD10          at 0 range 3 .. 3;
      STOPF          at 0 range 4 .. 4;
      Reserved_5_5   at 0 range 5 .. 5;
      RxNE           at 0 range 6 .. 6;
      TxE            at 0 range 7 .. 7;
      BERR           at 0 range 8 .. 8;
      ARLO           at 0 range 9 .. 9;
      AF             at 0 range 10 .. 10;
      OVR            at 0 range 11 .. 11;
      PECERR         at 0 range 12 .. 12;
      Reserved_13_13 at 0 range 13 .. 13;
      TIMEOUT        at 0 range 14 .. 14;
      SMBALERT       at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Status register 2
   type SR2_Register is record
      --  Read-only. Master/slave
      MSL            : Boolean;
      --  Read-only. Bus busy
      BUSY           : Boolean;
      --  Read-only. Transmitter/receiver
      TRA            : Boolean;
      --  unspecified
      Reserved_3_3   : Interfaces.Unsigned_32 range 0 .. 1;
      --  Read-only. General call address (Slave mode)
      GENCALL        : Boolean;
      --  Read-only. SMBus device default address (Slave mode)
      SMBDEFAULT     : Boolean;
      --  Read-only. SMBus host header (Slave mode)
      SMBHOST        : Boolean;
      --  Read-only. Dual flag (Slave mode)
      DUALF          : Boolean;
      --  Read-only. acket error checking register
      PEC            : Interfaces.Unsigned_32 range 0 .. 255;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SR2_Register use record
      MSL            at 0 range 0 .. 0;
      BUSY           at 0 range 1 .. 1;
      TRA            at 0 range 2 .. 2;
      Reserved_3_3   at 0 range 3 .. 3;
      GENCALL        at 0 range 4 .. 4;
      SMBDEFAULT     at 0 range 5 .. 5;
      SMBHOST        at 0 range 6 .. 6;
      DUALF          at 0 range 7 .. 7;
      PEC            at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Clock control register
   type CCR_Register is record
      --  Clock control register in Fast/Standard mode (Master mode)
      CCR            : Interfaces.Unsigned_32 range 0 .. 4095;
      --  unspecified
      Reserved_12_13 : Interfaces.Unsigned_32 range 0 .. 3;
      --  Fast mode duty cycle
      DUTY           : Boolean;
      --  I2C master mode selection
      F_S            : Boolean;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CCR_Register use record
      CCR            at 0 range 0 .. 11;
      Reserved_12_13 at 0 range 12 .. 13;
      DUTY           at 0 range 14 .. 14;
      F_S            at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  TRISE register
   type TRISE_Register is record
      --  Maximum rise time in Fast/Standard mode (Master mode)
      TRISE         : Interfaces.Unsigned_32 range 0 .. 63;
      --  unspecified
      Reserved_6_31 : Interfaces.Unsigned_32 range 0 .. 67108863;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for TRISE_Register use record
      TRISE         at 0 range 0 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   --  FLTR register
   type FLTR_Register is record
      --  Digital Noise Filter. 0 to disable, or filtering capability up to N *
      --  TPCLK1
      DNF           : Interfaces.Unsigned_32 range 0 .. 15;
      --  Analog noise filter OFF
      ANOFF         : Boolean;
      --  unspecified
      Reserved_5_31 : Interfaces.Unsigned_32 range 0 .. 134217727;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for FLTR_Register use record
      DNF           at 0 range 0 .. 3;
      ANOFF         at 0 range 4 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Inter-integrated circuit
   type I2C_Peripheral is record
      --  Control register 1
      CR1   : aliased CR1_Register;
      pragma Volatile_Full_Access (CR1);
      --  Control register 2
      CR2   : aliased CR2_Register;
      pragma Volatile_Full_Access (CR2);
      --  Own address register 1
      OAR1  : aliased OAR1_Register;
      pragma Volatile_Full_Access (OAR1);
      --  Own address register 2
      OAR2  : aliased OAR2_Register;
      pragma Volatile_Full_Access (OAR2);
      --  Data register
      DR    : aliased DR_Register;
      pragma Volatile_Full_Access (DR);
      --  Status register 1
      SR1   : aliased SR1_Register;
      pragma Volatile_Full_Access (SR1);
      --  Status register 2
      SR2   : aliased SR2_Register;
      pragma Volatile_Full_Access (SR2);
      --  Clock control register
      CCR   : aliased CCR_Register;
      pragma Volatile_Full_Access (CCR);
      --  TRISE register
      TRISE : aliased TRISE_Register;
      pragma Volatile_Full_Access (TRISE);
      --  FLTR register
      FLTR  : aliased FLTR_Register;
      pragma Volatile_Full_Access (FLTR);
   end record
     with Volatile;

   for I2C_Peripheral use record
      CR1   at 16#0# range 0 .. 31;
      CR2   at 16#4# range 0 .. 31;
      OAR1  at 16#8# range 0 .. 31;
      OAR2  at 16#C# range 0 .. 31;
      DR    at 16#10# range 0 .. 31;
      SR1   at 16#14# range 0 .. 31;
      SR2   at 16#18# range 0 .. 31;
      CCR   at 16#1C# range 0 .. 31;
      TRISE at 16#20# range 0 .. 31;
      FLTR  at 16#24# range 0 .. 31;
   end record;

   --  Inter-integrated circuit
   I2C1_Periph : aliased I2C_Peripheral
     with Import, Address => I2C1_Base;

   --  Inter-integrated circuit
   I2C2_Periph : aliased I2C_Peripheral
     with Import, Address => I2C2_Base;

   --  Inter-integrated circuit
   I2C3_Periph : aliased I2C_Peripheral
     with Import, Address => I2C3_Base;

end STM32.Registers.I2C;
