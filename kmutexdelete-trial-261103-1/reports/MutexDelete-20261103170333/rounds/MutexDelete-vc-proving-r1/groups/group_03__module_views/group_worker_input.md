# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `module_views`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_03__module_views/MutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of__MutexDelete_which_implies_wit_4`, `proof_of__MutexDelete_which_implies_wit_4_split_goal_spatial`, `proof_of__MutexDelete_which_implies_wit_5`, `proof_of__MutexDelete_which_implies_wit_5_split_goal_spatial`, `proof_of__MutexDelete_which_implies_wit_6`, `proof_of__MutexDelete_which_implies_wit_6_split_goal_1`, `proof_of__MutexDelete_which_implies_wit_6_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_03__module_views/MutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexDelete_lib.v`
- Every new/adapted helper uses suffix `__module_views`. Preserve the seed.

### `proof_of__MutexDelete_which_implies_wit_4` — `aggressive_pre_process`

- Split `proof_of__MutexDelete_which_implies_wit_4_split_goal_spatial`: Unfold mutex_delete_id_restore and apply the separation-wand elimination law to the exact UShort cell and its restore wand. Address and value are identical on both sides; the result is the original os_inv.
### `proof_of__MutexDelete_which_implies_wit_5` — `aggressive_pre_process`

- Split `proof_of__MutexDelete_which_implies_wit_5_split_goal_spatial`: Unfold os_inv and mutex_inv only enough to isolate the Mutex manager. Use mutex_context to rewrite its stable manager pointer to &k_mutex_id_manager; put the unchanged management DLL and all non-Mutex components into mutex_delete_manager_frame. Pure os_world_wf is retained in the existing mutex_create_frame. No duplication of heap resources.
### `proof_of__MutexDelete_which_implies_wit_6` — `aggressive_pre_process`

- Split `proof_of__MutexDelete_which_implies_wit_6_split_goal_1`: Unfold mutex_delete_manager_frame and extract its explicit mutex_context pure conjunct while discarding/retaining spatial context as required by the pure entailment.

- Split `proof_of__MutexDelete_which_implies_wit_6_split_goal_spatial`: Unfold the manager frame. Rewrite os_mutexes using prefix++current::suffix, map_app/map_cons, and current.addr=mutex_pre; unfold mutex_link_node for the center node and rewrite stable head via mutex_context. Cancel the exact non-Mutex frame and whole management DLL; this is only a view change.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_03__module_views/proof_reuse.md`.

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
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-vc-proving-r1",
      "--group",
      "module_views"
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
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "module_views"
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
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "module_views"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/_coq_builds/MutexDelete-vc-proving-r1/group_03/src/.coq_debug/group_03_module_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_03__module_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_03__module_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
