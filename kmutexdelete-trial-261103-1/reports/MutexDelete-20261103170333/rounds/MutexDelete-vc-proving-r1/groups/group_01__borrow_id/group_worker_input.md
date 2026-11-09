# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `borrow_id`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_01__borrow_id/MutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of__MutexDelete_which_implies_wit_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_01__borrow_id/MutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexDelete_lib.v`
- Every new/adapted helper uses suffix `__borrow_id`. Preserve the seed.

### `proof_of__MutexDelete_which_implies_wit_3` — `LLM_pre_process`

Select the Mutex object supplied by mutex_delete_drained, then use In/in_split for prefix/current/suffix. From the actual old os_inv derive NoDup(map mutex_id) through store_idmanager/idbuckets_ok/idlist_ok, and NoDup(map mutex_addr) through disjoint store_mutex payload fields. Derive query=true from In current and the derived manager ID list. Locate the matching embedded IdNode in its derived hash bucket, split just its UShort ID cell, and introduce a spatial wand that restores the unchanged whole os_inv when that exact cell/value is returned. Normalize nested field addressing, retain all other bytes in the wand, and output the current acquired-state object, not an earlier snapshot. Prove the needed resource view helpers; the existing *_obligation Prop definitions are not theorems.

## Helpers

- `mutex_addresses_unique__borrow_id` (local): Prove os_inv sg st entails NoDup(map mutex_addr st.os_mutexes) by induction on the management DLL and exclusivity of an owned store_mutex scalar/pointer field when two payloads have the same base. Refold the entire original heap afterward; no new invariant assumption.
- `idmanager_member_id_field__borrow_id` (local): For idmanager_contains sm im id p, split store_idmanager sm im manager into p.IdNode.id # UShort |-> id and a wand returning that exact manager when the cell is supplied. Bounds/bucket membership and existing ID/DLL splitting provide the field; retain all manager fields, bitmap, bucket heads, links and other payloads in the wand.
- `drained_id_read_view__borrow_id` (local): Using a drained(p,id,st) witness and os_inv, choose prefix/current/suffix via In/in_split; obtain ID NoDup from idbuckets_ok, address NoDup from the disjoint payload proof, and query=true from current membership in the derived ID list. Apply the ID-manager field view to the embedded IdNode and frame the other modules into mutex_delete_id_restore sg st p id. Establish exactly the which_implies_wit_3 output without changing the current state.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_01__borrow_id/proof_reuse.md`.

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
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-vc-proving-r1",
      "--group",
      "borrow_id"
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
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "borrow_id"
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
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "borrow_id"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/_coq_builds/MutexDelete-vc-proving-r1/group_01/src/.coq_debug/group_01_borrow_id.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_01__borrow_id/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_01__borrow_id/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
