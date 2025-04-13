--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces.STM32.RCC;

package body STM32.I2C.I2C_1 is

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Self  : in out Device;
      SCL   : Pin;
      SDA   : Pin;
      Speed : Interfaces.Unsigned_32)
   is
      pragma Unreferenced (Self);
   begin
      Interfaces.STM32.RCC.RCC_Periph.APB1ENR.I2C1EN := 1;
      Implementation.Configure (SCL, SDA, Speed);
   end Configure;

   ------------
   -- Device --
   ------------

   protected body Device is

      ---------------
      -- Has_Error --
      ---------------

      function Has_Error return Boolean is (Implementation.Has_Error (Data));

      --------------
      -- On_Error --
      --------------

      procedure On_Error is
      begin
         Implementation.On_Error (Data);
      end On_Error;

      --------------
      -- On_Event --
      --------------

      procedure On_Event is
      begin
         Implementation.On_Event (Data);
      end On_Event;

      -------------------------
      -- Start_Data_Exchange --
      -------------------------

      procedure Start_Data_Exchange
        (Slave  : I2C_Slave_Address;
         Buffer : System.Address;
         Write  : Natural;
         Read   : Natural;
         Done   : A0B.Callbacks.Callback) is
      begin
         Implementation.Start_Data_Exchange
           (Data, Slave, Buffer, Write, Read, Done);
      end Start_Data_Exchange;

   end Device;

   ---------------
   -- Has_Error --
   ---------------

   function Has_Error (Self : Device) return Boolean is
     (Self.Has_Error);

   -------------------------
   -- Start_Data_Exchange --
   -------------------------

   procedure Start_Data_Exchange
     (Self   : in out Device;
      Slave  : I2C_Slave_Address;
      Buffer : System.Address;
      Write  : Natural;
      Read   : Natural;
      Done   : A0B.Callbacks.Callback) is
   begin
      Self.Start_Data_Exchange (Slave, Buffer, Write, Read, Done);
   end Start_Data_Exchange;

end STM32.I2C.I2C_1;
