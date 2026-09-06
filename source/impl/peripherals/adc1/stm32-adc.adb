
with STM32.GPIO;
with STM32.Registers.GPIO;

package body STM32.ADC is

   ------------------------
   -- ADC_Implementation --
   ------------------------

   package body ADC_Implementation is

      ----------------------------------
      -- Initialize_Single_Conversion --
      ----------------------------------

      procedure Initialize_Single_Conversion
        (P  : Pin;
         Ch : ADC_Chanel) is
      begin
         STM32.GPIO.Enable_GPIO (P.Port);
         STM32.Registers.GPIO.GPIO_Periph
           (P.Port).MODER (P.Pin) := STM32.Registers.GPIO.Mode_AN;

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
      end Initialize_Single_Conversion;

      -----------------
      -- Initialized --
      -----------------

      function Initialized return Boolean is
      begin
         return Periph.CR2.ADON;
      end Initialized;

      ----------------------
      -- Get_Single_Value --
      ----------------------

      function Get_Single_Value return Interfaces.Unsigned_8
      is
         Result : Interfaces.Unsigned_8;
      begin
         Periph.CR2.SWSTART := True; --  start conversion

         while not Periph.SR.EOC loop
            null;
         end loop;

         Result := Interfaces.Unsigned_8 (Periph.DR.DATA and 16#FF#);
         Periph.SR.EOC := False;

         return Result;
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
