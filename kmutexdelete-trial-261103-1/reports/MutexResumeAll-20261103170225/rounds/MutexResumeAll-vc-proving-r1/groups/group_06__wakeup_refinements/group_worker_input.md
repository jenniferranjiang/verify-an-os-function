# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `wakeup_refinements`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_06__wakeup_refinements/MutexResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic`, `proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_06__wakeup_refinements/MutexResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexResumeAll_lib.v`
- Every new/adapted helper uses suffix `__wakeup_refinements`. Preserve the seed.

### `proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic` — `LLM_pre_process`

Choose source sg/before equal to target sg/before. Before transferring os_inv, extract pure ID uniqueness, SUSPEND descriptor/source membership and exclusive scheduler ownership. Introduce the wand and destruct the general post alternatives. The non-SUSPEND branch is impossible by same-ID/task-map uniqueness. In the success branch instantiate the specialized desc/after/retval; use ktask_wakeup_step and old unique source membership to show exact semaphore head removal, unchanged other queues and pending(rest), hence wakeup_semaphore_head. Preserve returned os_inv. This proves a declared refinement; it is not a body proof of KTaskWakeup.
### `proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic` — `LLM_pre_process`

Choose identical sg/before and transfer os_inv with a wand. The explicit ktask_wakeup_detached_null_condition yields desc.delay=0 for the returned successful lookup, and self-owned sched membership when SUSPEND. Failure branch keeps before and the same descriptor. Success uses zero-delay identity, removal from the unique self-owned list, no membership in any other queue, and unchanged module/ID/running projections to construct ktask_wakeup_detached_null_step. Preserve the returned os_inv and all general post witnesses.

## Helpers

- `general_wakeup_semaphore_refinement__wakeup_refinements` (local): Under actual source os_inv pure consistency, same-ID lookup and semaphore head membership, derive specialized wakeup_semaphore_head from ktask_wakeup_step. Extract all required uniqueness/source facts before consuming source heap; preserve a pure record across the post wand. Prove cross-module remove_found identities using absence and target queue exact tail using NoDup.
- `general_wakeup_detached_refinement__wakeup_refinements` (local): From actual source os_inv consistency, detached-null condition, returned lookup/map facts and ktask_wakeup_step derive ktask_wakeup_detached_null_step. Prove self-owned-list split/removal and all other queues absent, plus ktask_unset_delay_step 0 identity. Preserve result and task descriptor witnesses.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_06__wakeup_refinements/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "MutexResumeAll-20261103170225",
      "--round",
      "MutexResumeAll-vc-proving-r1",
      "--group",
      "wakeup_refinements"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-check",
      "--run",
      "MutexResumeAll-20261103170225",
      "--round",
      "MutexResumeAll-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "wakeup_refinements"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-check",
      "--run",
      "MutexResumeAll-20261103170225",
      "--round",
      "MutexResumeAll-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "wakeup_refinements"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/_coq_builds/MutexResumeAll-vc-proving-r1/group_06/src/.coq_debug/group_06_wakeup_refinements.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_06__wakeup_refinements/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_06__wakeup_refinements/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
