--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces;

with STM32.SDRAM;

procedure SDRAM is
   --  STM32F429-DISCO SDRAM pins:
   Pins : constant STM32.Pin_Array :=
     ((STM32.PB, 5),   --  SDCKE1
      (STM32.PB, 6),   --  SDNE1
      (STM32.PC, 0),   --  SDNWE
      (STM32.PD, 0),   --  D2
      (STM32.PD, 1),   --  D3
      (STM32.PD, 8),   --  D13
      (STM32.PD, 9),   --  D14
      (STM32.PD, 10),   --  D15
      (STM32.PD, 14),   --  D0
      (STM32.PD, 15),   --  D1
      (STM32.PE, 0),   --  NBL0
      (STM32.PE, 1),   --  NBL1
      (STM32.PE, 7),   --  D4
      (STM32.PE, 8),   --  D5
      (STM32.PE, 9),   --  D6
      (STM32.PE, 10),  --  D7
      (STM32.PE, 11),  --  D8
      (STM32.PE, 12),  --  D9
      (STM32.PE, 13),  --  D10
      (STM32.PE, 14),  --  D11
      (STM32.PE, 15),  --  D12
      (STM32.PF, 0),   --  A0
      (STM32.PF, 1),   --  A1
      (STM32.PF, 2),   --  A2
      (STM32.PF, 3),   --  A3
      (STM32.PF, 4),   --  A4
      (STM32.PF, 5),   --  A5
      (STM32.PF, 11),  --  SDNRAS
      (STM32.PF, 12),  --  A6
      (STM32.PF, 13),  --  A7
      (STM32.PF, 14),  --  A8
      (STM32.PF, 15),  --  A9
      (STM32.PG, 0),   --  A10
      (STM32.PG, 1),   --  A11
      (STM32.PG, 4),   --  BA0
      (STM32.PG, 5),   --  BA1
      (STM32.PG, 8),   --  SDCLK
      (STM32.PG, 15)); --  SDNCAS
begin
   STM32.SDRAM.Initialize (Pins);

   --  IS42S16400J values:
   STM32.SDRAM.Configure
     (Banks =>
        (2 =>
           (Control =>
              (Read_Pipe_Delay  => 1,
               Burst_Read       => True,   --  enable burst read mode
               SDCLK_Period     => 2,      --  2 HCLK cycles (90MHz)
               Write_Protection => False,  --  allow writes
               CAS_Latency      => 3,   --  3 SDCLK cycles
               Banks            => 4,   --  4 banks inside SDRAM chip
               Bus_Width        => 16,  --  access by 16-bit words
               Row_Bits         => 12,  --  4096 rows
               Column_Bits      => 8),  --  268 columns
            Timing  =>
              (Row_To_Column_Delay     => 2,  --  15ns / 11.11ns = 2
               Row_Precharge_Delay     => 2,  --  15ns / 11.11ns = 2
               Write_Recovery_Time     => 3,  --  tWR >= tRAS - tRCD = 4-2 ⇒ 3
               Row_Cycle_Delay         => 7,  --  63ns / 11.11ns = 7
               Self_Refresh_Time       => 4,  --  42ns / 11.11ns = 4
               Exit_Self_Refresh_Delay => 7,  --  70ns / 11.11ns = 7
               Load_To_Active_Delay    => 2))));

   STM32.SDRAM.Enable_Clock_Configuration (Banks => STM32.SDRAM.Second);
   delay 0.01;  --  wait for clock to stabilize

   STM32.SDRAM.Load_Mode_Register ((2 => 16#230#), Auto_Refresh => 2);
   --  0x230 means:
   --  burst length = 1, burst type = sequential, CAS latency = 3,
   --  op mode = standard, write burst mode = disabled

   STM32.SDRAM.Set_Refresh_Timer (1406);
   --  64ms / 4096 rows * 90MHz = 1406.25

   declare
      use type Interfaces.Unsigned_32;
      Data : array (0 .. 8 * 1024 * 1024 / 4 - 1) of Interfaces.Unsigned_32
        with Import, Address => STM32.SDRAM.Bank_2_Start;
   begin
      for J in Data'Range loop
         Data (J) := Interfaces.Unsigned_32 (J);
      end loop;
      --  Write SDRAM with known values.

      loop
         for J in Data'Range loop
            pragma Assert (Data (J) = Interfaces.Unsigned_32 (J));
            --  Verify SDRAM contents.
         end loop;
      end loop;
   end;
end SDRAM;