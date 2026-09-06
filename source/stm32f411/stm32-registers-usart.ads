
--  This spec has been automatically generated from STM32F411.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.USART is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   type SR_Register is record
      PE             : Boolean;
      --   Parity error
      FE             : Boolean;
      --   Framing error
      NF             : Boolean;
      --   Noise detected flag
      ORE            : Boolean;
      --   Overrun error
      IDLE           : Boolean;
      --   IDLE line detected
      RXNE           : Boolean;
      --   Read data register not empty
      TC             : Boolean;
      --   Transmission complete
      TXE            : Boolean;
      --   Transmit data register empty
      LBD            : Boolean;
      --   LIN break detection flag
      CTS            : Boolean;
      --   CTS flag
      Reserved_10_31 : Interfaces.Unsigned_32 range 0 .. 4194303 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Status register
   --  Reset value: 0x00C00000

   for SR_Register use record
      PE             at 0 range 0 .. 0;
      FE             at 0 range 1 .. 1;
      NF             at 0 range 2 .. 2;
      ORE            at 0 range 3 .. 3;
      IDLE           at 0 range 4 .. 4;
      RXNE           at 0 range 5 .. 5;
      TC             at 0 range 6 .. 6;
      TXE            at 0 range 7 .. 7;
      LBD            at 0 range 8 .. 8;
      CTS            at 0 range 9 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   type BRR_Register is record
      DIV_Fraction   : Interfaces.Unsigned_32 range 0 .. 15;
      --   fraction of USARTDIV
      DIV_Mantissa   : Interfaces.Unsigned_32 range 0 .. 4095;
      --   mantissa of USARTDIV
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Baud rate register
   --  Access: read-write
   --  Reset value: 0x0000

   for BRR_Register use record
      DIV_Fraction   at 0 range 0 .. 3;
      DIV_Mantissa   at 0 range 4 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   type CR1_Register is record
      SBK            : Boolean;
      --   Send break
      RWU            : Boolean;
      --   Receiver wakeup
      RE             : Boolean;
      --   Receiver enable
      TE             : Boolean;
      --   Transmitter enable
      IDLEIE         : Boolean;
      --   IDLE interrupt enable
      RXNEIE         : Boolean;
      --   RXNE interrupt enable
      TCIE           : Boolean;
      --   Transmission complete interrupt enable
      TXEIE          : Boolean;
      --   TXE interrupt enable
      PEIE           : Boolean;
      --   PE interrupt enable
      PS             : Boolean;
      --   Parity selection
      PCE            : Boolean;
      --   Parity control enable
      WAKE           : Boolean;
      --   Wakeup method
      M              : Boolean;
      --   Word length
      UE             : Boolean;
      --   USART enable
      Reserved       : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      OVER8          : Boolean;
      --   Oversampling mode
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;
   --   Control register 1
   --  Access: read-write
   --  Reset value: 0x0000

   for CR1_Register use record
      SBK            at 0 range 0 .. 0;
      RWU            at 0 range 1 .. 1;
      RE             at 0 range 2 .. 2;
      TE             at 0 range 3 .. 3;
      IDLEIE         at 0 range 4 .. 4;
      RXNEIE         at 0 range 5 .. 5;
      TCIE           at 0 range 6 .. 6;
      TXEIE          at 0 range 7 .. 7;
      PEIE           at 0 range 8 .. 8;
      PS             at 0 range 9 .. 9;
      PCE            at 0 range 10 .. 10;
      WAKE           at 0 range 11 .. 11;
      M              at 0 range 12 .. 12;
      UE             at 0 range 13 .. 13;
      Reserved       at 0 range 14 .. 14;
      OVER8          at 0 range 15 .. 15;
   end record;

   type CR2_Register is record
      ADD            : Interfaces.Unsigned_32 range 0 .. 15;
      --   Address of the USART node
      Reserved_4_4   : Boolean := False;
      LBDL           : Boolean;
      --   lin break detection length
      LBDIE          : Boolean;
      --   LIN break detection interrupt enable
      Reserved_7_7   : Boolean := False;
      LBCL           : Boolean;
      --   Last bit clock pulse
      CPHA           : Boolean;
      --   Clock phase
      CPOL           : Boolean;
      --   Clock polarity
      CLKEN          : Boolean;
      --   Clock enable
      STOP           : Interfaces.Unsigned_32 range 0 .. 3;
      --   STOP bits
      LINEN          : Boolean;
      --   LIN mode enable
      Reserved_15_31 : Interfaces.Unsigned_32 range 0 .. 131071 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Control register 2
   --  Access: read-write
   --  Reset value: 0x0000

   for CR2_Register use record
      ADD            at 0 range 0 .. 3;
      Reserved_4_4   at 0 range 4 .. 4;
      LBDL           at 0 range 5 .. 5;
      LBDIE          at 0 range 6 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      LBCL           at 0 range 8 .. 8;
      CPHA           at 0 range 9 .. 9;
      CPOL           at 0 range 10 .. 10;
      CLKEN          at 0 range 11 .. 11;
      STOP           at 0 range 12 .. 13;
      LINEN          at 0 range 14 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   type CR3_Register is record
      EIE            : Boolean;
      --   Error interrupt enable
      IREN           : Boolean;
      --   IrDA mode enable
      IRLP           : Boolean;
      --   IrDA low-power
      HDSEL          : Boolean;
      --   Half-duplex selection
      NACK           : Boolean;
      --   Smartcard NACK enable
      SCEN           : Boolean;
      --   Smartcard mode enable
      DMAR           : Boolean;
      --   DMA enable receiver
      DMAT           : Boolean;
      --   DMA enable transmitter
      RTSE           : Boolean;
      --   RTS enable
      CTSE           : Boolean;
      --   CTS enable
      CTSIE          : Boolean;
      --   CTS interrupt enable
      ONEBIT         : Boolean;
      --   One sample bit method enable
      Reserved_12_31 : Interfaces.Unsigned_32 range 0 .. 1048575 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Control register 3
   --  Access: read-write
   --  Reset value: 0x0000

   for CR3_Register use record
      EIE            at 0 range 0 .. 0;
      IREN           at 0 range 1 .. 1;
      IRLP           at 0 range 2 .. 2;
      HDSEL          at 0 range 3 .. 3;
      NACK           at 0 range 4 .. 4;
      SCEN           at 0 range 5 .. 5;
      DMAR           at 0 range 6 .. 6;
      DMAT           at 0 range 7 .. 7;
      RTSE           at 0 range 8 .. 8;
      CTSE           at 0 range 9 .. 9;
      CTSIE          at 0 range 10 .. 10;
      ONEBIT         at 0 range 11 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   type GTPR_Register is record
      PSC            : Interfaces.Unsigned_32 range 0 .. 255;
      --   Prescaler value
      GT             : Interfaces.Unsigned_32 range 0 .. 255;
      --   Guard time value
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   Guard time and prescaler register
   --  Access: read-write
   --  Reset value: 0x0000

   for GTPR_Register use record
      PSC            at 0 range 0 .. 7;
      GT             at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   type USART_Peripheral is record
      SR   : aliased SR_Register;
      pragma Volatile_Full_Access (SR);
      --   Status register
      DR  : aliased Interfaces.Unsigned_32 range 0 .. 511;
      pragma Volatile_Full_Access (DR);
      --   Data register
      BRR  : aliased BRR_Register;
      pragma Volatile_Full_Access (BRR);
      --   Baud rate register
      CR1  : aliased CR1_Register;
      pragma Volatile_Full_Access (CR1);
      --   Control register 1
      CR2  : aliased CR2_Register;
      pragma Volatile_Full_Access (CR2);
      --   Control register 2
      CR3  : aliased CR3_Register;
      pragma Volatile_Full_Access (CR3);
      --   Control register 3
      GTPR : aliased GTPR_Register;
      pragma Volatile_Full_Access (GTPR);
      --   Guard time and prescaler register
   end record
     with Volatile;

   --   Universal synchronous asynchronous receiver transmitter
   for USART_Peripheral use record
      SR   at 16#0# range 0 .. 31;
      DR   at 16#4# range 0 .. 31;
      BRR  at 16#8# range 0 .. 31;
      CR1  at 16#C# range 0 .. 15;
      CR2  at 16#10# range 0 .. 31;
      CR3  at 16#14# range 0 .. 31;
      GTPR at 16#18# range 0 .. 31;
   end record;

   USART1_Periph : aliased USART_Peripheral
     with Import, Address => USART1_Base;

   USART2_Periph : aliased USART_Peripheral
     with Import, Address => USART2_Base;

   USART6_Periph : aliased USART_Peripheral
     with Import, Address => USART6_Base;

end STM32.Registers.USART;
