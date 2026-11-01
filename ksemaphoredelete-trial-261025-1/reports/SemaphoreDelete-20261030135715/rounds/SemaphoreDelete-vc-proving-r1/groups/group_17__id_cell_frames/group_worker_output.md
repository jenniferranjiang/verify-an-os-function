# id_cell_frames delivery

Completed the four assigned witnesses: partial_solve_wit_13_pure, partial_solve_wit_13, partial_solve_wit_14_pure, and partial_solve_wit_14. Each proof starts with the prescribed LLM_pre_process route. Pure witnesses close by reflexivity; wrappers unfold the corresponding aux and reuse the given pure premises while preserving the identical ID field, delete_id_restore, and InsideCritical frame. No helper or library changes were needed.

Rocq MCP rocq_compile checked exact copied goal Definitions and annotation-library definitions with all four candidate proofs ending in Qed: success true, empty compiler output. Diagnostic Show/Abort calls preceded this finished check and are not counted as completion. The interactive backend was not used.

The required controller group-check completed with process exit 0 and JSON status passed (108.227908 seconds), recompiling the current lib, goal, auto, manual, and group wrapper in group_17/src. Forbidden lemma and tactic scan found no matches. Only assigned manual proof spans were changed; all other declarations and seed-library content remain unchanged.
