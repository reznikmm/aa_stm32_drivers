--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Synchronous_Task_Control;
with A0B.Callbacks.Generic_Subprogram;

package Suspension_Object_Callbacks is new
  A0B.Callbacks.Generic_Subprogram
    (Ada.Synchronous_Task_Control.Suspension_Object,
     Ada.Synchronous_Task_Control.Set_True);
