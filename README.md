# aa_stm32_drivers

> Another Ada STM32 MCU Drivers Library

A lightweight, generic-based driver library for STM32 microcontrollers.
This library provides low-level drivers for common peripherals while
prioritizing simplicity and efficiency.

## Driver Support Matrix

| Driver| Polling | IRQ | DMA |
| ----- | ------- | --- | --- |
| GPIO  |   Y     |  Y  |     |
| UART  |   Y     |  Y  |  Y  |
| I2C   |   -     |  Y  |  Y  |
| SPI   |   Y     |  Y  |  Y  |
| TIM   |   -     |  Y  |  Y  |
| RNG   |   Y     |  Y  |     |
| Flash |   -     |  Y  |     |
| UID   |   Y     |     |     |
| FSMC  |         |     |     |

## Table of Contents

- [Driver Support Matrix](#driver-support-matrix)
- [Features](#features)
- [Design Philosophy](#design-philosophy)
- [Installation](#installation)
- [Usage](#usage)
  - [GPIO](#gpio)
  - [UART/USART](#uartusart)
    - [UART Polling](#uart-polling)
    - [UART Interrupts](#uart-interrupts)
    - [UART DMA](#uart-dma)
  - [I2C](#i2c)
    - [I2C Interrupts](#i2c-interrupts)
    - [I2C DMA](#i2c-dma)
  - [SPI](#spi)
    - [SPI Polling](#spi-polling)
    - [SPI Interrupts and DMA](#spi-interrupts-and-dma)
  - [Timers](#timers)
  - [Timers with DMA](#timers-with-dma)
  - [UID](#uid)
  - [Flash](#flash)
  - [FSMC (Flexible static memory controller)](#flexible-static-memory-controller-fsmc)
  - [RNG (Random Number Generator)](#rng)
- [Demos](#demos)
- [Maintainer](#maintainer)
- [Contribute](#contribute)
- [License](#license)

## Features

- Simple and efficient peripheral drivers for:
  - GPIO (Polling, Interrupts APIs)
  - UART (Polling, Interrupts, DMA APIs)
  - I2C (Interrupts, DMA APIs)
  - SPI (Polling, Interrupts, DMA APIs)
  - Timers (Interrupts, DMA APIs)
  - MCUs UID
  - Flash for `stm32f429` (Interrupts API)
  - Flexible static memory controller (FSMC) for `stm32f40x`
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

#### UART Polling

The polling API is the simplest way to use UART/USART. It is ideal for debug
output (UART print), bootloaders, or simple programs where you do not want to
deal with callbacks. It is indispensable when you need to send a small number
of bytes.

There are no device objects or package instantiations. Use the appropriate
package, for example `STM32.UART.Polling_UART_5`, and call the procedures
directly. Use `Configure` to set up the peripheral, `Send` to transmit a
single byte, and `Put` to send a string (sequence of bytes).

Example:

```ada
with STM32.UART.Polling_UART_5;

procedure Main is
begin
  STM32.UART.Polling_UART_5.Configure
    (TX   => (STM32.PC, 12),
    RX   => (STM32.PD, 2),
    Rate => 115_200);

  STM32.UART.Polling_UART_5.Put ("Hello, world!\r\n");
end Main;
```

#### UART Interrupts

This variant supports USART 1, 2, 3, 6 and UART 4, 5. To use UART/USART with
interrupts, `with` the corresponding package, declare a device object, and
configure it with TX/RX pins and baud rate. Specify an interrupt priority for
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

#### UART DMA

The DMA variant of UART/USART allows efficient transfer of large amounts of
data with minimal CPU load. The API is analogous to the Interrupts variant.

### I2C

The I2C driver provides two variants with the same high-level API:

- Interrupt-driven: `STM32.I2C.I2C_1`
- DMA-assisted: `STM32.I2C.DMA_I2C_1`

#### I2C Interrupts

Configure an I2C device by providing SDA, SCL pins, and the speed:

The driver is interrupt-driven. The interrupt handler must respond before the
I2C hardware shifts out the next byte — in particular, it must assert NACK in
time at the end of a read transaction. If a higher-priority interrupt preempts
the I2C handler and causes it to miss that window, the transfer will
malfunction. It is therefore **strongly recommended to assign the highest
available interrupt priority** to the I2C device:

```ada
with STM32.I2C.I2C_1;

procedure Main is
   package I2C_1 is new STM32.I2C.I2C_1 (Priority => 255);
   --  Use the highest interrupt priority to ensure timely NACK handling.
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

If the bus is locked (e.g. a slave is holding SDA or SCL low forever),
the callback will never fire. Detecting and handling this situation -
for example by checking `Is_Bus_Busy` before starting a transfer and
enforcing a deadline with a watchdog or timeout — is the responsibility
of the caller.

#### I2C DMA

The DMA variant is useful for larger transfers and reduces CPU load during
data movement. Instantiate `STM32.I2C.DMA_I2C_1`, configure the pins and bus
speed, then use `Start_Data_Exchange` in the same way as the interrupt-driven
variant.

```ada
with STM32.I2C.DMA_I2C_1;

procedure Main is
  package I2C_1 is new STM32.I2C.DMA_I2C_1 (Priority => 241);
begin
  I2C_1.Configure
   (SDA   => (STM32.PB, 7),
    SCL   => (STM32.PB, 8),
    Speed => 400_000);
end Main;
```

Transfer completion is reported through the callback passed to
`Start_Data_Exchange`. Use `Has_Error` after completion to check whether the
last transfer failed.

#### Bus recovery

A slave can lock up the I2C bus by holding SDA low after an interrupted
transaction (power glitch, MCU reset mid-transfer, etc.). In that state
`Is_Bus_Busy` returns `True` and no new transfer can start.

Call `Recover_Bus` to recover. It performs next steps:

1. The I2C peripheral is reset.
2. The driver bit-bangs up to 9 SCL pulses (with SDA low) until the slave
   accepts the implicit NACK and releases the bus.
3. The peripheral is re-enabled.

```ada
if I2C_1.Is_Bus_Busy then
   I2C_1.Recover_Bus
     (SCL   => (STM32.PB, 8),
      SDA   => (STM32.PB, 7),
      Speed => 400_000);
end if;
```

The procedure takes approximately 9.5 clock cycles at the requested speed.
After it returns, check `Is_Bus_Busy` again and resume normal operation.

### SPI

The SPI driver provides three variants:

- Polling: `STM32.Polling.SPI_1` .. `SPI_5`
- Interrupt-driven: `STM32.SPI.SPI_1` .. `SPI_5`
- DMA-assisted: `STM32.SPI.DMA_SPI_1` .. `DMA_SPI_5`

#### SPI Polling

The polling API is the simplest way to talk to SPI_1 when transfers are
short and callbacks are not needed. Use `Configure` once, then `Send` and
`Receive` to exchange bytes synchronously.

`Receive` returns the byte that the slave shifted out during the previous
clocked transfer initiated by the master with `Send`. To receive the next
byte from the slave, the master must generate more SPI clocks by calling
`Send` again (usually with a dummy byte such as `16#00#`).

So if you need to send one request byte and read one response byte, do two
`Send` + `Receive` steps: first for the request phase, second for the
response phase.

```ada
with Interfaces;
with STM32.Polling.SPI_1;

procedure Main is
   package SPI renames STM32.Polling.SPI_1;
   Value : Interfaces.Unsigned_8;
begin
   SPI.Configure
     (SCK   => (STM32.PB, 3),
      MISO  => (STM32.PB, 4),
      MOSI  => (STM32.PB, 5),
      Speed => 3_000_000,
      Mode  => 3);

   --  Send request byte and read the simultaneously shifted byte
   SPI.Send (16#9F#);
   SPI.Receive (Value);

   --  Clock out one more byte to receive the response byte
   SPI.Send (16#00#);
   SPI.Receive (Value);
end Main;
```

#### SPI Interrupts and DMA

Configure an SPI device by specifying SCK, MISO, MOSI pins, and the speed:

```ada
SPI_1.Configure
  (SCK   => (STM32.PB, 3),
   MISO  => (STM32.PB, 4),
   MOSI  => (STM32.PB, 5),
   Speed => 2_800_000,  --  2.8 MHz
   Mode  => 0);
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
   Length   => Buffer'Length,
   Done     => Done);
```

The callback is called when the transfer is complete.

### Timers

A timer can be configured to generate a PWM (pulse width modulation) signal.
To configure a timer provide a pin to which the PWM signal will be output
and a base frequency.

```ada
TIM_3.Configure_PWM
  (Pin   => (STM32.PC, 8),
   Speed => 1_000_000);  -- 1 MHz (1µs per tick)
```

Start PWM signal generation with `Start_PWM` providing
- period in cycles of base frequency
- duty cycle in cycles of base frequency
- a callback to be called when next PWM parameters could be set.

```ada
TIM_3.Start_PWM
  (Period => 30_000,  -- 30 ms = 30_000 * 1µs
   Duty   => 600,     -- 600 µs = 600 * 1µs
   Done   => Done);
```

### Timers with DMA

The timer with DMA support can be configured by passing it a pin for each
active channel, the base frequency, and the period and duty values in pulses
of this base frequency. For example

```ada
TIM_3.Configure_PWM
  (Pins   =>
    (1 => (STM32.PA, 6),  --  Channel 1
     2 => (STM32.PC, 7)), --  Channel 2
   Speed  => 1_000_000,   -- 1 MHz (1µs per tick)
   Period => 30_000,      -- 30 ms
   Duty   => 600);        -- 600 µs
```

Now you can start continuous generation of the PWM signal in three
different ways.

* If you need a different period for each pulse, leave the pulse
  width constant you need to call `Start_PWM_With_Period`, passing
  it an array filled with the values of the desired periods and
  a callback. The callback will be called each time half of the
  buffer is transferred to the timer, allowing the user to change
  the values while the next half is being transferred to the timer.

  ```ada
     Buffer : STM32.Timers.Unsigned_16 (1 .. 10) :=
      (2_000, 3_000, others => 1_000);
  begin
     Start_PWM_With_Period (Buffer, Done);
     --  Wait for Done is called, change Buffer (1 .. 5)
  ```

  This will emit 2ms pulse, pause for 28ms, emit 3ms pulse, pause for
  27ms, emit 1ms pulse, pause for 29ms, etc.

* If you need a different pulse width for each pulse, leave the pulse
  period constant you need to call `Start_PWM_With_Duty`, passing
  it an array filled with the values of the desired widthws and
  a callback. Each active channel can have its own pulse width,
  so the array sequentially stores the width values for all active
  channels. Consider next example with two active channels

  ```ada
     Buffer : STM32.Timers.Unsigned_16 (1 .. 10) :=
      (2_000, 3_000, others => 1_000);
  begin
     Start_PWM_With_Duty (Buffer, Done);
     --  Wait for Done is called, change Buffer (1 .. 5)
  ```

  This will emit 2ms pulse, pause for 28ms on `PA6`, at the same time
  emit 3ms pulse, pause for 27ms on `PC7`, then next cyclce is started.

* It is possible to change both the pulse width in each active channel
  and the pulse period (common for all channels) with each pulse, but
  for this, channel 1 must be the first active channel
  (`Pins'First = 1` when calling `Configure_PWM`).
  In this case, the buffer will contain the period and width values
  for all active channels, the next period, and so on.

  ```ada
     Buffer : STM32.Timers.Unsigned_16 (1 .. 12) :=
      (20_000, 2_000, 3_000, others => 1_000);
  begin
     Start_PWM (Buffer, Done);
     --  Wait for Done is called, change Buffer (1 .. 6)
  ```

  This will emit 2ms pulse, pause for 18ms on `PA6`, at the same time
  emit 3ms pulse, pause for 17ms on `PC7`, then next cyclce is started.

To stop generation call `Stop`.

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
  (Address => STM32.Flash.Second_Bank,
   Size    => Sector_Size,
   Done    => Done);

-- Wait for the sector to erase, then write:
for J in 1 .. Sector_Size / 4 loop
   STM32.Flash.Programming;
   -- Enable writing into the flash.
   Buffer (J) := 16#AABBCCDD#;
   -- Write a word to 0x800_0000 + J - 1
end loop;

STM32.Flash.Lock;
```

### Flexible static memory controller (FSMC)

This component of STM32F40x/41x processors allows for the management
of static memory, flash memory, and PC Cards. Unlike the FMC in more
advanced MCU models, dynamic memory is not supported. Each type of
memory has its address bank. The controller offers flexible settings
for various operating modes. For instance, extended modes can have
different delays set for read and write operations. It is recommended
to refer to the STM32 Reference Manual (RM0090) for a detailed description
of possible modes and corresponding settings.

**Example**: Configuring Bank_1 for ILI9341 LCD controller:

* half word (16 bit access)
* with write enabled
* distinct read and write timings

```ada
STM32.FSMC.Configure
  (Bank_1 =>
     (1 =>  --  ILI9341 is connected to sub-bank 1
        (Is_Set => True,
         Value  =>
           (Write_Enable  => True,
            Bus_Width     => STM32.FSMC.Half_Word,
            Memory_Type   => STM32.FSMC.SRAM,
            Bus_Turn      => 15,  --  90ns
            Data_Setup    => 57, --  342ns
            Address_Setup => 0,
            Extended      =>
              (STM32.FSMC.Mode_A,
               Write_Bus_Turn      => 3,  --  18ns
               Write_Data_Setup    => 2,  --  12ns
               Write_Address_Setup => 0),
            others        => <>)),
      others => <>));
```

### RNG

The RNG driver supports two approaches. For a single word or a small number
of words, use polling with `Get_Next` (and optionally `Is_Ready`).
For a larger buffer, use the interrupt-driven generic package and
`Start_Reading`, which fills the buffer and triggers a callback when done.

**Polling example:**
```ada
declare
  Value : Interfaces.Unsigned_32;
begin
  STM32.RNG.Configure;
  STM32.RNG.Get_Next (Value);
end;
```

**Interrupt-driven example:**
```ada
with Ada.Synchronous_Task_Control;
with A0B.Callbacks.Generic_Subprogram;
with STM32.RNG;

procedure Main is
   package Suspension_Object_Callbacks is new
     A0B.Callbacks.Generic_Subprogram
       (Ada.Synchronous_Task_Control.Suspension_Object,
        Ada.Synchronous_Task_Control.Set_True);

   package RNG is new STM32.RNG.Generic_RNG (Priority => 241);

   Buffer : RNG.Unsigned_32_Array (1 .. 256);
   Signal : aliased Ada.Synchronous_Task_Control.Suspension_Object;
   Done   : constant A0B.Callbacks.Callback :=
     Suspension_Object_Callbacks.Create_Callback (Signal);
begin
   STM32.RNG.Configure;
   RNG.Start_Reading (Buffer, Done);
   --  Do anything else while random numbers are being generated
   Ada.Synchronous_Task_Control.Suspend_Until_True (Signal);
   -- Process Buffer here
end Main;
```

## Demos

The repository includes a demo project in `demos/` for STM32F4 targets.

Build all demos:

```shell
alr -C demos/stm32f4 build
```

Available demos:

- `uart/uart.adb`: UART polling send/receive example
- `uart/uart_dma.adb`: UART transfer using DMA
- `spi/spi_polling.adb`: SPI transfer using polling
- `spi/spi_dma.adb`: SPI transfer using DMA
- `tim/tim_dma.adb`: Timer PWM generation with DMA updates
- `rtc/rtc_main.adb`: RTC clock/calendar example
- `i2c/i2c.adb`: I2C bus scanner over addresses `0x08 .. 0x77` with UART output

## Maintainer

[@MaximReznik](https://github.com/reznikmm)

## Contribute

Contributions are welcome! Feel free to submit a pull request.

## License

This project is licensed under the Apache 2.0 License with LLVM Exceptions.
See the [LICENSES](LICENSES) files for details.

<!--- To generate stub code from SVD:
svd2ada --use-unsigned-type=Unsigned_32 \
 --package=STM32.Registers --boolean \
 --no-uint-subtypes --no-vfa-on-types --no-defaults \
 --base-types-package=Interfaces \
 -o STM32F429/ ./CMSIS-SVD/ST/STM32F429x.svd
--->
