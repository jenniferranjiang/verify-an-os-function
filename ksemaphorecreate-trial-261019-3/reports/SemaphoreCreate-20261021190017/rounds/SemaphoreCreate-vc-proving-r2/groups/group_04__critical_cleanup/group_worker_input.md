# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `critical_cleanup`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r2/groups/group_04__critical_cleanup/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_4`, `proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial`, `proof_of__SemaphoreCreate_partial_solve_wit_4_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_1`, `proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_2`, `proof_of__SemaphoreCreate_partial_solve_wit_4`, `proof_of__SemaphoreCreate_partial_solve_wit_5`, `proof_of__SemaphoreCreate_partial_solve_wit_6_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1`, `proof_of__SemaphoreCreate_partial_solve_wit_6`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r2/groups/group_04__critical_cleanup/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__critical_cleanup`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_4` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial`: Refold ZeroIdNode, zero value, both NodeZero predicates and padding into SemaphoreZero sem. Refold unchanged store_idmanager/store_dll and the listed component invariants into os_inv sg locked, using explicit old os_world_wf and semaphore_context. Keep InsideCritical sg locked. No publication occurred on the id=-1 branch.
### `proof_of__SemaphoreCreate_partial_solve_wit_4_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_1`: Extract manager base nonzero from store_idmanager at k_sem_id_manager. The other resources are frames; no arbitrary global-address axiom.

- Split `proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_2`: Extract embedded ID-node base nonzero from ZeroIdNode (or its zero field ownership and existing representation facts). Frame the manager and other invariant resources; do not infer it from a bare unrelated pointer.
### `proof_of__SemaphoreCreate_partial_solve_wit_4` — `LLM_pre_process`

Unfold implication and auxiliary target. Extract the same manager and ZeroIdNode base inequalities directly from their predicates, then refold; the auxiliary antecedent lacks local-variable cells, so do not instantiate the pure witness by inventing those cells. Reinsert all given pure facts and commute manager/ZeroIdNode to the front.
### `proof_of__SemaphoreCreate_partial_solve_wit_5` — `LLM_pre_process`

All target pure facts are explicit hypotheses for id=-1. Move SemaphoreZero sem before InsideCritical and os_inv; cancel without changing locked.
### `proof_of__SemaphoreCreate_partial_solve_wit_6_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1`: Use reflexive/stuttering branch of Crtos_GTrans locked locked, extracting any required world-wf premise from os_inv sg locked. Spatial local cells and critical token remain frames.
### `proof_of__SemaphoreCreate_partial_solve_wit_6` — `LLM_pre_process`

Unfold implication and auxiliary target. Establish the same stuttering GTrans directly on InsideCritical ** os_inv, reinsert given pure facts and cancel. The absence of local-variable cells in aux must not cause fabricated resources.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_04__critical_cleanup/proof_reuse.md`.

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
      "SemaphoreCreate-vc-proving-r2",
      "--group",
      "critical_cleanup"
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
      "SemaphoreCreate-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "critical_cleanup"
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
      "SemaphoreCreate-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "critical_cleanup"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/_coq_builds/SemaphoreCreate-vc-proving-r2/group_04/src/.coq_debug/group_04_critical_cleanup.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_04__critical_cleanup/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_04__critical_cleanup/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
