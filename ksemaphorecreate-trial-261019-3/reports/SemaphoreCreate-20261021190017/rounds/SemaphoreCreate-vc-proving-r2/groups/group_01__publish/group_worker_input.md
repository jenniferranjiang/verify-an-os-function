# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `publish`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r2/groups/group_01__publish/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_6`, `proof_of__SemaphoreCreate_entail_wit_6_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial`, `proof_of__SemaphoreCreate_partial_solve_wit_9_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_9`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r2/groups/group_01__publish/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__publish`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_6` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_6_split_goal_1`: Prove the creation branch of Crtos_GTrans from locked to replace_semaphores (semaphore_publish sem id val_pre (os_semaphores locked)) locked. Use old os_world_wf, minimum-free-id, fresh sem, id range and value range from PreH. Other state components are definitionally unchanged. No spatial ownership is consumed for this pure transition.

- Split `proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial`: Apply publish_resources__publish to old invariant components, updated store_idmanager, old shifted DLL tail, DllInsertedCut, self-linked pending head, value cell and padding. Fold a new semaphore with address sem, id, value val_pre and empty pending queue; reconstruct store_dll with the new link at the front and prove its nonzero condition using PreH7/8 and PreH16. Show semaphore_manager of the published list equals the link/add expression using minimum-free-id. Rebuild os_world_wf for the published state from old wf, freshness, free id and empty pending queue; all non-semaphore state projections remain locked. Frame InsideCritical sg locked, whose state stays locked until unlock.
### `proof_of__SemaphoreCreate_partial_solve_wit_9_pure` — `LLM_pre_process`

Introduce the full antecedent; consequent is exactly the given Crtos_GTrans hypothesis PreH13. Lift it into the pure assertion and leave all resources as the frame.
### `proof_of__SemaphoreCreate_partial_solve_wit_9` — `LLM_pre_process`

Unfold the implication and its auxiliary target. All pure conjuncts, including the published-state Crtos_GTrans, are already explicit hypotheses. Reinsert them and cancel the identical InsideCritical sg locked and os_inv at the published state. No extra result from the pure implication is needed.

## Helpers

- `publish_resources__publish` (local): Statement shape: under old os_world_wf sg locked, semaphore_context, dll_nodes_nonzero of old links, sem and embedded nodes nonzero, aligned sem, fresh sem, 0<=id<128, idmanager_min_free_id and 0<=value<=65535, the conjunction of old non-semaphore invariant components, linked/added ID-manager store, shifted old DLL tail, DllInsertedCut head first new_link, store_node_self_linked pending, value and padding entails os_inv sg (replace_semaphores (semaphore_publish sem id value old_list) locked). Prove the manager/list model equations, new semaphore empty-queue invariant, DLL splice reconstruction and world-wf preservation explicitly from these premises. Then frame InsideCritical. All premises/resources occur in entail_wit_6 split spatial; no layout or new address assumptions.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_01__publish/proof_reuse.md`.

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
      "SemaphoreCreate-vc-proving-r2",
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
      "SemaphoreCreate-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "publish"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/_coq_builds/SemaphoreCreate-vc-proving-r2/group_01/src/.coq_debug/group_01_publish.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_01__publish/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_01__publish/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
