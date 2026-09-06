--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Warnings (Off, "is an internal GNAT unit");
with System.BB.Board_Parameters;
pragma Warnings (On, "is an internal GNAT unit");

with STM32F411_Runtime_Config; use STM32F411_Runtime_Config;

package body STM32.System_Clocks is

   function PCLK1 return Interfaces.Unsigned_32 is
     (Interfaces.Unsigned_32 (System.BB.Board_Parameters.APB1_Freq));

   function PCLK2 return Interfaces.Unsigned_32 is
     (Interfaces.Unsigned_32 (System.BB.Board_Parameters.APB2_Freq));

   function TIMCLK1 return Interfaces.Unsigned_32 is
     (Interfaces.Unsigned_32
        ((if STM32F411_Runtime_Config.APB1_Pre = DIV1
         then System.BB.Board_Parameters.APB1_Freq
         else System.BB.Board_Parameters.APB1_Freq * 2)));

   function TIMCLK2 return Interfaces.Unsigned_32 is
     (Interfaces.Unsigned_32
        ((if STM32F411_Runtime_Config.APB2_Pre = DIV1
         then System.BB.Board_Parameters.APB2_Freq
         else System.BB.Board_Parameters.APB2_Freq * 2)));

   function HSE return Interfaces.Unsigned_32 is
      (System.BB.Board_Parameters.HSE_Freq);

end STM32.System_Clocks;
