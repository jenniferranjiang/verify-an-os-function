# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `lookup_bridge`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/KMutexDelete-vc-proving-r1/groups/group_00__lookup_bridge/KMutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of_KMutexDelete_which_implies_wit_1`, `proof_of_KMutexDelete_which_implies_wit_1_split_goal_spatial`, `proof_of_KMutexDelete_which_implies_wit_2`, `proof_of_KMutexDelete_which_implies_wit_2_split_goal_spatial`, `proof_of_KMutexDelete_which_implies_wit_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/KMutexDelete-vc-proving-r1/groups/group_00__lookup_bridge/KMutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/KMutexDelete_lib.v`
- Every new/adapted helper uses suffix `__lookup_bridge`. Preserve the seed.

### `proof_of_KMutexDelete_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of_KMutexDelete_which_implies_wit_1_split_goal_spatial`: Unfold os_inv, mutex_inv, mutex_lookup_frame and mutex_create_frame. Extract the pure mutex_context to rewrite manager_ptr to the global k_mutex_id_manager address. Split the actual Mutex ID-manager spatial component; cancel every other component into the exact stored frame and Mutex management DLL. Do not consume any published payload or manufacture an object.
### `proof_of_KMutexDelete_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of_KMutexDelete_which_implies_wit_2_split_goal_spatial`: Reverse the same definitional split. mutex_lookup_frame supplies mutex_context, the precise non-Mutex resources, all management nodes and payloads, and os_world_wf. Rewrite the manager address using mutex_context; reorder separating conjuncts and fold mutex_inv/os_inv at unchanged sg/st.
### `proof_of_KMutexDelete_which_implies_wit_3` — `LLM_pre_process`

Both disjuncts are identical; choose one. From store_idmanager_found derive its pure bucket membership for Build_IdNodeAbs key idnode and recover the unchanged store_idmanager via the existing found-to-manager lemma. With key=unsigned_last_nbits id 16, the derived mutex_manager consists of mapped mutex_idnode values in filtered object buckets: invert membership to obtain original in st.os_mutexes, original.mutex_id=key, and idnode=field_addr(original.mutex_addr,Mutex,id). From the management DLL in mutex_lookup_frame obtain original.mutex_addr<>0 using its store_mutex payload, without losing or duplicating the DLL. Low-16-bit arithmetic gives 0<=key<65536, hence mutex_delete_live. Instantiate EX original and refold the exact unchanged os_inv using manager and frame. Planned helpers below have premises available here, not extra environmental assumptions.

## Helpers

- `mutex_manager_contains_object__lookup_bridge` (local): Prove the pure statement: forall stable objects key node, mutex_context stable -> idmanager_contains stable.(mutex_manager_stable) (mutex_manager objects) key node -> exists m, In m objects /\ m.(mutex_id)=key /\ node=field_addr(m.(mutex_addr),Mutex,id). Unfold derived manager and idmanager_contains; use membership of an indexed map element (out-of-range gives nil), then invert the inner map and filter. Invert Build_IdNodeAbs equality. No NoDup or live-heap premise is needed for existence.
- `mutex_member_nonzero__lookup_bridge` (local): Prove: forall wait head objects m, In m objects -> store_dll (store_mutex wait) head (map mutex_link_node objects) |-- pure(m.(mutex_addr)<>0). Follow list membership through the DLL segments or use its existing split/member lemma; the selected store_mutex contains the nonzero base fact. Extract only the pure consequence and preserve the original heap via prop_apply when using it in the main witness. This is derived from actual payload ownership, not from a bare pointer or ID.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_00__lookup_bridge/proof_reuse.md`.

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
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "KMutexDelete-20261103170333",
      "--round",
      "KMutexDelete-vc-proving-r1",
      "--group",
      "lookup_bridge"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-check",
      "--run",
      "KMutexDelete-20261103170333",
      "--round",
      "KMutexDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "lookup_bridge"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-check",
      "--run",
      "KMutexDelete-20261103170333",
      "--round",
      "KMutexDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "lookup_bridge"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/_coq_builds/KMutexDelete-vc-proving-r1/group_00/src/.coq_debug/group_00_lookup_bridge.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_00__lookup_bridge/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_00__lookup_bridge/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
