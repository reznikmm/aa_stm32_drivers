--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F40x.svd
--  then edited to be more handy.

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.USART is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Status register
   type SR_Register is record
      --  Read-only. Parity error
      PE             : Boolean;
      --  Read-only. Framing error
      FE             : Boolean;
      --  Read-only. Noise detected flag
      NF             : Boolean;
      --  Read-only. Overrun error
      ORE            : Boolean;
      --  Read-only. IDLE line detected
      IDLE           : Boolean;
      --  Read data register not empty
      RXNE           : Boolean;
      --  Transmission complete
      TC             : Boolean;
      --  Read-only. Transmit data register empty
      TXE            : Boolean;
      --  LIN break detection flag
      LBD            : Boolean;
      --  CTS flag
      CTS            : Boolean;
      --  unspecified
      Reserved_10_31 : Interfaces.Unsigned_32 range 0 .. 4194303;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

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

   --  Baud rate register
   type BRR_Register is record
      --  fraction of USARTDIV
      DIV_Fraction   : Interfaces.Unsigned_32 range 0 .. 15;
      --  mantissa of USARTDIV
      DIV_Mantissa   : Interfaces.Unsigned_32 range 0 .. 4095;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for BRR_Register use record
      DIV_Fraction   at 0 range 0 .. 3;
      DIV_Mantissa   at 0 range 4 .. 15;
   end record;

   --  Control register 1
   type CR1_Register is record
      --  Send break
      SBK            : Boolean;
      --  Receiver wakeup
      RWU            : Boolean;
      --  Receiver enable
      RE             : Boolean;
      --  Transmitter enable
      TE             : Boolean;
      --  IDLE interrupt enable
      IDLEIE         : Boolean;
      --  RXNE interrupt enable
      RXNEIE         : Boolean;
      --  Transmission complete interrupt enable
      TCIE           : Boolean;
      --  TXE interrupt enable
      TXEIE          : Boolean;
      --  PE interrupt enable
      PEIE           : Boolean;
      --  Parity selection
      PS             : Boolean;
      --  Parity control enable
      PCE            : Boolean;
      --  Wakeup method
      WAKE           : Boolean;
      --  Word length
      M              : Boolean;
      --  USART enable
      UE             : Boolean;
      --  unspecified
      Reserved       : Interfaces.Unsigned_32 range 0 .. 1;
      --  Oversampling mode
      OVER8          : Boolean;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

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

   --  Control register 2
   type CR2_Register is record
      --  Address of the USART node
      ADD          : Interfaces.Unsigned_32 range 0 .. 15;
      --  unspecified
      Reserved_4_4 : Interfaces.Unsigned_32 range 0 .. 1;
      --  lin break detection length
      LBDL         : Boolean;
      --  LIN break detection interrupt enable
      LBDIE        : Boolean;
      --  unspecified
      Reserved_7_7 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Last bit clock pulse
      LBCL         : Boolean;
      --  Clock phase
      CPHA         : Boolean;
      --  Clock polarity
      CPOL         : Boolean;
      --  Clock enable
      CLKEN        : Boolean;
      --  STOP bits
      STOP         : Interfaces.Unsigned_32 range 0 .. 3;
      --  LIN mode enable
      LINEN        : Boolean;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for CR2_Register use record
      ADD          at 0 range 0 .. 3;
      Reserved_4_4 at 0 range 4 .. 4;
      LBDL         at 0 range 5 .. 5;
      LBDIE        at 0 range 6 .. 6;
      Reserved_7_7 at 0 range 7 .. 7;
      LBCL         at 0 range 8 .. 8;
      CPHA         at 0 range 9 .. 9;
      CPOL         at 0 range 10 .. 10;
      CLKEN        at 0 range 11 .. 11;
      STOP         at 0 range 12 .. 13;
      LINEN        at 0 range 14 .. 14;
   end record;

   --  Control register 3
   type CR3_Register is record
      --  Error interrupt enable
      EIE            : Boolean;
      --  IrDA mode enable
      IREN           : Boolean;
      --  IrDA low-power
      IRLP           : Boolean;
      --  Half-duplex selection
      HDSEL          : Boolean;
      --  Smartcard NACK enable
      NACK           : Boolean;
      --  Smartcard mode enable
      SCEN           : Boolean;
      --  DMA enable receiver
      DMAR           : Boolean;
      --  DMA enable transmitter
      DMAT           : Boolean;
      --  RTS enable
      RTSE           : Boolean;
      --  CTS enable
      CTSE           : Boolean;
      --  CTS interrupt enable
      CTSIE          : Boolean;
      --  One sample bit method enable
      ONEBIT         : Boolean;
      --  unspecified
      Reserved_12_15 : Interfaces.Unsigned_32 range 0 .. 15;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

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
      Reserved_12_15 at 0 range 12 .. 15;
   end record;

   --  Guard time and prescaler register
   type GTPR_Register is record
      --  Prescaler value
      PSC : Interfaces.Unsigned_32 range 0 .. 255;
      --  Guard time value
      GT  : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 16, Bit_Order => System.Low_Order_First;

   for GTPR_Register use record
      PSC at 0 range 0 .. 7;
      GT  at 0 range 8 .. 15;
   end record;

   --  Universal synchronous asynchronous receiver transmitter
   type USART_Peripheral is record
      --  Status register
      SR   : aliased SR_Register;
      pragma Volatile_Full_Access (SR);
      --  Data register
      DR  : aliased Interfaces.Unsigned_32 range 0 .. 511;
      pragma Volatile_Full_Access (DR);
      --  Baud rate register
      BRR  : aliased BRR_Register;
      pragma Volatile_Full_Access (BRR);
      --  Control register 1
      CR1  : aliased CR1_Register;
      pragma Volatile_Full_Access (CR1);
      --  Control register 2
      CR2  : aliased CR2_Register;
      pragma Volatile_Full_Access (CR2);
      --  Control register 3
      CR3  : aliased CR3_Register;
      pragma Volatile_Full_Access (CR3);
      --  Guard time and prescaler register
      GTPR : aliased GTPR_Register;
      pragma Volatile_Full_Access (GTPR);
   end record
     with Volatile;

   for USART_Peripheral use record
      SR   at 16#0# range 0 .. 31;
      DR   at 16#4# range 0 .. 31;
      BRR  at 16#8# range 0 .. 15;
      CR1  at 16#C# range 0 .. 15;
      CR2  at 16#10# range 0 .. 15;
      CR3  at 16#14# range 0 .. 15;
      GTPR at 16#18# range 0 .. 15;
   end record;

   --  Universal synchronous asynchronous receiver transmitter

   USART1_Periph : aliased USART_Peripheral
     with Import, Address => USART1_Base;

   USART2_Periph : aliased USART_Peripheral
     with Import, Address => USART2_Base;

   USART3_Periph : aliased USART_Peripheral
     with Import, Address => USART3_Base;

   UART4_Periph : aliased USART_Peripheral
     with Import, Address => UART4_Base;

   UART5_Periph : aliased USART_Peripheral
     with Import, Address => UART5_Base;

   USART6_Periph : aliased USART_Peripheral
     with Import, Address => USART6_Base;

   UART7_Base : constant System.Address := System'To_Address (16#40007800#);
   UART8_Base : constant System.Address := System'To_Address (16#40007C00#);

   UART7_Periph : aliased USART_Peripheral
     with Import, Address => UART7_Base;

   UART8_Periph : aliased USART_Peripheral
     with Import, Address => UART8_Base;

end STM32.Registers.USART;
