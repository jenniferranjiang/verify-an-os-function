# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `safety_1_8`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/DeInitDataqueue-vc-proving-r1/groups/group_06__safety_1_8/DeInitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_DeInitDataqueue_safety_wit_1`, `proof_of_DeInitDataqueue_safety_wit_2`, `proof_of_DeInitDataqueue_safety_wit_3`, `proof_of_DeInitDataqueue_safety_wit_4`, `proof_of_DeInitDataqueue_safety_wit_5`, `proof_of_DeInitDataqueue_safety_wit_6`, `proof_of_DeInitDataqueue_safety_wit_7`, `proof_of_DeInitDataqueue_safety_wit_8`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_DeInitDataqueue_safety_wit_1` — `LLM_pre_process`

Discharge fixed ILP32 INT_MIN/INT_MAX bounds for literal 0 or 1 and safe negation of 1 using integer arithmetic; spatial resources are only frame. Do not assume dynamic object bounds.
### `proof_of_DeInitDataqueue_safety_wit_2` — `LLM_pre_process`

Use base=dq_base q and mutually inconsistent null/non-null guard facts to derive False, leaving arbitrary spatial frame.
### `proof_of_DeInitDataqueue_safety_wit_3` — `LLM_pre_process`

Use base=dq_base q and mutually inconsistent null/non-null guard facts to derive False, leaving arbitrary spatial frame.
### `proof_of_DeInitDataqueue_safety_wit_4` — `LLM_pre_process`

Discharge fixed ILP32 INT_MIN/INT_MAX bounds for literal 0 or 1 and safe negation of 1 using integer arithmetic; spatial resources are only frame. Do not assume dynamic object bounds.
### `proof_of_DeInitDataqueue_safety_wit_5` — `LLM_pre_process`

Discharge fixed ILP32 INT_MIN/INT_MAX bounds for literal 0 or 1 and safe negation of 1 using integer arithmetic; spatial resources are only frame. Do not assume dynamic object bounds.
### `proof_of_DeInitDataqueue_safety_wit_6` — `LLM_pre_process`

Discharge fixed ILP32 INT_MIN/INT_MAX bounds for literal 0 or 1 and safe negation of 1 using integer arithmetic; spatial resources are only frame. Do not assume dynamic object bounds.
### `proof_of_DeInitDataqueue_safety_wit_7` — `LLM_pre_process`

Discharge fixed ILP32 INT_MIN/INT_MAX bounds for literal 0 or 1 and safe negation of 1 using integer arithmetic; spatial resources are only frame. Do not assume dynamic object bounds.
### `proof_of_DeInitDataqueue_safety_wit_8` — `LLM_pre_process`

Discharge fixed ILP32 INT_MIN/INT_MAX bounds for literal 0 or 1 and safe negation of 1 using integer arithmetic; spatial resources are only frame. Do not assume dynamic object bounds.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_06__safety_1_8/proof_reuse.md`.

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
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--group",
      "safety_1_8"
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
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "safety_1_8"
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
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "safety_1_8"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/_coq_builds/DeInitDataqueue-vc-proving-r1/group_06/src/.coq_debug/group_06_safety_1_8.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_06__safety_1_8/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_06__safety_1_8/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
