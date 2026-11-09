# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `unlock_context`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/KMutexDelete-vc-proving-r1/groups/group_06__unlock_context/KMutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of_KMutexDelete_partial_solve_wit_6_pure`, `proof_of_KMutexDelete_partial_solve_wit_6_pure_split_goal_1`, `proof_of_KMutexDelete_partial_solve_wit_6`, `proof_of_KMutexDelete_partial_solve_wit_7_pure`, `proof_of_KMutexDelete_partial_solve_wit_7_pure_split_goal_1`, `proof_of_KMutexDelete_partial_solve_wit_7`, `proof_of_KMutexDelete_partial_solve_wit_10_pure`, `proof_of_KMutexDelete_partial_solve_wit_10_pure_split_goal_1`, `proof_of_KMutexDelete_partial_solve_wit_10`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/KMutexDelete-vc-proving-r1/groups/group_06__unlock_context/KMutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/KMutexDelete_lib.v`
- Every new/adapted helper uses suffix `__unlock_context`. Preserve the seed.

### `proof_of_KMutexDelete_partial_solve_wit_6_pure` — `aggressive_pre_process`

- Split `proof_of_KMutexDelete_partial_solve_wit_6_pure_split_goal_1`: Only Crtos_GTrans st_lock st_lock is required. It is the reflexive shared protocol transition (in this model total); use its definition/reflexivity. Current local cells, os_inv and InsideCritical are irrelevant to this pure conclusion.
### `proof_of_KMutexDelete_partial_solve_wit_6` — `LLM_pre_process`

Introduce the pureVC assumption and prove its auxiliary implication directly: establish reflexive Crtos_GTrans at st_lock, repeat every supplied branch fact, and commute/cancel os_inv ** InsideCritical. No new state, ownership transfer, or synthesized local cell is needed.
### `proof_of_KMutexDelete_partial_solve_wit_7_pure` — `aggressive_pre_process`

- Split `proof_of_KMutexDelete_partial_solve_wit_7_pure_split_goal_1`: Only Crtos_GTrans st_lock st_lock is required. It is the reflexive shared protocol transition (in this model total); use its definition/reflexivity. Current local cells, os_inv and InsideCritical are irrelevant to this pure conclusion.
### `proof_of_KMutexDelete_partial_solve_wit_7` — `LLM_pre_process`

Introduce the pureVC assumption and prove its auxiliary implication directly: establish reflexive Crtos_GTrans at st_lock, repeat every supplied branch fact, and commute/cancel os_inv ** InsideCritical. No new state, ownership transfer, or synthesized local cell is needed.
### `proof_of_KMutexDelete_partial_solve_wit_10_pure` — `aggressive_pre_process`

- Split `proof_of_KMutexDelete_partial_solve_wit_10_pure_split_goal_1`: Only Crtos_GTrans st_lock st_lock is required. It is the reflexive shared protocol transition (in this model total); use its definition/reflexivity. Current local cells, os_inv and InsideCritical are irrelevant to this pure conclusion.
### `proof_of_KMutexDelete_partial_solve_wit_10` — `LLM_pre_process`

Introduce the pureVC assumption and prove its auxiliary implication directly: establish reflexive Crtos_GTrans at st_lock, repeat every supplied branch fact, and commute/cancel os_inv ** InsideCritical. No new state, ownership transfer, or synthesized local cell is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_06__unlock_context/proof_reuse.md`.

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
      "KMutexDelete-20261103170333",
      "--round",
      "KMutexDelete-vc-proving-r1",
      "--group",
      "unlock_context"
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
      "KMutexDelete-20261103170333",
      "--round",
      "KMutexDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "unlock_context"
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
      "KMutexDelete-20261103170333",
      "--round",
      "KMutexDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "unlock_context"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/_coq_builds/KMutexDelete-vc-proving-r1/group_06/src/.coq_debug/group_06_unlock_context.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_06__unlock_context/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_06__unlock_context/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
