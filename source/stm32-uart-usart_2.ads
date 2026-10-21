--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  USART_2 device.

with Interfaces;
with System;

with A0B.Callbacks;

generic
   Priority : System.Interrupt_Priority;
   --  Kept for API compatibility; Linux workers use normal task priorities.
package STM32.UART.USART_2 is

   procedure Configure
     (TX        : Pin;
      RX        : Pin;
      Rate      : Interfaces.Unsigned_32;
      Parity    : STM32.UART.Parity := None;
      Stop_Bits : Extended_Stop_Bits := 1.0)
     with Pre =>
       TX in (PA, 2) | (PD, 5) and then
       RX in (PA, 3) | (PD, 6);
   --
   --  Open ./uart_2_<TX-pin>_<RX-pin>, e.g. ./uart_2_PA2_PA3.
   --  The path is relative to the process working directory.

   procedure Set_Baud_Rate (Rate : Interfaces.Unsigned_32);
   --  Reconfigure USART_2 speed (baud rate)

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
   --  the UART line after at least one byte has been received. No other call
   --  to Start_Reading_Till_Idle or Start_Reading is allowed until Done is
   --  triggered.

   --  Buffers must remain valid until their callback runs. Callbacks execute
   --  in worker tasks, outside protected actions, and may start another IO.

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

   procedure Close;
   --  Cancel operations, wait for IO to stop, and close the file descriptor.
   --  Do not call from a completion callback.

end STM32.UART.USART_2;
