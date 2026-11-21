# Obtain annotation retry 3

Removed only `task != 0` from the two internal assertions before LinklistSuspend. Exact C-file comparison against attempt2 after confirms these two deletions are the whole change. Public contracts, imported contracts, global invariant, executable body, resource assertions and trust remain unchanged. The current abstract registered-task resources do not justify prematurely asserting a nonzero base address.

Read both historical and current manual entries and goal definitions for proof_of__SemaphoreObtain_entail_wit_8. Its two alternative conclusions formerly required the running task address to be nonzero. That pure requirement is now absent in both. The existential descriptor, task lookup, retained running-task equality, future-delay condition, InsideCritical, exstatus cell, and write-to-zero reconstruction wand all remain. The resource focus and reconstruction are still actual proof obligations; removing the unsupported pure conjunct does not discharge them. The matching second pre-call assertion likewise no longer preserves an unproved nonzero fact.

Post-call nonzero assertions are retained. Their source is the already verified semaphore_prio_ic Ensure: linklist_suspend_prio unfolds to linklist_suspend_step with flag 1; its invalid-flag alternative is impossible, and its successful alternative contains ktask_suspend_step whose first conjunct is task <> 0. This argument uses the returned relation only after the call. No later fact is assumed early.

Controller formal-case-lib-design passed/skipped for absent library, then symexec exited 0 / passed and published all four generated files. Native generated auto/manual division remains untouched. This repairs the reported annotation gap, not the remaining implementation proof. Main must recheck and prove the actual generated resource obligations.

Current manual top-level / split / auto counts: (36, 47, 107). Final C SHA256: df646ea87618010e0633e94ccdd881ee439cc06eed9c676aa90861f6b9e27030.
