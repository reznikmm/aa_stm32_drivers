
--  Random based on ADC1 device by picks up thermal noise on pin

package STM32.ADC.ADC1.RND is

   function Random return Interfaces.Unsigned_16
     with Pre => STM32.ADC.ADC1.Is_Initialized;
   --  Call STM32.ADC.ADC1.Initialize_Single_Conversion
   --    or STM32.ADC.ADC1.Initialize_Temperature before call this method

end STM32.ADC.ADC1.RND;
