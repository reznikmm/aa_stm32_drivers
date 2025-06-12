--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.GPIO;
with STM32.Registers.GPIO;

package body STM32.Timer is

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO (Item : Pin; Fun : Interfaces.Unsigned_32) is
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
         Periph.OSPEEDR (Pin) := STM32.Registers.GPIO.Speed_2MHz;
         Periph.OTYPER  (Pin) := STM32.Registers.GPIO.Push_Pull;
         Periph.PUPDR   (Pin) := STM32.Registers.GPIO.No_Pull;
         Periph.AFR     (Pin) := Fun;
      end Init_GPIO;

   begin
      STM32.GPIO.Enable_GPIO (Item.Port);
      Init_GPIO (STM32.Registers.GPIO.GPIO_Periph (Item.Port), Item.Pin);
   end Init_GPIO;

   ------------------------
   -- DMA_Implementation --
   ------------------------

   package body DMA_Implementation is

      procedure Start
        (Address : System.Address;
         Count   : Interfaces.Unsigned_16;
         Size    : STM32.DMA.Length_In_Bytes;
         On_Half : A0B.Callbacks.Callback);

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (Pin    : Pin_Array;
         Fun    : Interfaces.Unsigned_32;
         Speed  : Interfaces.Unsigned_32;
         Period : Interfaces.Unsigned_32;
         Duty   : Interfaces.Unsigned_32;
         Clock  : Interfaces.Unsigned_32)
      is
         use type Interfaces.Unsigned_32;
      begin
         for Item of Pin loop
            Init_GPIO (Item, Fun);
         end loop;

         Periph.CR1 :=
           (CEN    => False,  --  Counter enable
            UDIS   => False,  --  UEV enabled
            URS    => False,  --  IRQ or DMA
            OPM    => False,  --  One-pulse mode
            DIR    => False,  --  Counter used as upcounter
            CMS    => 0,      --  Center-aligned mode selection
            ARPE   => False,  --  Auto-reload preload disable
            CKD    => 0,      --  Clock division
            others => 0);

         Periph.DIER.UDE := True;  --  Update DMA request enable
         Periph.PSC := Clock / Speed - 1;  --  Prescaler
         Periph.ARR := Period;

         --  Set DCR.DBA to TIMx_CCR1 .. TIMx_CCR4 depending on Pi'First
         Periph.DCR :=
           (DBA    => Interfaces.Unsigned_32 (16#30# / 4 + Pin'First),
            DBL    => Pin'Length - 1,
            others => 0);

         for Channel in Pin'Range loop
            declare
               Low  : constant Natural range 0 .. 1 := (Channel - 1) mod 2;
               High : constant Natural range 0 .. 1 := (Channel - 1) / 2;
            begin
               Periph.CCMR (High).CCMR_Output (Low).CCxS := 0;  --  output
               Periph.CCMR (High).CCMR_Output (Low).OCxM := 6;  --  PWM mode 0
               Periph.CCMR (High).CCMR_Output (Low).OCxPE := True;  --  Preload
               Periph.CCER (Channel).CCxE := True;  --  OCx is output on pin
               Periph.CCER (Channel).CCxP := 0;  --  Polarity
               Periph.CCR (Channel) := Duty;
            end;
         end loop;
      end Configure;

      -----------
      -- Start --
      -----------

      procedure Start
        (Address : System.Address;
         Count   : Interfaces.Unsigned_16;
         Size    : STM32.DMA.Length_In_Bytes;
         On_Half : A0B.Callbacks.Callback)
      is
         use type STM32.DMA.Length_In_Bytes;
      begin
         Periph.CR1.CEN := True;

         Stream.Start_Circular_Transfer
           (Channel => Channel,
            Source  =>
              (Address     => Address,
               Item_Length => Size,
               Increment   => Size,
               Burst       => 1),
            Target  =>
              (Address     => Periph.DMAR'Address,
               Item_Length => Size,
               Increment   => 0,
               Burst       => 1),
            Count   => Count,
            FIFO    => (if Size = 4 then 4 else 0),
            Prio    => STM32.DMA.Low,
            On_Half => On_Half);
      end Start;

      ---------------
      -- Start_PWM --
      ---------------

      procedure Start_PWM
        (Data    : Unsigned_32_Array;
         On_Half : A0B.Callbacks.Callback)
      is
         use type Interfaces.Unsigned_32;
      begin
         --  Set DCR.DBA to TIMx_ARR and increase transfer count
         Periph.DCR :=
           (DBA    => Interfaces.Unsigned_32 (16#2C# / 4),
            DBL    => Periph.DCR.DBL + 1,
            others => 0);

         Start (Data'Address, Data'Length, 4, On_Half);
      end Start_PWM;

      --------------------
      -- Start_PWM_Duty --
      --------------------

      procedure Start_PWM_Duty
        (Duty    : Unsigned_32_Array;
         On_Half : A0B.Callbacks.Callback) is
      begin
         Start (Duty'Address, Duty'Length, 4, On_Half);
      end Start_PWM_Duty;

      ----------------------
      -- Start_PWM_Period --
      ----------------------

      procedure Start_PWM_Period
        (Period  : Unsigned_32_Array;
         On_Half : A0B.Callbacks.Callback) is
      begin
         --  Set DCR.DBA to TIMx_ARR
         Periph.DCR :=
           (DBA    => Interfaces.Unsigned_32 (16#2C# / 4),
            DBL    => 0,  --  1 transfer count
            others => 0);

         Start (Period'Address, Period'Length, 4, On_Half);
      end Start_PWM_Period;

      ----------
      -- Stop --
      ----------

      procedure Stop is
         Ignore : Interfaces.Unsigned_16;
      begin
         Stream.Stop_Transfer (Ignore);
         Periph.CR1.CEN := False;
      end Stop;

   end DMA_Implementation;

   package body TIM_Implementation is

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (Pin   : STM32.Pin;
         Fun   : Interfaces.Unsigned_32;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32)
      is
         use type Interfaces.Unsigned_32;

         Low  : constant Natural range 0 .. 1 := (Channel - 1) mod 2;
         High : constant Natural range 0 .. 1 := (Channel - 1) / 2;
      begin
         Init_GPIO (Pin, Fun);

         Periph.CR1 :=
           (CEN    => False,  --  Counter enable
            UDIS   => False,  --  UEV enabled
            URS    => False,  --  IRQ or DMA
            OPM    => False,  --  One-pulse mode
            DIR    => False,  --  Counter used as upcounter
            CMS    => 0,      --  Center-aligned mode selection
            ARPE   => True,   --  Auto-reload preload enabl
            CKD    => 0,      --  Clock division
            others => 0);

         Periph.DIER.UIE := True;  --  Update interrupt enabled
         Periph.CCMR (High).CCMR_Output (Low).CCxS := 0;  --  channel as output
         Periph.CCMR (High).CCMR_Output (Low).OCxM := 6;  --  PWM mode 0
         Periph.CCMR (High).CCMR_Output (Low).OCxPE := True;  --  Preload On
         Periph.CCER (Channel).CCxE := True;  --  OCx is output on the pin
         Periph.CCER (Channel).CCxP := 0;  --  Polarity
         Periph.PSC := Clock / Speed - 1;  --  Prescaler
      end Configure;

      ------------
      -- Device --
      ------------

      protected body Device is

         -----------------------
         -- Interrupt_Handler --
         -----------------------

         procedure Interrupt_Handler is
            SR : constant STM32.Registers.TIM.SR_Register := Periph.SR;
         begin

            if SR.UIF then
               Periph.SR.UIF := False;
               Periph.ARR := ARR;
               Periph.CCR (Channel) := CCR;

               if A0B.Callbacks.Is_Set (Done) then
                  A0B.Callbacks.Emit (Done);
                  A0B.Callbacks.Unset (Done);
               end if;
            end if;
         end Interrupt_Handler;

         ---------------
         -- Start_PWM --
         ---------------

         procedure Start_PWM
           (Period : Interfaces.Unsigned_16;
            Duty   : Interfaces.Unsigned_16;
            Done   : A0B.Callbacks.Callback) is
         begin
            Device.Done := Done;
            Device.ARR := Interfaces.Unsigned_32 (Period);
            Device.CCR := Interfaces.Unsigned_32 (Duty);

            if not Periph.CR1.CEN then
               Periph.ARR := Device.ARR;
               Periph.CCR (Channel) := Device.CCR;
               Periph.EGR.UG := True;
               Periph.CR1.CEN := True;
            end if;
         end Start_PWM;

      end Device;

   end TIM_Implementation;

end STM32.Timer;
