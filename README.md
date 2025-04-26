# aa_stm32_drivers

> Another Ada STM32 MCU Drivers Library

A lightweight, generic-based driver library for STM32 microcontrollers.
This library provides low-level drivers for common peripherals while
prioritizing simplicity and efficiency.

## Features

- Simple and efficient peripheral drivers for:
  - GPIO
  - UART
  - I2C
  - SPI
  - Timers
  - MCUs UID
  - Flash
- Support for:
  - STM32F407 (using the `light-tasking-stm32f4` Ada runtime library)
  - STM32F429 (using the `light-tasking-stm32f429disco` Ada runtime library)

## Design Philosophy

This library avoids using tagged types (object-oriented programming, as used
in the Ada Drivers Library and HAL) in favor of Ada generics.
The rationale for this decision includes:

- Most embedded applications use a fixed hardware configuration and don't
  require runtime polymorphism to switch between different peripheral
  implementations.
- Generic units provide compile-time specialization, leading to more
  efficient code.
- A simpler implementation without the overhead of tagged types.
- Better optimization opportunities for the compiler.

## Installation

Add this library to your project using Alire:

```shell
alr with aa_stm32_drivers --use=https://github.com/reznikmm/aa_stm32_drivers
```

## Usage

STM32 devices use pins grouped into ports. To specify a pin, provide a port
name (enumeration literals `PA`, `PB`, etc) and a pin number (0 to 15).

### GPIO

To configure a GPIO pin for output, use the `Configure_Output` procedure:

```ada
STM32.GPIO.Configure_Output (Pin => (STM32.PA, 1));
```

Set the pin state using:

```ada
STM32.GPIO.Set_Output (Pin => (STM32.PA, 1), Value => 0);  -- Clear pin
STM32.GPIO.Set_Output (Pin => (STM32.PA, 1), Value => 1);  -- Set pin
```

For input pins, configure them as interrupt sources and optionally
enable pull-up or pull-down resistors:

```ada
STM32.GPIO.Configure_Interrupt (Pin => (STM32.PA, 1));  -- No pull-up/down resistors
STM32.GPIO.Configure_Interrupt (Pin => (STM32.PA, 1), Pull_Up => True);
STM32.GPIO.Configure_Interrupt (Pin => (STM32.PA, 1), Pull_Down => True);
```

Don't forget to clear the interrupt flag when handling an interrupt:

```ada
STM32.GPIO.Clear_Interrupt (Pin => (STM32.PA, 1));
```

### UART/USART

The library supports USART 1, 2, 3, 6, and UART 4, 5. To use UART/USART,
`with` the corresponding package, declare a device object, and configure
it with TX/RX pins and a baud rate. Define an interrupt priority for
the protected object.

```ada
with STM32.UART.USART_1;

procedure Main is
   package USART_1 is new STM32.UART.USART_1 (Priority => 241);
begin
   USART_1.Configure
     (TX    => (STM32.PA, 9),
      RX    => (STM32.PA, 10),
      Speed => 115_200);
end Main;
```

