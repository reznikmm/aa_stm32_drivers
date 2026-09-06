--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Random number generator for STM32.

with Ada.Interrupts.Names;
with Interfaces;
with System;

with A0B.Callbacks;

package STM32.RNG is

   procedure Configure;
   --  Configure and enable random number generator.

   procedure Enable;
   --  Enable random number generator.

   procedure Disable;
   --  Disable random number generator.

   function Is_Ready return Boolean;
   --  Check if next random value is ready

   procedure Get_Next (Value : out Interfaces.Unsigned_32);
   --  Wait when next random value is ready and read it

   generic
      Priority   : System.Interrupt_Priority;
      --  Priority is used for underlying protected object.
   package Generic_RNG is

      type Unsigned_32_Array is
        array (Positive range <>) of Interfaces.Unsigned_32;

      procedure Start_Reading
        (Value : out Unsigned_32_Array;
         Done  : A0B.Callbacks.Callback);
      --  Start collecting random data to the Buffer. When Buffer is filled
      --  with words trigger Done callback. No other call to Start_Reading is
      --  allowed until Done is triggered. The buffer must remain available
      --  until Done is called.

      function Has_Error return Boolean;
      --  Return True if the RNG is no more able to generate random numbers
      --  because the RNG_CLK clock is not correct. Check that the clock
      --  controller is correctly configured to provide the RNG clock and
      --  clear the CEIS bit with Enable procedure.

   private

      protected Device
        with Interrupt_Priority => Priority
      is
         procedure Start_Reading
           (Value : out Unsigned_32_Array;
            Done  : A0B.Callbacks.Callback);

         function Has_Error return Boolean;

      private
         procedure Interrupt_Handler;

         pragma Attach_Handler
           (Interrupt_Handler,
            Ada.Interrupts.Names.HASH_RNG_Interrupt);

         Buffer : System.Address;
         Last   : Positive;
         Index  : Positive;
         Done   : A0B.Callbacks.Callback;
         Error  : Boolean := False;
      end Device;

   end Generic_RNG;

end STM32.RNG;
