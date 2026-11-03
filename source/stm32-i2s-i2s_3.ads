--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with A0B.Callbacks;

private with Ada.Interrupts.Names;
private with STM32.Registers.SPI;

generic
   Priority : System.Interrupt_Priority;
package STM32.I2S.I2S_3 is

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

   procedure Start_Reading
     (Buffer : System.Address;
      Length : Transfer_Length;
      Done   : A0B.Callbacks.Callback);
   --  Capture Length half-words, stop the clocks and emit Done once on
   --  completion or error. Buffer must remain available until Done and be
   --  half-word aligned. Length must contain complete stereo frames (a
   --  multiple of 2 for Data_16/Extended, or 4 for Data_24/32). Invalid
   --  buffers/lengths raise Constraint_Error; an active transfer raises
   --  Program_Error. Check Has_Error after completion before using data.
   --  Done runs in interrupt context: only signal completion there; query
   --  status and start the next capture from a task.

   function Is_Busy return Boolean;
   function Has_Error return Boolean;
   --  Error state is reset by Start_Reading.

private

   package Implementation is new IRQ_Implementation
     (Periph => STM32.Registers.SPI.SPI3_Periph,
      AF     => 6,
      Interrupt => Ada.Interrupts.Names.SPI3_Interrupt,
      Priority  => Priority);

   procedure Start_Reading
     (Buffer : System.Address;
      Length : Transfer_Length;
      Done   : A0B.Callbacks.Callback)
     renames Implementation.Device.Start_Reading;

   function Is_Busy return Boolean renames Implementation.Device.Is_Busy;

   function Has_Error return Boolean
     renames Implementation.Device.Has_Error;

end STM32.I2S.I2S_3;
