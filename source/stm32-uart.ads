--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------

--  Common UART API shared with the STM32 drivers.
--
--  Child packages provide generics with operations for a particular UART
--  device. The device generic package is instantiated with the priority. Its
--  Start_Reading and Start_Writing operations initialise the IO operation and
--  return. When the operation is completed, it triggers a callback provided
--  as a parameter. Read and write operations use separate wires and can be
--  performed independently (in parallel or time overlap).

package STM32.UART is

   type Status is record
      Parity_Error   : Boolean;
      Framing_Error  : Boolean;
      Noise_Detected : Boolean;
      Overrun        : Boolean;
      Idle_Line      : Boolean;
      Data_Available : Boolean;
      Send_Complete  : Boolean;
      Ready_To_Send  : Boolean;
   end record;

   type Standard_Stop_Bits is range 1 .. 2;
   --  Number of stop bits.

   type Extended_Stop_Bits is delta 0.5 range 0.5 .. 2.0;
   --  Retained for API compatibility. Linux supports only 1.0 and 2.0;
   --  fractional values raise Constraint_Error when configuring a device.

   function "+" (Left : Standard_Stop_Bits) return Extended_Stop_Bits is
     (case Left is when 1 => 1.0, when 2 => 2.0);

   type Parity is (None, Even, Odd);

end STM32.UART;
