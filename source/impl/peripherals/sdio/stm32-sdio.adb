--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.GPIO;
with STM32.Registers.GPIO;
with STM32.Registers.RCC;
with STM32.System_Clocks;

package body STM32.SDIO is

   use type Interfaces.Unsigned_32;

   Periph : Registers.SDIO_Peripheral renames Registers.SDIO_Periph;

   SDIO_Alternate_Function : constant := 12;

   HSI_Frequency : constant := 16_000_000;

   Current_Speed : Interfaces.Unsigned_32 := 400_000;
   --  Actual SDIO_CK frequency, used to convert data timeout

   type Word_Array is array (Positive range <>) of Interfaces.Unsigned_32;

   procedure Init_GPIO (Item : Pin; Pull_Up : Boolean);

   function SDIO_Clock return Interfaces.Unsigned_32;
   --  SDIOCLK frequency. It is the PLL48CLK (PLL "Q" output).

   function To_Block_Size
     (Value : Block_Length) return Registers.DCTRL_DBLOCKSIZE_Field;

   function To_Cycles (Timeout : Duration) return Interfaces.Unsigned_32;

   procedure Write_Clock_Control
     (Speed  : Positive;
      Width  : Bus_Width;
      Enable : Boolean);

   procedure Start_Command_Path (Item : Command);

   procedure Start_Data_Path
     (Data    : Data_Transfer;
      Use_DMA : Boolean);

   function Is_Command_Finished
     (Status : Registers.STA_Register;
      Kind   : Response_Kind) return Boolean is
       (if Kind = No_Response then Status.CMDSENT
        else Status.CMDREND or Status.CCRCFAIL or Status.CTIMEOUT);

   function Command_Error
     (Status : Registers.STA_Register;
      Kind   : Response_Kind) return Error_Kind is
       (if Kind = No_Response then No_Error
        elsif Status.CTIMEOUT then Command_Timeout
        elsif Status.CCRCFAIL and Kind /= Short_Response_Without_CRC
        then Command_CRC_Fail
        else No_Error);

   function Data_Error (Status : Registers.STA_Register) return Error_Kind is
     (if Status.STBITERR then Start_Bit_Error
      elsif Status.DCRCFAIL then Data_CRC_Fail
      elsif Status.TXUNDERR then Transmit_Underrun
      elsif Status.RXOVERR then Receive_Overrun
      elsif Status.DTIMEOUT then Data_Timeout
      else No_Error);
   --  A timeout could be a consequence of other errors, so report it last

   procedure Clear_Command_Flags;
   procedure Clear_Data_Flags;

   procedure Read_FIFO (State : in out Transfer_State; Count : Positive);
   --  Read Count words from FIFO into the buffer

   procedure Write_FIFO (State : in out Transfer_State; Count : Positive);
   --  Write up to Count words from the buffer into FIFO

   -------------------------
   -- Clear_Command_Flags --
   -------------------------

   procedure Clear_Command_Flags is
   begin
      Periph.ICR :=
        (CCRCFAILC      => True,
         CTIMEOUTC      => True,
         CMDRENDC       => True,
         CMDSENTC       => True,
         Reserved_11_21 => 0,
         Reserved_24_31 => 0,
         others         => False);
   end Clear_Command_Flags;

   -------------------------------
   -- Clear_Card_Interrupt_Flag --
   -------------------------------

   procedure Clear_Card_Interrupt_Flag is
   begin
      Periph.ICR :=
        (SDIOITC        => True,
         Reserved_11_21 => 0,
         Reserved_24_31 => 0,
         others         => False);
   end Clear_Card_Interrupt_Flag;

   ----------------------
   -- Clear_Data_Flags --
   ----------------------

   procedure Clear_Data_Flags is
   begin
      Periph.ICR :=
        (DCRCFAILC      => True,
         DTIMEOUTC      => True,
         TXUNDERRC      => True,
         RXOVERRC       => True,
         DATAENDC       => True,
         STBITERRC      => True,
         DBCKENDC       => True,
         Reserved_11_21 => 0,
         Reserved_24_31 => 0,
         others         => False);
   end Clear_Data_Flags;

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO (Item : Pin; Pull_Up : Boolean) is
      GPIO : STM32.Registers.GPIO.GPIO_Peripheral renames
        STM32.Registers.GPIO.GPIO_Periph (Item.Port);
   begin
      STM32.GPIO.Enable_GPIO (Item.Port);

      GPIO.MODER   (Item.Pin) := STM32.Registers.GPIO.Mode_AF;
      GPIO.OSPEEDR (Item.Pin) := STM32.Registers.GPIO.Speed_100MHz;
      GPIO.OTYPER  (Item.Pin) := STM32.Registers.GPIO.Push_Pull;
      GPIO.PUPDR   (Item.Pin) :=
        (if Pull_Up then STM32.Registers.GPIO.Pull_Up
         else STM32.Registers.GPIO.No_Pull);
      GPIO.AFR     (Item.Pin) := SDIO_Alternate_Function;
   end Init_GPIO;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Clock_Pin   : Pin;
      Command_Pin : Pin;
      Data_Pins   : Pin_Array;
      Speed       : Positive;
      Width       : Bus_Width)
   is
      RCC : STM32.Registers.RCC.RCC_Peripheral renames
        STM32.Registers.RCC.RCC_Periph;
   begin
      --  The card has pull-ups on CMD and DAT lines, but they are weak, so
      --  enable MCU pull-ups too. The clock line is driven by the host.
      Init_GPIO (Clock_Pin, Pull_Up => False);
      Init_GPIO (Command_Pin, Pull_Up => True);

      for Item of Data_Pins loop
         Init_GPIO (Item, Pull_Up => True);
      end loop;

      RCC.APB2ENR.SDIOEN := True;
      RCC.APB2RSTR.SDIORST := True;
      RCC.APB2RSTR.SDIORST := False;

      Write_Clock_Control (Speed, Width, Enable => False);

      Periph.POWER := (PWRCTRL => Registers.Power_ON, Reserved_2_31 => 0);

      Periph.CLKCR.CLKEN := True;

      Periph.MASK :=
        (Reserved_24_31 => 0,
         others         => False);

      Clear_Command_Flags;
      Clear_Data_Flags;
      Clear_Card_Interrupt_Flag;

      Periph.DCTRL :=
        (DTEN           => False,
         DTDIR          => Registers.Controller_To_Card,
         DTMODE         => Registers.Block,
         DMAEN          => False,
         DBLOCKSIZE     => Registers.Block_1b,
         RWSTART        => False,
         RWSTOP         => False,
         RWMOD          => False,
         SDIOEN         => True,  --  SD I/O card specific operations
         Reserved_12_31 => 0);
   end Initialize;

   ------------------------
   -- Interrupt_Mask --
   ------------------------

   function Interrupt_Mask
     (State          : Transfer_State;
      Card_Interrupt : Boolean) return Registers.MASK_Register
   is
      Wait_Response : constant Boolean :=
        not State.Command_Done and State.Response /= No_Response;

      Wait_Sent     : constant Boolean :=
        not State.Command_Done and State.Response = No_Response;

      Data_Active   : constant Boolean :=
        State.Data_Started and not State.Data_Done;

      Is_Read       : constant Boolean :=
        Data_Active and State.Data.Direction = Card_To_Host;

      Is_Write      : constant Boolean :=
        Data_Active and State.Data.Direction = Host_To_Card;
   begin
      return
        (CCRCFAILIE     => Wait_Response,
         CTIMEOUTIE     => Wait_Response,
         CMDRENDIE      => Wait_Response,
         CMDSENTIE      => Wait_Sent,
         DCRCFAILIE     => Data_Active,
         DTIMEOUTIE     => Data_Active,
         DATAENDIE      => Data_Active,
         STBITERRIE     => Data_Active,
         RXOVERRIE      => Is_Read,
         TXUNDERRIE     => Is_Write,
         RXFIFOHFIE     => Is_Read and not State.Use_DMA,
         TXFIFOHEIE     =>
           Is_Write and not State.Use_DMA and State.Next <= State.Last,
         SDIOITIE       => Card_Interrupt,
         Reserved_24_31 => 0,
         others         => False);
   end Interrupt_Mask;

   -------------------
   -- Long_Response --
   -------------------

   function Long_Response return Response_Words is
     (Periph.RESP1, Periph.RESP2, Periph.RESP3, Periph.RESP4);

   ---------------
   -- Read_FIFO --
   ---------------

   procedure Read_FIFO (State : in out Transfer_State; Count : Positive) is
      Buffer : Word_Array (1 .. State.Last)
        with Import, Address => State.Buffer;
      Value  : Interfaces.Unsigned_32;
   begin
      for J in 1 .. Count loop
         Value := Periph.FIFO;

         if State.Next <= State.Last then
            Buffer (State.Next) := Value;
            State.Next := State.Next + 1;
         end if;
      end loop;
   end Read_FIFO;

   ----------------------
   -- Response_Command --
   ----------------------

   function Response_Command return Command_Index is
     (Command_Index (Periph.RESPCMD.RESPCMD));

   -------------
   -- Set_Bus --
   -------------

   procedure Set_Bus
     (Speed : Positive;
      Width : Bus_Width) is
   begin
      Write_Clock_Control (Speed, Width, Enable => True);
   end Set_Bus;

   --------------------
   -- Short_Response --
   --------------------

   function Short_Response return Interfaces.Unsigned_32 is (Periph.RESP1);

   ----------------
   -- SDIO_Clock --
   ----------------

   function SDIO_Clock return Interfaces.Unsigned_32 is
      PLL   : constant STM32.Registers.RCC.PLLCFGR_Register :=
        STM32.Registers.RCC.RCC_Periph.PLLCFGR;

      Input : constant Interfaces.Unsigned_32 :=
        (if PLL.PLLSRC then STM32.System_Clocks.HSE else HSI_Frequency);
   begin
      return Input / PLL.PLLM * PLL.PLLN / PLL.PLLQ;
   end SDIO_Clock;

   ------------------------
   -- Start_Command_Path --
   ------------------------

   procedure Start_Command_Path (Item : Command) is
   begin
      Periph.ARG := Item.Argument;

      Periph.CMD :=
        (CMDINDEX       => Interfaces.Unsigned_32 (Item.Index),
         WAITRESP       =>
           (case Item.Response is
               when No_Response =>
                  Registers.No_Response,
               when Short_Response | Short_Response_Without_CRC =>
                  Registers.Short_Response,
               when Long_Response =>
                  Registers.Long_Response),
         WAITINT        => False,
         WAITPEND       => False,
         CPSMEN         => True,
         SDIOSuspend    => False,
         ENCMDcompl     => False,
         nIEN           => False,
         CE_ATACMD      => False,
         Reserved_15_31 => 0);
   end Start_Command_Path;

   ---------------------
   -- Start_Data_Path --
   ---------------------

   procedure Start_Data_Path
     (Data    : Data_Transfer;
      Use_DMA : Boolean) is
   begin
      Periph.DTIMER := To_Cycles (Data.Timeout);

      Periph.DLEN :=
        (DATALENGTH     => Interfaces.Unsigned_32 (Data.Length),
         Reserved_25_31 => 0);

      Periph.DCTRL :=
        (DTEN           => True,
         DTDIR          =>
           (case Data.Direction is
               when Card_To_Host => Registers.Card_To_Controller,
               when Host_To_Card => Registers.Controller_To_Card),
         DTMODE         => Registers.Block,
         DMAEN          => Use_DMA,
         DBLOCKSIZE     => To_Block_Size (Data.Block_Size),
         RWSTART        => False,
         RWSTOP         => False,
         RWMOD          => False,
         SDIOEN         => True,
         Reserved_12_31 => 0);
   end Start_Data_Path;

   --------------------
   -- Start_Transfer --
   --------------------

   procedure Start_Transfer
     (State    : out Transfer_State;
      Item     : Command;
      Has_Data : Boolean;
      Data     : Data_Transfer;
      Buffer   : System.Address;
      Use_DMA  : Boolean)
   is
      Is_Read : constant Boolean :=
        Has_Data and then Data.Direction = Card_To_Host;
   begin
      State :=
        (Response       => Item.Response,
         Has_Data       => Has_Data,
         Data           => (if Has_Data then Data else No_Data),
         Use_DMA        => Use_DMA,
         Buffer         => Buffer,
         Next           => 1,
         Last           => (if Has_Data then Data.Length / 4 else 0),
         Command_Done   => False,
         Data_Started   => Is_Read,
         Data_Done      => not Has_Data,
         Command_Result => No_Error,
         Data_Result    => No_Error);

      Clear_Command_Flags;
      Clear_Data_Flags;

      if Is_Read then
         --  The card could start sending data before the response end, so
         --  the data path should wait for it before the command is sent.
         Start_Data_Path (Data, Use_DMA);
      end if;

      Start_Command_Path (Item);
   end Start_Transfer;

   ----------
   -- Step --
   ----------

   procedure Step
     (State  : in out Transfer_State;
      Status : Registers.STA_Register)
   is
      Write_Started_Now : Boolean := False;
   begin
      if not State.Command_Done
        and then Is_Command_Finished (Status, State.Response)
      then
         State.Command_Done := True;
         State.Command_Result := Command_Error (Status, State.Response);
         Clear_Command_Flags;

         if State.Has_Data and State.Data.Direction = Host_To_Card then
            if State.Command_Result = No_Error then
               --  Write data could be sent only after the response
               Start_Data_Path (State.Data, State.Use_DMA);
               State.Data_Started := True;
               Write_Started_Now := True;
            else
               State.Data_Done := True;  --  Data path was not started
            end if;
         end if;
      end if;

      if not State.Data_Started
        or State.Data_Done
        or Write_Started_Now  --  Status is older than the data path start
      then
         return;
      end if;

      State.Data_Result := Data_Error (Status);

      if State.Data_Result /= No_Error then
         State.Data_Done := True;
         Clear_Data_Flags;

      elsif State.Use_DMA then
         if Status.DATAEND then
            State.Data_Done := True;
            Clear_Data_Flags;
         end if;

      elsif State.Data.Direction = Card_To_Host then
         if Status.RXFIFOHF then
            Read_FIFO (State, 8);
         elsif Status.DATAEND then
            --  The last words are in FIFO, but less than a half of it
            while Periph.STA.RXDAVL loop
               Read_FIFO (State, 1);
            end loop;

            State.Data_Done := True;
            Clear_Data_Flags;
         end if;

      else
         if Status.DATAEND then
            State.Data_Done := True;
            Clear_Data_Flags;
         elsif Status.TXACT and Status.TXFIFOHE then
            Write_FIFO (State, 8);
         end if;
      end if;
   end Step;

   -------------------
   -- To_Block_Size --
   -------------------

   function To_Block_Size
     (Value : Block_Length) return Registers.DCTRL_DBLOCKSIZE_Field
   is
      Size  : Positive := 1;
      Power : Natural := 0;
   begin
      while Size < Positive (Value) loop
         Size := Size * 2;
         Power := Power + 1;
      end loop;

      return Registers.DCTRL_DBLOCKSIZE_Field'Val (Power);
   end To_Block_Size;

   ---------------
   -- To_Cycles --
   ---------------

   function To_Cycles (Timeout : Duration) return Interfaces.Unsigned_32 is
      Limit  : constant Duration := 4_294_967_295.0;
      Cycles : constant Duration := Timeout * Integer (Current_Speed);
   begin
      if Cycles <= 0.0 then
         return 0;
      elsif Cycles >= Limit then
         return Interfaces.Unsigned_32'Last;
      else
         return Interfaces.Unsigned_32 (Cycles);
      end if;
   end To_Cycles;

   ----------------
   -- Write_FIFO --
   ----------------

   procedure Write_FIFO (State : in out Transfer_State; Count : Positive) is
      Buffer : constant Word_Array (1 .. State.Last)
        with Import, Address => State.Buffer;
   begin
      for J in 1 .. Count loop
         exit when State.Next > State.Last;
         Periph.FIFO := Buffer (State.Next);
         State.Next := State.Next + 1;
      end loop;
   end Write_FIFO;

   -------------------------
   -- Write_Clock_Control --
   -------------------------

   procedure Write_Clock_Control
     (Speed  : Positive;
      Width  : Bus_Width;
      Enable : Boolean)
   is
      Input   : constant Interfaces.Unsigned_32 := SDIO_Clock;

      Value : constant Interfaces.Unsigned_32 :=
        Interfaces.Unsigned_32 (Speed);

      Divider : constant Interfaces.Unsigned_32 :=
        Interfaces.Unsigned_32'Max (1, (Input + Value - 1) / Value);
      --  SDIO_CK = SDIOCLK / Divider, where Divider = CLKDIV + 2

      Bypass  : constant Boolean := Divider = 1;

      CLKDIV  : constant Interfaces.Unsigned_32 :=
        Interfaces.Unsigned_32'Min (Divider - 2, 255);
   begin
      Current_Speed := (if Bypass then Input else Input / (CLKDIV + 2));

      Periph.CLKCR :=
        (CLKDIV         => CLKDIV,
         CLKEN          => Enable,
         PWRSAV         => False,
         BYPASS         => Bypass,
         WIDBUS         =>
           (case Width is
               when 1 => Registers.Bus_Wide_1b,
               when 4 => Registers.Bus_Wide_4b,
               when 8 => Registers.Bus_Wide_8b),
         NEGEDGE        => Registers.Edge_Rising,
         --  Errata ES0182: don't use the dephasing selection
         HWFC_EN        => False,
         --  Errata ES0182: HW flow control makes glitches on SDIO_CK
         Reserved_15_31 => 0);
   end Write_Clock_Control;

end STM32.SDIO;
