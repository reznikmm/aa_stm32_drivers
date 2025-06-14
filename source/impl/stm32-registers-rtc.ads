--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  This spec has been automatically generated from STM32F411.svd
--  then edited to be more handy.

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

package STM32.Registers.RTC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  time register
   type TR_Register is record
      --  Second units in BCD format
      SU             : Interfaces.Unsigned_32 range 0 .. 15;
      --  Second tens in BCD format
      ST             : Interfaces.Unsigned_32 range 0 .. 7;
      --  unspecified
      Reserved_7_7   : Interfaces.Unsigned_32 range 0 .. 1;
      --  Minute units in BCD format
      MNU            : Interfaces.Unsigned_32 range 0 .. 15;
      --  Minute tens in BCD format
      MNT            : Interfaces.Unsigned_32 range 0 .. 7;
      --  unspecified
      Reserved_15_15 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Hour units in BCD format
      HU             : Interfaces.Unsigned_32 range 0 .. 15;
      --  Hour tens in BCD format
      HT             : Interfaces.Unsigned_32 range 0 .. 3;
      --  AM/PM notation
      PM             : Boolean;
      --  unspecified
      Reserved_23_31 : Interfaces.Unsigned_32 range 0 .. 511;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

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

   --  date register
   type DR_Register is record
      --  Date units in BCD format
      DU             : Interfaces.Unsigned_32 range 0 .. 15;
      --  Date tens in BCD format
      DT             : Interfaces.Unsigned_32 range 0 .. 3;
      --  unspecified
      Reserved_6_7   : Interfaces.Unsigned_32 range 0 .. 3;
      --  Month units in BCD format
      MU             : Interfaces.Unsigned_32 range 0 .. 15;
      --  Month tens in BCD format
      MT             : Boolean;
      --  Week day units
      WDU            : Interfaces.Unsigned_32 range 0 .. 7;
      --  Year units in BCD format
      YU             : Interfaces.Unsigned_32 range 0 .. 15;
      --  Year tens in BCD format
      YT             : Interfaces.Unsigned_32 range 0 .. 15;
      --  unspecified
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

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

   --  control register
   type CR_Register is record
      --  Wakeup clock selection
      WCKSEL         : Interfaces.Unsigned_32 range 0 .. 7;
      --  Time-stamp event active edge
      TSEDGE         : Boolean;
      --  Reference clock detection enable (50 or 60 Hz)
      REFCKON        : Boolean;
      --  Bypass the shadow registers
      BYPSHAD        : Boolean;
      --  Hour format
      FMT            : Boolean;
      --  Coarse digital calibration enable
      DCE            : Boolean;
      --  Alarm A enable
      ALRAE          : Boolean;
      --  Alarm B enable
      ALRBE          : Boolean;
      --  Wakeup timer enable
      WUTE           : Boolean;
      --  Time stamp enable
      TSE            : Boolean;
      --  Alarm A interrupt enable
      ALRAIE         : Boolean;
      --  Alarm B interrupt enable
      ALRBIE         : Boolean;
      --  Wakeup timer interrupt enable
      WUTIE          : Boolean;
      --  Time-stamp interrupt enable
      TSIE           : Boolean;
      --  Add 1 hour (summer time change)
      ADD1H          : Boolean;
      --  Subtract 1 hour (winter time change)
      SUB1H          : Boolean;
      --  Backup
      BKP            : Boolean;
      --  Calibration Output selection
      COSEL          : Boolean;
      --  Output polarity
      POL            : Boolean;
      --  Output selection
      OSEL           : Interfaces.Unsigned_32 range 0 .. 3;
      --  Calibration output enable
      COE            : Boolean;
      --  unspecified
      Reserved_24_31 : Interfaces.Unsigned_32 range 0 .. 255;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

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

   --  initialization and status register
   type ISR_Register is record
      --  Read-only. Alarm A write flag
      ALRAWF         : Boolean;
      --  Read-only. Alarm B write flag
      ALRBWF         : Boolean;
      --  Read-only. Wakeup timer write flag
      WUTWF          : Boolean;
      --  Shift operation pending
      SHPF           : Boolean;
      --  Read-only. Initialization status flag
      INITS          : Boolean;
      --  Registers synchronization flag
      RSF            : Boolean;
      --  Read-only. Initialization flag
      INITF          : Boolean;
      --  Initialization mode
      INIT           : Boolean;
      --  Alarm A flag
      ALRAF          : Boolean;
      --  Alarm B flag
      ALRBF          : Boolean;
      --  Wakeup timer flag
      WUTF           : Boolean;
      --  Time-stamp flag
      TSF            : Boolean;
      --  Time-stamp overflow flag
      TSOVF          : Boolean;
      --  Tamper detection flag
      TAMP1F         : Boolean;
      --  TAMPER2 detection flag
      TAMP2F         : Boolean;
      --  unspecified
      Reserved_15_15 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Read-only. Recalibration pending Flag
      RECALPF        : Boolean;
      --  unspecified
      Reserved_17_31 : Interfaces.Unsigned_32 range 0 .. 32767;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

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

   --  prescaler register
   type PRER_Register is record
      --  Synchronous prescaler factor
      PREDIV_S       : Interfaces.Unsigned_32 range 0 .. 32767;
      --  unspecified
      Reserved_15_15 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Asynchronous prescaler factor
      PREDIV_A       : Interfaces.Unsigned_32 range 0 .. 127;
      --  unspecified
      Reserved_23_31 : Interfaces.Unsigned_32 range 0 .. 511;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for PRER_Register use record
      PREDIV_S       at 0 range 0 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      PREDIV_A       at 0 range 16 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   --  wakeup timer register
   type WUTR_Register is record
      --  Wakeup auto-reload value bits
      WUT            : Interfaces.Unsigned_32 range 0 .. 65535;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for WUTR_Register use record
      WUT            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  calibration register
   type CALIBR_Register is record
      --  Digital calibration
      DC            : Interfaces.Unsigned_32 range 0 .. 31;
      --  unspecified
      Reserved_5_6  : Interfaces.Unsigned_32 range 0 .. 3;
      --  Digital calibration sign
      DCS           : Boolean;
      --  unspecified
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CALIBR_Register use record
      DC            at 0 range 0 .. 4;
      Reserved_5_6  at 0 range 5 .. 6;
      DCS           at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  alarm A/B register
   type ALRMR_Register is record
      --  Second units in BCD format
      SU    : Interfaces.Unsigned_32 range 0 .. 15;
      --  Second tens in BCD format
      ST    : Interfaces.Unsigned_32 range 0 .. 7;
      --  Alarm A/B seconds mask
      MSK1  : Boolean;
      --  Minute units in BCD format
      MNU   : Interfaces.Unsigned_32 range 0 .. 15;
      --  Minute tens in BCD format
      MNT   : Interfaces.Unsigned_32 range 0 .. 7;
      --  Alarm A/B minutes mask
      MSK2  : Boolean;
      --  Hour units in BCD format
      HU    : Interfaces.Unsigned_32 range 0 .. 15;
      --  Hour tens in BCD format
      HT    : Interfaces.Unsigned_32 range 0 .. 3;
      --  AM/PM notation
      PM    : Boolean;
      --  Alarm A/B hours mask
      MSK3  : Boolean;
      --  Date units or day in BCD format
      DU    : Interfaces.Unsigned_32 range 0 .. 15;
      --  Date tens in BCD format
      DT    : Interfaces.Unsigned_32 range 0 .. 3;
      --  Week day selection
      WDSEL : Boolean;
      --  Alarm A/B date mask
      MSK4  : Boolean;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for ALRMR_Register use record
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

   --  write protection register
   type WPR_Register is record
      --  Write-only. Write protection key
      KEY           : Interfaces.Unsigned_32 range 0 .. 255;
      --  unspecified
      Reserved_8_31 : Interfaces.Unsigned_32 range 0 .. 16777215;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for WPR_Register use record
      KEY           at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  sub second register
   type SSR_Register is record
      --  Read-only. Sub second value
      SS             : Interfaces.Unsigned_32 range 0 .. 65535;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SSR_Register use record
      SS             at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  shift control register
   type SHIFTR_Register is record
      --  Write-only. Subtract a fraction of a second
      SUBFS          : Interfaces.Unsigned_32 range 0 .. 32767;
      --  unspecified
      Reserved_15_30 : Interfaces.Unsigned_32 range 0 .. 65535;
      --  Write-only. Add one second
      ADD1S          : Boolean;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for SHIFTR_Register use record
      SUBFS          at 0 range 0 .. 14;
      Reserved_15_30 at 0 range 15 .. 30;
      ADD1S          at 0 range 31 .. 31;
   end record;

   --  time stamp time register
   type TSTR_Register is record
      --  Read-only. Second units in BCD format
      SU             : Interfaces.Unsigned_32 range 0 .. 15;
      --  Read-only. Second tens in BCD format
      ST             : Interfaces.Unsigned_32 range 0 .. 7;
      --  unspecified
      Reserved_7_7   : Interfaces.Unsigned_32 range 0 .. 1;
      --  Read-only. Minute units in BCD format
      MNU            : Interfaces.Unsigned_32 range 0 .. 15;
      --  Read-only. Minute tens in BCD format
      MNT            : Interfaces.Unsigned_32 range 0 .. 7;
      --  unspecified
      Reserved_15_15 : Interfaces.Unsigned_32 range 0 .. 1;
      --  Read-only. Hour units in BCD format
      HU             : Interfaces.Unsigned_32 range 0 .. 15;
      --  Read-only. Hour tens in BCD format
      HT             : Interfaces.Unsigned_32 range 0 .. 3;
      --  Read-only. AM/PM notation
      PM             : Boolean;
      --  unspecified
      Reserved_23_31 : Interfaces.Unsigned_32 range 0 .. 511;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

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

   --  time stamp date register
   type TSDR_Register is record
      --  Read-only. Date units in BCD format
      DU             : Interfaces.Unsigned_32 range 0 .. 15;
      --  Read-only. Date tens in BCD format
      DT             : Interfaces.Unsigned_32 range 0 .. 3;
      --  unspecified
      Reserved_6_7   : Interfaces.Unsigned_32 range 0 .. 3;
      --  Read-only. Month units in BCD format
      MU             : Interfaces.Unsigned_32 range 0 .. 15;
      --  Read-only. Month tens in BCD format
      MT             : Boolean;
      --  Read-only. Week day units
      WDU            : Interfaces.Unsigned_32 range 0 .. 7;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for TSDR_Register use record
      DU             at 0 range 0 .. 3;
      DT             at 0 range 4 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      MU             at 0 range 8 .. 11;
      MT             at 0 range 12 .. 12;
      WDU            at 0 range 13 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  timestamp sub second register
   type TSSSR_Register is record
      --  Read-only. Sub second value
      SS             : Interfaces.Unsigned_32 range 0 .. 65535;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for TSSSR_Register use record
      SS             at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  calibration register
   type CALR_Register is record
      --  Calibration minus
      CALM           : Interfaces.Unsigned_32 range 0 .. 511;
      --  unspecified
      Reserved_9_12  : Interfaces.Unsigned_32 range 0 .. 15;
      --  Use a 16-second calibration cycle period
      CALW16         : Boolean;
      --  Use an 8-second calibration cycle period
      CALW8          : Boolean;
      --  Increase frequency of RTC by 488.5 ppm
      CALP           : Boolean;
      --  unspecified
      Reserved_16_31 : Interfaces.Unsigned_32 range 0 .. 65535;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for CALR_Register use record
      CALM           at 0 range 0 .. 8;
      Reserved_9_12  at 0 range 9 .. 12;
      CALW16         at 0 range 13 .. 13;
      CALW8          at 0 range 14 .. 14;
      CALP           at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  tamper and alternate function configuration register
   type TAFCR_Register is record
      --  Tamper 1 detection enable
      TAMP1E         : Boolean;
      --  Active level for tamper 1
      TAMP1TRG       : Boolean;
      --  Tamper interrupt enable
      TAMPIE         : Boolean;
      --  Tamper 2 detection enable
      TAMP2E         : Boolean;
      --  Active level for tamper 2
      TAMP2TRG       : Boolean;
      --  unspecified
      Reserved_5_6   : Interfaces.Unsigned_32 range 0 .. 3;
      --  Activate timestamp on tamper detection event
      TAMPTS         : Boolean;
      --  Tamper sampling frequency
      TAMPFREQ       : Interfaces.Unsigned_32 range 0 .. 7;
      --  Tamper filter count
      TAMPFLT        : Interfaces.Unsigned_32 range 0 .. 3;
      --  Tamper precharge duration
      TAMPPRCH       : Interfaces.Unsigned_32 range 0 .. 3;
      --  TAMPER pull-up disable
      TAMPPUDIS      : Boolean;
      --  TAMPER1 mapping
      TAMP1INSEL     : Boolean;
      --  TIMESTAMP mapping
      TSINSEL        : Boolean;
      --  AFO_ALARM output type
      ALARMOUTTYPE   : Boolean;
      --  unspecified
      Reserved_19_31 : Interfaces.Unsigned_32 range 0 .. 8191;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

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

   --  alarm A/B sub second register
   type ALRM_SSR_Register is record
      --  Sub seconds value
      SS             : Interfaces.Unsigned_32 range 0 .. 32767;
      --  unspecified
      Reserved_15_23 : Interfaces.Unsigned_32 range 0 .. 511;
      --  Mask the most-significant bits starting at this bit
      MASKSS         : Interfaces.Unsigned_32 range 0 .. 15;
      --  unspecified
      Reserved_28_31 : Interfaces.Unsigned_32 range 0 .. 15;
   end record
     with Object_Size => 32, Bit_Order => System.Low_Order_First;

   for ALRM_SSR_Register use record
      SS             at 0 range 0 .. 14;
      Reserved_15_23 at 0 range 15 .. 23;
      MASKSS         at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   type BKP_Array is array (0 .. 19) of aliased Interfaces.Unsigned_32
     with Component_Size => 32;

   -----------------
   -- Peripherals --
   -----------------

   --  Real-time clock
   type RTC_Peripheral is record
      --  time register
      TR       : aliased TR_Register;
      pragma Volatile_Full_Access (TR);
      --  date register
      DR       : aliased DR_Register;
      pragma Volatile_Full_Access (DR);
      --  control register
      CR       : aliased CR_Register;
      pragma Volatile_Full_Access (CR);
      --  initialization and status register
      ISR      : aliased ISR_Register;
      pragma Volatile_Full_Access (ISR);
      --  prescaler register
      PRER     : aliased PRER_Register;
      pragma Volatile_Full_Access (PRER);
      --  wakeup timer register
      WUTR     : aliased WUTR_Register;
      pragma Volatile_Full_Access (WUTR);
      --  calibration register
      CALIBR   : aliased CALIBR_Register;
      pragma Volatile_Full_Access (CALIBR);
      --  alarm A register
      ALRMAR   : aliased ALRMR_Register;
      pragma Volatile_Full_Access (ALRMAR);
      --  alarm B register
      ALRMBR   : aliased ALRMR_Register;
      pragma Volatile_Full_Access (ALRMBR);
      --  write protection register
      WPR      : aliased WPR_Register;
      pragma Volatile_Full_Access (WPR);
      --  sub second register
      SSR      : aliased SSR_Register;
      pragma Volatile_Full_Access (SSR);
      --  shift control register
      SHIFTR   : aliased SHIFTR_Register;
      pragma Volatile_Full_Access (SHIFTR);
      --  time stamp time register
      TSTR     : aliased TSTR_Register;
      pragma Volatile_Full_Access (TSTR);
      --  time stamp date register
      TSDR     : aliased TSDR_Register;
      pragma Volatile_Full_Access (TSDR);
      --  timestamp sub second register
      TSSSR    : aliased TSSSR_Register;
      pragma Volatile_Full_Access (TSSSR);
      --  calibration register
      CALR     : aliased CALR_Register;
      pragma Volatile_Full_Access (CALR);
      --  tamper and alternate function configuration register
      TAFCR    : aliased TAFCR_Register;
      pragma Volatile_Full_Access (TAFCR);
      --  alarm A sub second register
      ALRMASSR : aliased ALRM_SSR_Register;
      pragma Volatile_Full_Access (ALRMASSR);
      --  alarm B sub second register
      ALRMBSSR : aliased ALRM_SSR_Register;
      pragma Volatile_Full_Access (ALRMBSSR);
      --  backup register
      BKP_R    : BKP_Array;
   end record
     with Volatile;

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
      BKP_R    at 16#50# range 0 .. 639;
   end record;

   --  Real-time clock
   RTC_Periph : aliased RTC_Peripheral
     with Import, Address => RTC_Base;

end STM32.Registers.RTC;
