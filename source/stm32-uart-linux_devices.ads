--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with STM32.UART.Generic_UART;

--  Internal port definitions. Instantiating a public Device generic creates
--  its own descriptor and operation slots on the shared dispatcher.
package STM32.UART.Linux_Devices is

   function Extended (Value : Extended_Stop_Bits) return Extended_Stop_Bits is
     (Value);
   function Extended (Value : Standard_Stop_Bits) return Extended_Stop_Bits is
     (+Value);

   package Port_1 is new Generic_UART
     (Number => 1,
      TX_Pins => ((PA, 9), (PB, 6)),
      RX_Pins => ((PA, 10), (PB, 7)),
      Configure_Stop_Bits => Extended_Stop_Bits,
      Default_Stop_Bits => 1.0,
      To_Extended => Extended);

   package Port_2 is new Generic_UART
     (Number => 2,
      TX_Pins => ((PA, 2), (PD, 5)),
      RX_Pins => ((PA, 3), (PD, 6)),
      Configure_Stop_Bits => Extended_Stop_Bits,
      Default_Stop_Bits => 1.0,
      To_Extended => Extended);

   package Port_3 is new Generic_UART
     (Number => 3,
      TX_Pins => ((PB, 10), (PC, 10), (PD, 8)),
      RX_Pins => ((PB, 11), (PC, 11), (PD, 9)),
      Configure_Stop_Bits => Extended_Stop_Bits,
      Default_Stop_Bits => 1.0,
      To_Extended => Extended);

   package Port_4 is new Generic_UART
     (Number => 4,
      TX_Pins => ((PA, 0), (PC, 10)),
      RX_Pins => ((PA, 1), (PC, 11)),
      Configure_Stop_Bits => Standard_Stop_Bits,
      Default_Stop_Bits => 1,
      To_Extended => Extended);

   package Port_5 is new Generic_UART
     (Number => 5,
      TX_Pins => (1 => (PC, 12)),
      RX_Pins => (1 => (PD, 2)),
      Configure_Stop_Bits => Standard_Stop_Bits,
      Default_Stop_Bits => 1,
      To_Extended => Extended);

   package Port_6 is new Generic_UART
     (Number => 6,
      TX_Pins => (1 => (PC, 6)),
      RX_Pins => (1 => (PC, 7)),
      Configure_Stop_Bits => Extended_Stop_Bits,
      Default_Stop_Bits => 1.0,
      To_Extended => Extended);

end STM32.UART.Linux_Devices;
