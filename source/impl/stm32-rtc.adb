--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces;
with STM32.Registers.PWR;
with STM32.Registers.RCC;
with STM32.Registers.RTC;
with STM32.System_Clocks;

package body STM32.RTC is

   -----------
   -- Clock --
   -----------

   procedure Clock
     (Date : out RTC.Date;
      Time : out RTC.Time)
   is
      use type Interfaces.Unsigned_32;

      RTC : STM32.Registers.RTC.RTC_Peripheral renames
        STM32.Registers.RTC.RTC_Periph;

      TR : constant STM32.Registers.RTC.TR_Register := RTC.TR;
      DR : constant STM32.Registers.RTC.DR_Register := RTC.DR;
   begin
      Date :=
        (Year    => Natural (DR.YT) * 10 + Natural (DR.YU),
         Month   => (if DR.MT then 10 else 0) + Natural (DR.MU),
         Day     => Natural (DR.DT) * 10 + Natural (DR.DU),
         Weekday => STM32.RTC.Weekday'Val (DR.WDU - 1));

      Time :=
        (Hour   => Natural (TR.HT) * 10 + Natural (TR.HU),
         Minute => Natural (TR.MNT) * 10 + Natural (TR.MNU),
         Second => Natural (TR.ST) * 10 + Natural (TR.SU));
   end Clock;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Date    : RTC.Date;
      Time    : RTC.Time;
      Clock   : Clock_Source := Low_Speed_External;
      Success : out Boolean)
   is
      use type Interfaces.Unsigned_32;

      RCC : STM32.Registers.RCC.RCC_Peripheral renames
        STM32.Registers.RCC.RCC_Periph;

      PWR : STM32.Registers.PWR.PWR_Peripheral renames
        STM32.Registers.PWR.PWR_Periph;

      RTC : STM32.Registers.RTC.RTC_Peripheral renames
        STM32.Registers.RTC.RTC_Periph;

   begin
      RCC.APB1ENR.PWREN := True;
      RCC.CFGR.RTCPRE := STM32.System_Clocks.HSE / 1_000_000;

      PWR.CR.DBP := True;  --  Disable write protection on BDCR

      --  Reset backup domain
      RCC.BDCR.BDRST := True;
      RCC.BDCR.BDRST := False;

      RCC.BDCR :=
        (LSEON  => Clock = Low_Speed_External,
         LSERDY => False,
         LSEBYP => False,
         RTCSEL => 1 + Clock_Source'Pos (Clock),
         RTCEN  => True,
         BDRST  => False,
         others => 0);

      --  Disable write protection
      RTC.WPR := (16#CA#, 0);
      RTC.WPR := (16#53#, 0);

      RTC.ISR.INIT := True;

      --  Entering initialization phase mode. It takes from 1 to 2 RTCCLK clock
      --  cycles (due to clock synch)
      delay 2.0 / 32_768.0;

      if not RTC.ISR.INITF then
         RTC.ISR.INIT := False;

         --  Enable write protection
         RTC.WPR := (16#00#, 0);
         PWR.CR.DBP := False;
         Success := False;
         return;
      end if;

      --  Set prescaler to total 2**15 = 32.768kHz. Two write access REQUIRED
      RTC.PRER.PREDIV_A := 127;  --  devide by 128 2**7

      RTC.PRER.PREDIV_S :=
        (if Clock = High_Speed_External then 8191 else 255);
      --  devide by 256 2**8 for LSE/LSI or by 8192 if HSE

      RTC.DR :=
        (DU  => Interfaces.Unsigned_32 (Date.Day mod 10),
         DT  => Interfaces.Unsigned_32 (Date.Day / 10),
         MU  => Interfaces.Unsigned_32 (Date.Month mod 10),
         MT  => Date.Month > 9,
         WDU => Interfaces.Unsigned_32 (1 + Weekday'Pos (Date.Weekday)),
         YU  => Interfaces.Unsigned_32 (Date.Year mod 10),
         YT  => Interfaces.Unsigned_32 (Date.Year / 10),
         others => 0);
      --  RTC.CR.FMT := False; --  24 h format

      RTC.TR :=
        (SU  => Interfaces.Unsigned_32 (Time.Second mod 10),
         ST  => Interfaces.Unsigned_32 (Time.Second / 10),
         MNU => Interfaces.Unsigned_32 (Time.Minute mod 10),
         MNT => Interfaces.Unsigned_32 (Time.Minute / 10),
         HU  => Interfaces.Unsigned_32 (Time.Hour mod 10),
         HT  => Interfaces.Unsigned_32 (Time.Hour / 10),
         PM  => False,
         others => 0);

      RTC.ISR.INIT := False;

      --  Enable write protection
      RTC.WPR := (16#00#, 0);
      PWR.CR.DBP := False;
      Success := True;
   end Initialize;

end STM32.RTC;
