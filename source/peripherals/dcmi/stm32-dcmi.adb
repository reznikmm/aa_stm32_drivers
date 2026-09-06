--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.GPIO;
with STM32.Registers.DCMI;
with STM32.Registers.GPIO;
with STM32.Registers.RCC;

package body STM32.DCMI is

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Bus_Width      : Camera_Bus_Width;
      VSYNC_Polarity : STM32.Bit;
      HSYNC_Polarity : STM32.Bit;
      PCLK_Polarity  : STM32.Bit;
      Make_Snapshot  : Boolean;
      Crop           : Crop_Window := No_Crop)
   is
      DCMI : STM32.Registers.DCMI.DCMI_Peripheral renames
        STM32.Registers.DCMI.DCMI_Periph;
   begin
      DCMI.CR.ENABLE := False;

      if Crop.Is_Set then
         DCMI.CWSIZE :=
           (CAPCNT         => Interfaces.Unsigned_32 (Crop.Width - 1),
            Reserved_14_15 => 0,
            VLINE          => Interfaces.Unsigned_32 (Crop.Height - 1),
            Reserved_30_31 => 0);

         DCMI.CWSTRT :=
           (HOFFCNT        => Interfaces.Unsigned_32 (Crop.Offset_X),
            Reserved_14_15 => 0,
            VST            => Interfaces.Unsigned_32 (Crop.Offset_Y),
            Reserved_29_31 => 0);
      end if;

      DCMI.CR :=
        (CAPTURE        => False,
         CM             => Make_Snapshot,
         CROP           => Crop.Is_Set,
         JPEG           => False,  --  No JPEG
         ESS            => False,  --  Hardware synchronization
         PCKPOL         => PCLK_Polarity = 1,
         HSPOL          => HSYNC_Polarity = 1,
         VSPOL          => VSYNC_Polarity = 1,
         FCRC           => 0,  --  All frames captured
         EDM            =>
           (case Bus_Width is
            when 8 => 0,
            when 10 => 1,
            when 12 => 2,
            when 14 => 3),
         Reserved_12_13 => 0,
         ENABLE         => True,
         Reserved_15_31 => 0);
   end Configure;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Pins : Pin_Array) is
      procedure Init_GPIO
        (Periph : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin    : Pin_Index);

      ---------------
      -- Init_GPIO --
      ---------------

      procedure Init_GPIO
        (Periph : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin    : Pin_Index) is
      begin
         Periph.MODER   (Pin) := STM32.Registers.GPIO.Mode_AF;
         Periph.OSPEEDR (Pin) := STM32.Registers.GPIO.Speed_100MHz;
         Periph.OTYPER  (Pin) := STM32.Registers.GPIO.Push_Pull;
         Periph.PUPDR   (Pin) := STM32.Registers.GPIO.No_Pull;
         Periph.AFR     (Pin) := 13;
      end Init_GPIO;

      RCC : STM32.Registers.RCC.RCC_Peripheral renames
        STM32.Registers.RCC.RCC_Periph;
   begin
      RCC.AHB2ENR.DCMIEN := True;

      for Item of Pins loop
         STM32.GPIO.Enable_GPIO (Item.Port);
         Init_GPIO (STM32.Registers.GPIO.GPIO_Periph (Item.Port), Item.Pin);
      end loop;
   end Initialize;

   -------------------
   -- Start_Capture --
   -------------------

   procedure Start_Capture
     (Target : STM32.DMA.Location;
      Count  : Interfaces.Unsigned_16;
      Prio   : STM32.DMA.Priority_Level := STM32.DMA.Low;
      Done   : A0B.Callbacks.Callback)
   is
      DCMI : STM32.Registers.DCMI.DCMI_Peripheral renames
        STM32.Registers.DCMI.DCMI_Periph;
   begin
      DMA_Stream.Start_Transfer
        (Channel => 1,
         Source  =>
           (Address     => DCMI.DR'Address,
            Item_Length => 4,
            Increment   => 0,
            Burst       => 1),
         Target  => Target,
         Count   => Count,
         FIFO    => STM32.DMA.FIFO_Bytes'Last,
         Prio    => Prio,
         Done    => Done);

      DCMI.CR.CAPTURE := True;
   end Start_Capture;

   ------------------
   -- Stop_Capture --
   ------------------

   procedure Stop_Capture is
      DCMI : STM32.Registers.DCMI.DCMI_Peripheral renames
        STM32.Registers.DCMI.DCMI_Periph;
   begin
      DCMI.CR.CAPTURE := False;
   end Stop_Capture;

end STM32.DCMI;
