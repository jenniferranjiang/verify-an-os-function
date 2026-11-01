# entry_frames proof delivery

Completed candidates for `proof_of__SemaphoreDelete_partial_solve_wit_1`, `_2`, `_5`, `_6_pure`, and `_6` using the assigned `LLM_pre_process` route. The first four close directly; `_6` first introduces its pure premise and then unfolds `_SemaphoreDelete_partial_solve_wit_6_aux` before applying the same preprocessing tactic. No helpers were added, and the group library seed is unchanged.

Rocq MCP verification: `mcp__rocq_mcp__rocq_compile` returned `success: true` with empty compiler output for all five complete candidate proofs together. The candidate used exact, unmodified goal Definitions copied from the canonical goal file and the unchanged group library seed, with workspace `/home/xinra/crtos/ksemaphoredelete-trial-261025-1`. An earlier `Show. Abort.` diagnostic confirmed that the first four proofs had no goals and the last had only its `_aux` wrapper; that diagnostic is not counted as a completed proof. No interactive pet calls were attempted.

The initial development/debug requests rejected the original assigned `Admitted` spans at structure validation, before staging; completed proofs were saved only after the successful MCP candidate compile. A forbidden-lemma/tactic scan of the copied manual and group library returned no matches. Only assigned proof spans were changed.

Final controller verification: the exact assigned `coq-check --target-kind group-check --group entry_frames` command exited 0 and returned JSON `status: passed`, `returncode: 0`. It recompiled all five staged current-source targets, including the original goal, manual, and group wrapper; build workspace: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r1/group_13/src`.
