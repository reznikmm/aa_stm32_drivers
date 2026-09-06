package STM32.ADC.ADC1.RND is

   function Random return Interfaces.Unsigned_16
     with Pre => Initialized;

end STM32.ADC.ADC1.RND;
