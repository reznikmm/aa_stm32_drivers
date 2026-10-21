--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Interfaces;
with System;
with A0B.Callbacks;
with STM32.UART.Linux_Devices;

generic
   Priority : System.Interrupt_Priority;
package STM32.UART.USART_2 is

   package Implementation is new Linux_Devices.Port_2.Device (Priority);
   --  Thin API aliases; all behavior is in Generic_UART.Device.

   procedure Configure
     (TX        : Pin;
      RX        : Pin;
      Rate      : Interfaces.Unsigned_32;
      Parity    : STM32.UART.Parity := None;
      Stop_Bits : Extended_Stop_Bits := 1.0)
     renames Implementation.Configure;

   procedure Set_Baud_Rate (Rate : Interfaces.Unsigned_32)
     renames Implementation.Set_Baud_Rate;

   procedure Set_Stop_Bits (Value : Standard_Stop_Bits)
     renames Implementation.Set_Stop_Bits;

   procedure Set_Stop_Bits (Value : Extended_Stop_Bits)
     renames Implementation.Set_Stop_Bits;

   procedure Set_Parity (Value : Parity)
     renames Implementation.Set_Parity;

   procedure Enable
     renames Implementation.Enable;

   procedure Disable
     renames Implementation.Disable;

   procedure Start_Reading
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback)
     renames Implementation.Start_Reading;

   procedure Start_Reading_Till_Idle
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback)
     renames Implementation.Start_Reading_Till_Idle;

   function Bytes_Read return Natural
     renames Implementation.Bytes_Read;

   procedure Start_Writing
     (Buffer : System.Address;
      Length : Positive;
      Done   : A0B.Callbacks.Callback)
     renames Implementation.Start_Writing;

   function Is_Busy return Boolean
     renames Implementation.Is_Busy;

   function Has_Error return Boolean
     renames Implementation.Has_Error;

   procedure Stop
     renames Implementation.Stop;

   procedure Close
     renames Implementation.Close;

end STM32.UART.USART_2;
