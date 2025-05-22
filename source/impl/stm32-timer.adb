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
