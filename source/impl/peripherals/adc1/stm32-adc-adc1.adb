
with STM32.Registers.RCC;

package body STM32.ADC.ADC1 is

   ----------------------------------
   -- Initialize_Single_Conversion --
   ----------------------------------

   procedure Initialize_Single_Conversion (P : Pin)
   is
      Ch : ADC_Chanel;
   begin
      STM32.Registers.RCC.RCC_Periph.APB2ENR.ADC1EN := True;

      Ch := ADC_Chanel (P.Pin);
      case P.Port is
         when PA =>
            null;

         when PB =>
            Ch := Ch + 8;

         when PC =>
            Ch := Ch + 10;

         when others =>
            raise Constraint_Error; -- should not happen
      end case;

      Implementation.Initialize_Single_Conversion (P, Ch);
   end Initialize_Single_Conversion;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean is
   begin
      return Implementation.Initialized;
   end Initialized;

   ----------------------
   -- Get_Single_Value --
   ----------------------

   function Get_Single_Value return Interfaces.Unsigned_8 is
   begin
      return Implementation.Get_Single_Value;
   end Get_Single_Value;

   ---------
   -- Off --
   ---------

   procedure Off is
   begin
      Implementation.Off;
   end Off;

end STM32.ADC.ADC1;
