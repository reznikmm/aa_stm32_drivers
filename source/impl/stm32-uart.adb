--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.GPIO;
with STM32.Registers.GPIO;

with A0B.Callbacks.Generic_Subprogram;

package body STM32.UART is

   procedure Configure
     (TX     : Pin;
      RX     : Pin;
      Speed  : Interfaces.Unsigned_32;
      Clock  : Interfaces.Unsigned_32;
      Periph : in out STM32.Registers.USART.USART_Peripheral;
      Fun    : GPIO_Function)
     with Inline;

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (TX     : Pin;
      RX     : Pin;
      Speed  : Interfaces.Unsigned_32;
      Clock  : Interfaces.Unsigned_32;
      Periph : in out STM32.Registers.USART.USART_Peripheral;
      Fun    : GPIO_Function)
   is
      use type Interfaces.Unsigned_32;

      Divider  : constant Interfaces.Unsigned_32 := 25 * Clock / (4 * Speed);
      Fraction : constant Interfaces.Unsigned_32 := Divider rem 100;

   begin
      Init_GPIO (TX, Fun);
      Init_GPIO (RX, Fun);

      Periph.BRR.DIV_Fraction := (Fraction * 16 + 50) / 100;
      Periph.BRR.DIV_Mantissa := Divider / 100;

      Periph.CR1 :=
        (SBK      => False,
         RWU      => False,
         RE       => True,  --  Receiver enable
         TE       => True,  --  Transmitter enable
         IDLEIE   => False,  --  IDLE interrupt enable
         RXNEIE   => False,
         TCIE     => False,  --  Transmission complete interrupt enable
         TXEIE    => False,
         PEIE     => False,  --  Parity Error
         PS       => False,  --  is Odd parity
         PCE      => False,  --  Parity control enable
         WAKE     => False,
         M        => False,  --  9 bits
         UE       => True,  --  USART enable
         Reserved => 0,
         OVER8    => False);
   end Configure;

   package body DMA_Implementation is

      procedure RX_Done (Done : in out A0B.Callbacks.Callback);

      package RX_Callback is new A0B.Callbacks.Generic_Subprogram
        (A0B.Callbacks.Callback, RX_Done);

      procedure TX_Done (Done : in out A0B.Callbacks.Callback);

      package TX_Callback is new A0B.Callbacks.Generic_Subprogram
        (A0B.Callbacks.Callback, TX_Done);

      protected body Device is

         -----------------------
         -- Interrupt_Handler --
         -----------------------

         procedure Interrupt_Handler is
            use type Interfaces.Unsigned_32;

            SR : constant STM32.Registers.USART.SR_Register := Periph.SR;
            --  Keep SR copy to avoid losing clear-on-read bits
         begin
            if Periph.CR1.TCIE and then SR.TC then
               --  Change UART speed on transmission complete
               Periph.CR1.TE := False;  --  Transmitter disable
               Periph.CR1.RE := False;  --  Receiver disable

               Periph.BRR.DIV_Fraction := (Divider mod 100 * 16 + 50) / 100;
               Periph.BRR.DIV_Mantissa := Divider / 100;

               Periph.CR1.TCIE := False;  --  disable transmission complete irq
               Periph.CR1.TE := True;  --  Transmitter enable
               Periph.CR1.RE := True;  --  Receiver enable
            end if;
         end Interrupt_Handler;

         ---------------
         -- Set_Speed --
         ---------------

         procedure Set_Speed
           (Speed : Interfaces.Unsigned_32;
            Clock : Interfaces.Unsigned_32)
         is
            use type Interfaces.Unsigned_32;
         begin
            Divider := 25 * Clock / (4 * Speed);
            Periph.CR1.TCIE := True;  --  enable transmission complete IRQ
         end Set_Speed;

         -------------------
         -- Start_Reading --
         -------------------

         procedure Start_Reading
           (Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback) is
         begin
            Input_Done := Done;
            Periph.CR3.DMAR := True;

            RX_Stream.Start_Transfer
              (Channel,
               Source =>
                 (Address     => Periph.DR'Address,
                  Item_Length => 1,  --  8 bit
                  Increment   => 0,
                  Burst       => 1),
               Target =>
                 (Address     => Buffer,
                  Item_Length => 1,
                  Increment   => 1,
                  Burst       => 1),
               Count  => Interfaces.Unsigned_16 (Length),
               FIFO   => 4,
               Prio   => STM32.DMA.Low,
               Done   => RX_Callback.Create_Callback (Input_Done));
         end Start_Reading;

         -------------------
         -- Start_Writing --
         -------------------

         procedure Start_Writing
           (Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback) is
         begin
            Output_Done := Done;
            Periph.CR3.DMAT := True;

            --  Clear SR.TC
            Periph.SR :=
              (TC             => False,  --  clear TC
               RXNE           => True,   --  don't clear RXNE
               LBD            => True,   --  don't clear LBD
               CTS            => True,   --  don't clear CTS
               Reserved_10_31 => 0,      --  all others are read-only
               others         => False);

            TX_Stream.Start_Transfer
              (Channel,
               Source =>
                 (Address     => Buffer,
                  Item_Length => 1,
                  Increment   => 1,
                  Burst       => 1),
               Target =>
                 (Address     => Periph.DR'Address,
                  Item_Length => 1,  --  16 bit access???
                  Increment   => 0,
                  Burst       => 1),
               Count  => Interfaces.Unsigned_16 (Length),
               FIFO   => 4,
               Prio   => STM32.DMA.Low,
               Done   => TX_Callback.Create_Callback (Output_Done));
         end Start_Writing;
      end Device;

      -------------
      -- RX_Done --
      -------------

      procedure RX_Done (Done : in out A0B.Callbacks.Callback) is
      begin
         Periph.CR3.DMAR := False;
         A0B.Callbacks.Emit (Done);
      end RX_Done;

      -------------
      -- TX_Done --
      -------------

      procedure TX_Done (Done : in out A0B.Callbacks.Callback) is
      begin
         Periph.CR3.DMAT := False;
         A0B.Callbacks.Emit (Done);
      end TX_Done;

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (TX    : Pin;
         RX    : Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32) is
      begin
         Configure (TX, RX, Speed, Clock, Periph, Fun);
      end Configure;

   end DMA_Implementation;

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO
     (TX  : Pin;
      Fun : GPIO_Function)
   is
      procedure Init_GPIO
        (GPIO : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin  : Pin_Index;
         Fun  : GPIO_Function);

      ---------------
      -- Init_GPIO --
      ---------------

      procedure Init_GPIO
        (GPIO : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin  : Pin_Index;
         Fun  : GPIO_Function) is
      begin
         GPIO.MODER   (Pin) := STM32.Registers.GPIO.Mode_AF;
         GPIO.OSPEEDR (Pin) := STM32.Registers.GPIO.Speed_50MHz;
         GPIO.OTYPER  (Pin) := STM32.Registers.GPIO.Push_Pull;
         GPIO.PUPDR   (Pin) := STM32.Registers.GPIO.Pull_Up;
         GPIO.AFR     (Pin) := Fun;
      end Init_GPIO;

   begin
      STM32.GPIO.Enable_GPIO (TX.Port);
      Init_GPIO (STM32.Registers.GPIO.GPIO_Periph (TX.Port), TX.Pin, Fun);
   end Init_GPIO;

   -------------------------
   -- UART_Implementation --
   -------------------------

   package body UART_Implementation is

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (TX    : Pin;
         RX    : Pin;
         Speed : Interfaces.Unsigned_32;
         Clock : Interfaces.Unsigned_32) is
      begin
         Configure (TX, RX, Speed, Clock, Periph, Fun);
      end Configure;

      ------------
      -- Device --
      ------------

      protected body Device is

         ----------------
         -- Bytes_Read --
         ----------------

         function Bytes_Read return Natural is (Input.Next - 1);

         -----------------------
         -- Interrupt_Handler --
         -----------------------

         procedure Interrupt_Handler is
            use type Interfaces.Unsigned_32;

            Input_Buffer : String (1 .. Positive'Last)
              with Import, Address => Input.Buffer;

            Output_Buffer : String (1 .. Positive'Last)
              with Import, Address => Output.Buffer;

            SR : constant STM32.Registers.USART.SR_Register := Periph.SR;
            --  Keep SR copy to avoid losing clear-on-read bits
         begin
            if Periph.CR1.RXNEIE and then SR.RXNE then
               Input_Buffer (Input.Next) := Character'Val (Periph.DR);
               Input.Next := Input.Next + 1;

               if Input.Next > Input.Last then
                  Periph.CR1.RXNEIE := False;
                  Periph.CR1.IDLEIE := False;
                  A0B.Callbacks.Emit (Input.Done);
                  A0B.Callbacks.Unset (Input.Done);
               elsif Set_Idle then
                  Set_Idle := False;
                  Periph.CR1.IDLEIE := True;
               end if;
            end if;

            if Periph.CR1.IDLEIE and then SR.IDLE then
               Periph.CR1.RXNEIE := False;
               Periph.CR1.IDLEIE := False;
               A0B.Callbacks.Emit (Input.Done);
               A0B.Callbacks.Unset (Input.Done);
            end if;

            if Periph.CR1.TXEIE and then SR.TXE then
               Periph.DR := Character'Pos (Output_Buffer (Output.Next));

               Output.Next := Output.Next + 1;

               if Output.Next > Output.Last then
                  Periph.CR1.TXEIE := False;
                  A0B.Callbacks.Emit (Output.Done);
                  A0B.Callbacks.Unset (Output.Done);
               end if;
            end if;

            if Periph.CR1.TCIE and then SR.TC then
               --  Change UART speed on transmission complete
               Periph.CR1.TE := False;  --  Transmitter disable
               Periph.CR1.RE := False;  --  Receiver disable

               Periph.BRR.DIV_Fraction := (Divider mod 100 * 16 + 50) / 100;
               Periph.BRR.DIV_Mantissa := Divider / 100;

               Periph.CR1.TCIE := False;  --  disable transmission complete irq
               Periph.CR1.TE := True;  --  Transmitter enable
               Periph.CR1.RE := True;  --  Receiver enable
            end if;
         end Interrupt_Handler;

         ---------------
         -- Set_Speed --
         ---------------

         procedure Set_Speed
           (Speed : Interfaces.Unsigned_32;
            Clock : Interfaces.Unsigned_32)
         is
            use type Interfaces.Unsigned_32;
         begin
            Divider := 25 * Clock / (4 * Speed);
            Periph.CR1.TCIE := True;  --  enable transmission complete IRQ
         end Set_Speed;

         -------------------
         -- Start_Reading --
         -------------------

         procedure Start_Reading
           (Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback) is
         begin
            pragma Assert (not A0B.Callbacks.Is_Set (Input.Done));

            Set_Idle := False;

            Input :=
              (Buffer => Buffer,
               Last   => Length,
               Next   => 1,
               Done   => Done);

            Periph.CR1.RXNEIE := True;
            --  RXNE (RX not empty) interrupt enable. TBD: errors interrupts?
         end Start_Reading;

         -----------------------------
         -- Start_Reading_Till_Idle --
         -----------------------------

         procedure Start_Reading_Till_Idle
           (Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback) is
         begin
            pragma Assert (not A0B.Callbacks.Is_Set (Input.Done));

            Set_Idle := True;

            Input :=
              (Buffer => Buffer,
               Last   => Length,
               Next   => 1,
               Done   => Done);

            Periph.CR1.RXNEIE := True;
            --  RXNE (RX not empty) interrupt enable. TBD: errors interrupts?
         end Start_Reading_Till_Idle;

         -------------------
         -- Start_Writing --
         -------------------

         procedure Start_Writing
           (Buffer : System.Address;
            Length : Positive;
            Done   : A0B.Callbacks.Callback) is
         begin
            pragma Assert (not A0B.Callbacks.Is_Set (Output.Done));

            Output :=
              (Buffer => Buffer,
               Last   => Length,
               Next   => 1,
               Done   => Done);

            Periph.CR1.TXEIE := True;  --  IRQ is generated whenever TXE=1
         end Start_Writing;

      end Device;

   end UART_Implementation;

end STM32.UART;
