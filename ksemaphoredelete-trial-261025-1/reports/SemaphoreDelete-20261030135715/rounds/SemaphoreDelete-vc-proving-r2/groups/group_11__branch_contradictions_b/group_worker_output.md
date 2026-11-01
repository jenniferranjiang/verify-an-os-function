Completed all five assigned top-level witnesses using `LLM_pre_process ltac:(lia || congruence)`.

Compared current goal definitions with the matching r1 proofs and reused those proof bodies. The resched equalities/inequality and conflicting boolean query premises still directly yield contradictions. No helpers were added, the library seed is unchanged, and all unassigned proof spans were preserved. Forbidden lemma scan was clear.

Validation against current r2 inputs:
- Exact controller group-check: exit 0, JSON status passed; target `VC/SemaphoreDelete_group_11_branch_contradictions_b_check.v` in `group_11/src`.
- Rocq MCP `rocq_compile`: success true for the exact current manual prelude and the five assigned proof blocks, using the r2 `group_11/src` workspace. The static workspace warning is covered by the reviewed wrapper aliases; compilation succeeded.

All writes complete; ready for main finalize-delivery.
