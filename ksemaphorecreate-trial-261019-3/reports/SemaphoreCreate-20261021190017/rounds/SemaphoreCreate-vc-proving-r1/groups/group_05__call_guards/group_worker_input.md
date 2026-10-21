# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `call_guards`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_05__call_guards/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_partial_solve_wit_4_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_1`, `proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_2`, `proof_of__SemaphoreCreate_partial_solve_wit_4`, `proof_of__SemaphoreCreate_partial_solve_wit_5`, `proof_of__SemaphoreCreate_partial_solve_wit_6_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1`, `proof_of__SemaphoreCreate_partial_solve_wit_6`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_05__call_guards/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__call_guards`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_partial_solve_wit_4_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_1`: Expose the manager first field from store_idmanager and use valid typed ownership to derive the base manager address nonzero (id_max offset zero in the current layout). Frame every OS and semaphore resource; do not assume globals are nonzero without the existing ownership/layout evidence.

- Split `proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_2`: Unfold ZeroIdNode and extract its explicit base-nonzero pure fact, giving sem.id<>0; frame remaining resources.
### `proof_of__SemaphoreCreate_partial_solve_wit_4` — `LLM_pre_process`

Introduce quantified values and hypotheses, unfold the named whole VC (and auxiliary definition if present), introduce its pure-witness implication without importing any admitted theorem. Establish the consequent pure conjuncts from the explicit PreH hypotheses; use sep_apply/entailer and cancellation to reorder the identical spatial resources. No existential or abstract state change is needed. Derive sem.id<>0 from ZeroIdNode and manager<>0 from its owned first field, so the auxiliary goal can be proved without trying to synthesize removed local stack cells. Move manager/ZeroIdNode to the front.
### `proof_of__SemaphoreCreate_partial_solve_wit_5` — `LLM_pre_process`

Introduce quantified values and hypotheses, unfold the named whole VC (and auxiliary definition if present), introduce its pure-witness implication without importing any admitted theorem. Establish the consequent pure conjuncts from the explicit PreH hypotheses; use sep_apply/entailer and cancellation to reorder the identical spatial resources. No existential or abstract state change is needed. Move SemaphoreZero sem to the free-call front; keep InsideCritical locked and os_inv locked.
### `proof_of__SemaphoreCreate_partial_solve_wit_6_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1`: Prove Crtos_GTrans locked locked by reflexive guarantee closure (unfold Crtos_GTrans if needed); the failed ID allocation has not changed OS state. The target is pure and all spatial resources remain framed.
### `proof_of__SemaphoreCreate_partial_solve_wit_6` — `LLM_pre_process`

Introduce quantified values and hypotheses, unfold the named whole VC (and auxiliary definition if present), introduce its pure-witness implication without importing any admitted theorem. Establish the consequent pure conjuncts from the explicit PreH hypotheses; use sep_apply/entailer and cancellation to reorder the identical spatial resources. No existential or abstract state change is needed. Establish Crtos_GTrans locked locked by reflexivity independently of the removed local cells; preserve InsideCritical and os_inv locked.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_05__call_guards/proof_reuse.md`.

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
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--group",
      "call_guards"
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
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "call_guards"
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
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "call_guards"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/_coq_builds/SemaphoreCreate-vc-proving-r1/group_05/src/.coq_debug/group_05_call_guards.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_05__call_guards/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_05__call_guards/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
