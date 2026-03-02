--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

private with STM32.Registers.USART;

package STM32.UART.Polling_USART_3 is

   procedure Configure
     (TX   : Pin;
      RX   : Pin;
      Rate : Interfaces.Unsigned_32)
     with Pre =>
       TX in (PB, 10) | (PC, 10) | (PD, 8) and then
       RX in (PB, 11) | (PC, 11) | (PD, 9);
   --  Configure USART_3 on given pins and baud rate

   procedure Set_Baud_Rate (Rate : Interfaces.Unsigned_32);
   --  Reconfigure USART_3 baud rate. Don't call while send in not complete

   function Status return STM32.UART.Status with Inline;
   --  Return current receiver/transmitter status

   function Data_Available return Boolean is (Status.Data_Available);
   --  Check if RX data available

   procedure Receive (Data : out Interfaces.Unsigned_8);
   --  Wait for RX data and read it into Data

   function Ready_To_Send return Boolean is (Status.Ready_To_Send);
   --  Check if TX register is empty

   procedure Send (Data : Interfaces.Unsigned_8);
   --  Wait while is TX register is empty and push Data to it

   procedure Put (Data : String);
   --  Send eah character of Data using Send procedure

private

   package Implementation is new Polling_Implementation
     (STM32.Registers.USART.USART3_Periph,
      UART_1_3);

   function Status return STM32.UART.Status renames Implementation.Status;

   procedure Send (Data : Interfaces.Unsigned_8) renames Implementation.Send;

   procedure Put (Data : String) renames Implementation.Put;

   procedure Receive (Data : out Interfaces.Unsigned_8)
     renames Implementation.Receive;

end STM32.UART.Polling_USART_3;
