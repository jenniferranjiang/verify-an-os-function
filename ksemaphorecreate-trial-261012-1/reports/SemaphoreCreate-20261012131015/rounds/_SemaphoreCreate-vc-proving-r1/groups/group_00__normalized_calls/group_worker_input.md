# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `normalized_calls`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_SemaphoreCreate-vc-proving-r1/groups/group_00__normalized_calls/_SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_partial_solve_wit_1_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_1`, `proof_of__SemaphoreCreate_partial_solve_wit_2_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_2`, `proof_of__SemaphoreCreate_safety_wit_4`, `proof_of__SemaphoreCreate_safety_wit_12`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of__SemaphoreCreate_partial_solve_wit_1_pure` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. Pure projection/reflexivity pattern: prove 32 = 32. P also has C locals and SemaphoreOutsideCritical sg hs before; Q has only the stated pure conjunction. Extract explicit premises and split the conjunction; do not consume or reconstruct resources. No existential witnesses or new refinement transition.
### `proof_of__SemaphoreCreate_partial_solve_wit_1` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. This definition is pure-VC -> auxiliary-VC. Introduce that implication premise, unfold the auxiliary, and establish its pure conjuncts directly: 32 = 32. P and Q contain exactly SemaphoreOutsideCritical sg hs before; cancel these resources modulo separating associativity/commutativity. Retain all other named pure premises. No change of abstract state or existential instantiation is required.
### `proof_of__SemaphoreCreate_partial_solve_wit_2_pure` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. Pure projection/reflexivity pattern: prove 0 = 0 and 32 = 32; retval <> 0 and the entry nesting bound are explicit premises. P also has C locals and OSHeap(store_sem_allocated retval) and SemaphoreOutsideCritical sg hs before; Q has only the stated pure conjunction. Extract explicit premises and split the conjunction; do not consume or reconstruct resources. No existential witnesses or new refinement transition.
### `proof_of__SemaphoreCreate_partial_solve_wit_2` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. This definition is pure-VC -> auxiliary-VC. Introduce that implication premise, unfold the auxiliary, and establish its pure conjuncts directly: 0 = 0 and 32 = 32; retval <> 0 and the entry nesting bound are explicit premises. P and Q contain exactly OSHeap(store_sem_allocated retval) and SemaphoreOutsideCritical sg hs before; cancel these resources modulo separating associativity/commutativity. Retain all other named pure premises. No change of abstract state or existential instantiation is required.
### `proof_of__SemaphoreCreate_safety_wit_4` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. The two conclusions are INT_MIN <= 32 and 32 <= INT_MAX. Reduce the imported signed 32-bit limits and discharge both closed inequalities. The antecedent locals and protocol/heap resources are unchanged and are used only as the domain of a pure assertion; no existential, list transformation, or transition is needed.
### `proof_of__SemaphoreCreate_safety_wit_12` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. The two conclusions are INT_MIN <= 32 and 32 <= INT_MAX. Reduce the imported signed 32-bit limits and discharge both closed inequalities. The antecedent locals and protocol/heap resources are unchanged and are used only as the domain of a pure assertion; no existential, list transformation, or transition is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_00__normalized_calls/proof_reuse.md`.

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
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-proving-r1",
      "--group",
      "normalized_calls"
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
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "normalized_calls"
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
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "normalized_calls"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_coq_builds/_SemaphoreCreate-vc-proving-r1/group_00/src/.coq_debug/group_00_normalized_calls.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_00__normalized_calls/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_00__normalized_calls/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
