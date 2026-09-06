
--  This spec has been automatically generated from STM32F411.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.I2C is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   type CR1_Register is record
      PE             : Boolean;
      --   Peripheral enable
      SMBUS          : Boolean;
      --   SMBus mode
      Reserved_2_2   : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      SMBTYPE        : Boolean;
      --   SMBus type
      ENARP          : Boolean;
      --   ARP enable
      ENPEC          : Boolean;
      --   PEC enable
      ENGC           : Boolean;
      --   General call enable
      NOSTRETCH      : Boolean;
      --   Clock stretching disable (Slave mode)
      START          : Boolean;
      --   Start generation
      STOP           : Boolean;
      --   Stop generation
      ACK            : Boolean;
      --   Acknowledge enable
      POS            : Boolean;
      --   Acknowledge/PEC Position (for data reception)
      PEC            : Boolean;
      --   Packet error checking
      ALERT          : Boolean;
      --   SMBus alert
      Reserved_14_14 : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      SWRST          : Boolean;
      --   Software reset
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Control register 1
   --  Access: read-write
   --  Reset value: 0x0000

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

   type CR2_Register is record
      FREQ           : Interfaces.Unsigned_32 range 0 .. 63;
      --   Peripheral clock frequency
      Reserved_6_7   : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      ITERREN        : Boolean;
      --   Error interrupt enable
      ITEVTEN        : Boolean;
      --   Event interrupt enable
      ITBUFEN        : Boolean;
      --   Buffer interrupt enable
      DMAEN          : Boolean;
      --   DMA requests enable
      LAST           : Boolean;
      --   DMA last transfer
      Reserved_13_31 : Interfaces.Unsigned_32 range 0 .. 524287 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Control register 2
   --  Access: read-write
   --  Reset value: 0x0000

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

   type OAR1_Register is record
      ADD0           : Boolean;
      --   Interface address
      ADD7           : Interfaces.Unsigned_32 range 0 .. 127;
      --   Interface address
      ADD10          : Interfaces.Unsigned_32 range 0 .. 3;
      --   Interface address
      Reserved_10_14 : Interfaces.Unsigned_32 range 0 .. 31 := 0;
      ADDMODE        : Boolean;
      --   Addressing mode (slave mode)
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Own address register 1
   --  Access: read-write
   --  Reset value: 0x0000

   for OAR1_Register use record
      ADD0           at 0 range 0 .. 0;
      ADD7           at 0 range 1 .. 7;
      ADD10          at 0 range 8 .. 9;
      Reserved_10_14 at 0 range 10 .. 14;
      ADDMODE        at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   type OAR2_Register is record
      ENDUAL        : Boolean;
      --   Dual addressing mode enable
      ADD2          : Interfaces.Unsigned_32 range 0 .. 127;
      --   Interface address
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Own address register 2
   --  Access: read-write
   --  Reset value: 0x0000

   for OAR2_Register use record
      ENDUAL        at 0 range 0 .. 0;
      ADD2          at 0 range 1 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   type DR_Register is record
      DR            : Interfaces.Unsigned_32 range 0 .. 255;
      --   8-bit data register
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Data register
   --  Access: read-write
   --  Reset value: 0x0000

   for DR_Register use record
      DR            at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   type SR1_Register is record
      SB             : Boolean;
      --   Start bit (Master mode)
      ADDR           : Boolean;
      --   Address sent (master mode)/matched (slave mode)
      BTF            : Boolean;
      --   Byte transfer finished
      ADD10          : Boolean;
      --   10-bit header sent (Master mode)
      STOPF          : Boolean;
      --   Stop detection (slave mode)
      Reserved_5_5   : Boolean := False;
      RxNE           : Boolean;
      --   Data register not empty (receivers)
      TxE            : Boolean;
      --   Data register empty (transmitters)
      BERR           : Boolean;
      --   Bus error
      ARLO           : Boolean;
      --   Arbitration lost (master mode)
      AF             : Boolean;
      --   Acknowledge failure
      OVR            : Boolean;
      --   Overrun/Underrun
      PECERR         : Boolean;
      --   PEC Error in reception
      Reserved_13_13 : Boolean := False;
      TIMEOUT        : Boolean;
      --   Timeout or Tlow error
      SMBALERT       : Boolean;
      --   SMBus alert
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Status register 1
   --  Reset value: 0x0000

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

   type SR2_Register is record
      MSL            : Boolean;
      --   Master/slave
      BUSY           : Boolean;
      --   Bus busy
      TRA            : Boolean;
      --   Transmitter/receiver
      Reserved_3_3   : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      GENCALL        : Boolean;
      --   General call address (Slave mode)
      SMBDEFAULT     : Boolean;
      --   SMBus device default address (Slave mode)
      SMBHOST        : Boolean;
      --   SMBus host header (Slave mode)
      DUALF          : Boolean;
      --   Dual flag (Slave mode)
      PEC            : Interfaces.Unsigned_32 range 0 .. 255;
      --   acket error checking register
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Status register 2
   --  Access: read-only
   --  Reset value: 0x0000

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

   type CCR_Register is record
      CCR            : Interfaces.Unsigned_32 range 0 .. 4095;
      --   Clock control register in Fast/Standard mode (Master mode)
      Reserved_12_13 : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      DUTY           : Boolean;
      --   Fast mode duty cycle
      F_S            : Boolean;
      --   I2C master mode selection
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Clock control register
   --  Access: read-write
   --  Reset value: 0x0000

   for CCR_Register use record
      CCR            at 0 range 0 .. 11;
      Reserved_12_13 at 0 range 12 .. 13;
      DUTY           at 0 range 14 .. 14;
      F_S            at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   type TRISE_Register is record
      TRISE         : Interfaces.Unsigned_32 range 0 .. 63;
      --   Maximum rise time in Fast/Standard mode (Master mode)
      Reserved_6_31 : Interfaces.Unsigned_32 range 0 .. 67108863 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   TRISE register
   --  Access: read-write
   --  Reset value: 0x0002

   for TRISE_Register use record
      TRISE         at 0 range 0 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   type I2C_Peripheral is record
      CR1   : aliased CR1_Register;
      pragma Volatile_Full_Access (CR1);
      --   Control register 1
      CR2   : aliased CR2_Register;
      pragma Volatile_Full_Access (CR2);
      --   Control register 2
      OAR1  : aliased OAR1_Register;
      pragma Volatile_Full_Access (OAR1);
      --   Own address register 1
      OAR2  : aliased OAR2_Register;
      pragma Volatile_Full_Access (OAR2);
      --   Own address register 2
      DR    : aliased DR_Register;
      pragma Volatile_Full_Access (DR);
      --   Data register
      SR1   : aliased SR1_Register;
      pragma Volatile_Full_Access (SR1);
      --   Status register 1
      SR2   : aliased SR2_Register;
      pragma Volatile_Full_Access (SR2);
      --   Status register 2
      CCR   : aliased CCR_Register;
      pragma Volatile_Full_Access (CCR);
      --   Clock control register
      TRISE : aliased TRISE_Register;
      pragma Volatile_Full_Access (TRISE);
      --   TRISE register
   end record
     with Volatile;

   --   Inter-integrated circuit
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
   end record;

   I2C3_Periph : aliased I2C_Peripheral
     with Import, Address => I2C3_Base;

   I2C1_Periph : aliased I2C_Peripheral
     with Import, Address => I2C1_Base;

   I2C2_Periph : aliased I2C_Peripheral
     with Import, Address => I2C2_Base;

end STM32.Registers.I2C;
