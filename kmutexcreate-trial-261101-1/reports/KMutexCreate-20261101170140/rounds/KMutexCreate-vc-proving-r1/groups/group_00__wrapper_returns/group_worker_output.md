# wrapper_returns proof delivery

Completed the two assigned top-level return witnesses in the required `LLM_pre_process` mode. Both choose the supplied `after_3`, retain the identical `OutsideCritical` resource using `cancel`, and discharge the pure return bounds/equality and existing `safeExec` fact from the hypotheses. No predicate, specification, helper, import, or unassigned proof was changed.

Interactive validation used Rocq MCP with the trial workspace and the exact current `VC/KMutexCreate_goal.v` imports/definitions as a preamble (stopping before its `Module Type VC_Correct`). This avoids the staged-directory load-path limitation without changing namespaces or load paths. States 1→4→6→9 proved return witness 1 through `Qed`; state 9→17 proved return witness 2 through `Qed`. No new hypotheses or axioms were introduced.

The controller group-development check passed. The final controller group-check passed with exit code 0 and JSON status passed, compiling the current generated goal, copied manual, case library and group wrapper (198 reused base dependency objects; 15.27 seconds). Forbidden lemma/tactic scan found no matches.

The initial coq-debug call rejected unfinished generated `Admitted` placeholders; no proof bypass was attempted. Direct MCP startup against the staged manual failed to resolve its generated-goal import, hence the exact-definition preamble method above. Final acceptance still compiled the assigned proofs against the controller's frozen generated goal module.
