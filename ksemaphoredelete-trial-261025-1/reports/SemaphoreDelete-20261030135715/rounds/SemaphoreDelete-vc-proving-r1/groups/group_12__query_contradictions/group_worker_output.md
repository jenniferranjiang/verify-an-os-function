# query_contradictions delivery

Completed all six assigned proof spans: `proof_of__SemaphoreDelete_partial_solve_wit_20_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_20`, `proof_of__SemaphoreDelete_partial_solve_wit_22_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_22`, `proof_of__SemaphoreDelete_partial_solve_wit_23`, and `proof_of__SemaphoreDelete_partial_solve_wit_25`.

Each proof begins with `LLM_pre_process ltac:(congruence)`. The two non-pure wrappers unfold their generated auxiliary proposition when needed. Contradictory false/true equalities for the same retained manager query close each goal. No helper or library change was needed; statements, unassigned proofs, and semantic inputs remain unchanged.

Validation:

- Forbidden-lemma/tactic scan of both group files: no matches.
- Initial development attempt on unchanged seed proofs was rejected structurally for assigned Admitted tokens; these were subsequently replaced.
- Current group-development: exit code 0, JSON status passed (113.331112 seconds).
- Rocq MCP `rocq_compile`: success true on the exact prelude plus the six completed assigned lemma declarations/proofs, using the staged group_12/dev workspace; empty compiler output. The generic missing-project workspace warning did not prevent imports or compilation.
- Current group-check: exit code 0, JSON status passed (142.168849 seconds), including the exact group wrapper.

No annotation gap or infrastructure blocker remains. Work stopped after terminal report delivery; main may finalize the current files.
