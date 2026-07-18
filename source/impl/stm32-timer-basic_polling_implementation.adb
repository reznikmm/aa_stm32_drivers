--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

package body STM32.Timer.Basic_Polling_Implementation is

   procedure Configure (Setting : Basic_Settings) is
      CR1 : STM32.Registers.TIM.CR1_Register := Periph.CR1;
   begin
      if Setting.Auto_Reload_Buffered.Is_Set then
         CR1.ARPE := Setting.Auto_Reload_Buffered.Value;
      end if;

      if Setting.One_Pulse_Mode.Is_Set then
         CR1.OPM := Setting.One_Pulse_Mode.Value;
      end if;

      if Setting.Update_Request.Is_Set then
         CR1.URS := not Setting.Update_Request.Value;
      end if;

      if Setting.Update_Disable.Is_Set then
         CR1.UDIS := Setting.Update_Disable.Value;
      end if;

      if Setting.Enable.Is_Set then
         CR1.CEN := Setting.Enable.Value;
      end if;

      Periph.CR1 := CR1;
   end Configure;

   function To_Basic_Configuration
     (CR1 : STM32.Registers.TIM.CR1_Register) return Basic_Configuration is
      (Auto_Reload_Buffered => CR1.ARPE,
       One_Pulse_Mode       => CR1.OPM,
       Update_Request       => not CR1.URS,
       Update_Disable       => CR1.UDIS,
       Enable               => CR1.CEN) with Inline;

   function Configuration return Basic_Configuration is
      (To_Basic_Configuration (Periph.CR1));

   function Frequency (Clock : Interfaces.Unsigned_32) return Positive is
      use type Interfaces.Unsigned_32;
   begin
      return Positive (Clock / (Periph.PSC + 1));
   end Frequency;

   procedure Update_Generation is
   begin
      Periph.EGR :=
        (UG       => True,
         Reserved => 0,
         CCxG     => (others => False),
         others   => False);
   end Update_Generation;

   procedure Set_Frequency
     (Value : Positive;
      Clock : Interfaces.Unsigned_32)
   is
      use type Interfaces.Unsigned_32;
      Prescaler : Interfaces.Unsigned_32 :=
       Clock / Interfaces.Unsigned_32 (Value);
   begin
      Prescaler := Interfaces.Unsigned_32'Max (Prescaler, 1);
      Prescaler := Interfaces.Unsigned_32'Min (Prescaler, 2**16);
      Set_Prescaler (Interfaces.Unsigned_16 (Prescaler - 1));
   end Set_Frequency;

   procedure Set_Prescaler (Value : Interfaces.Unsigned_16) is
   begin
      Periph.PSC := Interfaces.Unsigned_32 (Value);
   end Set_Prescaler;

   procedure Set_Counter (Value : Interfaces.Unsigned_16) is
   begin
      Periph.CNT := Interfaces.Unsigned_32 (Value);
   end Set_Counter;

   procedure Set_Auto_Reload_Value (Value : Interfaces.Unsigned_16) is
   begin
      Periph.ARR := Interfaces.Unsigned_32 (Value);
   end Set_Auto_Reload_Value;

end STM32.Timer.Basic_Polling_Implementation;
