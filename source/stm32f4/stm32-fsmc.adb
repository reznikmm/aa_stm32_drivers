--  SPDX-FileCopyrightText: 2023-2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces;
with STM32.GPIO;
with STM32.Registers.FSMC;
with STM32.Registers.GPIO;
with STM32.Registers.RCC;

package body STM32.FSMC is

   procedure Init_GPIO (Item : Pin);

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Bank_1 : Bank_1_Configuration := (1 .. 4 => (Is_Set => False));
      Bank_2 : NAND_PC_Card_Configuration := (Is_Set => False);
      Bank_3 : NAND_PC_Card_Configuration := (Is_Set => False);
      Bank_4 : NAND_PC_Card_Configuration := (Is_Set => False))
   is
      pragma Unreferenced (Bank_2, Bank_3, Bank_4);
   begin
      for X in Bank_1'Range loop
         declare
            pragma Warnings (Off,  "is not referenced");
            --  GNAT GCC 12.2 gives a wrong warnings here
            BCR  : STM32.Registers.FSMC.BCR_Register renames
              STM32.Registers.FSMC.FSMC_Periph.BCR_BTR (X).BCR;
            BTR  : STM32.Registers.FSMC.BTR_Register renames
              STM32.Registers.FSMC.FSMC_Periph.BCR_BTR (X).BTR;
            BWTR : STM32.Registers.FSMC.BWTR_Register renames
              STM32.Registers.FSMC.FSMC_Periph.BWTR (X).BWTR;
            pragma Warnings (On,  "is not referenced");
         begin
            if Bank_1 (X).Is_Set then
               declare
                  Value : Asynchronous_Configuration renames Bank_1 (X).Value;
               begin
                  BCR :=
                    (MBKEN          => True,
                     MUXEN          => False,
                     MTYP           => Memory_Type'Pos (Value.Memory_Type),
                     MWID           => Memory_Bus_Width'Pos (Value.Bus_Width),
                     FACCEN         => Value.Memory_Type = NOR_Flash,
                     Reserved_7_7   => 1,
                     BURSTEN        => False,
                     WAITPOL        => Value.Wait_Signal = Positive,
                     WRAPMOD        => False,
                     WAITCFG        => False,
                     WREN           => Value.Write_Enable,
                     WAITEN         => False,
                     EXTMOD         => Value.Extended.Mode /= None,
                     ASYNCWAIT      => Value.Wait_Signal /= None,
                     Reserved_16_18 => 0,
                     CBURSTRW       => False,
                     Reserved_20_31 => 0);

                  BTR :=
                    (ADDSET  => Interfaces.Unsigned_32 (Value.Address_Setup),
                     ADDHLD  =>
                       (if Value.Extended.Mode = Mode_D
                        then Interfaces.Unsigned_32
                          (Value.Extended.Read_Address_Hold)
                        else 0),
                     DATAST  => Interfaces.Unsigned_32 (Value.Data_Setup),
                     BUSTURN => Interfaces.Unsigned_32 (Value.Bus_Turn),
                     CLKDIV  => 0,
                     DATLAT  => 0,
                     ACCMOD  =>
                       (if Value.Extended.Mode = None then 0
                        else Asynchronous_Extended_Mode'Pos
                          (Value.Extended.Mode)),
                     Reserved_30_31 => 0);

                  if Value.Extended.Mode /= None then
                     BWTR :=
                       (ADDSET => Interfaces.Unsigned_32
                          (Value.Extended.Write_Address_Setup),
                        ADDHLD =>
                          (if Value.Extended.Mode = Mode_D
                           then Interfaces.Unsigned_32
                             (Value.Extended.Write_Address_Hold)
                           else 0),
                        DATAST =>
                          Interfaces.Unsigned_32
                            (Value.Extended.Write_Data_Setup),
                        Reserved_16_19 => 16#F#,
                        CLKDIV         => 0,
                        DATLAT         => 0,
                        ACCMOD         => 0,
                        Reserved_30_31 => 0);
                  end if;
               end;
            else
               BCR.MBKEN := False;
            end if;
         end;
      end loop;
   end Configure;

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
      RCC.AHB3ENR.FSMCEN := True;

      for Pin of Pins loop
         Init_GPIO (Pin);
      end loop;
   end Initialize;

end STM32.FSMC;
