
with Interfaces; use Interfaces;
private with STM32.Registers.ADC;

package STM32.ADC is

   subtype ADC_Chanel is Interfaces.Unsigned_32 range 0 .. 15;

private

   generic
      Periph : in out STM32.Registers.ADC.ADC_Peripheral;

   package ADC_Implementation is

      procedure Initialize_Single_Conversion
        (P  : Pin;
         Ch : ADC_Chanel);

      function Initialized return Boolean with Inline;

      function Get_Single_Value return Interfaces.Unsigned_8;

      procedure Off;

   end ADC_Implementation;

end STM32.ADC;
