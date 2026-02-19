--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.Registers.RCC;
with STM32.Registers.RNG;

package body STM32.RNG is

   package body Generic_RNG is

      protected body Device is

         function Has_Error return Boolean is (Error);

         --------------
         -- Get_Next --
         --------------

         procedure Start_Reading
           (Value : out Unsigned_32_Array;
            Done  : A0B.Callbacks.Callback)
         is
            Periph : STM32.Registers.RNG.RNG_Peripheral renames
              STM32.Registers.RNG.RNG_Periph;
         begin
            Buffer := Value'Address;
            Last := Value'Length;
            Index := 1;
            Device.Done := Done;
            Error := False;

            if Periph.SR.DRDY then
               --  One in, one out - no interrupt change needed
               Value (Value'First) := Periph.DR;
               Index := Index + 1;
            end if;

            if Index <= Last then
               Periph.CR.IE := True;
            else
               A0B.Callbacks.Emit (Done);
            end if;
         end Start_Reading;

         -----------------------
         -- Interrupt_Handler --
         -----------------------

         procedure Interrupt_Handler is
            Value  : Unsigned_32_Array (1 .. Last)
              with Import, Address => Buffer;

            Periph : STM32.Registers.RNG.RNG_Peripheral renames
              STM32.Registers.RNG.RNG_Periph;
         begin
            if Periph.SR.CECS then
               Error := True;
               A0B.Callbacks.Emit (Done);
               Periph.CR.IE := False;

            elsif Periph.SR.SECS then
               Periph.SR :=
                 (SEIS          => False,  --  Reset SECS
                  CEIS          => True,   --  Don't reset SECS
                  Reserved_3_4  => 0,
                  Reserved_7_31 => 0,
                  others        => False);

            elsif Periph.SR.DRDY then
               Value (Index) := Periph.DR;

               if Index = Last then
                  Periph.CR.IE := False;
                  A0B.Callbacks.Emit (Done);
               else
                  Index := Index + 1;
               end if;

            end if;
         end Interrupt_Handler;

      end Device;

      ---------------
      -- Has_Error --
      ---------------

      function Has_Error return Boolean is (Device.Has_Error);

      -------------------
      -- Start_Reading --
      -------------------

      procedure Start_Reading
        (Value : out Unsigned_32_Array;
         Done  : A0B.Callbacks.Callback) is
      begin
         Device.Start_Reading (Value, Done);
      end Start_Reading;

   end Generic_RNG;

   ---------------
   -- Configure --
   ---------------

   procedure Configure is
      RCC : STM32.Registers.RCC.RCC_Peripheral renames
        STM32.Registers.RCC.RCC_Periph;
   begin
      RCC.AHB2ENR.RNGEN := True;
      RCC.AHB2RSTR.RNGRST := True;
      RCC.AHB2RSTR.RNGRST := False;
      Enable;
   end Configure;

   -------------
   -- Disable --
   -------------

   procedure Disable is
      Periph : STM32.Registers.RNG.RNG_Peripheral renames
        STM32.Registers.RNG.RNG_Periph;
   begin
      Periph.CR.RNGEN := False;
   end Disable;

   ------------
   -- Enable --
   ------------

   procedure Enable is
      Periph : STM32.Registers.RNG.RNG_Peripheral renames
        STM32.Registers.RNG.RNG_Periph;
   begin
      Periph.CR.RNGEN := True;

      Periph.SR :=
        (CEIS          => False,  --  Reset CECS
         SEIS          => False,  --  Reset SECS
         Reserved_3_4  => 0,
         Reserved_7_31 => 0,
         others        => False);
   end Enable;

   --------------
   -- Get_Next --
   --------------

   procedure Get_Next (Value : out Interfaces.Unsigned_32) is
      Periph : STM32.Registers.RNG.RNG_Peripheral renames
        STM32.Registers.RNG.RNG_Periph;
   begin
      while not Periph.SR.DRDY loop
         null;
      end loop;

      Value := Periph.DR;
   end Get_Next;

   --------------
   -- Is_Ready --
   --------------

   function Is_Ready return Boolean is
      Periph : STM32.Registers.RNG.RNG_Peripheral renames
        STM32.Registers.RNG.RNG_Periph;
   begin
      return Periph.SR.DRDY;
   end Is_Ready;

end STM32.RNG;
