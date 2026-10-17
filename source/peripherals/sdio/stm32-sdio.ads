--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Common code for the SDIO host controller (STM32F40x/41x, STM32F42x/43x).
--
--  The MCU has a single SDIO peripheral. Child packages provide three
--  variants with the same command model:
--
--  * Polling_SDIO - blocking procedures, the CPU busy-waits on the status
--    register and moves data through the FIFO;
--  * Generic_SDIO - interrupt driven, the FIFO is served by the SDIO
--    interrupt handler, completion is reported by a callback;
--  * DMA_SDIO     - interrupt driven, data is moved by DMA2 Stream 3
--    (channel 4) in the peripheral flow control mode.
--
--  Use only one variant in a program, because all of them drive the same
--  peripheral.
--
--  The driver doesn't know anything about SD/SDIO protocol. It sends a
--  command, receives a response and optionally transfers a data block(s).
--  Card enumeration and CMD52/CMD53 encoding belong to the upper layer.

with Interfaces;
with System.Storage_Elements;

private with STM32.Registers.SDIO;

package STM32.SDIO is

   use type System.Storage_Elements.Integer_Address;

   type Bus_Width is range 1 .. 8
     with Static_Predicate => Bus_Width in 1 | 4 | 8;
   --  Number of data lines in use

   type Command_Index is range 0 .. 63;

   type Response_Kind is
     (No_Response,
      --  The command has no response (CMD0)

      Short_Response,
      --  48-bit response protected by CRC7: R1, R1b, R5, R6, R7

      Short_Response_Without_CRC,
      --  48-bit response with the CRC field set to all ones: R3 (ACMD41),
      --  R4 (CMD5). The controller reports CRC failure for such responses
      --  and the driver ignores it.

      Long_Response);
      --  136-bit response: R2 (CMD2, CMD9, CMD10)

   type Command is record
      Command  : Command_Index;
      Argument : Interfaces.Unsigned_32 := 0;
      Response : Response_Kind := Short_Response;
   end record;

   type Transfer_Direction is (Card_To_Host, Host_To_Card);

   type Block_Length is range 4 .. 16_384
     with Static_Predicate => Block_Length in
       4 | 8 | 16 | 32 | 64 | 128 | 256 | 512 |
       1024 | 2048 | 4096 | 8192 | 16_384;
   --  Data block size in bytes. Hardware supports smaller blocks (1 and 2
   --  bytes), but the FIFO is 32-bit wide, so the driver accepts only
   --  multiples of a word.

   subtype Data_Length is Positive range 1 .. 2 ** 25 - 1;

   type Data_Transfer is record
      Direction  : Transfer_Direction;
      Block_Size : Block_Length;
      Length     : Data_Length;
      --  Total length in bytes, a multiple of Block_Size
      Timeout    : Interfaces.Unsigned_32;
      --  Data timeout in SDIO_CK periods.
   end record
     with Dynamic_Predicate =>
       Data_Transfer.Length mod Positive (Data_Transfer.Block_Size) = 0;
   --  Data phase description for a data command (CMD53, CMD17, etc).
   --
   --  For SDIO byte mode CMD53 (byte count < block size) use a power of two
   --  byte count and set Block_Size = Length. The STM32 data path state
   --  machine works with blocks only.

   type Error_Kind is
     (No_Error,
      Command_Timeout,    --  No response in 64 SDIO_CK periods
      Command_CRC_Fail,   --  Response received, but CRC check failed
      Data_Timeout,       --  No data/busy end before Data_Transfer.Timeout
      Data_CRC_Fail,      --  Data block CRC check failed
      Transmit_Underrun,  --  FIFO was empty while sending data
      Receive_Overrun,    --  FIFO was full while receiving data
      Start_Bit_Error,    --  No start bit on all data lines (wide bus)
      DMA_Error);         --  DMA transfer error

   type Response_Words is array (1 .. 4) of Interfaces.Unsigned_32;
   --  Long response (R2) without CRC and end bit. Response_Words (1) keeps
   --  bits 127 .. 96 of the card register (CID/CSD).

   function Is_Word_Aligned (Value : System.Address) return Boolean is
     (System.Storage_Elements.To_Integer (Value) mod 4 = 0);

   function Is_DMA_Accessible (Value : System.Address) return Boolean is
     (System.Storage_Elements.To_Integer (Value) not in
        16#1000_0000# .. 16#1000_FFFF#);
   --  The CCM data RAM is not accessible by DMA

   function Is_Data_Pin (Index : Natural; Item : Pin) return Boolean is
     (case Index is
         when 0 => Item in (PC, 8) | (PB, 4) | (PB, 7),
         when 1 => Item in (PC, 9) | (PA, 8),
         when 2 => Item in (PC, 10) | (PA, 9),
         when 3 => Item in (PC, 11) | (PB, 5),
         when 4 => Item = (PB, 8),
         when 5 => Item = (PB, 9),
         when 6 => Item in (PC, 6) | (PB, 14),
         when 7 => Item in (PC, 7) | (PB, 10),
         when others => False);
   --  STM32F40x/STM32F42x have the only mapping for SDIO_D0 .. SDIO_D7.
   --  F411: PA8,PA9,PB4,PB5,PB7,PB10,PB14.

   function Is_Valid_Pin_Set
     (Clock_Pin   : Pin;
      Command_Pin : Pin;
      Data_Pins   : Pin_Array) return Boolean is
       (Clock_Pin in (PC, 12) | (PB, 15)
        and then Command_Pin in (PD, 2) | (PA, 6)
        and then Data_Pins'Length in 1 | 4 | 8
        and then
          (for all J in Data_Pins'Range =>
             Is_Data_Pin (J - Data_Pins'First, Data_Pins (J))));
   --  Data_Pins are SDIO_D0, SDIO_D1, ... in this order
   --  F411: PA6,PB15

private

   package Registers renames STM32.Registers.SDIO;

   procedure Initialize
     (Clock_Pin   : Pin;
      Command_Pin : Pin;
      Data_Pins   : Pin_Array;
      Speed       : Positive;
      Width       : Bus_Width);
   --  Enable and reset the peripheral, configure GPIO, power the card bus on
   --  and start SDIO_CK with given Speed (Hz) and bus Width.

   procedure Set_Bus
     (Speed : Positive;
      Width : Bus_Width);
   --  Change the SDIO_CK frequency (Hz) and the bus width

   No_Data : constant Data_Transfer :=
     (Direction  => Card_To_Host,
      Block_Size => 4,
      Length     => 4,
      Timeout    => 0);

   type Transfer_State is record
      Response       : Response_Kind := No_Response;
      Has_Data       : Boolean := False;
      Data           : Data_Transfer := No_Data;
      Use_DMA        : Boolean := False;
      Buffer         : System.Address := System.Null_Address;
      Next           : Positive := 1;  --  Next word to read/write
      Last           : Natural := 0;   --  Last word of the buffer
      Command_Done   : Boolean := True;
      Data_Started   : Boolean := False;
      Data_Done      : Boolean := True;
      Command_Result : Error_Kind := No_Error;
      Data_Result    : Error_Kind := No_Error;
   end record;
   --  The state of a command/data transaction shared by all variants

   procedure Start_Transfer
     (State    : out Transfer_State;
      Item     : Command;
      Has_Data : Boolean;
      Data     : Data_Transfer;
      Buffer   : System.Address;
      Use_DMA  : Boolean);
   --  Clear flags, enable the data path for a read transfer and send the
   --  command. For a write transfer the data path is enabled by Step after
   --  a successful response.

   procedure Step
     (State  : in out Transfer_State;
      Status : Registers.STA_Register);
   --  Make progress according to the Status snapshot: finish the command
   --  phase, start the write data path, serve the FIFO (unless DMA is used),
   --  detect the data end or errors. Clear flags that have been handled.

   function Is_Finished (State : Transfer_State) return Boolean is
     (State.Command_Done and State.Data_Done);

   function Result (State : Transfer_State) return Error_Kind is
     (if State.Command_Result /= No_Error then State.Command_Result
      else State.Data_Result);

   function Interrupt_Mask
     (State          : Transfer_State;
      Card_Interrupt : Boolean) return Registers.MASK_Register;
   --  Interrupts required to make progress for State

   procedure Clear_Card_Interrupt_Flag;

   function Short_Response return Interfaces.Unsigned_32;
   --  32 bits of the last short response (card status for R1, OCR for R3
   --  and R4, flags and data for R5, RCA and status for R6).

   function Long_Response return Response_Words;
   --  Last long response (R2)

   function Response_Command return Command_Index;
   --  Command index of the last response (63 for R2, R3, R4)

end STM32.SDIO;
