
--  This spec has been automatically generated from STM32F411.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.RTC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   type TR_Register is record
      SU             : Interfaces.Unsigned_32 range 0 .. 15;
      --   Second units in BCD format
      ST             : Interfaces.Unsigned_32 range 0 .. 7;
      --   Second tens in BCD format
      Reserved_7_7   : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      MNU            : Interfaces.Unsigned_32 range 0 .. 15;
      --   Minute units in BCD format
      MNT            : Interfaces.Unsigned_32 range 0 .. 7;
      --   Minute tens in BCD format
      Reserved_15_15 : Interfaces.Unsigned_32 range 0 .. 1 := 0;
      HU             : Interfaces.Unsigned_32 range 0 .. 15;
      --   Hour units in BCD format
      HT             : Interfaces.Unsigned_32 range 0 .. 3;
      --   Hour tens in BCD format
      PM             : Boolean;
      --   AM/PM notation
      Reserved_23_31 : Interfaces.Unsigned_32 range 0 .. 511 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   time register
   --  Access: read-write
   --  Reset value: 0x00000000

   for TR_Register use record
      SU             at 0 range 0 .. 3;
      ST             at 0 range 4 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      MNU            at 0 range 8 .. 11;
      MNT            at 0 range 12 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      HU             at 0 range 16 .. 19;
      HT             at 0 range 20 .. 21;
      PM             at 0 range 22 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   type DR_Register is record
      DU             : Interfaces.Unsigned_32 range 0 .. 15;
      --   Date units in BCD format
      DT             : Interfaces.Unsigned_32 range 0 .. 3;
      --   Date tens in BCD format
      Reserved_6_7   : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      MU             : Interfaces.Unsigned_32 range 0 .. 15;
      --   Month units in BCD format
      MT             : Boolean;
      --   Month tens in BCD format
      WDU            : Interfaces.Unsigned_32 range 0 .. 7;
      --   Week day units
      YU             : Interfaces.Unsigned_32 range 0 .. 15;
      --   Year units in BCD format
      YT             : Interfaces.Unsigned_32 range 0 .. 15;
      --   Year tens in BCD format
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   date register
   --  Access: read-write
   --  Reset value: 0x00002101

   for DR_Register use record
      DU             at 0 range 0 .. 3;
      DT             at 0 range 4 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      MU             at 0 range 8 .. 11;
      MT             at 0 range 12 .. 12;
      WDU            at 0 range 13 .. 15;
      YU             at 0 range 16 .. 19;
      YT             at 0 range 20 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   type CR_Register is record
      WCKSEL         : Interfaces.Unsigned_32 range 0 .. 7;
      --   Wakeup clock selection
      TSEDGE         : Boolean;
      --   Time-stamp event active edge
      REFCKON        : Boolean;
      --   Reference clock detection enable (50 or 60 Hz)
      BYPSHAD        : Boolean;
      --   Bypass the shadow registers
      FMT            : Boolean;
      --   Hour format
      DCE            : Boolean;
      --   Coarse digital calibration enable
      ALRAE          : Boolean;
      --   Alarm A enable
      ALRBE          : Boolean;
      --   Alarm B enable
      WUTE           : Boolean;
      --   Wakeup timer enable
      TSE            : Boolean;
      --   Time stamp enable
      ALRAIE         : Boolean;
      --   Alarm A interrupt enable
      ALRBIE         : Boolean;
      --   Alarm B interrupt enable
      WUTIE          : Boolean;
      --   Wakeup timer interrupt enable
      TSIE           : Boolean;
      --   Time-stamp interrupt enable
      ADD1H          : Boolean;
      --   Add 1 hour (summer time change)
      SUB1H          : Boolean;
      --   Subtract 1 hour (winter time change)
      BKP            : Boolean;
      --   Backup
      COSEL          : Boolean;
      --   Calibration Output selection
      POL            : Boolean;
      --   Output polarity
      OSEL           : Interfaces.Unsigned_32 range 0 .. 3;
      --   Output selection
      COE            : Boolean;
      --   Calibration output enable
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   control register
   --  Access: read-write
   --  Reset value: 0x00000000

   for CR_Register use record
      WCKSEL         at 0 range 0 .. 2;
      TSEDGE         at 0 range 3 .. 3;
      REFCKON        at 0 range 4 .. 4;
      BYPSHAD        at 0 range 5 .. 5;
      FMT            at 0 range 6 .. 6;
      DCE            at 0 range 7 .. 7;
      ALRAE          at 0 range 8 .. 8;
      ALRBE          at 0 range 9 .. 9;
      WUTE           at 0 range 10 .. 10;
      TSE            at 0 range 11 .. 11;
      ALRAIE         at 0 range 12 .. 12;
      ALRBIE         at 0 range 13 .. 13;
      WUTIE          at 0 range 14 .. 14;
      TSIE           at 0 range 15 .. 15;
      ADD1H          at 0 range 16 .. 16;
      SUB1H          at 0 range 17 .. 17;
      BKP            at 0 range 18 .. 18;
      COSEL          at 0 range 19 .. 19;
      POL            at 0 range 20 .. 20;
      OSEL           at 0 range 21 .. 22;
      COE            at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   type ISR_Register is record
      ALRAWF         : Boolean;
      --   Alarm A write flag
      ALRBWF         : Boolean;
      --   Alarm B write flag
      WUTWF          : Boolean;
      --   Wakeup timer write flag
      SHPF           : Boolean;
      --   Shift operation pending
      INITS          : Boolean;
      --   Initialization status flag
      RSF            : Boolean;
      --   Registers synchronization flag
      INITF          : Boolean;
      --   Initialization flag
      INIT           : Boolean;
      --   Initialization mode
      ALRAF          : Boolean;
      --   Alarm A flag
      ALRBF          : Boolean;
      --   Alarm B flag
      WUTF           : Boolean;
      --   Wakeup timer flag
      TSF            : Boolean;
      --   Time-stamp flag
      TSOVF          : Boolean;
      --   Time-stamp overflow flag
      TAMP1F         : Boolean;
      --   Tamper detection flag
      TAMP2F         : Boolean;
      --   TAMPER2 detection flag
      Reserved_15_15 : Boolean := False;
      RECALPF        : Boolean;
      --   Recalibration pending Flag
      Reserved_17_31 : Interfaces.Unsigned_32 range 0 .. 32767 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   initialization and status register
   --  Reset value: 0x00000007

   for ISR_Register use record
      ALRAWF         at 0 range 0 .. 0;
      ALRBWF         at 0 range 1 .. 1;
      WUTWF          at 0 range 2 .. 2;
      SHPF           at 0 range 3 .. 3;
      INITS          at 0 range 4 .. 4;
      RSF            at 0 range 5 .. 5;
      INITF          at 0 range 6 .. 6;
      INIT           at 0 range 7 .. 7;
      ALRAF          at 0 range 8 .. 8;
      ALRBF          at 0 range 9 .. 9;
      WUTF           at 0 range 10 .. 10;
      TSF            at 0 range 11 .. 11;
      TSOVF          at 0 range 12 .. 12;
      TAMP1F         at 0 range 13 .. 13;
      TAMP2F         at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      RECALPF        at 0 range 16 .. 16;
      Reserved_17_31 at 0 range 17 .. 31;
   end record;

   type PRER_Register is record
      PREDIV_S       : Interfaces.Unsigned_32 range 0 .. 32767;
      --   Synchronous prescaler factor
      Reserved_15_15 : Boolean := False;
      PREDIV_A       : Interfaces.Unsigned_32 range 0 .. 127;
      --   Asynchronous prescaler factor
      Reserved_23_31 : Interfaces.Unsigned_32 range 0 .. 511 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   prescaler register
   --  Access: read-write
   --  Reset value: 0x007F00FF

   for PRER_Register use record
      PREDIV_S       at 0 range 0 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      PREDIV_A       at 0 range 16 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   type WUTR_Register is record
      WUT            : Interfaces.Unsigned_32 range 0 .. 65535;
      --   Wakeup auto-reload value bits
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   wakeup timer register
   --  Access: read-write
   --  Reset value: 0x0000FFFF

   for WUTR_Register use record
      WUT            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   type CALIBR_Register is record
      DC            : Interfaces.Unsigned_32 range 0 .. 31;
      --   Digital calibration
      Reserved_5_6  : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      DCS           : Boolean;
      --   Digital calibration sign
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   calibration register
   --  Access: read-write
   --  Reset value: 0x00000000

   for CALIBR_Register use record
      DC            at 0 range 0 .. 4;
      Reserved_5_6  at 0 range 5 .. 6;
      DCS           at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   type ALRMAR_Register is record
      SU    : Interfaces.Unsigned_32 range 0 .. 15;
      --   Second units in BCD format
      ST    : Interfaces.Unsigned_32 range 0 .. 7;
      --   Second tens in BCD format
      MSK1  : Boolean;
      --   Alarm A seconds mask
      MNU   : Interfaces.Unsigned_32 range 0 .. 15;
      --   Minute units in BCD format
      MNT   : Interfaces.Unsigned_32 range 0 .. 7;
      --   Minute tens in BCD format
      MSK2  : Boolean;
      --   Alarm A minutes mask
      HU    : Interfaces.Unsigned_32 range 0 .. 15;
      --   Hour units in BCD format
      HT    : Interfaces.Unsigned_32 range 0 .. 3;
      --   Hour tens in BCD format
      PM    : Boolean;
      --   AM/PM notation
      MSK3  : Boolean;
      --   Alarm A hours mask
      DU    : Interfaces.Unsigned_32 range 0 .. 15;
      --   Date units or day in BCD format
      DT    : Interfaces.Unsigned_32 range 0 .. 3;
      --   Date tens in BCD format
      WDSEL : Boolean;
      --   Week day selection
      MSK4  : Boolean;
      --   Alarm A date mask
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   alarm A register
   --  Access: read-write
   --  Reset value: 0x00000000

   for ALRMAR_Register use record
      SU    at 0 range 0 .. 3;
      ST    at 0 range 4 .. 6;
      MSK1  at 0 range 7 .. 7;
      MNU   at 0 range 8 .. 11;
      MNT   at 0 range 12 .. 14;
      MSK2  at 0 range 15 .. 15;
      HU    at 0 range 16 .. 19;
      HT    at 0 range 20 .. 21;
      PM    at 0 range 22 .. 22;
      MSK3  at 0 range 23 .. 23;
      DU    at 0 range 24 .. 27;
      DT    at 0 range 28 .. 29;
      WDSEL at 0 range 30 .. 30;
      MSK4  at 0 range 31 .. 31;
   end record;

   type ALRMBR_Register is record
      SU    : Interfaces.Unsigned_32 range 0 .. 15;
      --   Second units in BCD format
      ST    : Interfaces.Unsigned_32 range 0 .. 7;
      --   Second tens in BCD format
      MSK1  : Boolean;
      --   Alarm B seconds mask
      MNU   : Interfaces.Unsigned_32 range 0 .. 15;
      --   Minute units in BCD format
      MNT   : Interfaces.Unsigned_32 range 0 .. 7;
      --   Minute tens in BCD format
      MSK2  : Boolean;
      --   Alarm B minutes mask
      HU    : Interfaces.Unsigned_32 range 0 .. 15;
      --   Hour units in BCD format
      HT    : Interfaces.Unsigned_32 range 0 .. 3;
      --   Hour tens in BCD format
      PM    : Boolean;
      --   AM/PM notation
      MSK3  : Boolean;
      --   Alarm B hours mask
      DU    : Interfaces.Unsigned_32 range 0 .. 15;
      --   Date units or day in BCD format
      DT    : Interfaces.Unsigned_32 range 0 .. 3;
      --   Date tens in BCD format
      WDSEL : Boolean;
      --   Week day selection
      MSK4  : Boolean;
      --   Alarm B date mask
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   alarm B register
   --  Access: read-write
   --  Reset value: 0x00000000

   for ALRMBR_Register use record
      SU    at 0 range 0 .. 3;
      ST    at 0 range 4 .. 6;
      MSK1  at 0 range 7 .. 7;
      MNU   at 0 range 8 .. 11;
      MNT   at 0 range 12 .. 14;
      MSK2  at 0 range 15 .. 15;
      HU    at 0 range 16 .. 19;
      HT    at 0 range 20 .. 21;
      PM    at 0 range 22 .. 22;
      MSK3  at 0 range 23 .. 23;
      DU    at 0 range 24 .. 27;
      DT    at 0 range 28 .. 29;
      WDSEL at 0 range 30 .. 30;
      MSK4  at 0 range 31 .. 31;
   end record;

   type WPR_Register is record
      KEY           : Interfaces.Unsigned_32 range 0 .. 255;
      --   Write protection key
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   write protection register
   --  Access: write-only
   --  Reset value: 0x00000000

   for WPR_Register use record
      KEY           at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   type SSR_Register is record
      SS             : Interfaces.Unsigned_32 range 0 .. 65535;
      --   Sub second value
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   sub second register
   --  Access: read-only
   --  Reset value: 0x00000000

   for SSR_Register use record
      SS             at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   type SHIFTR_Register is record
      SUBFS          : Interfaces.Unsigned_32 range 0 .. 32767;
      --   Subtract a fraction of a second
      Reserved_15_30 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
      ADD1S          : Boolean;
      --   Add one second
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   shift control register
   --  Access: write-only
   --  Reset value: 0x00000000

   for SHIFTR_Register use record
      SUBFS          at 0 range 0 .. 14;
      Reserved_15_30 at 0 range 15 .. 30;
      ADD1S          at 0 range 31 .. 31;
   end record;

   type TSTR_Register is record
      SU             : Interfaces.Unsigned_32 range 0 .. 15;
      --   Second units in BCD format
      ST             : Interfaces.Unsigned_32 range 0 .. 7;
      --   Second tens in BCD format
      Reserved_7_7   : Boolean := False;
      MNU            : Interfaces.Unsigned_32 range 0 .. 15;
      --   Minute units in BCD format
      MNT            : Interfaces.Unsigned_32 range 0 .. 7;
      --   Minute tens in BCD format
      Reserved_15_15 : Boolean := False;
      HU             : Interfaces.Unsigned_32 range 0 .. 15;
      --   Hour units in BCD format
      HT             : Interfaces.Unsigned_32 range 0 .. 3;
      --   Hour tens in BCD format
      PM             : Boolean;
      --   AM/PM notation
      Reserved_23_31 : Interfaces.Unsigned_32 range 0 .. 511 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   time stamp time register
   --  Access: read-only
   --  Reset value: 0x00000000

   for TSTR_Register use record
      SU             at 0 range 0 .. 3;
      ST             at 0 range 4 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      MNU            at 0 range 8 .. 11;
      MNT            at 0 range 12 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      HU             at 0 range 16 .. 19;
      HT             at 0 range 20 .. 21;
      PM             at 0 range 22 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   type TSDR_Register is record
      DU             : Interfaces.Unsigned_32 range 0 .. 15;
      --   Date units in BCD format
      DT             : Interfaces.Unsigned_32 range 0 .. 3;
      --   Date tens in BCD format
      Reserved_6_7   : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      MU             : Interfaces.Unsigned_32 range 0 .. 15;
      --   Month units in BCD format
      MT             : Boolean;
      --   Month tens in BCD format
      WDU            : Interfaces.Unsigned_32 range 0 .. 7;
      --   Week day units
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   time stamp date register
   --  Access: read-only
   --  Reset value: 0x00000000

   for TSDR_Register use record
      DU             at 0 range 0 .. 3;
      DT             at 0 range 4 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      MU             at 0 range 8 .. 11;
      MT             at 0 range 12 .. 12;
      WDU            at 0 range 13 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   type TSSSR_Register is record
      SS             : Interfaces.Unsigned_32 range 0 .. 65535;
      --   Sub second value
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   timestamp sub second register
   --  Access: read-only
   --  Reset value: 0x00000000

   for TSSSR_Register use record
      SS             at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   type CALR_Register is record
      CALM           : Interfaces.Unsigned_32 range 0 .. 511;
      --   Calibration minus
      Reserved_9_12  : Interfaces.Unsigned_32 range 0 .. 15 := 0;
      CALW16         : Boolean;
      --   Use a 16-second calibration cycle period
      CALW8          : Boolean;
      --   Use an 8-second calibration cycle period
      CALP           : Boolean;
      --   Increase frequency of RTC by 488.5 ppm
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   calibration register
   --  Access: read-write
   --  Reset value: 0x00000000

   for CALR_Register use record
      CALM           at 0 range 0 .. 8;
      Reserved_9_12  at 0 range 9 .. 12;
      CALW16         at 0 range 13 .. 13;
      CALW8          at 0 range 14 .. 14;
      CALP           at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   type TAFCR_Register is record
      TAMP1E         : Boolean;
      --   Tamper 1 detection enable
      TAMP1TRG       : Boolean;
      --   Active level for tamper 1
      TAMPIE         : Boolean;
      --   Tamper interrupt enable
      TAMP2E         : Boolean;
      --   Tamper 2 detection enable
      TAMP2TRG       : Boolean;
      --   Active level for tamper 2
      Reserved_5_6   : Interfaces.Unsigned_32 range 0 .. 3 := 0;
      TAMPTS         : Boolean;
      --   Activate timestamp on tamper detection event
      TAMPFREQ       : Interfaces.Unsigned_32 range 0 .. 7;
      --   Tamper sampling frequency
      TAMPFLT        : Interfaces.Unsigned_32 range 0 .. 3;
      --   Tamper filter count
      TAMPPRCH       : Interfaces.Unsigned_32 range 0 .. 3;
      --   Tamper precharge duration
      TAMPPUDIS      : Boolean;
      --   TAMPER pull-up disable
      TAMP1INSEL     : Boolean;
      --   TAMPER1 mapping
      TSINSEL        : Boolean;
      --   TIMESTAMP mapping
      ALARMOUTTYPE   : Boolean;
      --   AFO_ALARM output type
      Reserved_19_31 : Interfaces.Unsigned_32 range 0 .. 8191 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   tamper and alternate function configuration register
   --  Access: read-write
   --  Reset value: 0x00000000

   for TAFCR_Register use record
      TAMP1E         at 0 range 0 .. 0;
      TAMP1TRG       at 0 range 1 .. 1;
      TAMPIE         at 0 range 2 .. 2;
      TAMP2E         at 0 range 3 .. 3;
      TAMP2TRG       at 0 range 4 .. 4;
      Reserved_5_6   at 0 range 5 .. 6;
      TAMPTS         at 0 range 7 .. 7;
      TAMPFREQ       at 0 range 8 .. 10;
      TAMPFLT        at 0 range 11 .. 12;
      TAMPPRCH       at 0 range 13 .. 14;
      TAMPPUDIS      at 0 range 15 .. 15;
      TAMP1INSEL     at 0 range 16 .. 16;
      TSINSEL        at 0 range 17 .. 17;
      ALARMOUTTYPE   at 0 range 18 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   type ALRMASSR_Register is record
      SS             : Interfaces.Unsigned_32 range 0 .. 32767;
      --   Sub seconds value
      Reserved_15_23 : Interfaces.Unsigned_32 range 0 .. 511 := 0;
      MASKSS         : Interfaces.Unsigned_32 range 0 .. 15;
      --   Mask the most-significant bits starting at this bit
      Reserved_28_31 : Interfaces.Unsigned_32 range 0 .. 15 := 0;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   alarm A sub second register
   --  Access: read-write
   --  Reset value: 0x00000000

   for ALRMASSR_Register use record
      SS             at 0 range 0 .. 14;
      Reserved_15_23 at 0 range 15 .. 23;
      MASKSS         at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   type ALRMBSSR_Register is record
      SS             : Interfaces.Unsigned_32 range 0 .. 32767;
      --   Sub seconds value
      Reserved_15_23 : Interfaces.Unsigned_32 range 0 .. 511 := 0;
      MASKSS         : Interfaces.Unsigned_32 range 0 .. 15;
      --   Mask the most-significant bits starting at this bit
      Reserved_28_31 : Interfaces.Unsigned_32 range 0 .. 15;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;
   --   alarm B sub second register
   --  Access: read-write
   --  Reset value: 0x00000000

   for ALRMBSSR_Register use record
      SS             at 0 range 0 .. 14;
      Reserved_15_23 at 0 range 15 .. 23;
      MASKSS         at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   type BKPxR_Array is array (0 .. 19) of
     Interfaces.Unsigned_32 range 0 .. 4294967295
       with Component_Size => 32, Size => 640, Volatile;

   -----------------
   -- Peripherals --
   -----------------

   type RTC_Peripheral is record
      TR       : aliased TR_Register;
      pragma Volatile_Full_Access (TR);
      --   time register
      DR       : aliased DR_Register;
      pragma Volatile_Full_Access (DR);
      --   date register
      CR       : aliased CR_Register;
      pragma Volatile_Full_Access (CR);
      --   control register
      ISR      : aliased ISR_Register;
      pragma Volatile_Full_Access (ISR);
      --   initialization and status register
      PRER     : aliased PRER_Register;
      pragma Volatile_Full_Access (PRER);
      --   prescaler register
      WUTR     : aliased WUTR_Register;
      pragma Volatile_Full_Access (WUTR);
      --   wakeup timer register
      CALIBR   : aliased CALIBR_Register;
      pragma Volatile_Full_Access (CALIBR);
      --   calibration register
      ALRMAR   : aliased ALRMAR_Register;
      pragma Volatile_Full_Access (ALRMAR);
      --   alarm A register
      ALRMBR   : aliased ALRMBR_Register;
      pragma Volatile_Full_Access (ALRMBR);
      --   alarm B register
      WPR      : aliased WPR_Register;
      pragma Volatile_Full_Access (WPR);
      --   write protection register
      SSR      : aliased SSR_Register;
      pragma Volatile_Full_Access (SSR);
      --   sub second register
      SHIFTR   : aliased SHIFTR_Register;
      pragma Volatile_Full_Access (SHIFTR);
      --   shift control register
      TSTR     : aliased TSTR_Register;
      pragma Volatile_Full_Access (TSTR);
      --   time stamp time register
      TSDR     : aliased TSDR_Register;
      pragma Volatile_Full_Access (TSDR);
      --   time stamp date register
      TSSSR    : aliased TSSSR_Register;
      pragma Volatile_Full_Access (TSSSR);
      --   timestamp sub second register
      CALR     : aliased CALR_Register;
      pragma Volatile_Full_Access (CALR);
      --   calibration register
      TAFCR    : aliased TAFCR_Register;
      pragma Volatile_Full_Access (TAFCR);
      --   tamper and alternate function configuration register
      ALRMASSR : aliased ALRMASSR_Register;
      pragma Volatile_Full_Access (ALRMASSR);
      --   alarm A sub second register
      ALRMBSSR : aliased ALRMBSSR_Register;
      pragma Volatile_Full_Access (ALRMBSSR);
      --   alarm B sub second register
      BKPxR    : aliased BKPxR_Array;
      --   backup register
   end record
     with Volatile;

   --   Real-time clock
   for RTC_Peripheral use record
      TR       at 16#0# range 0 .. 31;
      DR       at 16#4# range 0 .. 31;
      CR       at 16#8# range 0 .. 31;
      ISR      at 16#C# range 0 .. 31;
      PRER     at 16#10# range 0 .. 31;
      WUTR     at 16#14# range 0 .. 31;
      CALIBR   at 16#18# range 0 .. 31;
      ALRMAR   at 16#1C# range 0 .. 31;
      ALRMBR   at 16#20# range 0 .. 31;
      WPR      at 16#24# range 0 .. 31;
      SSR      at 16#28# range 0 .. 31;
      SHIFTR   at 16#2C# range 0 .. 31;
      TSTR     at 16#30# range 0 .. 31;
      TSDR     at 16#34# range 0 .. 31;
      TSSSR    at 16#38# range 0 .. 31;
      CALR     at 16#3C# range 0 .. 31;
      TAFCR    at 16#40# range 0 .. 31;
      ALRMASSR at 16#44# range 0 .. 31;
      ALRMBSSR at 16#48# range 0 .. 31;
      BKPxR    at 16#50# range 0 .. 639;
   end record;

   RTC_Periph : aliased RTC_Peripheral
     with Import, Address => RTC_Base;

end STM32.Registers.RTC;
