--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces;

with STM32.GPIO;
with STM32.Registers.FMC;
with STM32.Registers.GPIO;
with STM32.Registers.RCC;

package body STM32.SDRAM is

   subtype U32 is Interfaces.Unsigned_32;

   function "+" (Command : Command_Kind) return U32 is
     (Command_Kind'Pos (Command));

   procedure Init_GPIO (Item : Pin);

   ---------------
   -- Init_GPIO --
   ---------------

   procedure Init_GPIO (Item : Pin) is

      procedure Init_GPIO
        (Periph : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin    : Pin_Index);

      ---------------
      -- Init_GPIO --
      ---------------

      procedure Init_GPIO
        (Periph : in out STM32.Registers.GPIO.GPIO_Peripheral;
         Pin    : Pin_Index) is
      begin
         Periph.MODER   (Pin) := STM32.Registers.GPIO.Mode_AF;
         Periph.OSPEEDR (Pin) := STM32.Registers.GPIO.Speed_100MHz;
         Periph.OTYPER  (Pin) := STM32.Registers.GPIO.Push_Pull;
         Periph.PUPDR   (Pin) := STM32.Registers.GPIO.No_Pull;
         Periph.AFR     (Pin) := 12;
      end Init_GPIO;

   begin
      STM32.GPIO.Enable_GPIO (Item.Port);
      Init_GPIO (STM32.Registers.GPIO.GPIO_Periph (Item.Port), Item.Pin);
   end Init_GPIO;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Pins : Pin_Array) is
      RCC : STM32.Registers.RCC.RCC_Peripheral renames
        STM32.Registers.RCC.RCC_Periph;
   begin
      RCC.AHB3ENR.FMCEN := True;

      for Pin of Pins loop
         Init_GPIO (Pin);
      end loop;
   end Initialize;

   ---------------
   -- Configure --
   ---------------

   procedure Configure (Banks : Bank_Configuration_Array) is
      Periph : STM32.Registers.FMC.FMC_Peripheral renames
        STM32.Registers.FMC.FMC_Periph;

      function "+" (Size : Item_Size) return Interfaces.Unsigned_32 is
        (case Size is
           when 8  => 0,
           when 16 => 1,
           when 32 => 2);
   begin
      if Banks'Length = 0 then
         Periph.SDCR1.SDCLK := 0;  --  disable clock for all banks
         Periph.SDCR2.SDCLK := 0;  --  disable clock for all banks
         return;
      end if;

      declare
         First : Bank_Configuration renames Banks (Banks'First);
         Last  : Bank_Configuration renames Banks (Banks'Last);

         Max_Write_Recovery_Time : constant Cycle_Count :=
           Cycle_Count'Max
             (First.Timing.Write_Recovery_Time,
              Last.Timing.Write_Recovery_Time);

         Max_Row_Cycle_Delay : constant Cycle_Count :=
           Cycle_Count'Max
             (First.Timing.Row_Cycle_Delay,
              Last.Timing.Row_Cycle_Delay);
      begin
         Periph.SDCR1 :=
           (NC             => U32 (First.Control.Column_Bits - 8),
            NR             => U32 (First.Control.Row_Bits - 11),
            MWID           => +First.Control.Bus_Width,
            NB             => First.Control.Banks = 4,
            CAS            => U32 (First.Control.CAS_Latency),
            WP             => First.Control.Write_Protection,
            SDCLK          =>
              (if Banks'First = 1
               then U32 (First.Control.SDCLK_Period) else 0),
            RBURST         => First.Control.Burst_Read,
            RPIPE => U32 (First.Control.Read_Pipe_Delay),
            Reserved_15_31 => 0);

         Periph.SDCR2 :=
           (NC             => U32 (Last.Control.Column_Bits - 8),
            NR             => U32 (Last.Control.Row_Bits - 11),
            MWID           => +Last.Control.Bus_Width,
            NB             => Last.Control.Banks = 4,
            CAS            => U32 (Last.Control.CAS_Latency),
            WP             => Last.Control.Write_Protection,
            SDCLK          =>
              (if Banks'Last = 2 then U32 (Last.Control.SDCLK_Period) else 0),
            RBURST         => False,  --  don't care
            RPIPE          => 0,  --  read-only
            Reserved_15_31 => 0);

         Periph.SDTR1 :=
           (TMRD           => U32 (First.Timing.Load_To_Active_Delay - 1),
            TXSR           => U32 (First.Timing.Exit_Self_Refresh_Delay - 1),
            TRAS           => U32 (First.Timing.Self_Refresh_Time - 1),
            TRC            => U32 (Max_Row_Cycle_Delay - 1),
            TWR            => U32 (Max_Write_Recovery_Time - 1),
            TRP            => U32 (First.Timing.Row_Precharge_Delay - 1),
            TRCD           => U32 (First.Timing.Row_To_Column_Delay - 1),
            Reserved_28_31 => 0);

         Periph.SDTR2 :=
              (TMRD           => U32 (Last.Timing.Load_To_Active_Delay - 1),
               TXSR           => U32 (Last.Timing.Exit_Self_Refresh_Delay - 1),
               TRAS           => U32 (Last.Timing.Self_Refresh_Time - 1),
               TRC            => 0,  --  don't care
               TWR            => U32 (Max_Write_Recovery_Time - 1),
               TRP            => 0,  --  don't care
               TRCD           => U32 (Last.Timing.Row_To_Column_Delay - 1),
               Reserved_28_31 => 0);
      end;
   end Configure;

   --------------------------------
   -- Enable_Clock_Configuration --
   --------------------------------

   procedure Enable_Clock_Configuration (Banks : Bank_Set := Both) is

      Periph : STM32.Registers.FMC.FMC_Peripheral renames
        STM32.Registers.FMC.FMC_Periph;
   begin
      Periph.SDCMR :=
        (MODE   => +Clock_Configuration_Enable,
         CTB2   => Banks (2),
         CTB1   => Banks (1),
         others => 0);
   end Enable_Clock_Configuration;

   ------------------------
   -- Load_Mode_Register --
   ------------------------

   procedure Load_Mode_Register
     (Value        : Mode_Register_Per_Bank;
      Auto_Refresh : Positive)
   is
      First : Natural renames Value (Value'First);
      Last  : Natural renames Value (Value'Last);

      Periph : STM32.Registers.FMC.FMC_Peripheral renames
        STM32.Registers.FMC.FMC_Periph;
   begin
      Periph.SDCMR :=
        (MODE   => +All_Bank_Precharge,
         CTB1   => Value'First = 1,
         CTB2   => Value'Last = 2,
         others => 0);

      Periph.SDCMR :=
        (MODE   => +STM32.SDRAM.Auto_Refresh,
         CTB1   => Value'First = 1,
         CTB2   => Value'Last = 2,
         NRFS   => U32 (Auto_Refresh),
         others => 0);

      if Value'Length = 1 or First = Last then
         Periph.SDCMR :=
           (MODE   => +Load_Mode_Register,
            CTB1   => Value'First = 1,
            CTB2   => Value'Last = 2,
            MRD    => U32 (First),
            others => 0);
      else
         Periph.SDCMR :=
           (MODE   => +Load_Mode_Register,
            CTB1   => True,
            CTB2   => False,
            MRD    => U32 (First),
            others => 0);

         Periph.SDCMR :=
           (MODE   => +Load_Mode_Register,
            CTB1   => False,
            CTB2   => True,
            MRD    => U32 (Last),
            others => 0);
      end if;
   end Load_Mode_Register;

   -----------------------
   -- Set_Refresh_Timer --
   -----------------------

   procedure Set_Refresh_Timer (Value : Positive) is
      Periph : STM32.Registers.FMC.FMC_Peripheral renames
        STM32.Registers.FMC.FMC_Periph;
   begin
      Periph.SDRTR :=
        (CRE    => False,
         COUNT  => U32 (Value - 20),
         REIE   => False,
         others => 0);
   end Set_Refresh_Timer;

end STM32.SDRAM;