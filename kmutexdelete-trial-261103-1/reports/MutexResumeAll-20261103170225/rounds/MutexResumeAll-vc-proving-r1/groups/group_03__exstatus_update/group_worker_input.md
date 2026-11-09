# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `exstatus_update`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_03__exstatus_update/MutexResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_which_implies_wit_5`, `proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial`, `proof_of_LinklistResumeAll_which_implies_wit_6`, `proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial`, `proof_of_LinklistResumeAll_partial_solve_wit_9`, `proof_of_LinklistResumeAll_partial_solve_wit_10`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_03__exstatus_update/MutexResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexResumeAll_lib.v`
- Every new/adapted helper uses suffix `__exstatus_update`. Preserve the seed.

### `proof_of_LinklistResumeAll_which_implies_wit_5` — `aggressive_pre_process`

- Split `proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial`: Extract the registered target descriptor exstatus field from os_inv using the explicit map lookup. Introduce the wand for returning the field with -1 and proving os_inv at replace_task_desc_map(update target (set_task_desc_exstatus desc (-1))) current. All other bytes stay framed. Show cross-module pure associations depend on unchanged scheduler/delay/id/domain fields, not exstatus. This is a real field-update restoration lemma, not a pure-state cast.
### `proof_of_LinklistResumeAll_which_implies_wit_6` — `aggressive_pre_process`

- Split `proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial`: Unfold mutex_resume_exstatus_restore; supply the adjacent target.exstatus=-1 cell to wand elimination. Numeric bounds are already hypotheses and are irrelevant to the frame restoration.
### `proof_of_LinklistResumeAll_partial_solve_wit_9` — `LLM_pre_process`

All required pure facts are existing PreH facts. Rewrite retval=target so the exstatus address agrees, forget the old typed value to produce the undef Int cell, and cancel the restore wand and InsideCritical frame.
### `proof_of_LinklistResumeAll_partial_solve_wit_10` — `LLM_pre_process`

Rewrite retval=target, copy existing pure facts, and cancel the new exstatus=-1 cell, restore wand, and InsideCritical exactly. No new state relation is introduced.

## Helpers

- `task_exstatus_focus__exstatus_update` (local): For a known task map entry, prove os_inv sg st |-- old exstatus cell ** (new exstatus cell -* os_inv sg marked), marked being the exact map update and new value=-1. Split store_map/task payload; establish descriptor-update equalities and unchanged domain/scheduler/delay/ID/module facts; reconstruct all task-map-indexed resources. Every premise is the actual VC map fact plus os_inv.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_03__exstatus_update/proof_reuse.md`.

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
      "exstatus_update"
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
      "exstatus_update"
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
      "exstatus_update"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/_coq_builds/MutexResumeAll-vc-proving-r1/group_03/src/.coq_debug/group_03_exstatus_update.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_03__exstatus_update/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_03__exstatus_update/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