Use `Start_Reading` to initiate reading and `Start_Writing` for writing.
The library leverages the 
[`A0B.Callbacks` crate](https://github.com/godunko/a0b-callbacks)
for callbacks.

```ada
with Ada.Synchronous_Task_Control;
with A0B.Callbacks.Generic_Subprogram;
with STM32.UART.USART_1;

procedure Main is
   package Suspension_Object_Callbacks is new
     A0B.Callbacks.Generic_Subprogram
       (Ada.Synchronous_Task_Control.Suspension_Object,
        Ada.Synchronous_Task_Control.Set_True);

   package USART_1 is new STM32.UART.USART_1 (Priority => 241);

   Buffer  : String (1 .. 8);
   Signal  : aliased Ada.Synchronous_Task_Control.Suspension_Object;
   Done    : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Signal);
begin
   USART_1.Configure
     (TX    => (STM32.PA, 9),
      RX    => (STM32.PA, 10),
      Speed => 115_200);

   loop
      USART_1.Start_Reading
        (Buffer'Address, Buffer'Length, Done);

      Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);

      -- Process Buffer here
   end loop;
end Main;
```

### I2C

Configure an I2C device by providing SDA, SCL pins, and the speed:

```ada
with STM32.I2C.I2C_1;

procedure Main is
   package I2C_1 is new STM32.I2C.I2C_1 (Priority => 241);
begin
   I2C_1.Configure
     (SDA => (STM32.PB, 7),
      SCL => (STM32.PB, 8),
      Speed => 400_000);
end Main;
```

Use `Start_Data_Exchange` to initiate transfers. The transfer can read data
from the slave, write data to the slave or write some data and then read
as a single transaction enclosed in start/stop condition signals.
```ada
I2C_1.Start_Data_Exchange
  (Slave    => 16#1E#,         --  Slave address 0 .. 0x7F
   Buffer   => Buffer'Address, --  Buffer to read/write
   Write    => 1,              --  Number of bytes to write
   Read     => Buffer'Length,  --  Number of bytes to read
   Callback => Done);
```

The callback is called when the transfer is complete.

### SPI

Configure an SPI device by specifying SCK, MISO, MOSI pins, and the speed:

```ada
SPI_1.Configure
  (SCK   => (STM32.PB, 3),
   MISO  => (STM32.PB, 4),
   MOSI  => (STM32.PB, 5),
   Speed => 2_800_000);  --  2.8 MHz
```

Several SPI devices can be connected to the same SPI bus. 
A specific device is activated by a dedicated pin usually called `CS` (Chip Select).
SPI transfers are bidirectional. The user provides data to write in the buffer.
When the transfer is complete the buffer is filled with read data.

Initiate transfers using `Start_Data_Exchange`:

```ada
SPI_1.Start_Data_Exchange
  (CS       => (STM32.PB, 6),
   Buffer   => Buffer'Address,
   Size     => Buffer'Length,
   Callback => Done);
```

The callback is called when the transfer is complete.

### Timers

A timer can be configured to generate a PWM (pulse width modulation) signal.
To configure a timer provide a pin to which the PWM signal will be output and a frequency.

```ada
TIM_3.Configure_PWM
  (Pin   => (STM32.PC, 8),
   Speed => 1_000_000);  -- 1 MHz
```

Start PWM signal generation with `Start_PWM` providing
- period in cycles of given frequency
- duty cycle in cycles of given frequency
- a callback to be called when next PWM parameters could be set.

```ada
TIM_3.Start_PWM
  (Period => 30_000,  -- 30 ms
   Duty   => 600,     -- 600 µs
   Done   => Done);
```

### UID

You can get unique identifier of the device using `UID` and `UID_Image`
functions. They return the same value, but use different types
(`Unsigned_64` and `String (1 .. 8)`).

```ada
Put_Line (STM32.UIDs.UID_Image);
```

### Flash

Procedures for flash memory include:
- `Unlock` and `Lock` for protection control.
- `Erase_Sector` to erase a sector (it returns sector size).
- `Programming` to enable writing.

Note. On STM32F407 the code can't be executed from flash memory while
flash is being written/erased. On STM32F429 the code can be executed
from one flash memory bank while another is being written/erased.

```ada
STM32.Flash.Unlock;

STM32.Flash.Erase_Sector
  (Address => System'To_Address (16#0800_0000#),
   Size    => Sector_Size,
   Done    => Done);

-- Wait for the sector to erase, then write:
for J in 1 .. Sector_Size loop
   STM32.Flash.Programming;
   -- Write a word to 0x800_0000 + J - 1
end loop;

STM32.Flash.Lock;
```

## Maintainer

[@MaximReznik](https://github.com/reznikmm)

## Contribute

Contributions are welcome! Feel free to submit a pull request.

## License

This project is licensed under the Apache 2.0 License with LLVM Exceptions.
See the [LICENSES](LICENSES) files for details.

