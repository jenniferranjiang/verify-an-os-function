# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `safety_entry`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_07__safety_entry/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_safety_wit_1`, `proof_of__SemaphoreCreate_safety_wit_2`, `proof_of__SemaphoreCreate_safety_wit_3`, `proof_of__SemaphoreCreate_safety_wit_4`, `proof_of__SemaphoreCreate_safety_wit_5`, `proof_of__SemaphoreCreate_safety_wit_6`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_07__safety_entry/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__safety_entry`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_safety_wit_1` — `LLM_pre_process`

Normalize INT_MIN/INT_MAX and prove signed bounds for literal zero. Introduce the branch premises; all local, allocated-byte or OS resources are merely an antecedent frame.
### `proof_of__SemaphoreCreate_safety_wit_2` — `LLM_pre_process`

Normalize INT_MIN/INT_MAX and prove signed bounds for literal zero. Introduce the branch premises; all local, allocated-byte or OS resources are merely an antecedent frame.
### `proof_of__SemaphoreCreate_safety_wit_3` — `LLM_pre_process`

Normalize INT_MIN/INT_MAX and prove signed bounds for literal zero. Introduce the branch premises; all local, allocated-byte or OS resources are merely an antecedent frame.
### `proof_of__SemaphoreCreate_safety_wit_4` — `LLM_pre_process`

Normalize INT_MIN/INT_MAX and prove signed bounds for literal 32. No sizeof or ABI fact is needed because the generated statement contains the numeric constant.
### `proof_of__SemaphoreCreate_safety_wit_5` — `LLM_pre_process`

Normalize INT_MIN/INT_MAX and prove signed bounds for literal zero. Introduce the branch premises; all local, allocated-byte or OS resources are merely an antecedent frame.
### `proof_of__SemaphoreCreate_safety_wit_6` — `LLM_pre_process`

Normalize INT_MIN/INT_MAX and prove signed bounds for literal zero. Introduce the branch premises; all local, allocated-byte or OS resources are merely an antecedent frame.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_07__safety_entry/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-debug",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--group",
      "safety_entry"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "safety_entry"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "safety_entry"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/_coq_builds/SemaphoreCreate-vc-proving-r1/group_07/src/.coq_debug/group_07_safety_entry.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_07__safety_entry/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_07__safety_entry/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
