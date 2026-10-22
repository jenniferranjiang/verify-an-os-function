# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `publish`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_01__publish/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_7`, `proof_of__SemaphoreCreate_entail_wit_7_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial`, `proof_of__SemaphoreCreate_partial_solve_wit_9_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_9`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_01__publish/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__publish`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_7` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_7_split_goal_1`: P is the full DLL after dll_insert_after_dispatch at the global head, linked ID manager and unchanged OS frames. Q is Crtos_GTrans st_lock (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores st_lock)) st_lock). Unfold the actual current Crtos_GTrans definition and prove its required components from the displayed update; no stronger hardware relation is assumed.

- Split `proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial`: P owns the updated DLL, store_idmanager after add/link and every non-semaphore OS invariant. Q folds os_inv for replace_semaphores with a new head semaphore. Reduce head insertion dispatch, rewrite map of publication, identify the linked manager with semaphore_manager of publication, prove preserved world well-formedness from os_world_wf/min-free/freshness/bounds and context. Rebuild task_world_wf if indexed record transport is not definitional, and frame other components. Retain InsideCritical sg st_lock unchanged; do not change it to the new state.
### `proof_of__SemaphoreCreate_partial_solve_wit_9_pure` — `LLM_pre_process`

Q is exactly the Crtos_GTrans premise already present. Introduce variables and pure premises, extract that premise, and discharge the pure entailment from the local stores plus InsideCritical and updated os_inv. No new transition is needed.
### `proof_of__SemaphoreCreate_partial_solve_wit_9` — `LLM_pre_process`

Introduce all pure premises; preserve each spatial resource with cancellation/reassociation. Re-establish the displayed pure conjunction from the same antecedent premises; there is no state change or fresh existential. Unfold the pure-to-aux wrapper and prove the aux directly: Crtos_GTrans is explicitly available. Keep InsideCritical at st_lock and os_inv at the published replacement state.

## Helpers

- `published_manager__publish` (local): Prove equality between semaphore_manager (semaphore_publish sem id val ss) and idmanager_link stable (idmanager_add (semaphore_manager ss) id) id (&sem->id), under semaphore_context stable, relevant well-formedness/min-free and sem freshness. Use definitions of publication, manager bitmap/map/buckets; extensionality and finite bucket analysis if necessary. All hypotheses come from entail_wit_7; use for the manager component of the spatial split.
- `published_world_wf__publish` (local): Under os_world_wf sg st, semaphore_context (os_semaphore_stable sg), 0<=val<=65535, sem<>0, fresh sem in st, 0<=id<128 and idmanager_min_free_id, prove os_world_wf sg (replace_semaphores (semaphore_publish sem id val (os_semaphores st)) st). Decompose world invariants; unchanged task/mutex/event/etc projections transport, new semaphore has bounded value and empty wait queue, min-free gives distinct ID. Use in entail_wit_7 spatial; do not introduce stronger premises.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_01__publish/proof_reuse.md`.

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
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--group",
      "publish"
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
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "publish"
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
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "publish"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/_coq_builds/SemaphoreCreate-vc-proving-r1/group_01/src/.coq_debug/group_01_publish.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_01__publish/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_01__publish/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
