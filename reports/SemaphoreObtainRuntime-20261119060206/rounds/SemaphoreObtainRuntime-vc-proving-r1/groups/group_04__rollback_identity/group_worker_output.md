# rollback_identity delivery

All five assigned proof spans are Qed. Protected whole-mode split blocks remain generated Proof/Abort.

- which_implies_wit_10: borrow the cached task ID cell from task-world/ID-manager consistency, derive its range and lookup relation, and retain the exact restoration wand.
- which_implies_wit_11 split and aggressive wrapper: consume that wand to restore os_inv.
- entail_wit_13_1: obtain ID uniqueness from os_inv, identify the queried task and descriptor, and contradict the returned non-suspended status.
- entail_wit_13_2: transport ID-manager consistency through wakeup_task_ids, identify the queried task and descriptor, construct the finite-delay failure plus actual Wakeup effect, and use wp_spec/bind refinement to obtain ret(-5).

Historical borrowing/ID-uniqueness proof patterns were adapted from the completed canonical LinklistSuspendSemaphore manual. No specs, global libraries, trust assumptions, or unassigned proof spans were changed.

Validation: controller group-development and exact group-check both returned exit 0 and JSON status passed. Exact group-check compiled SemaphoreObtainRuntime_group_04_rollback_identity_check.v (elapsed 50.383004 seconds). Local controller checks were used; no Rocq MCP source transmission. Existing .vo artifacts are retained. Parent finalization and whole-function final-check remain parent responsibilities.
