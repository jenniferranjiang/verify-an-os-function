# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `constant_safety_b`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_09__constant_safety_b/SemaphoreDelete_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_safety_wit_5`, `proof_of__SemaphoreDelete_safety_wit_6`, `proof_of__SemaphoreDelete_safety_wit_7`, `proof_of__SemaphoreDelete_safety_wit_8`, `proof_of__SemaphoreDelete_safety_wit_14`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_09__constant_safety_b/SemaphoreDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/SemaphoreDelete_lib.v`
- Every new/adapted helper uses suffix `__constant_safety_b`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreDelete_safety_wit_5` — `LLM_pre_process`

Use LLM_pre_process; both goals are the constant 0 within signed Int bounds. Unfold INT_MIN/INT_MAX if needed and solve arithmetic; all spatial resources are irrelevant frames and need no unfolding.
### `proof_of__SemaphoreDelete_safety_wit_6` — `LLM_pre_process`

Use LLM_pre_process; both goals are the constant 0 within signed Int bounds. Unfold INT_MIN/INT_MAX if needed and solve arithmetic; all spatial resources are irrelevant frames and need no unfolding.
### `proof_of__SemaphoreDelete_safety_wit_7` — `LLM_pre_process`

Use LLM_pre_process; both goals are the constant 0 within signed Int bounds. Unfold INT_MIN/INT_MAX if needed and solve arithmetic; all spatial resources are irrelevant frames and need no unfolding.
### `proof_of__SemaphoreDelete_safety_wit_8` — `LLM_pre_process`

Use LLM_pre_process; both goals are the constant 0 within signed Int bounds. Unfold INT_MIN/INT_MAX if needed and solve arithmetic; all spatial resources are irrelevant frames and need no unfolding.
### `proof_of__SemaphoreDelete_safety_wit_14` — `LLM_pre_process`

Use LLM_pre_process; both goals are the constant 1 within signed Int bounds. Unfold INT_MIN/INT_MAX if needed and solve arithmetic; all spatial resources are irrelevant frames and need no unfolding.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_09__constant_safety_b/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-debug",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-proving-r1",
      "--group",
      "constant_safety_b"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "constant_safety_b"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "constant_safety_b"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r1/group_09/src/.coq_debug/group_09_constant_safety_b.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_09__constant_safety_b/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_09__constant_safety_b/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
