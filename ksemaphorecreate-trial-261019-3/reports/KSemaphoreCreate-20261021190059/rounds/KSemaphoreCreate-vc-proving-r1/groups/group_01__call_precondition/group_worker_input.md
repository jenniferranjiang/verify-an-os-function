# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `call_precondition`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/KSemaphoreCreate-20261021190059/KSemaphoreCreate-vc-proving-r1/groups/group_01__call_precondition/KSemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of_KSemaphoreCreate_partial_solve_wit_1_pure`, `proof_of_KSemaphoreCreate_partial_solve_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/KSemaphoreCreate-20261021190059/KSemaphoreCreate-vc-proving-r1/groups/group_01__call_precondition/KSemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC/KSemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__call_precondition`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of_KSemaphoreCreate_partial_solve_wit_1_pure` — `LLM_pre_process`

Unfold KSemaphoreCreate_partial_solve_wit_1_pure and introduce all parameters and PreH1. The antecedent contains val's UShort points-to cell framed with OutsideCritical sg before. The consequent is the pure proposition safeExec (LastSeen before) (abs_semaphore_create sg val_pre) X, literally supplied by PreH1. Apply pure-right entailment (entailer!/standard pure introduction) and exact PreH1; there are no existential witnesses or target spatial resources and no heap mutation, bounds argument, or abstract transition. No helper is needed.
### `proof_of_KSemaphoreCreate_partial_solve_wit_1` — `LLM_pre_process`

Unfold KSemaphoreCreate_partial_solve_wit_1, introduce its pure-VC implication argument, then unfold KSemaphoreCreate_partial_solve_wit_1_aux and introduce parameters and PreH1. Establish both pure conjuncts with the same PreH1, which is safeExec (LastSeen before) (abs_semaphore_create sg val_pre) X. Preserve and cancel the identical OutsideCritical sg before resource. The implication argument need not be applied because the aux obligation already quantifies PreH1. There are no existential witnesses, resource conversions, or new transitions and no helper is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/KSemaphoreCreate-20261021190059/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/KSemaphoreCreate-20261021190059/rounds/KSemaphoreCreate-vc-proving-r1/groups/group_01__call_precondition/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-debug",
      "--run",
      "KSemaphoreCreate-20261021190059",
      "--round",
      "KSemaphoreCreate-vc-proving-r1",
      "--group",
      "call_precondition"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-check",
      "--run",
      "KSemaphoreCreate-20261021190059",
      "--round",
      "KSemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "call_precondition"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-check",
      "--run",
      "KSemaphoreCreate-20261021190059",
      "--round",
      "KSemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "call_precondition"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/KSemaphoreCreate-20261021190059/_coq_builds/KSemaphoreCreate-vc-proving-r1/group_01/src/.coq_debug/group_01_call_precondition.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/KSemaphoreCreate-20261021190059/rounds/KSemaphoreCreate-vc-proving-r1/groups/group_01__call_precondition/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/KSemaphoreCreate-20261021190059/rounds/KSemaphoreCreate-vc-proving-r1/groups/group_01__call_precondition/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
