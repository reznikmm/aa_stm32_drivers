--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with A0B.Callbacks;

--  Internal cooperative scheduler for Linux device implementations.
--  All instances share one dispatcher task, independent of device count.
package STM32.Workers is

   type Step_Status is (Pending, Completed, Failed);

   generic
      type Request_Type is private;

      with procedure Step
        (Request : in out Request_Type;
         Count   : in out Natural;
         Status  : out Step_Status);
      --  Perform a short, nonblocking step. Count starts at zero and persists
      --  with Request between steps. Return Pending to be scheduled again,
      --  Completed on success or Failed on error. Do not wait for device IO,
      --  sleep, or wait for another worker; use poll(..., 0), nonblocking IO,
      --  and timestamps instead. Exceptions become Failed with zero count.

   package Generic_Worker is
      --  Each instance is one operation slot, without its own task.
      --  Request may contain any device-specific state, e.g. paired SPI
      --  buffers, a UART buffer, an idle deadline, or an operation code.

      procedure Enable;
      --  Initially disabled. Enabling a busy slot raises Program_Error.

      procedure Disable;
      --  Reject new requests and cancel outstanding work before its next step.
      --  The callback still runs; Count retains progress made before cancel.

      procedure Start
        (Request : Request_Type;
         Done    : A0B.Callbacks.Callback);
      --  Copy the request and schedule it. Busy/disabled raises Program_Error.
      --  Referenced resources must remain valid until completion. Starting
      --  clears the error flag. Separate slots may run independent operations.

      function Is_Busy return Boolean;
      function Has_Error return Boolean;
      function Count return Natural;
      --  Results of the last completed request; Start clears Has_Error.

      procedure Wait_Until_Idle;
      --  Wait for all access to this slot, including its callback, to finish.
      --  Disable first if cancellation is required, then release resources.
      --  Never call this from a Step or callback. Lifecycle calls must be
      --  serialized by the application. Scope exit disables and drains a slot.

      --  Steps and callbacks for every device run in the single dispatcher.
      --  Done runs outside protected actions after Is_Busy is cleared, and
      --  may Start the next request. It must be short and must not block or
      --  raise. Callback exceptions cannot terminate the dispatcher.
   end Generic_Worker;

end STM32.Workers;
