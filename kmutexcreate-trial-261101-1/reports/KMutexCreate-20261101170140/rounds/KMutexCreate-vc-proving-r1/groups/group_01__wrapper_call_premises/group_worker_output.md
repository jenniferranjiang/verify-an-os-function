# wrapper_call_premises delivery

Both assigned witnesses are proved using the prescribed `LLM_pre_process` route, with the existing safeExec hypothesis and unchanged OutsideCritical resource. No helper, import, specification, model or C-body change was needed.

- `proof_of_KMutexCreate_partial_solve_wit_1_pure`: one `LLM_pre_process ltac:(assumption)` closes the pure entailment.
- `proof_of_KMutexCreate_partial_solve_wit_1`: the first invocation introduces the implication premise; the second unfolds the auxiliary VC and closes the duplicated pure facts plus preserved resource.

Rocq MCP interactive checks completed both exact statements through Qed. The interactive preamble used the unchanged imports and Definitions from canonical `VC/KMutexCreate_goal.v`, excluding its VC_Correct module-type axioms. Main authorized this scratch context because direct file start could not load generated goal artifacts. No assumptions were added. MCP states 6 and 11 reported no remaining goals.

Controller group-check completed with exit code 0 and JSON status passed, recompiling the current goal, case library, auto, manual and group wrapper, with 198 base artifacts reused. The group library seed and all unassigned proof spans remain unchanged. Forbidden-lemma/tactic scan returned no matches.
