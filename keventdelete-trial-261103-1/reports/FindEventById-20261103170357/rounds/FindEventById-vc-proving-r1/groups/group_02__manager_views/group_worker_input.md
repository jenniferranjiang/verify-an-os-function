# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `manager_views`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/FindEventById-vc-proving-r1/groups/group_02__manager_views/FindEventById_proof_manual.v`.
- Editable proof spans: `proof_of_FindEventById_which_implies_wit_1`, `proof_of_FindEventById_which_implies_wit_1_split_goal_1`, `proof_of_FindEventById_which_implies_wit_1_split_goal_spatial`, `proof_of_FindEventById_which_implies_wit_2`, `proof_of_FindEventById_which_implies_wit_2_split_goal_1`, `proof_of_FindEventById_which_implies_wit_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/FindEventById-vc-proving-r1/groups/group_02__manager_views/FindEventById_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/FindEventById_lib.v`
- Every new/adapted helper uses suffix `__manager_views`. Preserve the seed.

### `proof_of_FindEventById_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of_FindEventById_which_implies_wit_1_split_goal_1`: The global manager address is the address of a C variable. Apply the existing CNotation addr_of_LE_var_not_zero axiom; it is already the project global-address model, not a new assumption. The os_inv heap is irrelevant to this pure conclusion.

- Split `proof_of_FindEventById_which_implies_wit_1_split_goal_spatial`: P is os_inv sg st. Unfold os_inv, event_inv, find_event_manager_frame and event_create_frame only. Extract event_context, rewrite event_manager_ptr to &(k_event_id_manager), and reorder/cancel manager versus frame. Keep all other module resources and the event-management DLL; do not duplicate them.
### `proof_of_FindEventById_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of_FindEventById_which_implies_wit_2_split_goal_1`: Input query(event_manager(os_events st),id)=false. Unfold idmanager_query/event_manager and use id_in_ids_false_iff to get id not in map event_id es. For each e in es, in_map gives its ID membership, hence e.id<>id. Select the p=0 arm of event_lookup_result. Spatial manager/frame may be discarded for this pure split.

- Split `proof_of_FindEventById_which_implies_wit_2_split_goal_spatial`: P is store_idmanager at global_manager ** find_event_manager_frame. Open frame and its os_world_wf to obtain os_global_context/event_context and manager_ptr=global_manager. Reassemble os_inv and event_inv from the same manager, full event DLL and all unchanged modules. No query-dependent spatial update is needed; lazy bucket form is already represented by store_idmanager.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_02__manager_views/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "FindEventById-20261103170357",
      "--round",
      "FindEventById-vc-proving-r1",
      "--group",
      "manager_views"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "FindEventById-20261103170357",
      "--round",
      "FindEventById-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "manager_views"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "FindEventById-20261103170357",
      "--round",
      "FindEventById-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "manager_views"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/_coq_builds/FindEventById-vc-proving-r1/group_02/src/.coq_debug/group_02_manager_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_02__manager_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_02__manager_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
