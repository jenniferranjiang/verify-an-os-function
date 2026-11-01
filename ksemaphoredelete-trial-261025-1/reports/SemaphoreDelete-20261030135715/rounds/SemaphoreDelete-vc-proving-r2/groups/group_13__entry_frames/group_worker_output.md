# entry_frames r2 delivery

The five assigned witnesses `_1`, `_2`, `_5`, `_6_pure`, and `_6` use the assigned `LLM_pre_process` route. The first four close directly; `_6` unfolds the matching `_aux` after introduction of its pure premise and then closes with the same preprocessing tactic. Only assigned proof spans were changed; no helpers were added and the group library seed was preserved.

Reuse was checked against r1: all five current goal Definitions plus `_6_aux` match the historical staged goal Definitions exactly; the group library seeds are byte-identical. Current candidate validation used `mcp__rocq_mcp__rocq_compile` with the exact current goal Definitions and unchanged seed copied into the candidate source. It returned `success: true` and empty output in the main trial workspace. No interactive pet calls or raw compiler commands were used.

The forbidden lemma/tactic scan of the copied manual and group library was clean.

Current exact controller group-check exited 0 and returned JSON `status: passed`, `returncode: 0`. It recompiled the five staged source targets including the original goal, manual, and group wrapper, in `verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r2/group_13/src`. Elapsed time: 94.127684 seconds.
