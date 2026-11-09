# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `branch_safety`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/KEventDelete-vc-proving-r1/groups/group_03__branch_safety/KEventDelete_proof_manual.v`.
- Editable proof spans: `proof_of_KEventDelete_safety_wit_1`, `proof_of_KEventDelete_safety_wit_2`, `proof_of_KEventDelete_safety_wit_3`, `proof_of_KEventDelete_safety_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/KEventDelete-vc-proving-r1/groups/group_03__branch_safety/KEventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/KEventDelete_lib.v`
- Every new/adapted helper uses suffix `__branch_safety`. Preserve the seed.

### `proof_of_KEventDelete_safety_wit_1` — `LLM_pre_process`

Introduce premises, reduce the fixed INT_MIN/INT_MAX bounds, and establish that literal zero lies in signed-int range by arithmetic. Antecedent carries OutsideCritical and event/id locals; target has only the two constant pure inequalities. No existential, heap transformation, or semantic transition.
### `proof_of_KEventDelete_safety_wit_2` — `LLM_pre_process`

Same literal-zero range pattern as safety_wit_1. The extra nonnull and event-delete guard premises are unused; the target contains only 0 <= INT_MAX and INT_MIN <= 0, discharged by the fixed integer-bound definitions.
### `proof_of_KEventDelete_safety_wit_3` — `LLM_pre_process`

PreH1 retval <> 0 and PreH2 retval = 0 contradict. Eliminate this contradiction to establish the pure False entailment regardless of OutsideCritical/event/id resources; no witness or state change.
### `proof_of_KEventDelete_safety_wit_4` — `LLM_pre_process`

PreH1 retval = 0 contradicts PreH2 retval <> 0. Eliminate the contradiction to prove the pure False entailment. The guard and safeExec facts do not require unfolding.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-proving-r1/groups/group_03__branch_safety/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "KEventDelete-20261103211513",
      "--round",
      "KEventDelete-vc-proving-r1",
      "--group",
      "branch_safety"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "KEventDelete-20261103211513",
      "--round",
      "KEventDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "branch_safety"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "KEventDelete-20261103211513",
      "--round",
      "KEventDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "branch_safety"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/_coq_builds/KEventDelete-vc-proving-r1/group_03/src/.coq_debug/group_03_branch_safety.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-proving-r1/groups/group_03__branch_safety/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-proving-r1/groups/group_03__branch_safety/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
