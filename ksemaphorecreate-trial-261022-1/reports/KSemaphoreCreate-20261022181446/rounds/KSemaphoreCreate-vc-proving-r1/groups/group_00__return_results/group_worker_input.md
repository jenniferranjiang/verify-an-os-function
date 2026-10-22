# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `return_results`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/KSemaphoreCreate-20261022181446/KSemaphoreCreate-vc-proving-r1/groups/group_00__return_results/KSemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of_KSemaphoreCreate_return_wit_1`, `proof_of_KSemaphoreCreate_return_wit_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/KSemaphoreCreate-20261022181446/KSemaphoreCreate-vc-proving-r1/groups/group_00__return_results/KSemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/VC/KSemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__return_results`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of_KSemaphoreCreate_return_wit_1` — `LLM_pre_process`

Unfold the witness and introduce val_pre, X, before, sg, after_3, retval and the pure hypotheses. Instantiate the result state existential with after_3. The spatial resource OutsideCritical sg after_3 is identical on both sides and cancels. The result equality retval = -5 and safeExec for ret(-5) are exactly PreH1 and PreH2; introduce these pure conjunctions directly. The earlier abs_semaphore_create safeExec hypothesis is only a frame of logical context; no transition or invariant unfolding is necessary.
### `proof_of_KSemaphoreCreate_return_wit_2` — `LLM_pre_process`

Unfold and introduce all variables/hypotheses. Instantiate after_2 with after_3, retain OutsideCritical sg after_3 by reflexive entailment, and introduce the three consequent pure facts using PreH1 (nonnegative retval), PreH2 (retval < 128), and PreH3 (safeExec of ret retval). No new arithmetic, resource transformation, or refinement transition is required.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/KSemaphoreCreate-20261022181446/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/KSemaphoreCreate-20261022181446/rounds/KSemaphoreCreate-vc-proving-r1/groups/group_00__return_results/proof_reuse.md`.

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
      "KSemaphoreCreate-20261022181446",
      "--round",
      "KSemaphoreCreate-vc-proving-r1",
      "--group",
      "return_results"
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
      "KSemaphoreCreate-20261022181446",
      "--round",
      "KSemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "return_results"
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
      "KSemaphoreCreate-20261022181446",
      "--round",
      "KSemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "return_results"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/KSemaphoreCreate-20261022181446/_coq_builds/KSemaphoreCreate-vc-proving-r1/group_00/src/.coq_debug/group_00_return_results.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/KSemaphoreCreate-20261022181446/rounds/KSemaphoreCreate-vc-proving-r1/groups/group_00__return_results/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/KSemaphoreCreate-20261022181446/rounds/KSemaphoreCreate-vc-proving-r1/groups/group_00__return_results/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
