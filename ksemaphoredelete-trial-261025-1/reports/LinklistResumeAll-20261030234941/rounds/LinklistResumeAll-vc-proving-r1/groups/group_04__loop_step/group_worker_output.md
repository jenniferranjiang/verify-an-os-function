# loop_step proof delivery

Completed the three assigned whole-goal proofs with `LLM_pre_process`.

- `entail_wit_2`: retain `next_state` and `rest`, forget the two local pointer values using `store_ptr_undef_store_ptr`, recover the semaphore pending address sequence by mapping `getData`, identify the updated descriptor from the task-map lookup, and prepend the current `semaphore_resume_one` to the tail steps before applying the existing continuation. The proof explicitly clears both `target <> 0` premises.
- `partial_solve_wit_13_pure`: its three pure conclusions follow from the explicit premises on an arbitrary heap.
- `partial_solve_wit_13`: unfold the auxiliary VC after the required preprocessing, cancel the identical `os_inv`, and supply all repeated pure facts from the auxiliary premises.

No helper declarations or seed-library changes were needed. Statements, other proof spans and frozen semantic inputs were preserved.

Rocq MCP: `mcp__rocq_mcp__rocq_compile` compiled all three complete candidate proofs together against the original goal imported from this group's controller development workspace, returning `success: true` and empty compiler output. The static workspace warning about project discovery remained, but the adapter resolved imports and actual compilation succeeded. Earlier `Show. Abort.` calls were diagnostic only.

Development staging passed with exit code 0 and JSON `status: passed`. The explicit forbidden-lemma/tactic scan of the group manual and library found no matches.

Final controller `group-check --group loop_step` passed with process exit code 0 and JSON `status: passed`; it compiled the current manual, library, goal, auto proof and group wrapper in `group_04/src` (98.567172 seconds). All group writes are complete.
