--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  TIM5 device using DMA.

with Interfaces;
with System;

with A0B.Callbacks;

private with STM32.DMA.Stream_1_0;

generic
   Priority : System.Any_Priority;
   --  Priority is used for underlying protected object.
package STM32.Timer.DMA_TIM_5 is

   subtype Pin_Array is STM32.Timer.Pin_Array
     with Dynamic_Predicate =>
       (if 1 in Pin_Array'Range then Pin_Array (1) = (PA, 0)) and
       (if 2 in Pin_Array'Range then Pin_Array (2) = (PA, 1)) and
       (if 3 in Pin_Array'Range then Pin_Array (3) = (PA, 2)) and
       (if 4 in Pin_Array'Range then Pin_Array (4) = (PA, 3));

   procedure Configure_PWM
     (Pins    : Pin_Array;
      Speed   : Interfaces.Unsigned_32;
      Period  : Interfaces.Unsigned_32;
      Duty    : Interfaces.Unsigned_32);
   --  Configure TIM5 on given pins, speed, constant period and duty.

   procedure Start_PWM_With_Period
     (Period  : Unsigned_32_Array;
      On_Half : A0B.Callbacks.Callback);
   --  Start PWM generation. After each cycle, change the period to the value
   --  from the next element of the Period array. When the middle and end of
   --  the array are reached, call On_Half callback. The procedure saves the
   --  array address, so the array must remain accessible until PWM generation
   --  is complete. To stop generation, call the Stop procedure.

   procedure Start_PWM_With_Duty
     (Duty    : Unsigned_32_Array;
      On_Half : A0B.Callbacks.Callback);
   --  Start generating PWM. After each cycle, change the Duty of each active
   --  channel to the value from the next element of the Duty array. For
   --  example, for 3 channels, Duty should be Duty1, Duty2, Duty3, then the
   --  values for the next cycle are similar. When you reach the middle of the
   --  array and its end, call Half callback. The procedure saves the array
   --  address, so the array must remain accessible until the end of PWM
   --  generation. To stop generation, call the Stop procedure.

   procedure Start_PWM
     (Data    : Unsigned_32_Array;
      On_Half : A0B.Callbacks.Callback);
   --  Start generating PWM by changing the period and duty of each active
   --  channel after each cycle. The elements of the Data array must contain
   --  the period and duty of the active channels. For example, for 3 channels,
   --  Data should contain Period, Duty1, Duty2, Duty3, then the values for
   --  the next cycle similarly. When the middle of the array and its end
   --  are reached, call the On_Half callback. The procedure saves the array
   --  address, so the array must remain accessible until the end of PWM
   --  generation. To stop generation, call the Stop procedure.
   --
   --  To make this work Pins'First should be 1 in Configure_PWM call.

   procedure Stop;
   --  To stop PWM generation

private

   package DMA_1_Stream_0 is new STM32.DMA.Stream_1_0 (Priority);

   package Implementation is new DMA_Implementation
     (STM32.Registers.TIM.TIM5_Periph,
      Channel => 6,
      Stream  => DMA_1_Stream_0.Stream);

   procedure Start_PWM_With_Duty
     (Duty    : Unsigned_32_Array;
      On_Half : A0B.Callbacks.Callback) renames Implementation.Start_PWM_Duty;

   procedure Start_PWM_With_Period
     (Period    : Unsigned_32_Array;
      On_Half   : A0B.Callbacks.Callback)
        renames Implementation.Start_PWM_Period;

   procedure Start_PWM
     (Data    : Unsigned_32_Array;
      On_Half : A0B.Callbacks.Callback) renames Implementation.Start_PWM;

   procedure Stop renames Implementation.Stop;

end STM32.Timer.DMA_TIM_5;
