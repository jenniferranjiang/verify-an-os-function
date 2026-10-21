# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `inner_constants`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r1/groups/group_10__inner_constants/AllocId_proof_manual.v`.
- Editable proof spans: `proof_of_AllocId_safety_wit_20`, `proof_of_AllocId_safety_wit_21`, `proof_of_AllocId_safety_wit_24`, `proof_of_AllocId_safety_wit_29`, `proof_of_AllocId_safety_wit_30`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_AllocId_safety_wit_20` — `LLM_pre_process`

Pattern CONST: introduce quantified values and pure hypotheses, use LLM_pre_process to expose the pure target; the local cells, manager fields, bitmap and bucket heap are irrelevant to the closed integer fact. Normalize INT_MIN/INT_MAX and discharge the displayed constants with lia; no existential or state transition.
### `proof_of_AllocId_safety_wit_21` — `LLM_pre_process`

Pattern CONST: introduce quantified values and pure hypotheses, use LLM_pre_process to expose the pure target; the local cells, manager fields, bitmap and bucket heap are irrelevant to the closed integer fact. Normalize INT_MIN/INT_MAX and discharge the displayed constants with lia; no existential or state transition.
### `proof_of_AllocId_safety_wit_24` — `LLM_pre_process`

Pattern CONST: introduce quantified values and pure hypotheses, use LLM_pre_process to expose the pure target; the local cells, manager fields, bitmap and bucket heap are irrelevant to the closed integer fact. Normalize INT_MIN/INT_MAX and discharge the displayed constants with lia; no existential or state transition.
### `proof_of_AllocId_safety_wit_29` — `LLM_pre_process`

Pattern CONST: introduce quantified values and pure hypotheses, use LLM_pre_process to expose the pure target; the local cells, manager fields, bitmap and bucket heap are irrelevant to the closed integer fact. Normalize INT_MIN/INT_MAX and discharge the displayed constants with lia; no existential or state transition.
### `proof_of_AllocId_safety_wit_30` — `LLM_pre_process`

Pattern CONST: introduce quantified values and pure hypotheses, use LLM_pre_process to expose the pure target; the local cells, manager fields, bitmap and bucket heap are irrelevant to the closed integer fact. Normalize INT_MIN/INT_MAX and discharge the displayed constants with lia; no existential or state transition.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r1/groups/group_10__inner_constants/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-debug",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-proving-r1",
      "--group",
      "inner_constants"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-check",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "inner_constants"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-check",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "inner_constants"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/_coq_builds/AllocId-vc-proving-r1/group_10/src/.coq_debug/group_10_inner_constants.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r1/groups/group_10__inner_constants/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r1/groups/group_10__inner_constants/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
