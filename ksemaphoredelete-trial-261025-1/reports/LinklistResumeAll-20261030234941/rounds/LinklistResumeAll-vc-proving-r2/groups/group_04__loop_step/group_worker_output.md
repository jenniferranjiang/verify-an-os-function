# loop_step r2

All three assigned proofs use the required `LLM_pre_process` whole-goal route. Reused and adapted the previous round proofs after reading the current exact definitions; see `proof_reuse.md`.

The loop-step proof recovers the pending address sequence from its `sched_link_node` projection, identifies the marked descriptor, and composes the current wakeup step with the tail steps before applying the existing continuation. It explicitly clears the remaining `target <> 0` premise. The pure call premise and auxiliary entailment follow from explicit premises and cancellation of the identical `os_inv`.

Rocq MCP `rocq_compile` checked a complete candidate containing the current goal definitions copied verbatim, current library seed, exact imports and all three complete proofs: `success: true`, empty output. No interactive backend was used. The copied goal route was used because current staged goals had not yet been compiled; final controller checking validates the original generated files.

No helpers or semantic inputs were changed. The forbidden-lemma/tactic scan found no matches. Development checking was skipped; final exact group-check is the acceptance check.

Controller `coq-check --target-kind group-check --group loop_step` completed with process exit code 0 and JSON `status: passed` (81.193918 seconds), compiling the current goal, library, automatic proof, manual and group wrapper in round r2 `group_04/src`. All writes are complete.
