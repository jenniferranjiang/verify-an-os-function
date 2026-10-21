# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `outer_literals`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r2/groups/group_06__outer_literals/AllocId_proof_manual.v`.
- Editable proof spans: `proof_of_AllocId_safety_wit_7`, `proof_of_AllocId_safety_wit_8`, `proof_of_AllocId_safety_wit_10`, `proof_of_AllocId_safety_wit_11`, `proof_of_AllocId_safety_wit_12`, `proof_of_AllocId_safety_wit_13`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_AllocId_safety_wit_7` — `LLM_pre_process`

Introduce the generated parameters and premises; the antecedent heap is only context. Introduce the pure consequent and discharge its literal integer bounds by unfolding INT_MIN/INT_MAX and arithmetic. No resource transfer, existential or abstract-state transition is required.
### `proof_of_AllocId_safety_wit_8` — `LLM_pre_process`

The denominator is the literal 8. Choose the right branch 8<>-1 in the overflow disjunction and prove 8<>0 by arithmetic. Antecedent heap is context; no state or witness changes.
### `proof_of_AllocId_safety_wit_10` — `LLM_pre_process`

Introduce the generated parameters and premises; the antecedent heap is only context. Introduce the pure consequent and discharge its literal integer bounds by unfolding INT_MIN/INT_MAX and arithmetic. No resource transfer, existential or abstract-state transition is required.
### `proof_of_AllocId_safety_wit_11` — `LLM_pre_process`

Introduce the generated parameters and premises; the antecedent heap is only context. Introduce the pure consequent and discharge its literal integer bounds by unfolding INT_MIN/INT_MAX and arithmetic. No resource transfer, existential or abstract-state transition is required.
### `proof_of_AllocId_safety_wit_12` — `LLM_pre_process`

Introduce the generated parameters and premises; the antecedent heap is only context. Introduce the pure consequent and discharge its literal integer bounds by unfolding INT_MIN/INT_MAX and arithmetic. No resource transfer, existential or abstract-state transition is required.
### `proof_of_AllocId_safety_wit_13` — `LLM_pre_process`

Introduce the generated parameters and premises; the antecedent heap is only context. Introduce the pure consequent and discharge its literal integer bounds by unfolding INT_MIN/INT_MAX and arithmetic. No resource transfer, existential or abstract-state transition is required.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_06__outer_literals/proof_reuse.md`.

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
      "outer_literals"
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
      "outer_literals"
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
      "outer_literals"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/_coq_builds/AllocId-vc-proving-r2/group_06/src/.coq_debug/group_06_outer_literals.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_06__outer_literals/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_06__outer_literals/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
