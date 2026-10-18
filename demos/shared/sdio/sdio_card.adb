--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.GPIO;

with SDIO_Board;

package body SDIO_Card is

   use type Interfaces.Unsigned_32;
   use type Interfaces.Unsigned_8;
   use type STM32.SDIO.Error_Kind;

   subtype Function_Number is Interfaces.Unsigned_32 range 0 .. 7;
   subtype Register_Address is Interfaces.Unsigned_32 range 0 .. 16#1_FFFF#;

   type Byte_Array is array (Positive range <>) of Interfaces.Unsigned_8;

   New_Line : constant String := ASCII.CR & ASCII.LF;

   R5_Error_Flags : constant := 16#CB00#;
   --  COM_CRC_ERROR, ILLEGAL_COMMAND, ERROR, FUNCTION_NUMBER, OUT_OF_RANGE

   CCCR_Revision         : constant := 16#00#;
   CCCR_Bus_Control      : constant := 16#07#;
   CCCR_Card_Capability  : constant := 16#08#;
   CCCR_CIS_Pointer      : constant := 16#09#;
   CCCR_Block_Size_Low   : constant := 16#10#;
   CCCR_Block_Size_High  : constant := 16#11#;

   CCCR_IO_Enable        : constant := 16#02#;
   CCCR_IO_Ready         : constant := 16#03#;
   CCCR_IO_Abort         : constant := 16#06#;
   FBR1_Block_Size_Low   : constant := 16#110#;
   FBR1_Block_Size_High  : constant := 16#111#;

   Backplane_Function    : constant := 1;
   Backplane_Window      : constant := 16#1000A#;
   --  Three bytes: bits 15 .. 8, 23 .. 16, 31 .. 24 of backplane address
   Backplane_Word_Access : constant := 16#8000#;
   --  Offset of 32-bit access area in the backplane window

   Chipcommon_Base       : constant := 16#1800_0000#;
   --  Chip id register is the first register of the chipcommon core

   CIS_Length : constant := 64;

   procedure Check (Name : String; Error : STM32.SDIO.Error_Kind);
   --  Print the command result

   function Hex
     (Value  : Interfaces.Unsigned_32;
      Length : Positive := 8) return String;

   function IO_Read_Write_Direct
     (Write    : Boolean;
      Number   : Function_Number;
      Address  : Register_Address;
      Data     : Interfaces.Unsigned_8 := 0) return STM32.SDIO.Command;
   --  Encode CMD52

   procedure Read_Byte
     (Address : Register_Address;
      Value   : out Interfaces.Unsigned_8;
      Error   : out STM32.SDIO.Error_Kind;
      Number  : Function_Number := 0);
   --  Read a byte of function Number with CMD52

   procedure Write_Byte
     (Address : Register_Address;
      Value   : Interfaces.Unsigned_8;
      Error   : out STM32.SDIO.Error_Kind;
      Number  : Function_Number := 0);
   --  Write a byte of function Number with CMD52

   procedure Reset_IO;
   --  Write RES bit in CCCR I/O abort register. It resets the I/O part of
   --  the card (bus width, enabled functions) if the card has not been
   --  powered off since the previous run. A card after power-on doesn't
   --  respond, that's fine.

   procedure Enable_Backplane (Success : out Boolean);
   --  Enable function 1 (backplane of Broadcom WiFi chips), set its block
   --  size and point the backplane window to the chipcommon core.

   procedure Read_Chip_Id (Title : String; Success : out Boolean);
   --  Read chipcommon chip id register with CMD53 (function 1), compare it
   --  with CMD52 byte reads.

   procedure Read_CIS
     (Title   : String;
      CIS     : Register_Address;
      Buffer  : out Byte_Array;
      Success : out Boolean);
   --  Read Buffer'Length bytes of the common CIS with CMD53, print them and
   --  compare first bytes with CMD52.

   -----------
   -- Check --
   -----------

   procedure Check (Name : String; Error : STM32.SDIO.Error_Kind) is
   begin
      Put (Name & ": " & Error'Image & New_Line);
   end Check;

   ---------
   -- Hex --
   ---------

   function Hex
     (Value  : Interfaces.Unsigned_32;
      Length : Positive := 8) return String
   is
      Digit_Image : constant String := "0123456789ABCDEF";
      Result      : String (1 .. Length);
      Rest        : Interfaces.Unsigned_32 := Value;
   begin
      for Index in reverse Result'Range loop
         Result (Index) := Digit_Image (Natural (Rest mod 16) + 1);
         Rest := Rest / 16;
      end loop;

      return Result;
   end Hex;

   --------------------------
   -- IO_Read_Write_Direct --
   --------------------------

   function IO_Read_Write_Direct
     (Write    : Boolean;
      Number   : Function_Number;
      Address  : Register_Address;
      Data     : Interfaces.Unsigned_8 := 0) return STM32.SDIO.Command is
   begin
      return
        (Command  => 52,
         Argument =>
           (if Write then 2 ** 31 else 0)
             + Number * 2 ** 28
             + Address * 2 ** 9
             + Interfaces.Unsigned_32 (Data),
         Response => STM32.SDIO.Short_Response);
   end IO_Read_Write_Direct;

   -----------
   -- Reset --
   -----------

   procedure Reset is
   begin
      STM32.GPIO.Configure_Output (SDIO_Board.Reset_Pin);
      STM32.GPIO.Set_Output (SDIO_Board.Reset_Pin, 0);
      delay 0.001;
      STM32.GPIO.Set_Output (SDIO_Board.Reset_Pin, 1);
      delay 0.001;
   end Reset;

   ---------------
   -- Read_Byte --
   ---------------

   procedure Read_Byte
     (Address : Register_Address;
      Value   : out Interfaces.Unsigned_8;
      Error   : out STM32.SDIO.Error_Kind;
      Number  : Function_Number := 0)
   is
      Response : Interfaces.Unsigned_32;
   begin
      Send_Command (IO_Read_Write_Direct (False, Number, Address), Error);
      Response := Short_Response;
      Value := Interfaces.Unsigned_8 (Response mod 256);

      if Error = STM32.SDIO.No_Error
        and then (Response and R5_Error_Flags) /= 0
      then
         Put ("R5 flags: " & Hex (Response / 256, 2) & New_Line);
      end if;
   end Read_Byte;

   ----------------------
   -- Enable_Backplane --
   ----------------------

   procedure Enable_Backplane (Success : out Boolean) is
      Error : STM32.SDIO.Error_Kind;
      Value : Interfaces.Unsigned_8;
   begin
      Write_Byte (FBR1_Block_Size_Low, 64, Error);
      Write_Byte (FBR1_Block_Size_High, 0, Error);

      Write_Byte (CCCR_IO_Enable, 2 ** Backplane_Function, Error);
      Check ("Enable function 1", Error);

      for Attempt in 1 .. 100 loop
         Read_Byte (CCCR_IO_Ready, Value, Error);
         exit when (Value and 2 ** Backplane_Function) /= 0;
         delay 0.001;
      end loop;

      Success := (Value and 2 ** Backplane_Function) /= 0;
      Put ("IO ready: " & Hex (Interfaces.Unsigned_32 (Value), 2)
           & New_Line);

      if not Success then
         return;
      end if;

      --  Backplane window := chipcommon base
      for J in 0 .. 2 loop
         Write_Byte
           (Backplane_Window + Register_Address (J),
            Interfaces.Unsigned_8 (Chipcommon_Base / 2 ** (8 * (J + 1))
                                   mod 256),
            Error,
            Number => Backplane_Function);
      end loop;

      Check ("Backplane window", Error);
   end Enable_Backplane;

   ------------------
   -- Read_Chip_Id --
   ------------------

   procedure Read_Chip_Id (Title : String; Success : out Boolean) is
      Error  : STM32.SDIO.Error_Kind;
      Value  : Interfaces.Unsigned_8;
      Buffer : Byte_Array (1 .. 4) := (others => 0)
        with Alignment => 4;
   begin
      Send_Data_Command
        (Item   =>
           (Command  => 53,
            Argument =>
              Backplane_Function * 2 ** 28
              + 2 ** 26  --  OP code: incrementing address
              + Backplane_Word_Access * 2 ** 9
              + Buffer'Length,
            Response => STM32.SDIO.Short_Response),
         Data   =>
           (Direction  => STM32.SDIO.Card_To_Host,
            Block_Size => Buffer'Length,
            Length     => Buffer'Length,
            Timeout    => 1_000_000),
         Buffer => Buffer'Address,
         Error  => Error);

      Check ("CMD53 chip id " & Title, Error);
      Put ("CMD53 R5: " & Hex (Short_Response, 8) & New_Line);
      Put ("Chip id register:");

      for Item of reverse Buffer loop
         Put (" " & Hex (Interfaces.Unsigned_32 (Item), 2));
      end loop;

      Put (", chip: " & Hex (Interfaces.Unsigned_32 (Buffer (2)), 2)
           & Hex (Interfaces.Unsigned_32 (Buffer (1)), 2)
           & " (BCM43362 is A962)" & New_Line);

      --  Compare with CMD52 byte access to the same register
      for J in Buffer'Range loop
         Read_Byte
           (Register_Address (J - 1), Value, Error, Backplane_Function);

         if Value /= Buffer (J) then
            Put ("Mismatch at" & J'Image & ", CMD52 gives "
                 & Hex (Interfaces.Unsigned_32 (Value), 2) & New_Line);
            Success := False;
            return;
         end if;
      end loop;

      Put ("CMD53 data matches CMD52" & New_Line);
      Success := True;
   end Read_Chip_Id;

   --------------
   -- Reset_IO --
   --------------

   procedure Reset_IO is
      Error : STM32.SDIO.Error_Kind;
   begin
      Write_Byte (CCCR_IO_Abort, 16#08#, Error);
      delay 0.02;  --  The chip needs time to react
   end Reset_IO;

   --------------
   -- Read_CIS --
   --------------

   procedure Read_CIS
     (Title   : String;
      CIS     : Register_Address;
      Buffer  : out Byte_Array;
      Success : out Boolean)
   is
      Error : STM32.SDIO.Error_Kind;
      Value : Interfaces.Unsigned_8;
   begin
      Buffer := (others => 0);

      --  CMD53 (IO_RW_EXTENDED): read bytes of function 0 in byte mode
      --  with incrementing address.
      Send_Data_Command
        (Item   =>
           (Command  => 53,
            Argument =>
              2 ** 26  --  OP code: incrementing address
              + CIS * 2 ** 9
              + Buffer'Length,
            Response => STM32.SDIO.Short_Response),
         Data   =>
           (Direction  => STM32.SDIO.Card_To_Host,
            Block_Size => Buffer'Length,
            Length     => Buffer'Length,
            Timeout    => 1_000_000),
         Buffer => Buffer'Address,
         Error  => Error);

      Check ("CMD53 " & Title, Error);
      Put ("CMD53 R5: " & Hex (Short_Response, 8)
           & ", response command:"
           & Response_Command'Image & New_Line);

      for J in Buffer'Range loop
         Put (Hex (Interfaces.Unsigned_32 (Buffer (J)), 2));
         Put (if J mod 16 = 0 then New_Line else " ");
      end loop;

      --  Compare with CMD52
      for J in 1 .. 8 loop
         Read_Byte (CIS + Register_Address (J - 1), Value, Error);

         if Value /= Buffer (J) then
            Put ("Mismatch at" & J'Image & ", CMD52 gives "
                 & Hex (Interfaces.Unsigned_32 (Value), 2) & New_Line);
            Success := False;
            return;
         end if;
      end loop;

      Put ("CMD53 data matches CMD52" & New_Line);
      Success := True;
   end Read_CIS;

   ---------
   -- Run --
   ---------

   procedure Run (Data_Speed : Positive) is
      Error    : STM32.SDIO.Error_Kind;
      OCR      : Interfaces.Unsigned_32;
      RCA      : Interfaces.Unsigned_32;
      Value    : Interfaces.Unsigned_8;
      CIS      : Interfaces.Unsigned_32 := 0;
      Success  : Boolean;
      Buffer   : Byte_Array (1 .. CIS_Length) := (others => 0)
        with Alignment => 16;
   begin
      Reset_IO;

      --  Reset and probe the card: CMD0 + CMD5 (IO_SEND_OP_COND)
      for Attempt in 1 .. 100 loop
         Send_Command
           ((Command => 0, Argument => 0, Response => STM32.SDIO.No_Response),
            Error);

         Send_Command
           ((Command  => 5,
             Argument => 0,
             Response => STM32.SDIO.Short_Response_Without_CRC),
            Error);

         exit when Error = STM32.SDIO.No_Error;
         delay 0.001;
      end loop;

      Check ("CMD5", Error);

      if Error /= STM32.SDIO.No_Error then
         return;
      end if;

      OCR := Short_Response;
      Put ("OCR: " & Hex (OCR) & New_Line);

      --  Set the voltage window and wait for the card ready (C bit)
      for Attempt in 1 .. 100 loop
         Send_Command
           ((Command  => 5,
             Argument => OCR and 16#00FF_FFFF#,
             Response => STM32.SDIO.Short_Response_Without_CRC),
            Error);

         exit when Error = STM32.SDIO.No_Error
           and then (Short_Response and 16#8000_0000#) /= 0;

         delay 0.01;
      end loop;

      Check ("CMD5 ready", Error);

      --  CMD3 (SEND_RELATIVE_ADDR), R6
      Send_Command ((Command => 3, Argument => 0, others => <>), Error);
      Check ("CMD3", Error);
      RCA := Short_Response / 2 ** 16;
      Put ("RCA: " & Hex (RCA, 4) & New_Line);

      --  CMD7 (SELECT_CARD), R1b
      Send_Command
        ((Command => 7, Argument => RCA * 2 ** 16, others => <>), Error);
      Check ("CMD7", Error);

      Read_Byte (CCCR_Revision, Value, Error);
      Put ("CCCR revision: " & Hex (Interfaces.Unsigned_32 (Value), 2)
           & New_Line);

      Read_Byte (CCCR_Card_Capability, Value, Error);
      Put ("Card capability: " & Hex (Interfaces.Unsigned_32 (Value), 2)
           & New_Line);

      for J in reverse 0 .. 2 loop
         Read_Byte (CCCR_CIS_Pointer + Register_Address (J), Value, Error);
         CIS := CIS * 256 + Interfaces.Unsigned_32 (Value);
      end loop;

      Put ("Common CIS: " & Hex (CIS, 5) & New_Line);

      --  Function 0 block size
      Write_Byte (CCCR_Block_Size_Low, CIS_Length, Error);
      Check ("Block size low", Error);
      Write_Byte (CCCR_Block_Size_High, 0, Error);
      Check ("Block size high", Error);

      Read_Byte (CCCR_Block_Size_Low, Value, Error);
      Put ("Block size: " & Hex (Interfaces.Unsigned_32 (Value), 2)
           & New_Line);

      --  Data transfer in 1-bit mode first, to separate data path problems
      --  from bus width problems.
      Enable_Backplane (Success);

      if Success then
         Read_Chip_Id ("1-bit", Success);
      end if;

      Read_CIS ("1-bit", CIS, Buffer, Success);

      --  Switch to 4-bit bus: card first, then host
      Read_Byte (CCCR_Bus_Control, Value, Error);
      Put ("Bus control: " & Hex (Interfaces.Unsigned_32 (Value), 2)
           & New_Line);
      Write_Byte (CCCR_Bus_Control, (Value and 16#FC#) or 2, Error);
      Check ("Bus width 4", Error);
      Read_Byte (CCCR_Bus_Control, Value, Error);
      Put ("Bus control: " & Hex (Interfaces.Unsigned_32 (Value), 2)
           & New_Line);

      Set_Bus (Data_Speed, 4);

      Read_Chip_Id ("4-bit", Success);
      Read_CIS ("4-bit", CIS, Buffer, Success);

      if not Success then
         return;
      end if;

      --  Look for CISTPL_MANFID tuple
      declare
         Index : Positive := 1;
      begin
         while Index + 5 <= Buffer'Last and then Buffer (Index) /= 16#FF# loop
            if Buffer (Index) = 16#20# then
               Put ("Manufacturer: "
                    & Hex (Interfaces.Unsigned_32 (Buffer (Index + 3)), 2)
                    & Hex (Interfaces.Unsigned_32 (Buffer (Index + 2)), 2)
                    & ", card: "
                    & Hex (Interfaces.Unsigned_32 (Buffer (Index + 5)), 2)
                    & Hex (Interfaces.Unsigned_32 (Buffer (Index + 4)), 2)
                    & New_Line);
               exit;
            end if;

            Index := Index + 2 + Natural (Buffer (Index + 1));
         end loop;
      end;
   end Run;

   ----------------
   -- Write_Byte --
   ----------------

   procedure Write_Byte
     (Address : Register_Address;
      Value   : Interfaces.Unsigned_8;
      Error   : out STM32.SDIO.Error_Kind;
      Number  : Function_Number := 0)
   is
      Response : Interfaces.Unsigned_32;
   begin
      Send_Command
        (IO_Read_Write_Direct (True, Number, Address, Value), Error);
      Response := Short_Response;

      if Error = STM32.SDIO.No_Error
        and then (Response and R5_Error_Flags) /= 0
      then
         Put ("R5 flags: " & Hex (Response / 256, 2) & New_Line);
      end if;
   end Write_Byte;

end SDIO_Card;
