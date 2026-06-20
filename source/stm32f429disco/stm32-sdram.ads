--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  SDRAM Controller is part of FMC (Flexible Memory Controller) and is used
--  to interface with external SDRAM chips. This package provides a simple API
--  to initialize the SDRAM controller and the SDRAM chip.

with System;

package STM32.SDRAM is

   procedure Initialize (Pins : Pin_Array);
   --  Initialize the SDRAM controller and configure the pins for SDRAM
   --  operation

   type Bank_Index is range 1 .. 2;
   --  SDRAM controller has two banks, each can be connected to a separate
   --  SDRAM chip.

   type Bank_Set is array (Bank_Index) of Boolean;
   --  Set of banks.
   function First return Bank_Set is (1 => True, 2 => False);
   function Second return Bank_Set is (1 => False, 2 => True);
   function Both return Bank_Set is (1 => True, 2 => True);

   type Bank_Count is range 2 .. 4
     with Static_Predicate => Bank_Count in 2 | 4;
   --  Number of banks in the SDRAM chip.

   type Item_Size is range 8 .. 32
     with Static_Predicate => Item_Size in 8 | 16 | 32;

   type Control_Parameters is record
      Read_Pipe_Delay : Natural range 0 .. 2 := 0;
      --  The delay, in HCLK clock cycles, for reading data after CAS latency.
      Burst_Read : Boolean := False;
      --  Enable burst read mode. If disabled, the SDRAM controller will
      --  read one word at a time.
      SDCLK_Period : Natural range 2 .. 3 := 2;
      --  The period of the SDCLK clock, in HCLK clock cycles.
      Write_Protection : Boolean := False;
      --  Write accesses ignored or allowed
      CAS_Latency : Natural range 1 .. 3 := 1;
      --  The CAS latency, in HCLK clock cycles.
      Banks : Bank_Count := 2;
      --  Number of banks in the SDRAM chip.
      Bus_Width : Item_Size := 16;
      --  Memory data bus width.
      Row_Bits : Natural range 11 .. 13 := 12;
      --  Number of row address bits
      Column_Bits : Natural range 8 .. 11 := 8;
      --  Number of column address bits
   end record;

   type Cycle_Count is range 1 .. 16;
   --  Number of HCLK clock cycles for a parameter.

   type Timing_Parameters is record
      Row_To_Column_Delay : Cycle_Count := 16;
      --  Delay between the Activate command and a Read/Write command
      Row_Precharge_Delay : Cycle_Count := 16;
      --  Delay between a Precharge command and another command
      Write_Recovery_Time : Cycle_Count := 16;
      --  Delay between a Write and a Precharge command
      Row_Cycle_Delay : Cycle_Count := 16;
      --  Delay between the Refresh command and the Activate command, as well
      --  as the delay between two consecutive Refresh commands
      Self_Refresh_Time : Cycle_Count := 16;
      --  Minimum Self-refresh period
      Exit_Self_Refresh_Delay : Cycle_Count := 16;
      --  Delay from releasing the Self-refresh command to issuing the Activate
      --  command
      Load_To_Active_Delay : Cycle_Count := 16;
      --  Delay between a Load Mode Register command and an Active or Refresh
      --  command
   end record;

   type Bank_Configuration is record
      Control : Control_Parameters;
      Timing  : Timing_Parameters;
   end record;

   type Bank_Configuration_Array is array (Bank_Index range <>) of
     Bank_Configuration;

   procedure Configure (Banks : Bank_Configuration_Array);
   --  Configure the SDRAM controller with the given parameters for each bank.

   type Command_Kind is
     (Normal_Mode,
      Clock_Configuration_Enable,
      All_Bank_Precharge,
      Auto_Refresh,
      Load_Mode_Register,
      Self_Refresh,
      Power_Down);
   --  SDRAM command to send.

   type Command (Kind : Command_Kind := Normal_Mode) is record
      case Kind is
         when Load_Mode_Register =>
            Mode_Register : Natural range 0 .. 2**13 - 1 := 0;
            --  Value to load into the mode register.
         when Auto_Refresh =>
            Auto_Refresh_Count : Cycle_Count range 1 .. 15 := 1;
            --  Number of Auto-refresh commands to send.
         when others =>
            null;
      end case;
   end record;

   procedure Enable_Clock_Configuration (Banks : Bank_Set := Both);
   --  Enable the clock configuration mode for the given banks. This procedure
   --  must be called before sending any commands to the SDRAM controller.
   --  After calling this procedure, wait during the prescribed delay period.
   --  (typical delay is around 100 μs) to ensure that the clock configuration
   --  mode is enabled before sending any commands.

   type Mode_Register_Per_Bank is array (Bank_Index range <>) of
     Natural range 0 .. 2**13 - 1;
   --  Mode register values for each bank.

   procedure Load_Mode_Register
     (Value        : Mode_Register_Per_Bank;
      Auto_Refresh : Positive);
   --  Load the mode register for the given banks with the specified values.
   --  Set the Auto_Refresh parameter to the number of Auto-refresh commands to
   --  send.

   procedure Set_Refresh_Timer (Value : Positive);
   --  The Refresh_Timer parameter specifies the refresh period in SDCLK clock
   --  cycles (SDRAM refresh period / Number of rows x SDRAM clock frequency).

   Bank_1_Start : constant System.Address :=
     System'To_Address (16#C000_0000#);

   Bank_2_Start : constant System.Address :=
     System'To_Address (16#D000_0000#);

end STM32.SDRAM;