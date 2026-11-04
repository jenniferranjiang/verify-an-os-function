# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `call_guards`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_07__call_guards/MutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of__MutexDelete_partial_solve_wit_2_pure`, `proof_of__MutexDelete_partial_solve_wit_2_pure_split_goal_1`, `proof_of__MutexDelete_partial_solve_wit_4_pure`, `proof_of__MutexDelete_partial_solve_wit_5_pure`, `proof_of__MutexDelete_partial_solve_wit_8_pure`, `proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_1`, `proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_2`, `proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_07__call_guards/MutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexDelete_lib.v`
- Every new/adapted helper uses suffix `__call_guards`. Preserve the seed.

### `proof_of__MutexDelete_partial_solve_wit_2_pure` — `aggressive_pre_process`

- Split `proof_of__MutexDelete_partial_solve_wit_2_pure_split_goal_1`: Unfold mutex_pending_head; the C pending-list address and its abstract head are definitionally the same. All other spatial/pure context is frame.
### `proof_of__MutexDelete_partial_solve_wit_4_pure` — `LLM_pre_process`

Project mutex_delete_drained p id drained directly from the premise. The local C cells and OutsideCritical remain a frame.
### `proof_of__MutexDelete_partial_solve_wit_5_pure` — `LLM_pre_process`

Project the new acquisition fact mutex_delete_drained p id st_lock. The InsideCritical token and os_inv belong to this freshly acquired state, so no current/@pre bridge is missing.
### `proof_of__MutexDelete_partial_solve_wit_8_pure` — `aggressive_pre_process`

- Split `proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_1`: The address is the named C global &k_mutex_id_manager. Use the existing CNotation.addr_of_LE_var_not_zero fact, not an invented manager-pointer hypothesis.

- Split `proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_2`: Destruct the existing mutex_delete_drained p id st_lock (or its historical live counterpart) to obtain 0<=id; alternatively use the UShort local typed-store range. Keep resources as frame.

- Split `proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_3`: The same drained relation includes id<65536, exactly the required upper bound; no restriction to id<128 needs to be added.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_07__call_guards/proof_reuse.md`.

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
      "call_guards"
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
      "call_guards"
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
      "call_guards"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/_coq_builds/MutexDelete-vc-proving-r1/group_07/src/.coq_debug/group_07_call_guards.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_07__call_guards/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_07__call_guards/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
