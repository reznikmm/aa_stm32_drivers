--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with STM32.System_Clocks;
with STM32.Registers.GPIO;

with STM32.GPIO;

package body STM32.I2C is

   procedure Init_GPIO
     (Periph : in out STM32.Registers.GPIO.GPIO_Peripheral;
      Pin    : Pin_Index);

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

   ------------------------
   -- I2C_Implementation --
   ------------------------

   package body I2C_Implementation is

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
           (Reserved_2_2   => 0,
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

      --------------
      -- On_Error --
      --------------

      procedure On_Error (Self : in out Internal_Data) is
         SR1   : constant STM32.Registers.I2C.SR1_Register := Periph.SR1;
      begin

         if SR1.BERR or SR1.AF or SR1.ARLO then
            --  Bus error, Acknowledge failure, Arbitration lost
            Periph.SR1.BERR := False;
            Periph.SR1.AF   := False;
            Periph.SR1.ARLO := False;

            Periph.CR1.STOP := Periph.SR2.MSL;
            --  If we in Master mode then do STOP condition

            Self.Error := True;
            A0B.Callbacks.Emit (Self.Done);
            A0B.Callbacks.Unset (Self.Done);

         else
            raise Program_Error;
         end if;
      end On_Error;

      --------------
      -- On_Event --
      --------------

      procedure On_Event (Self : in out Internal_Data) is
         use type Interfaces.Unsigned_8;

         Buffer : String (1 .. Positive'Last)
           with Import, Address => Self.Buffer;

         RX    : constant Boolean := (Self.Slave and 1) /= 0;
         SR1   : constant STM32.Registers.I2C.SR1_Register := Periph.SR1;
         ACK   : constant Boolean := Self.Next < Self.Last - 1;
         Dummy : STM32.Registers.I2C.SR2_Register;
         None  : constant STM32.Registers.I2C.SR2_Register :=
           (Reserved_3_3   => 0,
            Reserved_16_31 => 0,
            PEC            => 0,
            others         => False);
      begin
         Periph.CR1.ACK := ACK;

         Dummy := (if SR1.ADDR then Periph.SR2 else None);
         --  Clear ADDR in EV6

         if SR1.SB then
            Periph.DR.DR := Interfaces.Unsigned_32 (Self.Slave);

         elsif RX then

            if SR1.ADDR then
               Periph.CR1.STOP := Self.Last = 1;

            elsif SR1.RxNE then
               Buffer (Self.Next) := Character'Val (Periph.DR.DR);
               Self.Next := Self.Next + 1;
               Periph.CR1.STOP := Self.Next = Self.Last;

               if Self.Next > Self.Last then
                  A0B.Callbacks.Emit (Self.Done);
                  A0B.Callbacks.Unset (Self.Done);

               end if;
            end if;

         elsif SR1.ADDR or SR1.TxE then
            --  Address or prev byte has been sent

            if Self.Next <= Self.Last then
               Periph.DR.DR := Character'Pos (Buffer (Self.Next));
               Self.Next := Self.Next + 1;

            elsif Self.Read > 0 then
               Periph.CR1.STOP := True;
               Self.Last   := Self.Read;
               Self.Next   := 1;
               Self.Read   := 0;
               Self.Slave  := Self.Slave + 1;

               while Periph.CR1.STOP loop
                  null;  --  It takes about 7 cycles on my board
               end loop;

               Periph.CR1.START := True;

            else
               Periph.CR1.STOP := True;
               A0B.Callbacks.Emit (Self.Done);
               A0B.Callbacks.Unset (Self.Done);

            end if;
         end if;

      end On_Event;

      -------------------------
      -- Start_Data_Exchange --
      -------------------------

      procedure Start_Data_Exchange
        (Self   : in out Internal_Data;
         Slave  : I2C_Slave_Address;
         Buffer : System.Address;
         Write  : Natural;
         Read   : Natural;
         Done   : A0B.Callbacks.Callback)
      is
         use type Interfaces.Unsigned_8;

         Reading : constant Interfaces.Unsigned_8 range 0 .. 1 :=
           (if Write = 0 and Read > 0 then 1 else 0);
      begin
         pragma Assert (not A0B.Callbacks.Is_Set (Self.Done));

         Self.Buffer := Buffer;
         Self.Last   := (if Write > 0 then Write else Read);
         Self.Next   := 1;
         Self.Read   := (if Write > 0 then Read else 0);
         Self.Done   := Done;
         Self.Slave  := 2 * Interfaces.Unsigned_8 (Slave) + Reading;
         Self.Error  := False;

         Periph.CR1 :=
           (PE     => True,
            START  => True,
            others => <>);
      end Start_Data_Exchange;

   end I2C_Implementation;

end STM32.I2C;
