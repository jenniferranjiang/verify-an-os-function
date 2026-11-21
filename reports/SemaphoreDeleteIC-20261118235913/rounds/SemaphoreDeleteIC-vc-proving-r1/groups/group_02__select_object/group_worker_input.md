# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `select_object`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreDeleteIC-20261118235913/SemaphoreDeleteIC-vc-proving-r1/groups/group_02__select_object/SemaphoreDeleteIC_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_which_implies_wit_1`, `proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_1`, `proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_2`, `proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_3`, `proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial`, `proof_of__SemaphoreDelete_entail_wit_1`, `proof_of__SemaphoreDelete_entail_wit_2`, `proof_of__SemaphoreDelete_partial_solve_wit_9_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreDelete_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_1`: Unfold os_inv/semaphore_inv/store_idmanager sufficiently to extract id_map_bytes_ok or idbuckets_ok, whose idlist_ok contains NoDup. The derived semaphore_manager idlist reduces to map semaphore_id old. Frame all resources while deriving this pure fact.

- Split `proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_2`: Extract semaphore_context from the semaphore_inv component of os_inv; no strengthening of global context is needed.

- Split `proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_3`: Extract os_world_wf, the outer pure conjunct of os_inv.

- Split `proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial`: Unfold os_inv and semaphore_inv; use semaphore_context equalities to replace manager_ptr/list_head by k_sem_id_manager/k_sem_list. Reorder/cancel all unchanged resource components. The explicit right frame contains task/tick/delay/assign/prio/zombie/recycler/idle/mutex/event/isr/exstatus/dataqueue exactly once.
### `proof_of__SemaphoreDelete_entail_wit_1` — `LLM_pre_process`

Use LLM_pre_process on a whole disjunct. Open store_idmanager_found to obtain the matching Build_IdNodeAbs in its bucket. With semaphore_context.hoffset=16 and the definition of semaphore_manager, use Znth/map/filter membership to find original in old with matching id and embedded address retval. Reconstitute store_idmanager using its found-to-manager lemma and preserve the complete frame. Extract original base nonzero from its management-DLL payload. Normalize semaphore_query_id id=id with 0<=id<=65535, apply quiescent to obtain original.pending=nil, then choose this original and reconstruct os_inv; all remaining local equalities are antecedent facts.
### `proof_of__SemaphoreDelete_entail_wit_2` — `LLM_pre_process`

Use LLM_pre_process; In original old gives prefix/suffix with old=prefix++original::suffix. Extract NoDup IDs from manager metadata, query=true from membership in map semaphore_id, and context/world from os_inv. Substitute sem and id equalities already present. Instantiate prefix/suffix, rewrite map_app/map_cons and semaphore_link_node to the explicit Build_DL_Node, unfold only semaphore_inv, and cancel every global frame component including dataqueue_inv.
### `proof_of__SemaphoreDelete_partial_solve_wit_9_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1`: The goal is the nonzero address of the named global k_sem_id_manager. Apply the existing QCP CNotation addr_of_LE_var_not_zero fact (same instantiated C notation module), which is already part of the frontend model, not a new axiom. The spatial resources can be framed; no missing base-field offset premise is needed. This split asks only pointer nonzero.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreDeleteIC-20261118235913/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/rounds/SemaphoreDeleteIC-vc-proving-r1/groups/group_02__select_object/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-debug",
      "--run",
      "SemaphoreDeleteIC-20261118235913",
      "--round",
      "SemaphoreDeleteIC-vc-proving-r1",
      "--group",
      "select_object"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "SemaphoreDeleteIC-20261118235913",
      "--round",
      "SemaphoreDeleteIC-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "select_object"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "SemaphoreDeleteIC-20261118235913",
      "--round",
      "SemaphoreDeleteIC-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "select_object"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreDeleteIC-20261118235913/_coq_builds/SemaphoreDeleteIC-vc-proving-r1/group_02/src/.coq_debug/group_02_select_object.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/rounds/SemaphoreDeleteIC-vc-proving-r1/groups/group_02__select_object/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/rounds/SemaphoreDeleteIC-vc-proving-r1/groups/group_02__select_object/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
