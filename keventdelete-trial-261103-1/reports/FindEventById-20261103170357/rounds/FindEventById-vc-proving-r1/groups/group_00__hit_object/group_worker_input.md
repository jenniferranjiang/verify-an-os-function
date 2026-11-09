# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `hit_object`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/FindEventById-vc-proving-r1/groups/group_00__hit_object/FindEventById_proof_manual.v`.
- Editable proof spans: `proof_of_FindEventById_which_implies_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/FindEventById-vc-proving-r1/groups/group_00__hit_object/FindEventById_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/FindEventById_lib.v`
- Every new/adapted helper uses suffix `__hit_object`. Preserve the seed.

### `proof_of_FindEventById_which_implies_wit_4` — `LLM_pre_process`

Unfold this whole disjunction and prove its first identical arm. P is store_idmanager_found(sm,event_manager(os_events st),global_manager,idnode,id) ** find_event_manager_frame(sg,st), with idnode <> 0. Extract the found bucket decomposition and its member Build_IdNodeAbs id idnode before refolding it; the frame supplies os_world_wf and thus event_context, so hoffset=16 and manager_ptr=global_manager. Recover e in os_events st from the derived bucket membership; instantiate found with event_addr e. Derive event_addr e <> 0 from the event DLL payload, not merely from the ID address equation. Record id=e.event_id and idnode=field_addr(e.event_addr,Event,id), establish event_delete_guard and event_lookup_result. Restore the manager using store_idmanager_found_store_idmanager, then unfold find_event_manager_frame/event_create_frame/os_inv/event_inv, use context and cancel exactly the unchanged modules and event DLL. Do not use the design Prop obligations as proof facts.

## Helpers

- `event_bucket_member__hit_object` (local): Prove a pure lemma: forall es k id node, In (Build_IdNodeAbs id node) (Znth k (idbuckets (event_manager es)) nil) -> exists e, In e es /\ event_id e=id /\ node=field_addr(event_addr e,Event,id). Expand event_manager; a member in a selected mapped bucket comes from map event_idnode of a filtered es. Use nth/default membership and in_map_iff, then filter membership; invalid indices select nil and are impossible. Record equality gives both id and address. The VC supplies membership from prefix ++ Build_IdNodeAbs id idnode :: suffix; no extra validity premise is required.
- `event_dll_addr_nonzero__hit_object` (local): Prove forall wait head es e, In e es -> store_dll (store_event wait) head (map event_link_node es) |-- pure(event_addr e <> 0). Induct over the DLL segment/map list; for the selected element unfold store_event and project its explicit nonzero pure fact; frame the untouched spine/payload. Use prop_apply to retain the DLL in the VC while acquiring this pure fact. The required membership is supplied by event_bucket_member__hit_object.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_00__hit_object/proof_reuse.md`.

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
      "hit_object"
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
      "hit_object"
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
      "hit_object"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/_coq_builds/FindEventById-vc-proving-r1/group_00/src/.coq_debug/group_00_hit_object.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_00__hit_object/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_00__hit_object/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
