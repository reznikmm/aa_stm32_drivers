--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

package body STM32.DMA is

   function To_Size (X : Length_In_Bytes) return Interfaces.Unsigned_32 is
     (case X is
         when 1 => 0,
         when 2 => 1,
         when 4 => 3,
         when others => 4);

   function To_Burst (X : Burst_Length) return Interfaces.Unsigned_32 is
     (case X is
         when 1 => 0,
         when 4 => 1,
         when 8 => 2,
         when 16 => 3);

   function Clear_All_Interrupts
     (Middle : Natural;
      Low    : Natural) return STM32.Registers.DMA.ISR_x4_VFA;

   --------------------------
   -- Clear_All_Interrupts --
   --------------------------

   function Clear_All_Interrupts
     (Middle : Natural;
      Low    : Natural) return STM32.Registers.DMA.ISR_x4_VFA
   is
      Result : STM32.Registers.DMA.ISR_x4 := (others => <>);
   begin
      Result (Middle).Item (Low) :=
        (Reserved => 0,
         others   => True);

      return (List => Result);
   end Clear_All_Interrupts;

   ---------------------------
   -- Stream_Implementation --
   ---------------------------

   package body Stream_Implementation is

      function Is_DMA2 return Boolean is
        (System."="
           (Periph.ISR'Address, STM32.Registers.DMA.DMA2_Periph.IFCR'Address));

      function Has_Peripheral_Controled_Flow
        (Channel : Channel_Id) return Boolean is
          (Channel = 4 and then Index in 3 | 6 and then Is_DMA2);

      procedure Configure is null;

      ------------------
      -- On_Interrupt --
      ------------------

      procedure On_Interrupt (Self : in out Internal_Data) is
         Stream : STM32.Registers.DMA.Stream renames Periph.List (Index);
         Low    : constant Natural range 0 .. 1 := Index mod 2;
         High   : constant Natural range 0 .. 1 := Index / 4;
         Middle : constant Natural range 0 .. 1 := Index / 2 mod 2;
         State  : constant STM32.Registers.DMA.ISR :=
           Periph.IFCR (High).List (Middle).Item (Low);
      begin
         Periph.IFCR (High) := Clear_All_Interrupts (Middle, Low);
         Self.Error := State.TEIF or State.DMEIF or State.FEIF;
         Stream.SxCR.EN := False;

         A0B.Callbacks.Emit (Self.Done);
      end On_Interrupt;

      -----------
      -- Start --
      -----------

      procedure Start_Transfer
        (Self     : in out Internal_Data;
         Channel  : Channel_Id;
         Source   : Location;
         Target   : Location;
         Count    : Interfaces.Unsigned_16;
         FIFO     : FIFO_Bytes;
         Prio     : Priority_Level;
         Done     : A0B.Callbacks.Callback)
      is
         use type Interfaces.Unsigned_16;

         Low    : constant Natural range 0 .. 1 := Index mod 2;
         High   : constant Natural range 0 .. 1 := Index / 4;
         Middle : constant Natural range 0 .. 1 := Index / 2 mod 2;

         Stream : STM32.Registers.DMA.Stream renames Periph.List (Index);
      begin
         while Stream.SxCR.EN loop
            Stream.SxCR.EN := False;
         end loop;

         Periph.IFCR (High) := Clear_All_Interrupts (Middle, Low);

         Stream.SxPAR :=
           (if Is_Memory (Target.Address) then Target.Address
            else Source.Address);

         Stream.SxM0AR :=
           (if Is_Memory (Target.Address) then Source.Address
            else Target.Address);

         Stream.SxNDTR := (Interfaces.Unsigned_32 (Count), Reserved => 0);

         Stream.SxFCR :=
           (FTH    => (case FIFO is
                       when 0 | 4 => 0,
                       when 8     => 1,
                       when 12    => 2,
                       when 16    => 3),
            DMDIS  => FIFO = 0,
            FS     => 0,
            FEIE   => False,
            others => 0);

         Stream.SxCR :=
           (EN     => False,
            DMEIE  => True,
            TEIE   => True,
            HTIE   => False,
            TCIE   => True,
            PFCTRL => Count = 0 and then
                        Has_Peripheral_Controled_Flow (Channel),
            DIR    => (if not Is_Memory (Source.Address) then 0
                       elsif not Is_Memory (Target.Address) then 1 else 2),
            CIRC   => False,  --  Circular
            PINC   => (if Is_Memory (Target.Address) then Target.Increment
                       else Source.Increment) /= 0,
            MINC   => (if Is_Memory (Target.Address) then Source.Increment
                       else Target.Increment) /= 0,
            PSIZE  => To_Size
                        (if Is_Memory (Target.Address) then Target.Item_Length
                         else Source.Item_Length),
            MSIZE  => To_Size
                        (if Is_Memory (Target.Address) then Source.Item_Length
                         else Target.Item_Length),
            PINCOS => (if Is_Memory (Target.Address) then Target.Increment
                       else Source.Increment) = 4,
            PL     => Priority_Level'Pos (Prio),
            DBM    => False,
            CT     => 0,  --  Current buffer
            PBURST => To_Burst
                        (if Is_Memory (Target.Address) then Target.Burst
                         else Source.Burst),
            MBURST => To_Burst
                        (if Is_Memory (Target.Address) then Source.Burst
                         else Target.Burst),
            CHSEL  => Channel_Id'Pos (Channel),
            others => 0);

         Stream.SxCR.En := True;
      end Start_Transfer;

   end Stream_Implementation;

end STM32.DMA;
