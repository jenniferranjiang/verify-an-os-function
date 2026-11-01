# manager_selection r2 delivery

Completed `proof_of__SemaphoreDelete_which_implies_wit_7` using the required `LLM_pre_process` route. Reused the validated r1 assigned proof and its three suffixed helpers after confirming the current goal equals the r1 staged goal and the current seed library is unchanged. Only the assigned proof span and appended helpers were restored; history remains read-only.

The proof constructs the current semaphore after resume-all, preserves its address/ID/value, establishes empty pending and splits its list membership. It derives `NoDup` from the actual manager resource through `idbuckets_ok` and `idlist_ok`, proves the query result from membership, and preserves the manager plus deletion frame. No new assumptions are introduced.

Rocq MCP `rocq_compile` checked a complete candidate containing the unchanged current goal, seed definitions, restored helpers and assigned proof in the trial workspace: `success: true`, empty diagnostics. This preceded saving the completed candidate.

The exact handoff `coq-check --target-kind group-check --group manager_selection` finished with process exit 0 and JSON `status: passed` (99.881988 seconds). It recompiled the library, goal, auto, manual and group check wrapper, staging five source files and reusing 201 base objects. The forbidden-lemma/tactic scan on the restored proof and appended helper closure was clean. No redundant development check was run.

All writes stop after the terminal report. Ready for main finalization.
