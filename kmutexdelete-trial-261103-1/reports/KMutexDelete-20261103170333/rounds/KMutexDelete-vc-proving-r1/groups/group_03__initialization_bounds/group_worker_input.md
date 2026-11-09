# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `initialization_bounds`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/KMutexDelete-vc-proving-r1/groups/group_03__initialization_bounds/KMutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of_KMutexDelete_safety_wit_1`, `proof_of_KMutexDelete_safety_wit_2`, `proof_of_KMutexDelete_safety_wit_3`, `proof_of_KMutexDelete_safety_wit_4`, `proof_of_KMutexDelete_partial_solve_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/KMutexDelete-vc-proving-r1/groups/group_03__initialization_bounds/KMutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/KMutexDelete_lib.v`
- Every new/adapted helper uses suffix `__initialization_bounds`. Preserve the seed.

### `proof_of_KMutexDelete_safety_wit_1` — `LLM_pre_process`

The goal only states INT_MIN<=0 and 0<=INT_MAX. Introduce logical parameters and facts, derive the numerical Arch32 constant bounds; spatial locals and OutsideCritical are irrelevant to this pure consequence and are not consumed in a later C step.
### `proof_of_KMutexDelete_safety_wit_2` — `LLM_pre_process`

The goal only states INT_MIN<=0 and 0<=INT_MAX. Introduce logical parameters and facts, derive the numerical Arch32 constant bounds; spatial locals and OutsideCritical are irrelevant to this pure consequence and are not consumed in a later C step.
### `proof_of_KMutexDelete_safety_wit_3` — `LLM_pre_process`

The goal only states INT_MIN<=0 and 0<=INT_MAX. Introduce logical parameters and facts, derive the numerical Arch32 constant bounds; spatial locals and OutsideCritical are irrelevant to this pure consequence and are not consumed in a later C step.
### `proof_of_KMutexDelete_safety_wit_4` — `LLM_pre_process`

The goal only states INT_MIN<=0 and 0<=INT_MAX. Introduce logical parameters and facts, derive the numerical Arch32 constant bounds; spatial locals and OutsideCritical are irrelevant to this pure consequence and are not consumed in a later C step.
### `proof_of_KMutexDelete_partial_solve_wit_1` — `LLM_pre_process`

All requested pure bounds/guard/safeExec already appear as premises; cancel the unchanged OutsideCritical resource. No existential or state change occurs.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_03__initialization_bounds/proof_reuse.md`.

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
      "initialization_bounds"
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
      "initialization_bounds"
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
      "initialization_bounds"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/_coq_builds/KMutexDelete-vc-proving-r1/group_03/src/.coq_debug/group_03_initialization_bounds.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_03__initialization_bounds/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_03__initialization_bounds/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
