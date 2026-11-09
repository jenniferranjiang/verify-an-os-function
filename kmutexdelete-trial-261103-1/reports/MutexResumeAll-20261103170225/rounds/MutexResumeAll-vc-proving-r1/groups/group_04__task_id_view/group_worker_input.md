# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `task_id_view`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_04__task_id_view/MutexResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_which_implies_wit_7`, `proof_of_LinklistResumeAll_which_implies_wit_8`, `proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial`, `proof_of_LinklistResumeAll_partial_solve_wit_12`, `proof_of_LinklistResumeAll_partial_solve_wit_13`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_04__task_id_view/MutexResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexResumeAll_lib.v`
- Every new/adapted helper uses suffix `__task_id_view`. Preserve the seed.

### `proof_of_LinklistResumeAll_which_implies_wit_7` — `LLM_pre_process`

Choose the actual uint16 task ID owned by the task ID manager in os_inv marked. Since replace_task_desc_map preserves os_mutexes, old pending membership gives current marked pending membership. Use the shared task representation/ID correspondence for get_task_with_idnode_success and typed UShort bounds. Split the ID field and build a wand returning unchanged os_inv marked; carry the prior remaining/marked equalities as pure facts.
### `proof_of_LinklistResumeAll_which_implies_wit_8` — `aggressive_pre_process`

- Split `proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial`: Unfold mutex_resume_id_restore and apply wand elimination to the exact target.id.id UShort cell. The ID is unchanged, so the same marked invariant is returned.
### `proof_of_LinklistResumeAll_partial_solve_wit_12` — `LLM_pre_process`

Rewrite retval=target to equate the read ID-cell address; every scalar bound, lookup and membership is already a hypothesis. Cancel typed ID cell, ID restore wand and InsideCritical.
### `proof_of_LinklistResumeAll_partial_solve_wit_13` — `LLM_pre_process`

Same address bridge retval=target in the reverse orientation; copy existing facts and cancel exactly. Do not consume the ID cell before the following restoration.

## Helpers

- `task_id_focus__task_id_view` (local): From os_inv sg marked and the known task being a Mutex waiter, derive exists id in [0,65536), get_task_with_idnode_success sg marked id task, and the ID UShort cell ** (same cell -* os_inv sg marked). Derive ID-manager/list/map correspondence from task_inv; use actual owned UShort for bounds. The pure pending relation is preserved by the earlier exstatus-only update.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_04__task_id_view/proof_reuse.md`.

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
      "task_id_view"
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
      "task_id_view"
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
      "task_id_view"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/_coq_builds/MutexResumeAll-vc-proving-r1/group_04/src/.coq_debug/group_04_task_id_view.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_04__task_id_view/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_04__task_id_view/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
