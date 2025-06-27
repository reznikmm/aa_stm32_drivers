--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Real-time clock and calendar for I2C STM32.

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

   type Clock_Source is
     (Low_Speed_External,
      Low_Speed_Internal,
      High_Speed_External);

   procedure Initialize
     (Date    : RTC.Date;
      Time    : RTC.Time;
      Clock   : Clock_Source := Low_Speed_External;
      Success : out Boolean);
   --  Initialize RTC device and set calendar and clock. Return Success = False
   --  if MCU is unable to enter initialization mode dutu absent RTCCLK clock

   procedure Clock
     (Date : out RTC.Date;
      Time : out RTC.Time);
   --  Fetch current date and time from the device.

end STM32.RTC;
