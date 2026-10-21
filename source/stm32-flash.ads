--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with System.Storage_Elements;
with A0B.Callbacks;

--  Linux file-backed STM32F427/F429 two-bank flash address space.
package STM32.Flash is

   First_Bank  : constant System.Address := System'To_Address (16#0800_0000#);
   Second_Bank : constant System.Address := System'To_Address (16#0810_0000#);

   procedure Unlock;
   --  Open/map ./stm32-flash.bin at First_Bank. A missing file is created
   --  with 2 MiB of FF bytes; an existing file must be exactly 2 MiB.
   --  Mapping never replaces existing process memory. Unlock permits erase
   --  and Programming; the mapping remains read-only until Programming.

   procedure Lock;
   --  Protect the mapping against writes and synchronously flush the file.
   --  Raises Program_Error while an erase is busy.

   procedure Erase_Sector
     (Address : System.Address;
      Size    : out System.Storage_Elements.Storage_Count;
      Done    : A0B.Callbacks.Callback);
   --  Erase the sector enclosing Address to FF, using the shared dispatcher.
   --  Each 1 MiB bank has four 16 KiB, one 64 KiB and seven 128 KiB sectors.
   --  Return Size immediately; Done runs after completion, including failure.
   --  Requires Unlock and no active erase. Invalid addresses raise
   --  Constraint_Error. Completion leaves the mapping read-only.

   procedure Programming;
   --  Enable direct stores to flash addresses. Requires Unlock and no erase.
   --  Retains the original call-before-write API. Ordinary mapped stores
   --  cannot emulate hardware restrictions on changing zero bits to ones.

   function Is_Busy return Boolean;
   function Has_Error return Boolean;
   --  State of the most recently submitted erase operation.

   procedure Flush;
   --  Synchronously persist mapped changes. Requires no active erase.

   procedure Close;
   --  Wait for erase and its callback, flush and unmap. Idempotent.
   --  All imported objects pointing at flash become invalid after Close.

   --  The path is relative to the working directory on the first Unlock.
   --  Use the file exclusively; do not resize it while mapped. Serialize
   --  lifecycle/programming calls in the application. Callbacks must be
   --  short and nonblocking; never call Lock, Flush or Close from a callback.
end STM32.Flash;
