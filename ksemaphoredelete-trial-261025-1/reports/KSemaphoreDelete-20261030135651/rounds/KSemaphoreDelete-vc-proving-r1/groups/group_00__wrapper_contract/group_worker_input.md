# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `wrapper_contract`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/KSemaphoreDelete-20261030135651/KSemaphoreDelete-vc-proving-r1/groups/group_00__wrapper_contract/KSemaphoreDelete_proof_manual.v`.
- Editable proof spans: `proof_of_KSemaphoreDelete_return_wit_1`, `proof_of_KSemaphoreDelete_partial_solve_wit_1_pure`, `proof_of_KSemaphoreDelete_partial_solve_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/KSemaphoreDelete-20261030135651/KSemaphoreDelete-vc-proving-r1/groups/group_00__wrapper_contract/KSemaphoreDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/KSemaphoreDelete_lib.v`
- Every new/adapted helper uses suffix `__wrapper_contract`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of_KSemaphoreDelete_return_wit_1` — `LLM_pre_process`

Unfold KSemaphoreDelete_return_wit_1 and introduce the logical parameters and hypotheses. The antecedent owns OutsideCritical sg after_2; choose after := after_2 for the existential. The required safeExec(LastSeen after_2, ret tt, X) is exactly PreH1; introduce that pure conjunct and preserve/cancel the identical OutsideCritical resource. PreH2 is unused. No refinement or state transition lemma is required.
### `proof_of_KSemaphoreDelete_partial_solve_wit_1_pure` — `LLM_pre_process`

Unfold the pure witness and introduce its parameters. The consequent is the same safeExec proposition supplied as PreH1. Prove the pure assertion from that hypothesis independently of the antecedent heap, which contains the local id Int cell and OutsideCritical sg before. Do not unfold or weaken safeExec; no arithmetic, state equality or resource bridge is missing.
### `proof_of_KSemaphoreDelete_partial_solve_wit_1` — `LLM_pre_process`

Unfold KSemaphoreDelete_partial_solve_wit_1, introduce the pure-witness premise, then unfold KSemaphoreDelete_partial_solve_wit_1_aux and introduce its parameters and PreH1. Both pure safeExec conjuncts in the consequent are exactly PreH1. Introduce them and preserve the identical OutsideCritical sg before resource by reflexivity/cancellation. The supplied pure-witness premise may remain unused because the aux goal already quantifies PreH1. No case-lib helper is necessary.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/KSemaphoreDelete-20261030135651/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/KSemaphoreDelete-20261030135651/rounds/KSemaphoreDelete-vc-proving-r1/groups/group_00__wrapper_contract/proof_reuse.md`.

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
      "KSemaphoreDelete-20261030135651",
      "--round",
      "KSemaphoreDelete-vc-proving-r1",
      "--group",
      "wrapper_contract"
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
      "KSemaphoreDelete-20261030135651",
      "--round",
      "KSemaphoreDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "wrapper_contract"
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
      "KSemaphoreDelete-20261030135651",
      "--round",
      "KSemaphoreDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "wrapper_contract"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/KSemaphoreDelete-20261030135651/_coq_builds/KSemaphoreDelete-vc-proving-r1/group_00/src/.coq_debug/group_00_wrapper_contract.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/KSemaphoreDelete-20261030135651/rounds/KSemaphoreDelete-vc-proving-r1/groups/group_00__wrapper_contract/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/KSemaphoreDelete-20261030135651/rounds/KSemaphoreDelete-vc-proving-r1/groups/group_00__wrapper_contract/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
