--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with System.STM32;

with STM32.GPIO;

package body STM32.Timer is

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO
     (Periph : in out Interfaces.STM32.GPIO.GPIO_Peripheral;
      Pin    : Pin_Index)
   is
      AF_TIM3_CH3    : constant := 2;
   begin
      Periph.MODER.Arr     (Pin) := System.STM32.Mode_AF;
      Periph.OSPEEDR.Arr   (Pin) := System.STM32.Speed_2MHz;
      Periph.OTYPER.OT.Arr (Pin) := System.STM32.Push_Pull;
      Periph.PUPDR.Arr     (Pin) := System.STM32.No_Pull;

      if Pin in Periph.AFRL.Arr'Range then
         Periph.AFRL.Arr (Pin) := AF_TIM3_CH3;
      else
         Periph.AFRH.Arr (Pin) := AF_TIM3_CH3;
      end if;
   end Init_GPIO;

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO (Item : Pin) is
   begin
      STM32.GPIO.Enable_GPIO (Item.Port);

      case Item.Port is
         when 'A' =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOA_Periph, Item.Pin);
         when 'B' =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOB_Periph, Item.Pin);
         when 'C' =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOC_Periph, Item.Pin);
         when 'D' =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOD_Periph, Item.Pin);
         when 'E' =>
            Init_GPIO (Interfaces.STM32.GPIO.GPIOE_Periph, Item.Pin);
      end case;
   end Init_GPIO;

   package body TIM_Implementation is

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (Pin   : STM32.Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.STM32.UInt32)
      is
         use type Interfaces.Unsigned_32;

         Prescaler : constant Interfaces.Unsigned_32 :=
           Interfaces.Unsigned_32 (Clock) / Speed - 1;
      begin
         Init_GPIO (Pin);
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
         Periph.CCMR2_Output.CC3S := 0;  --  channel is configured as output
         Periph.CCMR2_Output.OC3M := 6;  --  PWM mode 0
         Periph.CCMR2_Output.OC3PE := True;  --  Preload enable
         Periph.CCER.CC3E := True;  --  OC3 is output on the output pin
         Periph.CCER.CC3P := False;  --  Polarity
         Periph.PSC.PSC := Interfaces.STM32.TIM.PSC_PSC_Field (Prescaler);
      end Configure;

      ------------------
      -- On_Interrupt --
      ------------------

      procedure On_Interrupt (Self : in out Internal_Data) is
         SR : constant Interfaces.STM32.TIM.SR_Register_1 := Periph.SR;
      begin

         if SR.UIF then
            Periph.SR.UIF := False;
            Periph.ARR.ARR_L := Self.ARR;
            Periph.CCR3.CCR3_L := Self.CCR;

            if A0B.Callbacks.Is_Set (Self.Done) then
               A0B.Callbacks.Emit (Self.Done);
               A0B.Callbacks.Unset (Self.Done);
            end if;
         end if;
      end On_Interrupt;

      ---------------
      -- Start_PWM --
      ---------------

      procedure Start_PWM
        (Self   : in out Internal_Data;
         Period : Interfaces.Unsigned_16;
         Duty   : Interfaces.Unsigned_16;
         Done   : A0B.Callbacks.Callback) is
      begin
         Self.Done := Done;
         Self.ARR := Interfaces.STM32.TIM.ARR_ARR_L_Field (Period);
         Self.CCR := Interfaces.STM32.TIM.CCR3_CCR3_L_Field (Duty);

         if not Periph.CR1.CEN then
            Periph.ARR.ARR_L := Self.ARR;
            Periph.CCR3.CCR3_L := Self.CCR;
            Periph.EGR.UG := True;
            Periph.CR1.CEN := True;
         end if;
      end Start_PWM;

   end TIM_Implementation;

end STM32.Timer;
