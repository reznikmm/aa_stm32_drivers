--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

package body SD_Card is

   use type Interfaces.Unsigned_32;
   use type Interfaces.Unsigned_8;
   use type STM32.SDIO.Error_Kind;

   type Byte_Array is array (Positive range <>) of Interfaces.Unsigned_8;

   New_Line : constant String := ASCII.CR & ASCII.LF;

   Block_Size : constant := 512;

   R1_Error_Flags : constant := 16#FDF9_8008#;
   --  Error bits of the card status (R1)

   procedure Check (Name : String; Error : STM32.SDIO.Error_Kind);
   --  Print the command result and the short response

   function Hex
     (Value  : Interfaces.Unsigned_32;
      Length : Positive := 8) return String;

   procedure Dump (Buffer : Byte_Array);
   --  Print bytes in hex, 16 per line

   -----------
   -- Check --
   -----------

   procedure Check (Name : String; Error : STM32.SDIO.Error_Kind) is
   begin
      Put (Name & ": " & Error'Image & ", response: "
           & Hex (Short_Response) & New_Line);
   end Check;

   ----------
   -- Dump --
   ----------

   procedure Dump (Buffer : Byte_Array) is
   begin
      for J in Buffer'Range loop
         Put (Hex (Interfaces.Unsigned_32 (Buffer (J)), 2));
         Put (if (J - Buffer'First + 1) mod 16 = 0 then New_Line else " ");
      end loop;
   end Dump;

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

   ---------
   -- Run --
   ---------

   procedure Run (Data_Speed : Positive) is
      Error       : STM32.SDIO.Error_Kind;
      Version_2   : Boolean;
      High_Capacity : Boolean := False;
      OCR         : Interfaces.Unsigned_32 := 0;
      RCA         : Interfaces.Unsigned_32;
      Long        : STM32.SDIO.Response_Words;

      Single      : Byte_Array (1 .. Block_Size) := (others => 0)
        with Alignment => 16;
      Multiple    : Byte_Array (1 .. 2 * Block_Size) := (others => 16#EE#)
        with Alignment => 16;
   begin
      --  CMD0 (GO_IDLE_STATE)
      Send_Command
        ((Command => 0, Argument => 0, Response => STM32.SDIO.No_Response),
         Error);

      --  CMD8 (SEND_IF_COND): 2.7-3.6V, check pattern AA. R7
      Send_Command ((Command => 8, Argument => 16#1AA#, others => <>), Error);
      Check ("CMD8", Error);
      Version_2 := Error = STM32.SDIO.No_Error;

      if Version_2 and Short_Response /= 16#1AA# then
         Put ("Unusable card" & New_Line);
         return;
      end if;

      --  ACMD41 (SD_SEND_OP_COND) until the card is ready. R3 has no CRC
      for Attempt in 1 .. 100 loop
         Send_Command ((Command => 55, Argument => 0, others => <>), Error);

         if Error = STM32.SDIO.No_Error then
            Send_Command
              ((Command  => 41,
                Argument =>
                  (if Version_2 then 16#4000_0000# else 0)  --  HCS
                  + 16#00FF_8000#,  --  2.7 .. 3.6V
                Response => STM32.SDIO.Short_Response_Without_CRC),
               Error);

            OCR := Short_Response;
            exit when Error = STM32.SDIO.No_Error
              and then (OCR and 16#8000_0000#) /= 0;
         end if;

         delay 0.01;
      end loop;

      Check ("ACMD41", Error);

      if (OCR and 16#8000_0000#) = 0 then
         Put ("Card is not ready" & New_Line);
         return;
      end if;

      High_Capacity := (OCR and 16#4000_0000#) /= 0;
      Put ("High capacity: " & High_Capacity'Image & New_Line);

      --  CMD2 (ALL_SEND_CID). R2
      Send_Command
        ((Command => 2, Argument => 0, Response => STM32.SDIO.Long_Response),
         Error);
      Check ("CMD2", Error);
      Long := Long_Response;
      Put ("CID: " & Hex (Long (1)) & Hex (Long (2)) & Hex (Long (3))
           & Hex (Long (4)) & New_Line);

      --  CMD3 (SEND_RELATIVE_ADDR). R6
      Send_Command ((Command => 3, Argument => 0, others => <>), Error);
      Check ("CMD3", Error);
      RCA := Short_Response / 2 ** 16;

      --  CMD9 (SEND_CSD). R2
      Send_Command
        ((Command  => 9,
          Argument => RCA * 2 ** 16,
          Response => STM32.SDIO.Long_Response),
         Error);
      Check ("CMD9", Error);
      Long := Long_Response;
      Put ("CSD: " & Hex (Long (1)) & Hex (Long (2)) & Hex (Long (3))
           & Hex (Long (4)) & New_Line);

      --  CMD7 (SELECT_CARD). R1b
      Send_Command
        ((Command => 7, Argument => RCA * 2 ** 16, others => <>), Error);
      Check ("CMD7", Error);

      --  CMD16 (SET_BLOCKLEN), ignored by high capacity cards
      Send_Command
        ((Command => 16, Argument => Block_Size, others => <>), Error);
      Check ("CMD16", Error);

      --  ACMD6 (SET_BUS_WIDTH): 4 bits
      Send_Command
        ((Command => 55, Argument => RCA * 2 ** 16, others => <>), Error);
      Send_Command ((Command => 6, Argument => 2, others => <>), Error);
      Check ("ACMD6", Error);

      Set_Bus (Data_Speed, 4);

      --  CMD17 (READ_SINGLE_BLOCK) block 0. Address is 0 for both
      --  byte addressed (SDSC) and block addressed (SDHC) cards.
      Send_Data_Command
        (Item   => (Command => 17, Argument => 0, others => <>),
         Data   =>
           (Direction  => STM32.SDIO.Card_To_Host,
            Block_Size => Block_Size,
            Length     => Block_Size,
            Timeout    => 1_000_000),
         Buffer => Single'Address,
         Error  => Error);

      Check ("CMD17", Error);

      if (Short_Response and R1_Error_Flags) /= 0 then
         Put ("Card status has errors" & New_Line);
      end if;

      Dump (Single (1 .. 32));
      Put ("...");
      Put (New_Line);
      Dump (Single (Single'Last - 15 .. Single'Last));
      Put ("Boot signature: "
           & (if Single (511) = 16#55# and Single (512) = 16#AA# then "found"
              else "not found") & New_Line);

      --  CMD18 (READ_MULTIPLE_BLOCK) blocks 0 .. 1, then CMD12
      Send_Data_Command
        (Item   => (Command => 18, Argument => 0, others => <>),
         Data   =>
           (Direction  => STM32.SDIO.Card_To_Host,
            Block_Size => Block_Size,
            Length     => Multiple'Length,
            Timeout    => 1_000_000),
         Buffer => Multiple'Address,
         Error  => Error);

      Check ("CMD18", Error);

      --  CMD12 (STOP_TRANSMISSION). R1b
      Send_Command ((Command => 12, Argument => 0, others => <>), Error);
      Check ("CMD12", Error);

      if Multiple (1 .. Block_Size) = Single then
         Put ("CMD18 block 0 matches CMD17" & New_Line);
      else
         Put ("CMD18 block 0 differs from CMD17" & New_Line);
      end if;

      Put ("Block 1:" & New_Line);
      Dump (Multiple (Block_Size + 1 .. Block_Size + 32));
   end Run;

end SD_Card;
