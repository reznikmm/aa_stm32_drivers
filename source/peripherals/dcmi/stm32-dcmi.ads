--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Digital camera interface

with A0B.Callbacks;

with Interfaces;

with STM32.DMA;

generic

   with package DMA_Stream is new STM32.DMA.Generic_DMA_Stream (<>);

package STM32.DCMI is

   procedure Initialize (Pins : Pin_Array)
     with Pre =>
       (for all Pin of Pins => Pin in
           (PB, 7)  | (PG, 9) |              --  VSYNC
           (PA, 4)  |                        --  HSYNC
           (PA, 6)  |                        --  PIXCLK
           (PA, 9)  | (PC, 6) |              --  D0
           (PA, 10) | (PC, 7) |              --  D1
           (PB, 5)  | (PD, 6) |              --  D10
           (PB, 6)  | (PD, 3) |              --  D5
           (PB, 8)  | (PE, 5) |              --  D6
           (PB, 9)  | (PE, 6) |              --  D7
           (PC, 8)  | (PE, 0) | (PG, 10) |   --  D2
           (PC, 9)  | (PE, 1) | (PG, 11) |   --  D3
           (PC, 10) |                        --  D8
           (PC, 11) | (PE, 4) |              --  D4
           (PC, 12) |                        --  D9
           (PD, 2)  | (PF, 10) |             --  D11
           (PF, 11) | (PG, 6) |              --  D12
           (PG, 7)  | (PG, 15));             --  D13

   type Camera_Bus_Width is range 8 .. 14
     with Static_Predicate => Camera_Bus_Width in 8 | 10 | 12 | 14;

   type Crop_Window (Is_Set : Boolean := False) is record
      case Is_Set is
         when True =>
            Height   : Positive range 1 .. 2**14;
            Width    : Positive range 1 .. 2**14;
            Offset_X : Natural range 0 .. 2**14 - 1;
            Offset_Y : Natural range 0 .. 2**13 - 1;
         when False =>
            null;
      end case;
   end record;

   No_Crop : Crop_Window := (Is_Set => False);

   procedure Configure
     (Bus_Width      : Camera_Bus_Width;
      VSYNC_Polarity : STM32.Bit;
      HSYNC_Polarity : STM32.Bit;
      PCLK_Polarity  : STM32.Bit;
      Make_Snapshot  : Boolean;
      Crop           : Crop_Window := No_Crop);

   procedure Start_Capture
     (Target : STM32.DMA.Location;
      Count  : Interfaces.Unsigned_16;
      Prio   : STM32.DMA.Priority_Level := STM32.DMA.Low;
      Done   : A0B.Callbacks.Callback);
   --  Count is size of the frame (or crop window) in 32 bit words, like
   --  "width x height / 2" for 16 bit per pixel format.

   procedure Stop_Capture;

private

   pragma Compile_Time_Error (not DMA_Stream.Is_DMA2, "DMA2 expected");

   pragma Compile_Time_Error
     (DMA_Stream.Index not in 1 | 7, "DMA2 stream 1 or 7 expected");

end STM32.DCMI;
