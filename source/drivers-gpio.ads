--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces.STM32;

package Drivers.GPIO is
   pragma Preelaborate;

   procedure Configure_Output (Pin : Drivers.Pin);

   procedure Set_Output
     (Pin   : Drivers.Pin;
      Value : Interfaces.STM32.Bit);

   procedure Configure_Interrupt
     (Pin       : Drivers.Pin;
      Pull_Up   : Boolean := False;
      Pull_Down : Boolean := False)
        with Pre => not (Pull_Up and Pull_Down);
   --
   --  Switch pin to input and enable interrupt on it

   procedure Clear_Interrupt (Pin : Drivers.Pin);
   --  Clear pending interrupt

   type Pending_Interrupt_Set is array (Pin_Index) of Boolean
     with Component_Size => 1, Object_Size => 16;

   function Pending_Interrupts return Pending_Interrupt_Set;

   procedure Enable_GPIO (Port : Drivers.Port);

end Drivers.GPIO;
