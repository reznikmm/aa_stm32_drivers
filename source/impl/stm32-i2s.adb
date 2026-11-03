--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with System.Storage_Elements;

with A0B.Callbacks.Generic_Parameterless;
with STM32.GPIO;
with STM32.Registers.GPIO;

package body STM32.I2S is

   ------------------
   -- Check_Buffer --
   ------------------

   procedure Check_Buffer
     (Periph : STM32.Registers.SPI.SPI_Peripheral;
      Buffer : System.Address;
      Length : Transfer_Length)
   is
      use type Interfaces.Unsigned_32;
      use type System.Address;
      use type System.Storage_Elements.Integer_Address;

      Frame_Length : constant Positive :=
        (if Periph.I2SCFGR.DATLEN = 0 then 2 else 4);
   begin
      if Buffer = System.Null_Address or else
        System.Storage_Elements.To_Integer (Buffer) mod 2 /= 0 or else
        Length mod Frame_Length /= 0
      then
         raise Constraint_Error;
      end if;
   end Check_Buffer;

   --------------------
   -- Clear_Receiver --
   --------------------

   procedure Clear_Receiver
     (Periph : in out STM32.Registers.SPI.SPI_Peripheral)
   is
      Data  : constant STM32.Registers.SPI.DR_Register := Periph.DR;
      State : constant STM32.Registers.SPI.SR_Register := Periph.SR;
      pragma Unreferenced (Data, State);
   begin
      --  Reading DR followed by SR clears RXNE and OVR.
      null;
   end Clear_Receiver;

   ----------------------------
   -- Polling_Implementation --
   ----------------------------

   package body Polling_Implementation is

      procedure Init_GPIO (Item : Pin; Pull_Down : Boolean);

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (CK        : Pin;
         WS        : Pin;
         SD        : Pin;
         Frequency : Positive;
         Clock     : Positive;
         Format    : Data_Format;
         Standard  : I2S_Standard;
         Polarity  : Clock_Polarity)
      is
         use type Interfaces.Unsigned_64;

         Frame_Bits : constant Interfaces.Unsigned_64 :=
           (if Format = Data_16 then 32 else 64);
         Rate : constant Interfaces.Unsigned_64 :=
           Frame_Bits * Interfaces.Unsigned_64 (Frequency);
         Divider : constant Interfaces.Unsigned_64 :=
           (Interfaces.Unsigned_64 (Clock) + Rate / 2) / Rate;
         Config : STM32.Registers.SPI.I2SCFGR_Register;
      begin
         --  I2SDIV must be 2 .. 255. Reject unrepresentable rates before
         --  touching the peripheral, even when assertion checks are off.
         if Divider not in 4 .. 511 then
            raise Constraint_Error;
         end if;

         Periph.I2SCFGR.I2SE := False;
         Periph.CR1.SPE := False;
         Periph.CR2 :=
           (RXDMAEN => False,
            TXDMAEN => False,
            SSOE    => False,
            FRF     => False,
            ERRIE   => False,
            RXNEIE  => False,
            TXEIE   => False,
            others  => 0);
         Clear_Receiver (Periph);

         Init_GPIO (CK, Pull_Down => False);
         Init_GPIO (WS, Pull_Down => False);
         Init_GPIO (SD, Pull_Down => True);

         Periph.I2SPR :=
           (I2SDIV => Interfaces.Unsigned_32 (Divider / 2),
            ODD    => Divider mod 2 = 1,
            MCKOE  => False,
            others => 0);

         --  Preserve reserved bits: their Ada types differ between targets.
         Config := Periph.I2SCFGR;
         Config.CHLEN := Format /= Data_16;
         Config.DATLEN :=
           (case Format is
               when Data_16 | Data_16_Extended => 0,
               when Data_24 => 1,
               when Data_32 => 2);
         Config.CKPOL := Polarity = Idle_High;
         Config.I2SSTD := I2S_Standard'Pos (Standard);
         Config.PCMSYNC := False;
         Config.I2SCFG := 3;  --  Master receive
         Config.I2SE := False;
         Config.I2SMOD := True;
         Periph.I2SCFGR := Config;

         Error := False;
      end Configure;

      ---------------
      -- Has_Error --
      ---------------

      function Has_Error return Boolean is (Error);

      ---------------
      -- Init_GPIO --
      ---------------

      procedure Init_GPIO (Item : Pin; Pull_Down : Boolean) is
         GPIO : STM32.Registers.GPIO.GPIO_Peripheral renames
           STM32.Registers.GPIO.GPIO_Periph (Item.Port);
      begin
         STM32.GPIO.Enable_GPIO (Item.Port);
         GPIO.MODER (Item.Pin) := STM32.Registers.GPIO.Mode_AF;
         GPIO.OSPEEDR (Item.Pin) := STM32.Registers.GPIO.Speed_100MHz;
         GPIO.OTYPER (Item.Pin) := STM32.Registers.GPIO.Push_Pull;
         GPIO.PUPDR (Item.Pin) :=
           (if Pull_Down then STM32.Registers.GPIO.Pull_Down
              else STM32.Registers.GPIO.No_Pull);
         GPIO.AFR (Item.Pin) := AF;
      end Init_GPIO;

      -------------
      -- Receive --
      -------------

      procedure Receive (Buffer : System.Address; Length : Transfer_Length) is
         Data : Sample_Buffer (1 .. Length) with Import, Address => Buffer;
         State : STM32.Registers.SPI.SR_Register;
      begin
         Check_Buffer (Periph, Buffer, Length);
         Error := False;
         Clear_Receiver (Periph);
         Periph.I2SCFGR.I2SE := True;

         for Item of Data loop
            loop
               State := Periph.SR;
               exit when State.RXNE or State.OVR;
            end loop;

            if State.OVR then
               Error := True;
               exit;
            end if;

            Item := Interfaces.Unsigned_16 (Periph.DR.DR);
         end loop;

         Periph.I2SCFGR.I2SE := False;
         Clear_Receiver (Periph);
      end Receive;

   end Polling_Implementation;

   ------------------------
   -- IRQ_Implementation --
   ------------------------

   package body IRQ_Implementation is

      protected body Device is

         function Is_Busy return Boolean is (Busy);
         function Has_Error return Boolean is (Error);

         -----------------------
         -- Interrupt_Handler --
         -----------------------

         procedure Interrupt_Handler is
            Data : Sample_Buffer (1 .. Last)
              with Import, Address => Buffer;
            State : constant STM32.Registers.SPI.SR_Register := Periph.SR;
         begin
            if not Busy then
               return;
            end if;

            if State.OVR then
               Error := True;
            elsif State.RXNE then
               Data (Next) := Interfaces.Unsigned_16 (Periph.DR.DR);
               Next := Next + 1;
            end if;

            if Error or else Next > Last then
               Periph.CR2.RXNEIE := False;
               Periph.CR2.ERRIE := False;
               Periph.I2SCFGR.I2SE := False;
               Clear_Receiver (Periph);
               Busy := False;
               A0B.Callbacks.Emit_Once (Done);
            end if;
         end Interrupt_Handler;

         -------------------
         -- Start_Reading --
         -------------------

         procedure Start_Reading
           (Buffer : System.Address;
            Length : Transfer_Length;
            Done   : A0B.Callbacks.Callback) is
         begin
            if Busy then
               raise Program_Error;
            end if;

            Check_Buffer (Periph, Buffer, Length);
            Device.Buffer := Buffer;
            Last := Length;
            Next := 1;
            Device.Done := Done;
            Error := False;
            Busy := True;

            Clear_Receiver (Periph);
            Periph.CR2.RXNEIE := True;
            Periph.CR2.ERRIE := True;
            Periph.I2SCFGR.I2SE := True;
         end Start_Reading;

      end Device;

   end IRQ_Implementation;

   ------------------------
   -- DMA_Implementation --
   ------------------------

   package body DMA_Implementation is

      procedure On_DMA_Complete;

      package DMA_Callback is new A0B.Callbacks.Generic_Parameterless
        (On_DMA_Complete);

      protected body Device is

         function Is_Busy return Boolean is (Busy);
         function Has_Error return Boolean is (Error);

         ------------------
         -- DMA_Complete --
         ------------------

         procedure DMA_Complete is
         begin
            if Busy then
               Error := Periph.SR.OVR;
               Finish;
            end if;
         end DMA_Complete;

         ------------
         -- Finish --
         ------------

         procedure Finish is
         begin
            Periph.CR2.RXDMAEN := False;
            Periph.CR2.ERRIE := False;
            Periph.I2SCFGR.I2SE := False;
            Clear_Receiver (Periph);
            Busy := False;
            A0B.Callbacks.Emit_Once (Done);
         end Finish;

         -----------------------
         -- Interrupt_Handler --
         -----------------------

         procedure Interrupt_Handler is
            Remaining : Interfaces.Unsigned_16;
         begin
            if Busy and then Periph.SR.OVR then
               Error := True;
               Periph.CR2.RXDMAEN := False;
               Periph.I2SCFGR.I2SE := False;
               RX_Stream.Stop_Transfer (Remaining);
               Finish;
            end if;
         end Interrupt_Handler;

         -------------------
         -- Start_Reading --
         -------------------

         procedure Start_Reading
           (Buffer : System.Address;
            Length : Transfer_Length;
            Done   : A0B.Callbacks.Callback) is
         begin
            if Busy then
               raise Program_Error;
            end if;

            Check_Buffer (Periph, Buffer, Length);
            Device.Done := Done;
            Error := False;
            Busy := True;
            Clear_Receiver (Periph);

            RX_Stream.Start_Transfer
              (Channel => 0,
               Source  =>
                 (Address     => Periph.DR'Address,
                  Item_Length => 2,
                  Increment   => 0,
                  Burst       => 1),
               Target  =>
                 (Address     => Buffer,
                  Item_Length => 2,
                  Increment   => 2,
                  Burst       => 1),
               Count   => Interfaces.Unsigned_16 (Length),
               FIFO    => 0,
               Prio    => STM32.DMA.High,
               Done    => DMA_Callback.Create_Callback);

            Periph.CR2.RXDMAEN := True;
            Periph.CR2.ERRIE := True;
            Periph.I2SCFGR.I2SE := True;
         end Start_Reading;

      end Device;

      ---------------------
      -- On_DMA_Complete --
      ---------------------

      procedure On_DMA_Complete is
      begin
         --  Runs inside the stream protected object. Do not call any stream
         --  operation here, including Has_Error; callers query it afterwards.
         Device.DMA_Complete;
      end On_DMA_Complete;

   end DMA_Implementation;

end STM32.I2S;
