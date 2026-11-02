# safety_3 proof delivery

Completed the five assigned top-level witnesses `_MutexCreate_safety_wit_11` through `_MutexCreate_safety_wit_15`, each using the required `LLM_pre_process` route.

Witnesses 11, 12 and 15 discharge fixed 32-bit integer bounds; witness 13 contradicts the branch facts. Witness 14 explicitly applies the existing `PreH2` implication to `PreH5`, obtaining the nonnegative ID bound that contradicts `PreH1`.

All five exact current witnesses reached `Qed` in Rocq MCP. No helper, assumption, statement, predicate, spec, C source or unassigned proof was changed. The forbidden lemma/tactic scan passed.

The prescribed group-development command passed (exit 0, JSON status passed). The final prescribed group-check command passed (exit 0, JSON status passed, 17.898113 seconds), compiling `VC/MutexCreate_group_07_safety_3_check.v` and current dependencies under the controller staging workspace.
