--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Interrupts.Names;

with Interfaces.STM32.FLASH;

with Memory_Barriers;

package body STM32.Flash is

   FLASH_Periph : Interfaces.STM32.FLASH.FLASH_Peripheral renames
     Interfaces.STM32.FLASH.FLASH_Periph;

   procedure Wait_Flash;
   --  Spin CPU while the flash is budy

   ------------
   -- Device --
   ------------

   protected Device
     with Interrupt_Priority => System.Interrupt_Priority'First
   is

      procedure Set_Callback (Done : A0B.Callbacks.Callback);

   private
      procedure Interrupt;

      pragma Attach_Handler (Interrupt, Ada.Interrupts.Names.FLASH_Interrupt);

      Callback : A0B.Callbacks.Callback;
   end Device;

   protected body Device is

      ---------------
      -- Interrupt --
      ---------------

      procedure Interrupt is
      begin
         FLASH_Periph.SR.EOP := 1;
         FLASH_Periph.CR.EOPIE := 0;  --  Disable interrupt on EOP

         if A0B.Callbacks.Is_Set (Callback) then
            A0B.Callbacks.Emit_Once (Callback);
         end if;
      end Interrupt;

      ------------------
      -- Set_Callback --
      ------------------

      procedure Set_Callback (Done : A0B.Callbacks.Callback) is
      begin
         Callback := Done;
      end Set_Callback;

   end Device;

   ------------------
   -- Erase_Sector --
   ------------------

   procedure Erase_Sector
     (Address : System.Address;
      Size    : out System.Storage_Elements.Storage_Count;
      Done    : A0B.Callbacks.Callback)
   is
      use type System.Storage_Elements.Integer_Address;
      use type System.Storage_Elements.Storage_Count;

      Sector : Natural range 0 .. 27;
      Next   : constant System.Storage_Elements.Integer_Address :=
        System.Storage_Elements.To_Integer (Address) and not 16#0010_0000#;
   begin
      case Next is
         when 16#0800_0000# .. 16#0800_FFFF# =>
            Size := 16 * 1024;
            Sector := (Natural (Next) - 16#0800_0000#) / Natural (Size);

         when 16#0801_0000# .. 16#0801_FFFF# =>
            Size := 64 * 1024;
            Sector := 4;

         when 16#0802_0000# .. 16#080F_FFFF# =>
            Size := 128 * 1024;
            Sector := 5 + (Natural (Next) - 16#0802_0000#) / Natural (Size);

         when others =>
            raise Program_Error;
      end case;

      if Next /= System.Storage_Elements.To_Integer (Address) then
         Sector := Sector + 16;
      end if;

      Wait_Flash;
      FLASH_Periph.SR.EOP := 1;  --  Clear interrupt flag

      Device.Set_Callback (Done);

      FLASH_Periph.CR :=
        (LOCK   => 0,  --  (No-)Lock
         SER    => 1,  --  Sector erase
         SNB    => Interfaces.STM32.FLASH.CR_SNB_Field (Sector),
         PSIZE  => 2,  --  Parallelism size x32
         STRT   => 1,  --  Start
         EOPIE  => 1,  --  interrupt on EOP bit = 1
         ERRIE  => 1,
         others => <>);
   end Erase_Sector;

   ----------
   -- Lock --
   ----------

   procedure Lock is
   begin
      FLASH_Periph.CR :=
        (LOCK   => 1,  --  Lock
         others => <>);
   end Lock;

   -----------------
   -- Programming --
   -----------------

   procedure Programming is
   begin
      Wait_Flash;

      FLASH_Periph.CR :=
        (LOCK   => 0,  --  (No-)Lock
         PG     => 1,  --  Programming
         PSIZE  => 2,  --  Parallelism size x32
         others => <>);
   end Programming;

   ------------
   -- Unlock --
   ------------

   procedure Unlock is
   begin
      FLASH_Periph.KEYR := 16#4567_0123#;
      Memory_Barriers.Data_Synchronization_Barrier;
      FLASH_Periph.KEYR := 16#CDEF_89AB#;
      Memory_Barriers.Data_Synchronization_Barrier;
      Wait_Flash;
   end Unlock;

   ----------------
   -- Wait_Flash --
   ----------------

   procedure Wait_Flash is
      use type Interfaces.STM32.FLASH.SR_BSY_Field;

   begin
      while FLASH_Periph.SR.BSY = 1 loop
         null;
      end loop;
   end Wait_Flash;

end STM32.Flash;
