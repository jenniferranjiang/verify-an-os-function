# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `wrapper_call_premises`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/KMutexCreate-20261101170140/KMutexCreate-vc-proving-r1/groups/group_01__wrapper_call_premises/KMutexCreate_proof_manual.v`.
- Editable proof spans: `proof_of_KMutexCreate_partial_solve_wit_1_pure`, `proof_of_KMutexCreate_partial_solve_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/KMutexCreate-20261101170140/KMutexCreate-vc-proving-r1/groups/group_01__wrapper_call_premises/KMutexCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/VC/KMutexCreate_lib.v`
- Every new/adapted helper uses suffix `__wrapper_call_premises`. Preserve the seed.

### `proof_of_KMutexCreate_partial_solve_wit_1_pure` — `LLM_pre_process`

Unfold KMutexCreate_partial_solve_wit_1_pure and introduce variables and PreH1. The RHS is the pure proposition safeExec(LastSeen before_outside_critical, abs_mutex_create sg_outside_critical, X_outside_critical), exactly PreH1. Introduce the pure assertion using that hypothesis (entailer/pure-right); the pure assertion places no extra spatial demand. No existential, state transition, or predicate unfolding is required.
### `proof_of_KMutexCreate_partial_solve_wit_1` — `LLM_pre_process`

Unfold KMutexCreate_partial_solve_wit_1; introduce its implication premise, then unfold KMutexCreate_partial_solve_wit_1_aux and introduce variables and PreH1. Its consequent has two copies of the same pure safeExec proposition together with OutsideCritical sg_outside_critical before_outside_critical. Use PreH1 for both pure conjuncts and entailment reflexivity for the unchanged spatial resource. The implication premise can remain unused; pure facts can be duplicated without duplicating spatial ownership. This establishes the helper-call precondition for exactly the input abstract state and continuation, without expanding abs_mutex_create or adding assumptions.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/KMutexCreate-20261101170140/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/KMutexCreate-20261101170140/rounds/KMutexCreate-vc-proving-r1/groups/group_01__wrapper_call_premises/proof_reuse.md`.

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
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-debug",
      "--run",
      "KMutexCreate-20261101170140",
      "--round",
      "KMutexCreate-vc-proving-r1",
      "--group",
      "wrapper_call_premises"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-check",
      "--run",
      "KMutexCreate-20261101170140",
      "--round",
      "KMutexCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "wrapper_call_premises"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-check",
      "--run",
      "KMutexCreate-20261101170140",
      "--round",
      "KMutexCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "wrapper_call_premises"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/KMutexCreate-20261101170140/_coq_builds/KMutexCreate-vc-proving-r1/group_01/src/.coq_debug/group_01_wrapper_call_premises.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/KMutexCreate-20261101170140/rounds/KMutexCreate-vc-proving-r1/groups/group_01__wrapper_call_premises/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/KMutexCreate-20261101170140/rounds/KMutexCreate-vc-proving-r1/groups/group_01__wrapper_call_premises/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
