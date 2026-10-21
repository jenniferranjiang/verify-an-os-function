# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `control_paths`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r2/groups/group_07__control_paths/AllocId_proof_manual.v`.
- Editable proof spans: `proof_of_AllocId_safety_wit_6`, `proof_of_AllocId_safety_wit_15`, `proof_of_AllocId_safety_wit_16`, `proof_of_AllocId_safety_wit_17`, `proof_of_AllocId_safety_wit_18`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_AllocId_safety_wit_6` — `LLM_pre_process`

Explicit premises manager_pre=0 and manager_pre<>0 contradict, so derive the requested pure False. Heap need not be unfolded.
### `proof_of_AllocId_safety_wit_15` — `LLM_pre_process`

Use index>=end and index<=end to infer equality, contradicting index<>end; derive pure False independently of heap.
### `proof_of_AllocId_safety_wit_16` — `LLM_pre_process`

The premises index=end and index<end contradict; derive pure False independently of heap.
### `proof_of_AllocId_safety_wit_17` — `LLM_pre_process`

Introduce the generated parameters and premises; the antecedent heap is only context. Introduce the pure consequent and discharge its literal integer bounds by unfolding INT_MIN/INT_MAX and arithmetic. No resource transfer, existential or abstract-state transition is required.
### `proof_of_AllocId_safety_wit_18` — `LLM_pre_process`

Introduce the generated parameters and premises; the antecedent heap is only context. Introduce the pure consequent and discharge its literal integer bounds by unfolding INT_MIN/INT_MAX and arithmetic. No resource transfer, existential or abstract-state transition is required.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_07__control_paths/proof_reuse.md`.

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
      "AllocId-vc-proving-r2",
      "--group",
      "control_paths"
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
      "AllocId-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "control_paths"
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
      "AllocId-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "control_paths"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/_coq_builds/AllocId-vc-proving-r2/group_07/src/.coq_debug/group_07_control_paths.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_07__control_paths/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_07__control_paths/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
