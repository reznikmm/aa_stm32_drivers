--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.System_Clocks;
with STM32.Registers.GPIO;

with A0B.Callbacks.Generic_Parameterless;
with STM32.GPIO;
with Ada.Real_Time;

package body STM32.I2C is

   procedure Init_GPIO
     (Periph : in out STM32.Registers.GPIO.GPIO_Peripheral;
      Pin    : Pin_Index);

   procedure Recover_Bus
     (Periph : in out STM32.Registers.I2C.I2C_Peripheral;
      SCL    : Pin;
      SDA    : Pin;
      Speed  : Interfaces.Unsigned_32);

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO (Item : Pin) is
   begin
      STM32.GPIO.Enable_GPIO (Item.Port);
      Init_GPIO (STM32.Registers.GPIO.GPIO_Periph (Item.Port), Item.Pin);
   end Init_GPIO;

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO
     (Periph : in out STM32.Registers.GPIO.GPIO_Peripheral;
      Pin    : Pin_Index)
   is
      AF_I2C1_3 : constant := 4;
   begin
      Periph.MODER   (Pin) := STM32.Registers.GPIO.Mode_AF;
      Periph.OSPEEDR (Pin) := STM32.Registers.GPIO.Speed_100MHz;
      Periph.OTYPER  (Pin) := STM32.Registers.GPIO.Open_Drain;
      Periph.PUPDR   (Pin) := STM32.Registers.GPIO.No_Pull;
      Periph.AFR     (Pin) := AF_I2C1_3;
   end Init_GPIO;

   -----------------
   -- Recover_Bus --
   -----------------

   procedure Recover_Bus
     (Periph : in out STM32.Registers.I2C.I2C_Peripheral;
      SCL    : Pin;
      SDA    : Pin;
      Speed  : Interfaces.Unsigned_32)
   is
      Half_Period : constant Ada.Real_Time.Time_Span :=
        Ada.Real_Time.Nanoseconds (1E9 / 2 / Integer (Speed));

      procedure Spin (Time : Ada.Real_Time.Time_Span);
      --  Make CPU busy for given time

      ----------
      -- Spin --
      ----------

      procedure Spin (Time : Ada.Real_Time.Time_Span) is
         use type Ada.Real_Time.Time;
         Limit : constant Ada.Real_Time.Time := Ada.Real_Time.Clock + Time;
      begin
         while Ada.Real_Time.Clock < Limit loop
            null;
         end loop;
      end Spin;

      CR2   : constant STM32.Registers.I2C.CR2_Register   := Periph.CR2;
      CCR   : constant STM32.Registers.I2C.CCR_Register   := Periph.CCR;
      TRISE : constant STM32.Registers.I2C.TRISE_Register := Periph.TRISE;
   begin
      Periph.CR1 :=
        (PE             => False,
         SWRST          => True,
         Reserved_2_2   => 0,
         Reserved_14_14 => 0,
         Reserved_16_31 => 0,
         others         => False);

      STM32.GPIO.Configure_Output (SDA, Open_Drain => True);
      STM32.GPIO.Configure_Output (SCL, Open_Drain => True);
      --  Switch SDA/SCL to GPIO mode to reser I2C bus by bit shaking

      STM32.GPIO.Set_Output (SDA, 0);  --  emulate NACK

      --  Now make SCL pulses: 7 data bits + NACK + STOP
      --  SCL: `__^^__^^ ... __^^__^^__^^^^`
      --  SDA: `_________________________^^`
      --  Bit  `  01  02 ...   07  NA  STOP`
      for Bit in 1 .. 9 loop
         STM32.GPIO.Set_Output (SCL, 0);
         Spin (Half_Period);
         STM32.GPIO.Set_Output (SCL, 1);
         Spin (Half_Period);
      end loop;

      STM32.GPIO.Set_Output (SDA, 1);
      Spin (Half_Period);

      Init_GPIO (SCL);
      Init_GPIO (SDA);
      --  Switch pins back to I2C function

      Periph.CR1 :=
        (SWRST          => False,
         Reserved_2_2   => 0,
         Reserved_14_14 => 0,
         Reserved_16_31 => 0,
         others         => False);
      --  Finish I2C reset

      Periph.CR2 := CR2;
      Periph.CCR := CCR;
      Periph.TRISE := TRISE;
      --  Restore clock values

      Periph.CR1 :=
        (PE             => True,
         Reserved_2_2   => 0,
         Reserved_14_14 => 0,
         Reserved_16_31 => 0,
         others         => False);
      --  Enable I2C
   end Recover_Bus;

   ------------------------
   -- DMA_Implementation --
   ------------------------

   package body DMA_Implementation is

      procedure On_Transfer_Complete;

      package Transfer_Complete_Callbacks is new
        A0B.Callbacks.Generic_Parameterless (On_Transfer_Complete);

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (SCL   : Pin;
         SDA   : Pin;
         Speed : Interfaces.Unsigned_32)
      is
         use type Interfaces.Unsigned_32;

         Clock : constant Interfaces.Unsigned_32 := STM32.System_Clocks.PCLK1;

         Clock_MHz : constant Interfaces.Unsigned_32 := Clock / 1_000_000;

         Speed_x3  : constant Interfaces.Unsigned_32 := 3 * Speed;

         CCR       : Interfaces.Unsigned_32 range 4 .. 4095;
         --  The minimum allowed value is 0x04
      begin
         pragma Assert (Clock_MHz in 4 .. 50);
         Init_GPIO (SCL);
         Init_GPIO (SDA);

         Periph.CR1 :=
           (PE             => False,
            Reserved_2_2   => 0,
            Reserved_14_14 => 0,
            Reserved_16_31 => 0,
            others         => False);
         --  Disable I2C

         Periph.CR2 :=
           (FREQ    => Clock_MHz,
            ITERREN => True,   --  Error interrupt enable
            ITEVTEN => True,   --  Event interrupt enable
            ITBUFEN => False,  --  Buffer interrupt enable(XXX)
            DMAEN   => False,  --  DMA requests enable
            LAST    => True,   --  DMA last transfer(XXX)
            others  => 0);

         CCR := (Clock + Speed_x3 - 1) / Speed_x3;

         Periph.CCR :=
           (CCR    => CCR,
            DUTY   => False,  --  Fast mode duty cycle
            F_S    => True,   --  I2C master mode selection
            others => 0);

         --  SCL rise time is 300ns
         Periph.TRISE.TRISE := 300 * Clock_MHz / 1000 + 1;

         Periph.OAR1 :=
           (ADD0    => False,
            ADD7    => 0,      --  Slave address
            ADDMODE => False,  --  7 bit address
            others  => 0);

         Periph.CR1.PE := True;
      end Configure;

      --------------------------
      -- On_Transfer_Complete --
      --------------------------

      procedure On_Transfer_Complete is
      begin
         Device.On_Transfer_Complete;
      end On_Transfer_Complete;

      protected body Device is

         function Has_Error return Boolean is (Error);

         --------------
         -- On_Error --
         --------------

         procedure On_Error is
            SR1   : constant STM32.Registers.I2C.SR1_Register := Periph.SR1;
         begin

            if SR1.BERR or SR1.AF or SR1.ARLO then
               --  Bus error, Acknowledge failure, Arbitration lost
               Periph.SR1.BERR := False;
               Periph.SR1.AF   := False;
               Periph.SR1.ARLO := False;

               Periph.CR1.STOP := Periph.SR2.MSL;
               --  If we in Master mode then do STOP condition

               Periph.CR2.DMAEN := False;

               Error := True;
               A0B.Callbacks.Emit_Once (Done);

            else
               raise Program_Error;
            end if;
         end On_Error;

         --------------
         -- On_Event --
         --------------

         procedure On_Event is
            use type Interfaces.Unsigned_8;

            RX    : constant Boolean := (Slave and 1) /= 0;
            SR1   : constant STM32.Registers.I2C.SR1_Register := Periph.SR1;
            Dummy : STM32.Registers.I2C.SR2_Register;
         begin
            if SR1.SB then
               Periph.DR.DR := Interfaces.Unsigned_32 (Slave);

            elsif SR1.ADDR then
               --  Address has been sent
               if RX and Last < 2 then
                  Periph.CR1.ACK := False;
                  Dummy := Periph.SR2; --  Clear ADDR in EV6
               elsif Last = 0 then
                  Periph.CR1.STOP := True;
                  A0B.Callbacks.Emit_Once (Done);
               else
                  Dummy := Periph.SR2; --  Clear ADDR in EV6
               end if;
            elsif SR1.BTF and Stop then
               Stop := False;
               Periph.CR1.STOP := True;

               if Read > 0 then
                  Last   := Read;
                  Read   := 0;
                  Slave  := Slave + 1;

                  Periph.CR2.DMAEN := True;

                  RX_Stream.Start_Transfer
                    (Channel => Channel,
                     Source  =>
                       (Address     => Periph.DR'Address,
                        Item_Length => 1,  --  8 bit
                        Increment   => 0,
                        Burst       => 1),
                     Target  =>
                       (Address     => Device.Buffer,
                        Item_Length => 1,  --  8 bit
                        Increment   => 1,
                        Burst       => 1),
                     Count   => Interfaces.Unsigned_16 (Last),
                     FIFO    => 4,
                     Prio    => STM32.DMA.Low,
                     Done    => Transfer_Complete_Callbacks.Create_Callback);

                  while Periph.CR1.STOP loop
                     null;  --  It takes about 7 cycles on my board
                  end loop;

                  Periph.CR1.ACK := True;
                  Periph.CR1.START := True;
               else
                  A0B.Callbacks.Emit_Once (Done);
               end if;
            end if;
         end On_Event;

         --------------------------
         -- On_Transfer_Complete --
         --------------------------

         procedure On_Transfer_Complete is
            use type Interfaces.Unsigned_8;
            RX : constant Boolean := (Slave and 1) /= 0;
            --  Count : Natural := 0;
         begin
            Periph.CR2.DMAEN := False;

            if RX then
               Periph.CR1.STOP := True;
               A0B.Callbacks.Emit_Once (Done);
            else
               Stop := True;
            --  while not Periph.SR1.BTF loop
            --     Count := Count + 1;
            --     null;
            --  end loop;
            --
            --  pragma Assert (Count /= 99);

            end if;
         end On_Transfer_Complete;

         -------------------------
         -- Start_Data_Exchange --
         -------------------------

         procedure Start_Data_Exchange
           (Slave  : I2C_Slave_Address;
            Buffer : System.Address;
            Write  : Natural;
            Read   : Natural;
            Done   : A0B.Callbacks.Callback)
         is
            use type Interfaces.Unsigned_8;

            Reading : constant Interfaces.Unsigned_8 range 0 .. 1 :=
              (if Write = 0 and Read > 0 then 1 else 0);
         begin
            pragma Assert (not A0B.Callbacks.Is_Set (Device.Done));

            Device.Buffer := Buffer;
            Device.Last   := (if Write > 0 then Write else Read);
            Device.Read   := (if Write > 0 then Read else 0);
            Device.Done   := Done;
            Device.Slave  := 2 * Interfaces.Unsigned_8 (Slave) + Reading;
            Device.Error  := False;
            Device.Stop   := False;

            Periph.CR2.DMAEN := Read + Write > 0;

            if Write > 0 then
               TX_Stream.Start_Transfer
                 (Channel => Channel,
                  Source  =>
                    (Address     => Buffer,
                     Item_Length => 1,  --  8 bit
                     Increment   => 1,
                     Burst       => 1),
                  Target  =>
                    (Address     => Periph.DR'Address,
                     Item_Length => 1,  --  8 bit
                     Increment   => 0,
                     Burst       => 1),
                  Count   => Interfaces.Unsigned_16 (Device.Last),
                  FIFO    => 4,
                  Prio    => STM32.DMA.Low,
                  Done    => Transfer_Complete_Callbacks.Create_Callback);
            else
               RX_Stream.Start_Transfer
                 (Channel => Channel,
                  Source  =>
                    (Address     => Periph.DR'Address,
                     Item_Length => 1,  --  8 bit
                     Increment   => 0,
                     Burst       => 1),
                  Target  =>
                    (Address     => Buffer,
                     Item_Length => 1,  --  8 bit
                     Increment   => 1,
                     Burst       => 1),
                  Count   => Interfaces.Unsigned_16 (Device.Last),
                  FIFO    => 4,
                  Prio    => STM32.DMA.Low,
                  Done    => Transfer_Complete_Callbacks.Create_Callback);
            end if;

            Periph.CR1 :=
              (PE             => True,
               START          => True,
               ACK            => True,
               Reserved_2_2   => 0,
               Reserved_14_14 => 0,
               Reserved_16_31 => 0,
               others         => False);
         end Start_Data_Exchange;
      end Device;

      -----------------
      -- Recover_Bus --
      -----------------

      procedure Recover_Bus
        (SCL   : Pin;
         SDA   : Pin;
         Speed : Interfaces.Unsigned_32) is
      begin
         Recover_Bus (Periph, SCL => SCL, SDA => SDA, Speed => Speed);
      end Recover_Bus;

   end DMA_Implementation;

   ------------------------
   -- I2C_Implementation --
   ------------------------

   package body I2C_Implementation is

      ---------------
      -- Configure --
      ---------------

      procedure Configure
        (SCL   : Pin;
         SDA   : Pin;
         Speed : Interfaces.Unsigned_32)
      is
         use type Interfaces.Unsigned_32;

         Clock : constant Interfaces.Unsigned_32 := STM32.System_Clocks.PCLK1;

         Clock_MHz : constant Interfaces.Unsigned_32 := Clock / 1_000_000;

         Speed_x3  : constant Interfaces.Unsigned_32 := 3 * Speed;

         CCR       : Interfaces.Unsigned_32 range 4 .. 4095;
         --  The minimum allowed value is 0x04
      begin
         pragma Assert (Clock_MHz in 4 .. 50);
         Init_GPIO (SCL);
         Init_GPIO (SDA);

         Periph.CR1 :=
           (PE             => False,
            Reserved_2_2   => 0,
            Reserved_14_14 => 0,
            Reserved_16_31 => 0,
            others         => False);
         --  Disable I2C

         Periph.CR2 :=
           (FREQ    => Clock_MHz,
            ITERREN => True,   --  Error interrupt enable
            ITEVTEN => True,   --  Event interrupt enable
            ITBUFEN => True,   --  Buffer interrupt enable
            DMAEN   => False,  --  DMA requests enable
            LAST    => False,  --  DMA last transfer
            others  => 0);

         CCR := (Clock + Speed_x3 - 1) / Speed_x3;

         Periph.CCR :=
           (CCR    => CCR,
            DUTY   => False,  --  Fast mode duty cycle
            F_S    => True,   --  I2C master mode selection
            others => 0);

         --  SCL rise time is 300ns
         Periph.TRISE.TRISE := 300 * Clock_MHz / 1000 + 1;

         Periph.OAR1 :=
           (ADD0    => False,
            ADD7    => 0,      --  Slave address
            ADDMODE => False,  --  7 bit address
            others  => 0);

         Periph.CR1.PE := True;
      end Configure;

      protected body Device is

         --------------
         -- On_Error --
         --------------

         procedure On_Error is
            SR1   : constant STM32.Registers.I2C.SR1_Register := Periph.SR1;
         begin

            if SR1.BERR or SR1.AF or SR1.ARLO then
               --  Bus error, Acknowledge failure, Arbitration lost
               Periph.SR1.BERR := False;
               Periph.SR1.AF   := False;
               Periph.SR1.ARLO := False;

               Periph.CR1.STOP := Periph.SR2.MSL;
               --  If we in Master mode then do STOP condition

               Error := True;
               A0B.Callbacks.Emit_Once (Done);

            else
               raise Program_Error;
            end if;
         end On_Error;

         --------------
         -- On_Event --
         --------------

         procedure On_Event is
            use type Interfaces.Unsigned_8;

            Buffer : String (1 .. Positive'Last)
              with Import, Address => Device.Buffer;

            RX    : constant Boolean := (Slave and 1) /= 0;
            SR1   : constant STM32.Registers.I2C.SR1_Register := Periph.SR1;
            Dummy : STM32.Registers.I2C.SR2_Register;
            None  : constant STM32.Registers.I2C.SR2_Register :=
              (Reserved_3_3   => 0,
               Reserved_16_31 => 0,
               PEC            => 0,
               others         => False);
         begin
            Periph.CR1.ACK := Next < Last - 1;

            Dummy := (if SR1.ADDR then Periph.SR2 else None);
            --  Clear ADDR in EV6

            if SR1.SB then
               Periph.DR.DR := Interfaces.Unsigned_32 (Slave);

            elsif RX then

               if SR1.ADDR then
                  Periph.CR1.STOP := Last = 1;

               elsif SR1.RxNE then
                  Buffer (Next) := Character'Val (Periph.DR.DR);
                  Next := Next + 1;
                  Periph.CR1.STOP := Next = Last;

                  if Next > Last then
                     A0B.Callbacks.Emit_Once (Done);

                  end if;
               end if;

            elsif SR1.ADDR or SR1.TxE then
               --  Address or prev byte has been sent

               if Next <= Last then
                  Periph.DR.DR := Character'Pos (Buffer (Next));
                  Next := Next + 1;

               elsif Read > 0 then
                  Periph.CR1.STOP := True;
                  Last   := Read;
                  Next   := 1;
                  Read   := 0;
                  Slave  := Slave + 1;

                  while Periph.CR1.STOP loop
                     null;  --  It takes about 7 cycles on my board
                  end loop;

                  Periph.CR1.START := True;

               else
                  Periph.CR1.STOP := True;
                  A0B.Callbacks.Emit_Once (Done);

               end if;
            end if;
         end On_Event;

         ---------------
         -- Has_Error --
         ---------------

         function Has_Error return Boolean is (Error);

         -------------------------
         -- Start_Data_Exchange --
         -------------------------

         procedure Start_Data_Exchange
           (Slave  : I2C_Slave_Address;
            Buffer : System.Address;
            Write  : Natural;
            Read   : Natural;
            Done   : A0B.Callbacks.Callback)
         is
            use type Interfaces.Unsigned_8;

            Reading : constant Interfaces.Unsigned_8 range 0 .. 1 :=
              (if Write = 0 and Read > 0 then 1 else 0);
         begin
            pragma Assert (not A0B.Callbacks.Is_Set (Device.Done));

            Device.Buffer := Buffer;
            Device.Last   := (if Write > 0 then Write else Read);
            Device.Next   := 1;
            Device.Read   := (if Write > 0 then Read else 0);
            Device.Done   := Done;
            Device.Slave  := 2 * Interfaces.Unsigned_8 (Slave) + Reading;
            Device.Error  := False;

            Periph.CR1 :=
              (PE             => True,
               START          => True,
               Reserved_2_2   => 0,
               Reserved_14_14 => 0,
               Reserved_16_31 => 0,
               others         => False);
         end Start_Data_Exchange;

      end Device;

      ---------------
      -- Reset_Bus --
      ---------------

      procedure Recover_Bus
        (SCL   : Pin;
         SDA   : Pin;
         Speed : Interfaces.Unsigned_32) is
      begin
         Recover_Bus (Periph, SCL => SCL, SDA => SDA, Speed => Speed);
      end Recover_Bus;

   end I2C_Implementation;

end STM32.I2C;
