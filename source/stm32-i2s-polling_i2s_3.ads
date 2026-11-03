--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

private with STM32.Registers.SPI;

package STM32.I2S.Polling_I2S_3 is

   procedure Configure
     (CK        : Pin;
      WS        : Pin;
      SD        : Pin;
      Frequency : Positive;
      Clock     : Positive;
      Format    : Data_Format := Data_16;
      Standard  : I2S_Standard := Philips;
      Polarity  : Clock_Polarity := Idle_Low)
     with Pre =>
       CK in (PB, 3) | (PC, 10) and then
       WS = (PA, 4) and then
       SD in (PB, 5) | (PC, 12);
   --  Configure master receive with MCLK output disabled. Clock is the
   --  I2S source clock in Hz, configured by the application (PLLI2S or
   --  external I2S_CKIN), not PCLK1. Frequency is the stereo sample rate.
   --  The nearest prescaler is used; an unsupported rate raises
   --  Constraint_Error. Configure only while no transfer is active.

   procedure Receive (Buffer : System.Address; Length : Transfer_Length);
   --  Capture Length half-words, then stop the clocks. Buffer must be
   --  half-word aligned and hold Length half-words. Length must contain
   --  complete stereo frames (a multiple of 2 for Data_16/Extended, or
   --  4 for Data_24/32). Invalid buffers/lengths raise Constraint_Error.
   --  Returns early on overrun; check Has_Error before using the buffer.
   --  Calls on this device must be serialized by the application.

   function Has_Error return Boolean;
   --  Overrun during the last capture. Reset at Configure/Receive.

private

   package Implementation is new Polling_Implementation
     (Periph => STM32.Registers.SPI.SPI3_Periph,
      AF     => 6);

   procedure Receive (Buffer : System.Address; Length : Transfer_Length)
     renames Implementation.Receive;

   function Has_Error return Boolean renames Implementation.Has_Error;

end STM32.I2S.Polling_I2S_3;
