--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F40x.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.SDIO is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  PWRCTRL
   type POWER_PWRCTRL_Field is
     --  The clock to card is stopped.
     (Power_OFF,
      --  The card is clocked.
      Power_ON)
     with Size => 2;
   for POWER_PWRCTRL_Field use
     (Power_OFF => 0,
      Power_ON => 3);

   --  power control register
   type POWER_Register is record
      --  PWRCTRL
      PWRCTRL       : POWER_PWRCTRL_Field;
      --  unspecified
      Reserved_2_31 : Interfaces.Unsigned_32 range 0 .. 1073741823;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for POWER_Register use record
      PWRCTRL       at 0 range 0 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   --  Wide bus mode enable bit
   type CLKCR_WIDBUS_Field is
     --  Default bus mode: SDMMC_D0 is used.
     (Bus_Wide_1b,
      --  4-wide bus mode: SDMMC_D[3:0] used.
      Bus_Wide_4b,
      --  8-wide bus mode: SDMMC_D[7:0] used.
      Bus_Wide_8b)
     with Size => 2;
   for CLKCR_WIDBUS_Field use
     (Bus_Wide_1b => 0,
      Bus_Wide_4b => 1,
      Bus_Wide_8b => 2);

   --  SDIO_CK dephasing selection bit
   type CLKCR_NEGEDGE_Field is
     --  Cmd and Data changed on the SDMMCCLK falling edge succeeding the
     --  rising edge of SDMMC_CK.
     (Edge_Rising,
      --  Cmd and Data changed on the SDMMC_CK falling edge.
      Edge_Falling)
     with Size => 1;
   for CLKCR_NEGEDGE_Field use
     (Edge_Rising => 0,
      Edge_Falling => 1);

   --  SDI clock control register
   type CLKCR_Register is record
      --  Clock divide factor
      CLKDIV         : Interfaces.Unsigned_32 range 0 .. 255;
      --  Clock enable bit
      CLKEN          : Boolean;
      --  Power saving configuration bit
      PWRSAV         : Boolean;
      --  Clock divider bypass enable bit
      BYPASS         : Boolean;
      --  Wide bus mode enable bit
      WIDBUS         : CLKCR_WIDBUS_Field;
      --  SDIO_CK dephasing selection bit
      NEGEDGE        : CLKCR_NEGEDGE_Field;
      --  HW Flow Control enable
      HWFC_EN        : Boolean;
      --  unspecified
      Reserved_15_31 : Interfaces.Unsigned_32 range 0 .. 131071;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CLKCR_Register use record
      CLKDIV         at 0 range 0 .. 7;
      CLKEN          at 0 range 8 .. 8;
      PWRSAV         at 0 range 9 .. 9;
      BYPASS         at 0 range 10 .. 10;
      WIDBUS         at 0 range 11 .. 12;
      NEGEDGE        at 0 range 13 .. 13;
      HWFC_EN        at 0 range 14 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   --  Wait for response bits
   type CMD_WAITRESP_Field is
     --  No response, expect CMDSENT flag.
     (No_Response,
      --  Short response, expect CMDREND or CCRCFAIL flag.
      Short_Response,
      --  Long response, expect CMDREND or CCRCFAIL flag.
      Long_Response)
     with Size => 2;
   for CMD_WAITRESP_Field use
     (No_Response => 0,
      Short_Response => 1,
      Long_Response => 3);

   --  command register
   type CMD_Register is record
      --  Command index
      CMDINDEX       : Interfaces.Unsigned_32 range 0 .. 63;
      --  Wait for response bits
      WAITRESP       : CMD_WAITRESP_Field;
      --  CPSM waits for interrupt request
      WAITINT        : Boolean;
      --  CPSM Waits for ends of data transfer (CmdPend internal signal).
      WAITPEND       : Boolean;
      --  Command path state machine (CPSM) Enable bit
      CPSMEN         : Boolean;
      --  SD I/O suspend command
      SDIOSuspend    : Boolean;
      --  Enable CMD completion
      ENCMDcompl     : Boolean;
      --  not Interrupt Enable
      nIEN           : Boolean;
      --  CE-ATA command
      CE_ATACMD      : Boolean;
      --  unspecified
      Reserved_15_31 : Interfaces.Unsigned_32 range 0 .. 131071;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CMD_Register use record
      CMDINDEX       at 0 range 0 .. 5;
      WAITRESP       at 0 range 6 .. 7;
      WAITINT        at 0 range 8 .. 8;
      WAITPEND       at 0 range 9 .. 9;
      CPSMEN         at 0 range 10 .. 10;
      SDIOSuspend    at 0 range 11 .. 11;
      ENCMDcompl     at 0 range 12 .. 12;
      nIEN           at 0 range 13 .. 13;
      CE_ATACMD      at 0 range 14 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   --  command response register
   type RESPCMD_Register is record
      --  Read-only. Response command index
      RESPCMD       : Interfaces.Unsigned_32 range 0 .. 63;
      --  unspecified
      Reserved_6_31 : Interfaces.Unsigned_32 range 0 .. 67108863;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for RESPCMD_Register use record
      RESPCMD       at 0 range 0 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   --  data length register
   type DLEN_Register is record
      --  Data length value
      DATALENGTH     : Interfaces.Unsigned_32 range 0 .. 33554431;
      --  unspecified
      Reserved_25_31 : Interfaces.Unsigned_32 range 0 .. 127;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DLEN_Register use record
      DATALENGTH     at 0 range 0 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Data transfer direction selection
   type DCTRL_DTDIR_Field is
     --  Data is sent to the card
     (Controller_To_Card,
      --  Data is read from the card
      Card_To_Controller)
     with Size => 1;
   for DCTRL_DTDIR_Field use
     (Controller_To_Card => 0,
      Card_To_Controller => 1);

   --  Data transfer mode selection 1: Stream or SDIO multibyte data transfer.
   type DCTRL_DTMODE_Field is
     --  Block data transfer
     (Block,
      --  Stream or SDIO multibyte data transfer
      Stream)
     with Size => 1;
   for DCTRL_DTMODE_Field use
     (Block => 0,
      Stream => 1);

   --  Data block size
   type DCTRL_DBLOCKSIZE_Field is
     --  Block length = 2**0 = 1 byte
     (Block_1b,
      --  Block length = 2**1 = 2 byte
      Block_2b,
      --  Block length = 2**2 = 4 byte
      Block_4b,
      --  Block length = 2**3 = 8 byte
      Block_8b,
      --  Block length = 2**4 = 16 byte
      Block_16b,
      --  Block length = 2**5 = 32 byte
      Block_32b,
      --  Block length = 2**6 = 64 byte
      Block_64b,
      --  Block length = 2**7 = 128 byte
      Block_128b,
      --  Block length = 2**8 = 256 byte
      Block_256b,
      --  Block length = 2**9 = 512 byte
      Block_512b,
      --  Block length = 2**10 = 1024 byte
      Block_1024b,
      --  Block length = 2**11 = 2048 byte
      Block_2048b,
      --  Block length = 2**12 = 4096 byte
      Block_4096b,
      --  Block length = 2**13 = 8192 byte
      Block_8192b,
      --  Block length = 2**14 = 16384 byte
      Block_16384b)
     with Size => 4;
   for DCTRL_DBLOCKSIZE_Field use
     (Block_1b => 0,
      Block_2b => 1,
      Block_4b => 2,
      Block_8b => 3,
      Block_16b => 4,
      Block_32b => 5,
      Block_64b => 6,
      Block_128b => 7,
      Block_256b => 8,
      Block_512b => 9,
      Block_1024b => 10,
      Block_2048b => 11,
      Block_4096b => 12,
      Block_8192b => 13,
      Block_16384b => 14);

   --  data control register
   type DCTRL_Register is record
      --  DTEN
      DTEN           : Boolean;
      --  Data transfer direction selection
      DTDIR          : DCTRL_DTDIR_Field;
      --  Data transfer mode selection 1: Stream or SDIO multibyte data
      --  transfer.
      DTMODE         : DCTRL_DTMODE_Field;
      --  DMA enable bit
      DMAEN          : Boolean;
      --  Data block size
      DBLOCKSIZE     : DCTRL_DBLOCKSIZE_Field;
      --  Read wait start
      RWSTART        : Boolean;
      --  Read wait stop
      RWSTOP         : Boolean;
      --  Read wait mode
      RWMOD          : Boolean;
      --  SD I/O enable functions
      SDIOEN         : Boolean;
      --  unspecified
      Reserved_12_31 : Interfaces.Unsigned_32 range 0 .. 1048575;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DCTRL_Register use record
      DTEN           at 0 range 0 .. 0;
      DTDIR          at 0 range 1 .. 1;
      DTMODE         at 0 range 2 .. 2;
      DMAEN          at 0 range 3 .. 3;
      DBLOCKSIZE     at 0 range 4 .. 7;
      RWSTART        at 0 range 8 .. 8;
      RWSTOP         at 0 range 9 .. 9;
      RWMOD          at 0 range 10 .. 10;
      SDIOEN         at 0 range 11 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   --  data counter register
   type DCOUNT_Register is record
      --  Read-only. Data count value
      DATACOUNT      : Interfaces.Unsigned_32 range 0 .. 33554431;
      --  unspecified
      Reserved_25_31 : Interfaces.Unsigned_32 range 0 .. 127;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for DCOUNT_Register use record
      DATACOUNT      at 0 range 0 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  status register
   type STA_Register is record
      --  Read-only. Command response received (CRC check failed)
      CCRCFAIL       : Boolean;
      --  Read-only. Data block sent/received (CRC check failed)
      DCRCFAIL       : Boolean;
      --  Read-only. Command response timeout
      CTIMEOUT       : Boolean;
      --  Read-only. Data timeout
      DTIMEOUT       : Boolean;
      --  Read-only. Transmit FIFO underrun error
      TXUNDERR       : Boolean;
      --  Read-only. Received FIFO overrun error
      RXOVERR        : Boolean;
      --  Read-only. Command response received (CRC check passed)
      CMDREND        : Boolean;
      --  Read-only. Command sent (no response required)
      CMDSENT        : Boolean;
      --  Read-only. Data end (data counter, SDIDCOUNT, is zero)
      DATAEND        : Boolean;
      --  Read-only. Start bit not detected on all data signals in wide bus
      --  mode
      STBITERR       : Boolean;
      --  Read-only. Data block sent/received (CRC check passed)
      DBCKEND        : Boolean;
      --  Read-only. Command transfer in progress
      CMDACT         : Boolean;
      --  Read-only. Data transmit in progress
      TXACT          : Boolean;
      --  Read-only. Data receive in progress
      RXACT          : Boolean;
      --  Read-only. Transmit FIFO half empty: at least 8 words can be written
      --  into the FIFO
      TXFIFOHE       : Boolean;
      --  Read-only. Receive FIFO half full: there are at least 8 words in the
      --  FIFO
      RXFIFOHF       : Boolean;
      --  Read-only. Transmit FIFO full
      TXFIFOF        : Boolean;
      --  Read-only. Receive FIFO full
      RXFIFOF        : Boolean;
      --  Read-only. Transmit FIFO empty
      TXFIFOE        : Boolean;
      --  Read-only. Receive FIFO empty
      RXFIFOE        : Boolean;
      --  Read-only. Data available in transmit FIFO
      TXDAVL         : Boolean;
      --  Read-only. Data available in receive FIFO
      RXDAVL         : Boolean;
      --  Read-only. SDIO interrupt received
      SDIOIT         : Boolean;
      --  Read-only. CE-ATA command completion signal received for CMD61
      CEATAEND       : Boolean;
      --  unspecified
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for STA_Register use record
      CCRCFAIL       at 0 range 0 .. 0;
      DCRCFAIL       at 0 range 1 .. 1;
      CTIMEOUT       at 0 range 2 .. 2;
      DTIMEOUT       at 0 range 3 .. 3;
      TXUNDERR       at 0 range 4 .. 4;
      RXOVERR        at 0 range 5 .. 5;
      CMDREND        at 0 range 6 .. 6;
      CMDSENT        at 0 range 7 .. 7;
      DATAEND        at 0 range 8 .. 8;
      STBITERR       at 0 range 9 .. 9;
      DBCKEND        at 0 range 10 .. 10;
      CMDACT         at 0 range 11 .. 11;
      TXACT          at 0 range 12 .. 12;
      RXACT          at 0 range 13 .. 13;
      TXFIFOHE       at 0 range 14 .. 14;
      RXFIFOHF       at 0 range 15 .. 15;
      TXFIFOF        at 0 range 16 .. 16;
      RXFIFOF        at 0 range 17 .. 17;
      TXFIFOE        at 0 range 18 .. 18;
      RXFIFOE        at 0 range 19 .. 19;
      TXDAVL         at 0 range 20 .. 20;
      RXDAVL         at 0 range 21 .. 21;
      SDIOIT         at 0 range 22 .. 22;
      CEATAEND       at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  interrupt clear register
   type ICR_Register is record
      --  CCRCFAIL flag clear bit
      CCRCFAILC      : Boolean;
      --  DCRCFAIL flag clear bit
      DCRCFAILC      : Boolean;
      --  CTIMEOUT flag clear bit
      CTIMEOUTC      : Boolean;
      --  DTIMEOUT flag clear bit
      DTIMEOUTC      : Boolean;
      --  TXUNDERR flag clear bit
      TXUNDERRC      : Boolean;
      --  RXOVERR flag clear bit
      RXOVERRC       : Boolean;
      --  CMDREND flag clear bit
      CMDRENDC       : Boolean;
      --  CMDSENT flag clear bit
      CMDSENTC       : Boolean;
      --  DATAEND flag clear bit
      DATAENDC       : Boolean;
      --  STBITERR flag clear bit
      STBITERRC      : Boolean;
      --  DBCKEND flag clear bit
      DBCKENDC       : Boolean;
      --  unspecified
      Reserved_11_21 : Interfaces.Unsigned_32 range 0 .. 2047;
      --  SDIOIT flag clear bit
      SDIOITC        : Boolean;
      --  CEATAEND flag clear bit
      CEATAENDC      : Boolean;
      --  unspecified
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for ICR_Register use record
      CCRCFAILC      at 0 range 0 .. 0;
      DCRCFAILC      at 0 range 1 .. 1;
      CTIMEOUTC      at 0 range 2 .. 2;
      DTIMEOUTC      at 0 range 3 .. 3;
      TXUNDERRC      at 0 range 4 .. 4;
      RXOVERRC       at 0 range 5 .. 5;
      CMDRENDC       at 0 range 6 .. 6;
      CMDSENTC       at 0 range 7 .. 7;
      DATAENDC       at 0 range 8 .. 8;
      STBITERRC      at 0 range 9 .. 9;
      DBCKENDC       at 0 range 10 .. 10;
      Reserved_11_21 at 0 range 11 .. 21;
      SDIOITC        at 0 range 22 .. 22;
      CEATAENDC      at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  mask register
   type MASK_Register is record
      --  Command CRC fail interrupt enable
      CCRCFAILIE     : Boolean;
      --  Data CRC fail interrupt enable
      DCRCFAILIE     : Boolean;
      --  Command timeout interrupt enable
      CTIMEOUTIE     : Boolean;
      --  Data timeout interrupt enable
      DTIMEOUTIE     : Boolean;
      --  Tx FIFO underrun error interrupt enable
      TXUNDERRIE     : Boolean;
      --  Rx FIFO overrun error interrupt enable
      RXOVERRIE      : Boolean;
      --  Command response received interrupt enable
      CMDRENDIE      : Boolean;
      --  Command sent interrupt enable
      CMDSENTIE      : Boolean;
      --  Data end interrupt enable
      DATAENDIE      : Boolean;
      --  Start bit error interrupt enable
      STBITERRIE     : Boolean;
      --  Data block end interrupt enable
      DBCKENDIE      : Boolean;
      --  Command acting interrupt enable
      CMDACTIE       : Boolean;
      --  Data transmit acting interrupt enable
      TXACTIE        : Boolean;
      --  Data receive acting interrupt enable
      RXACTIE        : Boolean;
      --  Tx FIFO half empty interrupt enable
      TXFIFOHEIE     : Boolean;
      --  Rx FIFO half full interrupt enable
      RXFIFOHFIE     : Boolean;
      --  Tx FIFO full interrupt enable
      TXFIFOFIE      : Boolean;
      --  Rx FIFO full interrupt enable
      RXFIFOFIE      : Boolean;
      --  Tx FIFO empty interrupt enable
      TXFIFOEIE      : Boolean;
      --  Rx FIFO empty interrupt enable
      RXFIFOEIE      : Boolean;
      --  Data available in Tx FIFO interrupt enable
      TXDAVLIE       : Boolean;
      --  Data available in Rx FIFO interrupt enable
      RXDAVLIE       : Boolean;
      --  SDIO mode interrupt received interrupt enable
      SDIOITIE       : Boolean;
      --  CE-ATA command completion signal received interrupt enable
      CEATAENDIE     : Boolean;
      --  unspecified
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for MASK_Register use record
      CCRCFAILIE     at 0 range 0 .. 0;
      DCRCFAILIE     at 0 range 1 .. 1;
      CTIMEOUTIE     at 0 range 2 .. 2;
      DTIMEOUTIE     at 0 range 3 .. 3;
      TXUNDERRIE     at 0 range 4 .. 4;
      RXOVERRIE      at 0 range 5 .. 5;
      CMDRENDIE      at 0 range 6 .. 6;
      CMDSENTIE      at 0 range 7 .. 7;
      DATAENDIE      at 0 range 8 .. 8;
      STBITERRIE     at 0 range 9 .. 9;
      DBCKENDIE      at 0 range 10 .. 10;
      CMDACTIE       at 0 range 11 .. 11;
      TXACTIE        at 0 range 12 .. 12;
      RXACTIE        at 0 range 13 .. 13;
      TXFIFOHEIE     at 0 range 14 .. 14;
      RXFIFOHFIE     at 0 range 15 .. 15;
      TXFIFOFIE      at 0 range 16 .. 16;
      RXFIFOFIE      at 0 range 17 .. 17;
      TXFIFOEIE      at 0 range 18 .. 18;
      RXFIFOEIE      at 0 range 19 .. 19;
      TXDAVLIE       at 0 range 20 .. 20;
      RXDAVLIE       at 0 range 21 .. 21;
      SDIOITIE       at 0 range 22 .. 22;
      CEATAENDIE     at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  FIFO counter register
   type FIFOCNT_Register is record
      --  Read-only. Remaining number of words to be written to or read from
      --  the FIFO.
      FIFOCOUNT      : Interfaces.Unsigned_32 range 0 .. 16777215;
      --  unspecified
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for FIFOCNT_Register use record
      FIFOCOUNT      at 0 range 0 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Secure digital input/output interface
   type SDIO_Peripheral is record
      --  power control register
      POWER   : aliased POWER_Register;
      pragma Volatile_Full_Access (POWER);
      --  SDI clock control register
      CLKCR   : aliased CLKCR_Register;
      pragma Volatile_Full_Access (CLKCR);
      --  argument register
      ARG     : aliased Interfaces.Unsigned_32;
      --  command register
      CMD     : aliased CMD_Register;
      pragma Volatile_Full_Access (CMD);
      --  command response register
      RESPCMD : aliased RESPCMD_Register;
      pragma Volatile_Full_Access (RESPCMD);
      --  response 1..4 register
      RESP1   : aliased Interfaces.Unsigned_32;
      --  response 1..4 register
      RESP2   : aliased Interfaces.Unsigned_32;
      --  response 1..4 register
      RESP3   : aliased Interfaces.Unsigned_32;
      --  response 1..4 register
      RESP4   : aliased Interfaces.Unsigned_32;
      --  data timer register
      DTIMER  : aliased Interfaces.Unsigned_32;
      --  data length register
      DLEN    : aliased DLEN_Register;
      pragma Volatile_Full_Access (DLEN);
      --  data control register
      DCTRL   : aliased DCTRL_Register;
      pragma Volatile_Full_Access (DCTRL);
      --  data counter register
      DCOUNT  : aliased DCOUNT_Register;
      pragma Volatile_Full_Access (DCOUNT);
      --  status register
      STA     : aliased STA_Register;
      pragma Volatile_Full_Access (STA);
      --  interrupt clear register
      ICR     : aliased ICR_Register;
      pragma Volatile_Full_Access (ICR);
      --  mask register
      MASK    : aliased MASK_Register;
      pragma Volatile_Full_Access (MASK);
      --  FIFO counter register
      FIFOCNT : aliased FIFOCNT_Register;
      pragma Volatile_Full_Access (FIFOCNT);
      --  data FIFO register
      FIFO    : aliased Interfaces.Unsigned_32;
   end record
     with Volatile;

   for SDIO_Peripheral use record
      POWER   at 16#0# range 0 .. 31;
      CLKCR   at 16#4# range 0 .. 31;
      ARG     at 16#8# range 0 .. 31;
      CMD     at 16#C# range 0 .. 31;
      RESPCMD at 16#10# range 0 .. 31;
      RESP1   at 16#14# range 0 .. 31;
      RESP2   at 16#18# range 0 .. 31;
      RESP3   at 16#1C# range 0 .. 31;
      RESP4   at 16#20# range 0 .. 31;
      DTIMER  at 16#24# range 0 .. 31;
      DLEN    at 16#28# range 0 .. 31;
      DCTRL   at 16#2C# range 0 .. 31;
      DCOUNT  at 16#30# range 0 .. 31;
      STA     at 16#34# range 0 .. 31;
      ICR     at 16#38# range 0 .. 31;
      MASK    at 16#3C# range 0 .. 31;
      FIFOCNT at 16#48# range 0 .. 31;
      FIFO    at 16#80# range 0 .. 31;
   end record;

   --  Secure digital input/output interface
   SDIO_Periph : aliased SDIO_Peripheral
     with Import, Address => SDIO_Base;

end STM32.Registers.SDIO;
