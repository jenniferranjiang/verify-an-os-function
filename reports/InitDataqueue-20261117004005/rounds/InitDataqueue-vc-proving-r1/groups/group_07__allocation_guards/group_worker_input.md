# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `allocation_guards`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/InitDataqueue-vc-proving-r1/groups/group_07__allocation_guards/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_safety_wit_9`, `proof_of_InitDataqueue_safety_wit_10`, `proof_of_InitDataqueue_safety_wit_11`, `proof_of_InitDataqueue_safety_wit_12`, `proof_of_InitDataqueue_safety_wit_12_split_goal_1`, `proof_of_InitDataqueue_safety_wit_12_split_goal_2`, `proof_of_InitDataqueue_safety_wit_13`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_safety_wit_9` — `LLM_pre_process`

Pattern S: extract pure branch premises; malloc zero/nonzero or negative/nonnegative create return premises directly contradict, hence ex falso for the pure False target. No existential or resource transformation; frame all stores and os_inv.
### `proof_of_InitDataqueue_safety_wit_10` — `LLM_pre_process`

Pattern S: extract pure branch premises; malloc zero/nonzero or negative/nonnegative create return premises directly contradict, hence ex falso for the pure False target. No existential or resource transformation; frame all stores and os_inv.
### `proof_of_InitDataqueue_safety_wit_11` — `LLM_pre_process`

Pattern S: extract pure branch premises; malloc zero/nonzero or negative/nonnegative create return premises directly contradict, hence ex falso for the pure False target. No existential or resource transformation; frame all stores and os_inv.
### `proof_of_InitDataqueue_safety_wit_12` — `aggressive_pre_process`

- Split `proof_of_InitDataqueue_safety_wit_12_split_goal_1`: Extract 0<=NodeNumber_pre<=65535 from max_len UShort store (frame all other resources); compute INT_MIN/INT_MAX and use lia on NodeNumber_pre-1. No state/existential changes.

- Split `proof_of_InitDataqueue_safety_wit_12_split_goal_2`: Extract 0<=NodeNumber_pre<=65535 from max_len UShort store (frame all other resources); compute INT_MIN/INT_MAX and use lia on NodeNumber_pre-1. No state/existential changes.
### `proof_of_InitDataqueue_safety_wit_13` — `LLM_pre_process`

Pattern S: introduce all parameters and pure hypotheses; preserve/frame all spatial resources and prove constant signed-int bounds by computation/lia. This witness only constrains literals 0 or 1, never changes state or ownership.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_07__allocation_guards/proof_reuse.md`.

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
      "/home/xinra/crtos-verify",
      "coq-debug",
      "--run",
      "InitDataqueue-20261117004005",
      "--round",
      "InitDataqueue-vc-proving-r1",
      "--group",
      "allocation_guards"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "InitDataqueue-20261117004005",
      "--round",
      "InitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "allocation_guards"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "InitDataqueue-20261117004005",
      "--round",
      "InitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "allocation_guards"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/_coq_builds/InitDataqueue-vc-proving-r1/group_07/src/.coq_debug/group_07_allocation_guards.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_07__allocation_guards/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_07__allocation_guards/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
