# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `publish`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_00__publish/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_5`, `proof_of__SemaphoreCreate_entail_wit_5_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial`, `proof_of__SemaphoreCreate_partial_solve_wit_9_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_9`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_00__publish/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__publish`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_5` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_5_split_goal_1`: P contains DllInsertedCut, self-linked empty pend_list, linked ID manager, old DLL tail, payload and every non-semaphore OS component. The pure target is Crtos_GTrans locked (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores locked)) locked). Unfold Crtos_GTrans and the instantiated CriticalSTS transition (True); discharge the guarantee closure without changing any memory. All id/value/freshness assumptions are already explicit; no new axiom or assumed transition is allowed.

- Split `proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial`: Preserve InsideCritical sg locked. Set newstate := replace_semaphores (semaphore_publish sem id val_pre (os_semaphores locked)) locked. Build os_inv sg newstate: use publish_world_wf__publish for its pure world invariant; task map, roles, scheduling and all non-semaphore fields reduce to the locked state. Combine DllInsertedCut with dllseg_shift_rev to reconstruct the management DLL with semaphore_created sem id val_pre at its head; construct the new store_semaphore payload from the value cell, SemaphorePadding and self-linked empty pending list. Use publish_manager_store__publish to identify the ID allocation/link manager representation with semaphore_manager of the cons state. Fold semaphore_inv using explicit semaphore_context; frame/cancel remaining OS components. No resources may be duplicated or discarded to bypass the manager or list bridge.
### `proof_of__SemaphoreCreate_partial_solve_wit_9_pure` — `LLM_pre_process`

Introduce quantifiers and use explicit PreH11 Crtos_GTrans for the pure consequent under the arbitrary unchanged heap. This target establishes no additional transition.
### `proof_of__SemaphoreCreate_partial_solve_wit_9` — `LLM_pre_process`

Introduce quantified values and hypotheses, unfold the named whole VC (and auxiliary definition if present), introduce its pure-witness implication without importing any admitted theorem. Establish the consequent pure conjuncts from the explicit PreH hypotheses; use sep_apply/entailer and cancellation to reorder the identical spatial resources. No existential or abstract state change is needed. The consequent transition is already PreH11, and the identical InsideCritical locked plus os_inv newstate are preserved.

## Helpers

- `publish_world_wf__publish` (local): Prove forall sg st p id val, os_world_wf sg st -> os_world_wf sg (replace_semaphores (semaphore_publish p id val (os_semaphores st)) st). Destruct the old world record; all fields except semaphore state are definitionally preserved. For sched coverage unfold os_sched_owners/semaphore_waiters: the new semaphore contributes an empty pending list, so owners are unchanged. role_slot_wf depends on unchanged task map/role fields. Use at entail_wit_5 spatial split; sole premise is its explicit PreH12.
- `publish_manager_store__publish` (local): Prove the spatial manager representation bridge: semaphore_context ss -> idmanager_min_free_id (semaphore_manager_stable ss) (semaphore_manager sems) id -> 0 <= id < 128 -> store_idmanager (semaphore_manager_stable ss) (idmanager_link (semaphore_manager_stable ss) (idmanager_add (semaphore_manager sems) id) id (&(p # "Semaphore" ->ₛ "id"))) manager |-- store_idmanager (semaphore_manager_stable ss) (semaphore_manager (semaphore_publish p id val sems)) manager. Expand the cons map/filter descriptions of semaphore_manager; context fixes hash count 16. Show the selected bucket is updated by cons and others unchanged, with modulo bounds from id range. Relate idlist_add to the cons representation, using existing ID-map extensional/permutation facts if needed rather than demanding unjustified syntactic equality. All premises come from entail_wit_5 explicit context/min-free/range facts; preserve the same bytes and ID-node resources.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_00__publish/proof_reuse.md`.

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
      "publish"
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
      "publish"
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
      "publish"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/_coq_builds/SemaphoreCreate-vc-proving-r1/group_00/src/.coq_debug/group_00_publish.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_00__publish/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_00__publish/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
