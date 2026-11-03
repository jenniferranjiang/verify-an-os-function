# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `callee_precondition`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/KEventCreate-20261101232854/KEventCreate-vc-proving-r1/groups/group_01__callee_precondition/KEventCreate_proof_manual.v`.
- Editable proof spans: `proof_of_KEventCreate_partial_solve_wit_1_pure`, `proof_of_KEventCreate_partial_solve_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/KEventCreate-20261101232854/KEventCreate-vc-proving-r1/groups/group_01__callee_precondition/KEventCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventcreate-trial-261101-1/VC/KEventCreate_lib.v`
- Every new/adapted helper uses suffix `__callee_precondition`. Preserve the seed.

### `proof_of_KEventCreate_partial_solve_wit_1_pure` — `LLM_pre_process`

Unfold KEventCreate_partial_solve_wit_1_pure and introduce quantified values plus PreH1. The consequent is a pure assertion of exactly PreH1: safeExec (LastSeen before) (abs_event_create sg options_pre) X. Establish it by pure-assertion introduction/entailer from PreH1. The local UInt options cell and OutsideCritical resource do not need to be unfolded, transformed or used to derive new facts.
### `proof_of_KEventCreate_partial_solve_wit_1` — `LLM_pre_process`

Unfold KEventCreate_partial_solve_wit_1, introduce its premise, then unfold KEventCreate_partial_solve_wit_1_aux and introduce all quantified values and PreH1. Both pure conjuncts are the same given safeExec fact PreH1; establish each by pure introduction and cancel the unchanged OutsideCritical sg before resource. The pure-witness premise need not be invoked because PreH1 is already available in the auxiliary goal. There is no dependency on a sibling proof or helper.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/KEventCreate-20261101232854/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/KEventCreate-20261101232854/rounds/KEventCreate-vc-proving-r1/groups/group_01__callee_precondition/proof_reuse.md`.

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
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-debug",
      "--run",
      "KEventCreate-20261101232854",
      "--round",
      "KEventCreate-vc-proving-r1",
      "--group",
      "callee_precondition"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-check",
      "--run",
      "KEventCreate-20261101232854",
      "--round",
      "KEventCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "callee_precondition"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-check",
      "--run",
      "KEventCreate-20261101232854",
      "--round",
      "KEventCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "callee_precondition"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/KEventCreate-20261101232854/_coq_builds/KEventCreate-vc-proving-r1/group_01/src/.coq_debug/group_01_callee_precondition.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/KEventCreate-20261101232854/rounds/KEventCreate-vc-proving-r1/groups/group_01__callee_precondition/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/KEventCreate-20261101232854/rounds/KEventCreate-vc-proving-r1/groups/group_01__callee_precondition/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
