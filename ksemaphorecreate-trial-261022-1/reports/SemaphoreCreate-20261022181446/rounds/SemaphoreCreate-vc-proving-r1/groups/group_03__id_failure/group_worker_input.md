# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `id_failure`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_03__id_failure/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_4_1`, `proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_spatial`, `proof_of__SemaphoreCreate_entail_wit_4_2`, `proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_2`, `proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_spatial`, `proof_of__SemaphoreCreate_partial_solve_wit_5`, `proof_of__SemaphoreCreate_partial_solve_wit_6_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1`, `proof_of__SemaphoreCreate_partial_solve_wit_6`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_03__id_failure/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__id_failure`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_4_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_1`: From idmanager_first_free_id stable manager=None and semaphore_context, derive idmanager_full. Use the first-free/none characterization (or finite search completeness), with well-formedness from the displayed state/context. This is pure and leaves all memory irrelevant.

- Split `proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_spatial`: The returned ID node has arbitrary values, not zero. Weaken value and NodeZero cells to unknown-value storage, combine with store_idnode_insert_ready and SemaphorePadding into SemaphoreRaw using the frozen bridge; preserve required nonzero node facts from explicit premises and insert-ready definition. Fold the unchanged manager plus semaphore DLL and all other OS frames into os_inv sg st_lock using existing world/context facts. Keep InsideCritical unchanged.
### `proof_of__SemaphoreCreate_entail_wit_4_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_1`: Antecedent has retval<0 and idmanager_min_free_id stable manager retval. Unfold minimum-free membership/range to obtain 0<=retval and contradict the guard; then derive idmanager_full by ex falso.

- Split `proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_2`: Use the same contradiction between negative retval and minimum-free range to prove retval=-1; no inference from a successful insertion to a failure result is made on a reachable state.

- Split `proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_spatial`: The same contradictory minimum-free/negative premises close the whole spatial entailment by false elimination; do not attempt to recover the consumed ID node from the updated manager.
### `proof_of__SemaphoreCreate_partial_solve_wit_5` — `LLM_pre_process`

Introduce all pure premises; preserve each spatial resource with cancellation/reassociation. Re-establish the displayed pure conjunction from the same antecedent premises; there is no state change or fresh existential. Move SemaphoreRaw ahead of InsideCritical ** os_inv for x_free. The Raw object is complete but may contain nonzero fields; no assertion of preserved zero contents.
### `proof_of__SemaphoreCreate_partial_solve_wit_6_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1`: Unchanged-state unlock requires Crtos_GTrans st_lock st_lock. Reduce current transition definition or use its reflexivity. P contains local stores, InsideCritical and os_inv; no heap mutation is required.
### `proof_of__SemaphoreCreate_partial_solve_wit_6` — `LLM_pre_process`

Introduce all pure premises; preserve each spatial resource with cancellation/reassociation. Re-establish the displayed pure conjunction from the same antecedent premises; there is no state change or fresh existential. Prove reflexive Crtos_GTrans st_lock st_lock directly when unfolding the aux wrapper; its local-store pure antecedent need not be reconstructed. Both critical and OS state remain st_lock.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_03__id_failure/proof_reuse.md`.

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
      "id_failure"
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
      "id_failure"
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
      "id_failure"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/_coq_builds/SemaphoreCreate-vc-proving-r1/group_03/src/.coq_debug/group_03_id_failure.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_03__id_failure/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_03__id_failure/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
