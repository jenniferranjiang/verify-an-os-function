# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `safety_3`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r1/groups/group_07__safety_3/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_safety_wit_13`, `proof_of_InitDataqueue_safety_wit_14`, `proof_of_InitDataqueue_safety_wit_15`, `proof_of_InitDataqueue_safety_wit_16`, `proof_of_InitDataqueue_safety_wit_17`, `proof_of_InitDataqueue_safety_wit_18`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_safety_wit_13` — `LLM_pre_process`

The target is only constant 0/1 INT bounds or 1<>INT_MIN. Unfold machine limits, introduce pure context, prove arithmetic while retaining the spatial context.
### `proof_of_InitDataqueue_safety_wit_14` — `LLM_pre_process`

The target is only constant 0/1 INT bounds or 1<>INT_MIN. Unfold machine limits, introduce pure context, prove arithmetic while retaining the spatial context.
### `proof_of_InitDataqueue_safety_wit_15` — `LLM_pre_process`

The target is only constant 0/1 INT bounds or 1<>INT_MIN. Unfold machine limits, introduce pure context, prove arithmetic while retaining the spatial context.
### `proof_of_InitDataqueue_safety_wit_16` — `LLM_pre_process`

Pure contradiction from explicit malloc or Create branch hypotheses: zero versus nonzero/positive pointer, or negative versus nonnegative ID. Introduce context and derive False; all spatial resources are irrelevant.
### `proof_of_InitDataqueue_safety_wit_17` — `LLM_pre_process`

Pure contradiction from explicit malloc or Create branch hypotheses: zero versus nonzero/positive pointer, or negative versus nonnegative ID. Introduce context and derive False; all spatial resources are irrelevant.
### `proof_of_InitDataqueue_safety_wit_18` — `LLM_pre_process`

The target is only constant 0/1 INT bounds or 1<>INT_MIN. Unfold machine limits, introduce pure context, prove arithmetic while retaining the spatial context.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r1/groups/group_07__safety_3/proof_reuse.md`.

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
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-vc-proving-r1",
      "--group",
      "safety_3"
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
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "safety_3"
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
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "safety_3"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/_coq_builds/InitDataqueue-vc-proving-r1/group_07/src/.coq_debug/group_07_safety_3.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r1/groups/group_07__safety_3/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r1/groups/group_07__safety_3/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
