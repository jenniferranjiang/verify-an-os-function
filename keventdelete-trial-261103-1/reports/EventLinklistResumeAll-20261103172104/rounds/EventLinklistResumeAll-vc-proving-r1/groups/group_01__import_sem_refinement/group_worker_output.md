# import_sem_refinement delivery

Completed the assigned imported-contract refinement witness:
`proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic`.

The proof extracts a pure universal refinement fact from the old `os_inv` before passing its spatial resources to the generic contract. The generic non-SUSPEND branch contradicts the uniquely identified semaphore head descriptor; the successful branch returns the same descriptor, zero result, exact semaphore head removal and the complete pending wakeup frame, retaining the returned `os_inv`.

The group library proves DLL pure-property extraction and pointer uniqueness from separation resources; semaphore address uniqueness and pending SUSPEND facts; task-ID uniqueness using existing aligned TaskDescriptor ABI assumptions; exclusion of the target from other queues; and deterministic `remove_found` behavior. The public helper `generic_wakeup_sem_head__import_sem_refinement` packages these facts as a consequence of `os_inv`, without an extra assumed precondition. All added helpers use the assigned suffix; the seed and unassigned proof tokens remain fixed.

The previous approval blocker was resolved by the new direct user answer on 2026-11-04: “明确授权继续实现证明”, explicitly covering symbolic, VC and Rocq implementation proofs and overriding the earlier design-only restriction. The same previously rejected operation was retried and accepted. No alternate execution route was used to bypass review.

Validation: the exact handoff `coq-check --target-kind group-check --group import_sem_refinement` command completed with exit code 0 and JSON `status: passed`. It recompiled the current group library, goal, auto proof, manual proof and group wrapper; elapsed time was 49.842856 seconds. Forbidden-lemma/tactic scan found no matches. This verifies only the assigned group and does not claim KTaskWakeup body verification or completion of other groups.

All file writes stop after the terminal report; main owns finalization.
