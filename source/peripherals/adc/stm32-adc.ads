
--  Common code for ADC STM32.

with Interfaces; use Interfaces;
private with STM32.Registers.ADC;

package STM32.ADC is

   subtype ADC_Chanel is Interfaces.Unsigned_32 range 0 .. 15;

private

   subtype Internal_ADC_Chanel is Interfaces.Unsigned_32 range 16 .. 18;
   subtype All_ADC_Chanel is Interfaces.Unsigned_32 range 0 .. 18;

   generic
      Common : in out STM32.Registers.ADC.ADC_Common_Peripheral;
      Periph : in out STM32.Registers.ADC.ADC_Peripheral;
   package ADC_Implementation is
      --  Generic implementation for ADC initializaion and operations

      procedure Initialize_Single_Conversion
        (P  : Pin;
         Ch : ADC_Chanel);

      procedure Initialize_Temperature_Chanel (Ch : Internal_ADC_Chanel);
      procedure Initialize_VBAT_Chanel (Ch : Internal_ADC_Chanel);

      procedure Initialize_Chanel (Ch : All_ADC_Chanel);

      function Is_Initialized return Boolean with Inline;

      function Get_Single_Value return Interfaces.Unsigned_8
        with Pre => Is_Initialized;

      procedure Off;

   end ADC_Implementation;

end STM32.ADC;
