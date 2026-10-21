--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Internal Linux UART implementation shared by the public device generics.

with Interfaces;
with System;

with A0B.Callbacks;

generic
   Number : Positive;
   TX_Pins, RX_Pins : Pin_Array;
   type Configure_Stop_Bits is private;
   Default_Stop_Bits : Configure_Stop_Bits;
   with function To_Extended (Value : Configure_Stop_Bits)
     return Extended_Stop_Bits;
package STM32.UART.Generic_UART is

   function Valid_Pins (TX, RX : Pin) return Boolean is
     ((for some Value of TX_Pins => TX = Value) and then
      (for some Value of RX_Pins => RX = Value));

   generic
      Priority : System.Interrupt_Priority;
      --  Retained for API compatibility; the shared dispatcher ignores it.
   package Device is

      procedure Configure
        (TX        : Pin;
         RX        : Pin;
         Rate      : Interfaces.Unsigned_32;
         Parity    : STM32.UART.Parity := None;
         Stop_Bits : Configure_Stop_Bits := Default_Stop_Bits)
        with Pre => Valid_Pins (TX, RX);
      --
      --  Open ./uart_<Number>_<TX-pin>_<RX-pin>, e.g. ./uart_2_PA2_PA3.
      --  The path is relative to the process working directory.

      procedure Set_Baud_Rate (Rate : Interfaces.Unsigned_32);
      --  Reconfigure UART speed (baud rate)

      procedure Set_Stop_Bits (Value : Standard_Stop_Bits);
      --  Reconfigure STOP bits

      procedure Set_Stop_Bits (Value : Extended_Stop_Bits);
      --  Reconfigure STOP bits

      procedure Set_Parity (Value : Parity)
        with Pre => not Is_Busy;
      --  Reconfigure parity, retaining eight data bits.

      procedure Enable;
      --  Enable UART after Configure or Disable.

      procedure Disable;
      --  Cancel outstanding operations; their callbacks still run.
      --  Wait for completion before enabling or reconfiguring the port.

      procedure Start_Reading
        (Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback);
      --  Start reading into given Buffer of provided Length. When Buffer
      --  is filled with input bytes trigger Done callback. No other call to
      --  Start_Reading or Start_Reading_Till_Idle is allowed until Done is
      --  triggered.

      procedure Start_Reading_Till_Idle
        (Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback);
      --  Start a read operation into the provided Buffer of given Length. The
      --  read operation will complete and the Done callback will be triggered
      --  either when the Buffer is completely filled, or when an idle line
      --  condition (no new bytes received for a 100 ms) is detected on
      --  the UART line after at least one byte has been received. No call
      --  to Start_Reading_Till_Idle or Start_Reading is allowed until Done is
      --  triggered.

      --  Buffers must remain valid until their callback runs. Callbacks run
      --  in the shared dispatcher, outside protected actions, and may start
      --  another IO. They must be short, nonblocking, and must not raise.

      function Bytes_Read return Natural;
      --  Returns the number of bytes actually read during the last
      --  completed asynchronous read operation (e.g., Start_Reading or
      --  Start_Reading_Till_Idle). This function should be called only after
      --  the Done callback for a read operation has been triggered.

      procedure Start_Writing
        (Buffer : System.Address;
         Length : Positive;
         Done   : A0B.Callbacks.Callback);
      --  Start writing given Buffer of provided Length. When Buffer is
      --  sent trigger Done callback. No other call to Start_Writing is allowed
      --  until Done is triggered.

      function Is_Busy return Boolean;
      --  Returns True if device is reading or writing data

      function Has_Error return Boolean;
      --  True if either direction's last operation failed or was cancelled.
      --  Starting an operation clears the error for that direction.

      procedure Stop;
      --  Cancel IO and wait for callbacks, retaining the open, enabled port.
      --  Do not call from a completion callback.

      procedure Close;
      --  Cancel IO, wait for completion callbacks, and close the descriptor.
      --  Do not call from a completion callback.
   end Device;

end STM32.UART.Generic_UART;
