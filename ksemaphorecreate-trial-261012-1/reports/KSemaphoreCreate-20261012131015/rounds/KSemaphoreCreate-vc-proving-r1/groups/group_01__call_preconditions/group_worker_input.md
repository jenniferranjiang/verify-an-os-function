# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `call_preconditions`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/KSemaphoreCreate-20261012131015/KSemaphoreCreate-vc-proving-r1/groups/group_01__call_preconditions/KSemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of_KSemaphoreCreate_partial_solve_wit_1_pure`, `proof_of_KSemaphoreCreate_partial_solve_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_KSemaphoreCreate_partial_solve_wit_1_pure` — `LLM_pre_process`

Unfold KSemaphoreCreate_partial_solve_wit_1_pure and introduce binders. P is the val UShort cell separated from SemaphoreOutsideCritical sg hs before. Q is only the pure entry bound scheduler_lock_nest (os_scheduler before) < 65535, exactly PreH1. Introduce the pure assertion using PreH1 (entailer! or the pure assertion right rule), which is valid for any heap. No existential or pointer observation is required, and no spatial resource must be unfolded or transformed.
### `proof_of_KSemaphoreCreate_partial_solve_wit_1` — `LLM_pre_process`

Unfold KSemaphoreCreate_partial_solve_wit_1; introduce the pure-VC implication premise locally, then unfold KSemaphoreCreate_partial_solve_wit_1_aux and introduce before, hs, sg and PreH1. P is SemaphoreOutsideCritical sg hs before; Q conjoins two copies of the same entry nest bound with that identical resource. Introduce both pure conjuncts using PreH1 and close the resource entailment by reflexivity/cancellation (entailer!). The implication premise need not be used; do not import the other group or rely on any sibling proof. No transition, existential, resource splitting or helper is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/KSemaphoreCreate-20261012131015/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/KSemaphoreCreate-20261012131015/rounds/KSemaphoreCreate-vc-proving-r1/groups/group_01__call_preconditions/proof_reuse.md`.

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
      "KSemaphoreCreate-20261012131015",
      "--round",
      "KSemaphoreCreate-vc-proving-r1",
      "--group",
      "call_preconditions"
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
      "KSemaphoreCreate-20261012131015",
      "--round",
      "KSemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "call_preconditions"
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
      "KSemaphoreCreate-20261012131015",
      "--round",
      "KSemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "call_preconditions"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/KSemaphoreCreate-20261012131015/_coq_builds/KSemaphoreCreate-vc-proving-r1/group_01/src/.coq_debug/group_01_call_preconditions.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/KSemaphoreCreate-20261012131015/rounds/KSemaphoreCreate-vc-proving-r1/groups/group_01__call_preconditions/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/KSemaphoreCreate-20261012131015/rounds/KSemaphoreCreate-vc-proving-r1/groups/group_01__call_preconditions/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
