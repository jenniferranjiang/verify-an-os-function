Completed all six assigned unlock_frames witnesses for proving round r2.

Reused the corresponding r1 proof bodies after checking current declarations, reviewing current pure/aux goal definitions, and confirming the library seed is byte-identical. Pure goals follow from the existing Crtos_GTrans premises; auxiliary wrappers reinsert existing pure facts and cancel the unchanged InsideCritical, os_inv and SemaphoreRetired frames. No helpers were added and no seed or semantic inputs were changed.

Rocq MCP rocq_compile checked all six complete candidate proofs with exact current goal Definitions and current shared imports: success: true. This candidate contained no admitted proof. Forbidden lemma/tactic scans passed for the copied manual and group library.

The exact assigned controller command coq-check --target-kind group-check --group unlock_frames for SemaphoreDelete-vc-proving-r2 exited 0 with status: passed, elapsed 72.988075 seconds. It recompiled library, goal, auto/manual proofs and the group check wrapper in the current group_21/src workspace.

Terminal delivery is complete. All writing stopped before main finalization.
