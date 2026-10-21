# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `list_prepare`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r2/groups/group_02__list_prepare/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_5`, `proof_of__SemaphoreCreate_entail_wit_5_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial`, `proof_of__SemaphoreCreate_partial_solve_wit_7`, `proof_of__SemaphoreCreate_partial_solve_wit_8`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r2/groups/group_02__list_prepare/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__list_prepare`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_5` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_5_split_goal_1`: Extract manager idmax = 128 from explicit semaphore_context. Rewrite the given retval < idmax; conclude retval < 128. Spatial resources are irrelevant to this pure consequence.

- Split `proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial`: Use list_cut__list_prepare to split old store_dll into dllseg_shift_rev and the head/first boundary cut, distinguishing empty and nonempty old lists. The two NodeZero resources have both base nonzero inequalities explicitly in PreH9/10: turn pending NodeZero into NodeStorage, and combine new link NodeZero with old head boundary into DllInsertAfterCut head first new_link 0 0. Use semaphore_context to identify the stable head with k_sem_list and semaphore_first_link; frame updated store_idmanager, all other invariant components and padding.
### `proof_of__SemaphoreCreate_partial_solve_wit_7` — `LLM_pre_process`

The target takes the existing pending NodeStorage to the front. Reinsert all pure hypotheses and cancel/reorder NodeStorage, InsideCritical, unchanged invariant components, updated manager, shifted tail, DllInsertAfterCut, value and padding. No state transition or fresh existential.
### `proof_of__SemaphoreCreate_partial_solve_wit_8` — `LLM_pre_process`

After pending-list initialization, move existing DllInsertAfterCut to the front, preserving store_node_self_linked pending, InsideCritical, old invariant components, manager, shifted tail, value and padding. All target pure facts are hypotheses; cancellation handles the spatial permutation.

## Helpers

- `list_cut__list_prepare` (local): Statement shape: given semaphore_context for the stable semaphore state and new_link <> 0, store_dll (store_semaphore f) k_sem_list (map semaphore_link_node ss) ** NodeZero new_link entails dllseg_shift_rev (store_semaphore f) (semaphore_first_link stable ss) k_sem_list (map semaphore_link_node ss) ** DllInsertAfterCut k_sem_list (semaphore_first_link stable ss) new_link 0 0. Destruct ss: empty case uses self-linked head; nonempty case exposes first-node boundary and preserves the shifted tail. NodeZero supplies the two zero link cells. Used only in entail_wit_5 split spatial.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_02__list_prepare/proof_reuse.md`.

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
      "list_prepare"
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
      "list_prepare"
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
      "list_prepare"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/_coq_builds/SemaphoreCreate-vc-proving-r2/group_02/src/.coq_debug/group_02_list_prepare.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_02__list_prepare/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_02__list_prepare/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
