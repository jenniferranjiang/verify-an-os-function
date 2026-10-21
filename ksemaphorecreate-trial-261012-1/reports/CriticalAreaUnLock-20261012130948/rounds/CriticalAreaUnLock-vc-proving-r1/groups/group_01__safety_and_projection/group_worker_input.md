# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `safety_and_projection`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/CriticalAreaUnLock-20261012130948/CriticalAreaUnLock-vc-proving-r1/groups/group_01__safety_and_projection/CriticalAreaUnLock_proof_manual.v`.
- Editable proof spans: `proof_of_CriticalAreaUnLock_safety_wit_1`, `proof_of_CriticalAreaUnLock_return_wit_1`, `proof_of_CriticalAreaUnLock_partial_solve_wit_1_pure`, `proof_of_CriticalAreaUnLock_partial_solve_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_CriticalAreaUnLock_safety_wit_1` — `LLM_pre_process`

Introduce all parameters and pure hypotheses. The conclusion contains only 1 <= INT_MAX and INT_MIN <= 1 for Arch32 Int. Unfold the signed-int constants if required and discharge by arithmetic; the lock local cell, InsideCritical, nest UShort, and CriticalFrame are unchanged antecedent resources and no existential or protocol transition is needed.
### `proof_of_CriticalAreaUnLock_return_wit_1` — `LLM_pre_process`

Introduce all parameters and IRQ/guarantee assumptions. Both sides are exactly SemaphoreOutsideCritical sg hs (semaphore_nest_decrement after); close by derivable1 reflexivity. Do not unfold or alter the outside-critical protocol.
### `proof_of_CriticalAreaUnLock_partial_solve_wit_1_pure` — `LLM_pre_process`

Introduce the quantified values and the two explicit assumptions semaphore_irq_handler_ok lock_pre and SemaphoreGuarantee before (semaphore_nest_decrement after). Inject those same propositions into the pure conjunction conclusion. The local lock cell, InsideCritical, and decremented invariant remain antecedent resources; no additional premise or transition is needed.
### `proof_of_CriticalAreaUnLock_partial_solve_wit_1` — `LLM_pre_process`

Unfold the implication wrapper and introduce its pure-witness premise, then unfold the auxiliary goal. Introduce quantified parameters and the explicit IRQ/guarantee assumptions. Establish the four pure conjuncts by repeating the two assumptions; cancel the identical InsideCritical and decremented SemaphoreOSInvariant resources. The pure-witness premise need not provide any extra fact, and the proof must not depend on an admitted auto witness.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/CriticalAreaUnLock-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaUnLock-20261012130948/rounds/CriticalAreaUnLock-vc-proving-r1/groups/group_01__safety_and_projection/proof_reuse.md`.

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
      "CriticalAreaUnLock-20261012130948",
      "--round",
      "CriticalAreaUnLock-vc-proving-r1",
      "--group",
      "safety_and_projection"
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
      "CriticalAreaUnLock-20261012130948",
      "--round",
      "CriticalAreaUnLock-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "safety_and_projection"
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
      "CriticalAreaUnLock-20261012130948",
      "--round",
      "CriticalAreaUnLock-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "safety_and_projection"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/CriticalAreaUnLock-20261012130948/_coq_builds/CriticalAreaUnLock-vc-proving-r1/group_01/src/.coq_debug/group_01_safety_and_projection.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaUnLock-20261012130948/rounds/CriticalAreaUnLock-vc-proving-r1/groups/group_01__safety_and_projection/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaUnLock-20261012130948/rounds/CriticalAreaUnLock-vc-proving-r1/groups/group_01__safety_and_projection/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
