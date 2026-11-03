# branch_join_frames delivery

All three assigned spans were completed through Rocq MCP and closed with `Qed`.

- `proof_of__MutexCreate_partial_solve_wit_4`: `LLM_pre_process` preserves the supplied pure facts and commutes the two unchanged spatial resources.
- `proof_of__MutexCreate_entail_wit_1_1`: chooses the failure disjunction, derives signed bounds from the owned lock Int cell using `store_int_range`, and discharges min-free range implication by the contradiction between nonnegative min-free IDs and the actual failure ID -1. Resources are canceled unchanged.
- `proof_of__MutexCreate_entail_wit_1_2`: chooses the success disjunction, derives lock bounds from the same owned cell, and obtains ID < 128 from the existing min-free definition and `mutex_context` idmax equality. The actual successful ID and updated manager are preserved.

No helper, new assumption, import, statement, prelude, or unassigned proof was changed. Exact controller group-check exited 0 with status passed (elapsed 38.163522 seconds); it compiled the library, goals, auto/manual files and group wrapper.
