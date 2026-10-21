# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `invariants_and_calls`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/IdInsertObj-20261012130948/IdInsertObj-vc-proving-r1/groups/group_02__invariants_and_calls/IdInsertObj_proof_manual.v`.
- Editable proof spans: `proof_of_IdInsertObj_entail_wit_1`, `proof_of_IdInsertObj_entail_wit_2`, `proof_of_IdInsertObj_partial_solve_wit_1_pure`, `proof_of_IdInsertObj_partial_solve_wit_1`, `proof_of_IdInsertObj_partial_solve_wit_2_pure`, `proof_of_IdInsertObj_partial_solve_wit_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_IdInsertObj_entail_wit_1` — `LLM_pre_process`

P and Q have identical manager-before and detached-old-node heaps. Conjoin manager_pre <> 0 and idnode_pre <> 0 from PreH1/PreH3 and 0 = 0 by reflexivity, then cancel both heaps. The first check loop preserves parameters and state; no existential or helper.
### `proof_of_IdInsertObj_entail_wit_2` — `LLM_pre_process`

P and Q have identical manager-before and detached-old-node heaps. Conjoin manager_pre <> 0, idnode_pre <> 0, and id = 0 from PreH2/PreH3/PreH4; cancel the identical spatial frame. The second check loop preserves entry addresses; no existential or helper.
### `proof_of_IdInsertObj_partial_solve_wit_1_pure` — `LLM_pre_process`

Q is manager_pre <> 0, exactly PreH1. Introduce whole-goal binders and discharge the pure entailment while leaving stack slots, manager-before and detached-old-node as the antecedent frame. No existential, heap update or helper.
### `proof_of_IdInsertObj_partial_solve_wit_1` — `LLM_pre_process`

Unfold partial_solve_wit_1, introduce its pure-obligation implication premise, and unfold partial_solve_wit_1_aux. P and Q share manager-before and detached-old-node heaps; build duplicate manager nonzero, node nonzero and id = 0 from PreH1-3, then cancel. The implication premise need not be applied because these facts already occur in the aux binders. This packages AllocId call inputs without a state transition or existential.
### `proof_of_IdInsertObj_partial_solve_wit_2_pure` — `LLM_pre_process`

Q is the conjunction manager_pre <> 0 and idnode_pre <> 0 from PreH1/PreH2. P frames stack slots, allocated-unlinked manager and detached node carrying the new id; prove pure projection directly. No existential, transition or helper.
### `proof_of_IdInsertObj_partial_solve_wit_2` — `LLM_pre_process`

Unfold the whole implication, introduce its pure-obligation premise and unfold partial_solve_wit_2_aux. P and Q have the same allocated-unlinked manager and detached node carrying id. Reproduce duplicated nonzero facts from PreH1/PreH2 and min-free-id from PreH3, then cancel the heaps. This packages InsertObj inputs; its future add-then-link transition is handled by its accepted contract, not reconstructed here. No existential or helper.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/IdInsertObj-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/IdInsertObj-20261012130948/rounds/IdInsertObj-vc-proving-r1/groups/group_02__invariants_and_calls/proof_reuse.md`.

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
      "IdInsertObj-20261012130948",
      "--round",
      "IdInsertObj-vc-proving-r1",
      "--group",
      "invariants_and_calls"
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
      "IdInsertObj-20261012130948",
      "--round",
      "IdInsertObj-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "invariants_and_calls"
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
      "IdInsertObj-20261012130948",
      "--round",
      "IdInsertObj-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "invariants_and_calls"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/IdInsertObj-20261012130948/_coq_builds/IdInsertObj-vc-proving-r1/group_02/src/.coq_debug/group_02_invariants_and_calls.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/IdInsertObj-20261012130948/rounds/IdInsertObj-vc-proving-r1/groups/group_02__invariants_and_calls/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/IdInsertObj-20261012130948/rounds/IdInsertObj-vc-proving-r1/groups/group_02__invariants_and_calls/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
