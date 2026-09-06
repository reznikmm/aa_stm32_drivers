package body STM32.ADC.ADC1.RND is

   ------------
   -- Random --
   ------------

   function Random return Interfaces.Unsigned_16
   is
      Result : Interfaces.Unsigned_16 with Warnings => Off;

   begin
      for Index in 1 .. 8 loop
         Result := Shift_Left (Result, 2) or
           Interfaces.Unsigned_16 (STM32.ADC.ADC1.Get_Single_Value and 2#11#);
      end loop;

      return Result;
   end Random;

end STM32.ADC.ADC1.RND;
