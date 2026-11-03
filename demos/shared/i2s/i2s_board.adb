--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.GPIO;
with STM32.Registers.GPIO;
with STM32.Registers.RCC;

package body I2S_Board is

   ---------------------
   -- Configure_Clock --
   ---------------------

   procedure Configure_Clock is
      GPIO : STM32.Registers.GPIO.GPIO_Peripheral renames
        STM32.Registers.GPIO.GPIO_Periph (STM32.PC);
   begin
      STM32.GPIO.Enable_GPIO (STM32.PC);
      GPIO.MODER (9) := STM32.Registers.GPIO.Mode_AF;
      GPIO.PUPDR (9) := STM32.Registers.GPIO.No_Pull;
      GPIO.AFR (9) := 5;  --  I2S_CKIN
      STM32.Registers.RCC.RCC_Periph.CFGR.I2SSRC := False;

      --  I2S VCO = HSE/M * I2SN should be in 100..432 MHz
      --  50 ≤ PLLI2SN ≤ 432, 2 ≤ PLLR ≤ 7
      --  I2S CLK = I2S VCO / I2SR should be ≤ 192 MHz

      --  Here we have HSE/M=1MHz, I2S CLK = 86MHz
      STM32.Registers.RCC.RCC_Periph.PLLI2SCFGR :=
        (Reserved_0_5   => 0,
         PLLI2SNx       => 258,
         Reserved_15_27 => 0,
         PLLI2SRx       => 3,
         Reserved_31_31 => 0);

      STM32.Registers.RCC.RCC_Periph.CR.PLLI2SON := True;

      while not STM32.Registers.RCC.RCC_Periph.CR.PLLI2SRDY loop
         null;
      end loop;
   end Configure_Clock;

end I2S_Board;
