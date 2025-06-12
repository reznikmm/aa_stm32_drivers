--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Common code for timer STM32.
--
--  Child packages provide generics with operations for a particular timer
--  device. The device generic package is instantinated with the priority. Its
--  Start_PWM operation sets PWM setting to by applied on the next cycle and
--  returns. When settings are applied, it triggers a callback provided as
--  a parameter.

private with Ada.Interrupts;
with Interfaces;
private with System;

private with STM32.Registers.TIM;
private with STM32.DMA;

private with A0B.Callbacks;

package STM32.Timer is

   subtype Channel_Index is Positive range 1 .. 4;

   type Pin_Array is array (Channel_Index range <>) of STM32.Pin;

   type Unsigned_32_Array is array (Positive range <>)
     of Interfaces.Unsigned_32;

private

   procedure Init_GPIO (Item : Pin; Fun : Interfaces.Unsigned_32);

   AF_TIM_3_4_5 : constant := 2;

   generic
      Periph    : in out STM32.Registers.TIM.TIM_Peripheral;
      Channel   : Channel_Index;
      Interrupt : Ada.Interrupts.Interrupt_ID;
      Priority  : System.Interrupt_Priority;
   package TIM_Implementation is
      --  Generic implementation for timer initializaion, operations and
      --  interrupt handling procedure

      procedure Configure
        (Pin   : STM32.Pin;
         Fun   : Interfaces.Unsigned_32;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32);

      protected Device
        with Interrupt_Priority => Priority
      is

         procedure Start_PWM
           (Period : Interfaces.Unsigned_16;
            Duty   : Interfaces.Unsigned_16;
            Done   : A0B.Callbacks.Callback);

      private
         procedure Interrupt_Handler;

         pragma Attach_Handler (Interrupt_Handler, Interrupt);

         ARR  : Interfaces.Unsigned_32;
         CCR  : Interfaces.Unsigned_32;
         Done : A0B.Callbacks.Callback;
      end Device;

   end TIM_Implementation;

   generic
      Periph    : in out STM32.Registers.TIM.TIM_Peripheral;
      Channel   : STM32.DMA.Channel_Id;
      --  Interrupt : Ada.Interrupts.Interrupt_ID;
      --  Priority  : System.Interrupt_Priority;

      with package Stream is new STM32.DMA.Generic_DMA_Stream (<>);
   package DMA_Implementation is

      procedure Configure
        (Pin    : Pin_Array;
         Fun    : Interfaces.Unsigned_32;
         Speed  : Interfaces.Unsigned_32;
         Period : Interfaces.Unsigned_32;
         Duty   : Interfaces.Unsigned_32;
         Clock  : Interfaces.Unsigned_32);

      procedure Start_PWM_Duty
        (Duty    : Unsigned_32_Array;
         On_Half : A0B.Callbacks.Callback);

      procedure Start_PWM_Period
        (Period  : Unsigned_32_Array;
         On_Half : A0B.Callbacks.Callback);

      procedure Start_PWM
        (Data    : Unsigned_32_Array;
         On_Half : A0B.Callbacks.Callback);
      --  Data: Period + N x Duty

      procedure Stop;

   end DMA_Implementation;

end STM32.Timer;
