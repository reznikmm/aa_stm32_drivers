--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Real-time clock and calendar for I2C STM32.
--
--  private with Interfaces;
--  private with STM32.Registers.RTC;
--  with Ada.Real_Time;

package STM32.RTC is

   type Weekday is
     (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday);

   type Date is record
      Year    : Natural  range 0 .. 99;
      Month   : Positive range 1 .. 12;
      Day     : Positive range 1 .. 31;
      Weekday : RTC.Weekday;
   end record;

   type Time is record
      Hour    : Natural range 0 .. 23;
      Minute  : Natural range 0 .. 59;
      Second  : Natural range 0 .. 59;
   end record;

   procedure Initialize
     (Date : RTC.Date;
      Time : RTC.Time);

   procedure Clock
     (Date : out RTC.Date;
      Time : out RTC.Time);

end STM32.RTC;
