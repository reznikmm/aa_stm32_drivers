
--  ADC1 device.

package STM32.ADC.ADC1 is

   --  Pin   ADC Channel
   --  PA0   ADC1_IN0
   --  PA1   ADC1_IN1
   --  PA2   ADC1_IN2
   --  PA3   ADC1_IN3
   --  PA4   ADC1_IN4
   --  PA5   ADC1_IN5
   --  PA6   ADC1_IN6
   --  PA7   ADC1_IN7
   --  PB0   ADC1_IN8
   --  PB1   ADC1_IN9
   --  PC0   ADC1_IN10
   --  PC1   ADC1_IN11
   --  PC2   ADC1_IN12
   --  PC3   ADC1_IN13
   --  PC4   ADC1_IN14
   --  PC5   ADC1_IN15

   procedure Initialize_Single_Conversion (P : Pin)
     with Pre =>
       P in (PA, 0) | (PA, 1) | (PA, 2) | (PA, 3) | (PA, 4) | (PA, 5) |
         (PA, 6) | (PA, 7) | (PB, 0) | (PB, 1) | (PC, 0) | (PC, 1) |
           (PC, 2) | (PC, 3) | (PC, 4) | (PC, 5);
   --
   --  (Re-)configure ADC1 on given pin

   procedure Initialize_For_Temperature;
   --  (Re-)configure ADC1 to read internal temperature sensor data

   procedure Initialize_For_VBAT;
   --  (Re-)configure ADC1 for battery charge monitoring

   function Is_Initialized return Boolean with Inline;
   --  Returns True if ADC1 is initialized

   function Get_Single_Value return Interfaces.Unsigned_8;
   --  Get conversion value.
   --  Should be called after Initialize*

   procedure Off;
   --  Turn ADC1 off

private

   package Implementation is new ADC_Implementation
     (STM32.Registers.ADC.ADC_Common_Periph, STM32.Registers.ADC.ADC1_Periph);

end STM32.ADC.ADC1;
