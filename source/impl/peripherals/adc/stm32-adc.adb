
with STM32.Registers.GPIO;
with STM32.GPIO;

package body STM32.ADC is

   ------------------------
   -- ADC_Implementation --
   ------------------------

   package body ADC_Implementation is

      -----------------------
      -- Initialize_Chanel --
      -----------------------

      procedure Initialize_Chanel (Ch : All_ADC_Chanel) is
      begin
         Periph.CR2 :=
           (ADON           => False,
            CONT           => False,
            Reserved_2_7   => 0,
            DMA            => False,
            DDS            => False,
            EOCS           => False,
            ALIGN          => False,
            Reserved_12_15 => 0,
            JEXTSEL        => 0,
            JEXTEN         => 0,
            JSWSTART       => False,
            Reserved_23_23 => False,
            EXTSEL         => 0,
            EXTEN          => 0,
            SWSTART        => False,
            Reserved_31_31 => False);

         Periph.SQR3.SQ1 := Ch;
         Periph.SQR1.L   := 1;
         Periph.CR2.ADON := True;
      end Initialize_Chanel;

      ----------------------------------
      -- Initialize_Single_Conversion --
      ----------------------------------

      procedure Initialize_Single_Conversion
        (P  : Pin;
         Ch : ADC_Chanel) is
      begin
         Off;

         STM32.GPIO.Enable_GPIO (P.Port);
         STM32.Registers.GPIO.GPIO_Periph
           (P.Port).MODER (P.Pin) := STM32.Registers.GPIO.Mode_AN;

         Common.CCR :=
           (Reserved_0_7   => 0,
            A_DELAY        => 0,
            Reserved_12_12 => False,
            DDS            => False,
            DMA            => 0,
            ADCPRE         => 0,
            Reserved_18_21 => 0,
            VBATE          => False,
            TSVREFE        => False,
            Reserved_24_31 => 0);

         Initialize_Chanel (Ch);
      end Initialize_Single_Conversion;

      -----------------------------------
      -- Initialize_Temperature_Chanel --
      -----------------------------------

      procedure Initialize_Temperature_Chanel (Ch : Internal_ADC_Chanel) is
      begin
         Off;

         Common.CCR :=
           (Reserved_0_7   => 0,
            A_DELAY        => 0,
            Reserved_12_12 => False,
            DDS            => False,
            DMA            => 0,
            ADCPRE         => 0,
            Reserved_18_21 => 0,
            VBATE          => False,
            TSVREFE        => True,
            Reserved_24_31 => 0);

         Initialize_Chanel (Ch);
      end Initialize_Temperature_Chanel;

      ----------------------------
      -- Initialize_VBAT_Chanel --
      ----------------------------

      procedure Initialize_VBAT_Chanel (Ch : Internal_ADC_Chanel) is
      begin
         Off;

         Common.CCR :=
           (Reserved_0_7   => 0,
            A_DELAY        => 0,
            Reserved_12_12 => False,
            DDS            => False,
            DMA            => 0,
            ADCPRE         => 0,
            Reserved_18_21 => 0,
            VBATE          => True,
            TSVREFE        => False,
            Reserved_24_31 => 0);

         Initialize_Chanel (Ch);
      end Initialize_VBAT_Chanel;

      --------------------
      -- Is_Initialized --
      --------------------

      function Is_Initialized return Boolean is
      begin
         return Periph.CR2.ADON;
      end Is_Initialized;

      ----------------------
      -- Get_Single_Value --
      ----------------------

      function Get_Single_Value return Interfaces.Unsigned_8 is
      begin
         Periph.CR2.SWSTART := True; --  start conversion

         while not Periph.SR.EOC loop
            null;
         end loop;

         return Result : Interfaces.Unsigned_8 do
            Result := Interfaces.Unsigned_8 (Periph.DR.DATA and 16#FF#);
            Periph.SR.EOC   := False;
         end return;
      end Get_Single_Value;

      ---------
      -- Off --
      ---------

      procedure Off is
      begin
         Periph.CR2.ADON := False;
      end Off;

   end ADC_Implementation;

end STM32.ADC;
