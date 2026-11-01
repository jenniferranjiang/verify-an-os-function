Completed both assigned witnesses, `proof_of__SemaphoreDelete_partial_solve_wit_24` and `proof_of__SemaphoreDelete_partial_solve_wit_26`, using `LLM_pre_process ltac:(lia || int_auto)`.

The existing pure hypotheses discharge the repeated postcondition facts; the identical spatial resources cancel. No helper or seed library changes were needed. Unassigned proof spans remain unchanged.

Rocq MCP: `rocq_compile` checked a candidate source containing exact copies of both original goal Definitions and the seed annotation library, returning `success: true`. The interactive pet backend was not used.

Validation: forbidden-lemma/tactic scan found no matches. Controller `coq-check --target-kind group-check --group remove_member_frames` finished with exit code 0 and JSON `status: passed`, compiling the current group manual and wrapper (elapsed 114.847853 seconds).
