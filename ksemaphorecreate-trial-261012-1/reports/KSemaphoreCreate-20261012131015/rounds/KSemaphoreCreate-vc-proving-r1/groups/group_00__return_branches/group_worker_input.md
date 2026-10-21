# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `return_branches`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/KSemaphoreCreate-20261012131015/KSemaphoreCreate-vc-proving-r1/groups/group_00__return_branches/KSemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of_KSemaphoreCreate_return_wit_1`, `proof_of_KSemaphoreCreate_return_wit_2`, `proof_of_KSemaphoreCreate_return_wit_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_KSemaphoreCreate_return_wit_1` — `LLM_pre_process`

Unfold KSemaphoreCreate_return_wit_1 and introduce all binders (or use LLM_pre_process). P is SemaphoreOutsideCritical sg hs before; PreH1 supplies retval = -5. Select the first of the three postcondition disjuncts with the assertion disjunction introduction rules, discharge its pure equality from PreH1, and cancel the identical outside-critical resource by entailment reflexivity. No existential, state transition, arithmetic or resource unfolding is required; the entry nest bound is unused.
### `proof_of_KSemaphoreCreate_return_wit_2` — `LLM_pre_process`

Unfold KSemaphoreCreate_return_wit_2 and introduce binders. P owns SemaphoreOutsideCritical sg hs current_3; PreH1-PreH3 supply retval = -5, SemaphoreRely hs before current_3, and manager fullness at current_3. Select the middle postcondition disjunct and instantiate its current existential with current_3. Introduce its three pure conjuncts from those premises and cancel the identical outside-critical resource. The rely source/target is exactly before/current_3 already present in PreH2; do not identify current_3 with before or unfold the rely/representation. No additional transition or helper is needed.
### `proof_of_KSemaphoreCreate_return_wit_3` — `LLM_pre_process`

Unfold KSemaphoreCreate_return_wit_3 and introduce binders. P owns SemaphoreOutsideCritical sg hs (semaphore_os_publish p_2 retval val_pre current_3). Select the third postcondition disjunct and instantiate current_2 := current_3 and p := p_2. Its four pure conjuncts are precisely PreH1-PreH4: nonzero pointer, rely before/current_3, minimum-free ID at current_3, and guarantee current_3/(semaphore_os_publish p_2 retval val_pre current_3). Introduce them and cancel the identical published-state resource. Preserve the existing transition unchanged; no new rely/guarantee reasoning, resource transformation or arithmetic is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/KSemaphoreCreate-20261012131015/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/KSemaphoreCreate-20261012131015/rounds/KSemaphoreCreate-vc-proving-r1/groups/group_00__return_branches/proof_reuse.md`.

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
      "return_branches"
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
      "return_branches"
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
      "return_branches"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/KSemaphoreCreate-20261012131015/_coq_builds/KSemaphoreCreate-vc-proving-r1/group_00/src/.coq_debug/group_00_return_branches.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/KSemaphoreCreate-20261012131015/rounds/KSemaphoreCreate-vc-proving-r1/groups/group_00__return_branches/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/KSemaphoreCreate-20261012131015/rounds/KSemaphoreCreate-vc-proving-r1/groups/group_00__return_branches/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
