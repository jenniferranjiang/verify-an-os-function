# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `call_frames_2`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r2/groups/group_08__call_frames_2/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_partial_solve_wit_10_pure`, `proof_of_InitDataqueue_partial_solve_wit_10`, `proof_of_InitDataqueue_partial_solve_wit_11_pure`, `proof_of_InitDataqueue_partial_solve_wit_11`, `proof_of_InitDataqueue_partial_solve_wit_12_pure`, `proof_of_InitDataqueue_partial_solve_wit_12`, `proof_of_InitDataqueue_partial_solve_wit_13_pure`, `proof_of_InitDataqueue_partial_solve_wit_13`, `proof_of_InitDataqueue_partial_solve_wit_14_pure`, `proof_of_InitDataqueue_partial_solve_wit_14`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_partial_solve_wit_10_pure` — `LLM_pre_process`

Preserve every spatial cell at the same address (reorder/cancel only). Required pure facts are already named premises; for implication-shaped partial_solve, introduce the pure premise then unfold auxiliary target. No abstract-state transition is invented. Retain lock/current parameter and caller resources exactly. Pure projection or direct resource permutation.
### `proof_of_InitDataqueue_partial_solve_wit_10` — `LLM_pre_process`

Preserve every spatial cell at the same address (reorder/cancel only). Required pure facts are already named premises; for implication-shaped partial_solve, introduce the pure premise then unfold auxiliary target. No abstract-state transition is invented. Retain lock/current parameter and caller resources exactly. Auxiliary implication: introduce antecedent and unfold auxiliary definition.
### `proof_of_InitDataqueue_partial_solve_wit_11_pure` — `LLM_pre_process`

Preserve every spatial cell at the same address (reorder/cancel only). Required pure facts are already named premises; for implication-shaped partial_solve, introduce the pure premise then unfold auxiliary target. No abstract-state transition is invented. Retain lock/current parameter and caller resources exactly. Pure projection or direct resource permutation.
### `proof_of_InitDataqueue_partial_solve_wit_11` — `LLM_pre_process`

Preserve every spatial cell at the same address (reorder/cancel only). Required pure facts are already named premises; for implication-shaped partial_solve, introduce the pure premise then unfold auxiliary target. No abstract-state transition is invented. Retain lock/current parameter and caller resources exactly. Auxiliary implication: introduce antecedent and unfold auxiliary definition.
### `proof_of_InitDataqueue_partial_solve_wit_12_pure` — `LLM_pre_process`

Preserve every spatial cell at the same address (reorder/cancel only). Required pure facts are already named premises; for implication-shaped partial_solve, introduce the pure premise then unfold auxiliary target. No abstract-state transition is invented. Retain lock/current parameter and caller resources exactly. Pure projection or direct resource permutation.
### `proof_of_InitDataqueue_partial_solve_wit_12` — `LLM_pre_process`

Preserve every spatial cell at the same address (reorder/cancel only). Required pure facts are already named premises; for implication-shaped partial_solve, introduce the pure premise then unfold auxiliary target. No abstract-state transition is invented. Retain lock/current parameter and caller resources exactly. Auxiliary implication: introduce antecedent and unfold auxiliary definition.
### `proof_of_InitDataqueue_partial_solve_wit_13_pure` — `LLM_pre_process`

Preserve every spatial cell at the same address (reorder/cancel only). Required pure facts are already named premises; for implication-shaped partial_solve, introduce the pure premise then unfold auxiliary target. No abstract-state transition is invented. Retain lock/current parameter and caller resources exactly. Pure projection or direct resource permutation.
### `proof_of_InitDataqueue_partial_solve_wit_13` — `LLM_pre_process`

Preserve every spatial cell at the same address (reorder/cancel only). Required pure facts are already named premises; for implication-shaped partial_solve, introduce the pure premise then unfold auxiliary target. No abstract-state transition is invented. Retain lock/current parameter and caller resources exactly. Auxiliary implication: introduce antecedent and unfold auxiliary definition.
### `proof_of_InitDataqueue_partial_solve_wit_14_pure` — `LLM_pre_process`

Preserve every spatial cell at the same address (reorder/cancel only). Required pure facts are already named premises; for implication-shaped partial_solve, introduce the pure premise then unfold auxiliary target. No abstract-state transition is invented. Retain lock/current parameter and caller resources exactly. Pure projection or direct resource permutation.
### `proof_of_InitDataqueue_partial_solve_wit_14` — `LLM_pre_process`

Preserve every spatial cell at the same address (reorder/cancel only). Required pure facts are already named premises; for implication-shaped partial_solve, introduce the pure premise then unfold auxiliary target. No abstract-state transition is invented. Retain lock/current parameter and caller resources exactly. Auxiliary implication: introduce antecedent and unfold auxiliary definition.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_08__call_frames_2/proof_reuse.md`.

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
      "InitDataqueue-vc-proving-r2",
      "--group",
      "call_frames_2"
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
      "InitDataqueue-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "call_frames_2"
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
      "InitDataqueue-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "call_frames_2"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/_coq_builds/InitDataqueue-vc-proving-r2/group_08/src/.coq_debug/group_08_call_frames_2.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_08__call_frames_2/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_08__call_frames_2/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
