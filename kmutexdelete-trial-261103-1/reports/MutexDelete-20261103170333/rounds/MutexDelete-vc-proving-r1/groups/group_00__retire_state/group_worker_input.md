# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `retire_state`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_00__retire_state/MutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of__MutexDelete_entail_wit_3_2`, `proof_of__MutexDelete_entail_wit_3_2_split_goal_1`, `proof_of__MutexDelete_entail_wit_3_2_split_goal_2`, `proof_of__MutexDelete_entail_wit_3_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_00__retire_state/MutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexDelete_lib.v`
- Every new/adapted helper uses suffix `__retire_state`. Preserve the seed.

### `proof_of__MutexDelete_entail_wit_3_2` — `aggressive_pre_process`

- Split `proof_of__MutexDelete_entail_wit_3_2_split_goal_1`: For after := replace_mutexes (mutex_delete_unpublish p st_lock.os_mutexes) st_lock, unfold the existing Crtos_GTrans/Crtos_CS relation (True). The remaining heap is irrelevant to this pure goal.

- Split `proof_of__MutexDelete_entail_wit_3_2_split_goal_2`: Use safeExec(LastSeen drained, abs_mutex_retire p id, X), Crtos_RTrans drained st_lock, and mutex_delete_drained p id st_lock. In the guarded atomic nrm choose actual st_lock and the displayed unpublish after; choose output observation Crtos_RTrans after. Apply the safeExec weakest-precondition normal-execution clause and package safeExec(LastSeen after, ret tt, X). This uses the approved guard already present, not a stronger rely or an unproved obligation.

- Split `proof_of__MutexDelete_entail_wit_3_2_split_goal_spatial`: Preserve InsideCritical. Recover idnode = &(current.addr # Mutex->id) from idmanager_contains of the original derived manager plus NoDup old IDs and current membership. Using old address and ID NoDup and mutex_context, prove filter/unpublish removes exactly current and its derived manager equals the returned idmanager_remove; rewrite remaining DLL to that object sequence. Since current.pending=nil, unpublishing it preserves os_sched_owners and os_world_wf; all non-Mutex spatial components from mutex_create_frame remain unchanged. Normalize returned IdNode fields/self-links, combine detached payload and management self-link into MutexRetired, and fold the residual manager/DLL/frame into os_inv(after). Derive required nonzero/alignment facts from payload, valid typed fields and established layout facts; never apply mutex_delete_restore_obligation as a proved lemma.

## Helpers

- `current_idnode__retire_state` (local): Prove: mutex_context ms, NoDup(map mutex_id xs), In m xs and idmanager_contains ms.manager_stable (mutex_manager xs) m.id idnode imply idnode=&(m.addr # Mutex->id). Unfold the fixed 16-bucket derived map, recover an object from map/filter membership, and use NoDup of ID projections to identify it with m. These premises are all retained in the successful retirement VC.
- `unpublish_manager__retire_state` (local): Prove under mutex_context, old address/ID NoDup and In m xs that mutex_manager(mutex_delete_unpublish m.addr xs)=idmanager_remove ms.manager_stable (mutex_manager xs) m.id. Identify the unique removed object in the ID projection and each bucket; preserve ordering and the other 15 buckets. No old heap may be assumed after deletion; use exactly the pure facts retained by the VC.
- `retire_world__retire_state` (local): Prove from old os_world_wf, In m xs, NoDup(map mutex_addr xs), m.pending=nil, xs=st.os_mutexes that os_world_wf holds after replacing Mutexes with unpublish m.addr xs. Show mutex_waiters and therefore os_sched_owners unchanged, then preserve recycler/idle/context/task-domain fields. These facts come from the old non-Mutex frame and retained pure context.
- `retire_resources__retire_state` (local): Prove the spatial reconstruction from current payload, management self-link, returned IdNode ID=65535 and its self-links, returned removed manager, remaining DLL, exact mutex_create_frame, old address/ID NoDup and empty current pending. Use current_idnode/unpublish/world helpers; normalize addresses and fold os_inv(after) ** MutexRetired m. The input shape is the real successful post-callee heap, never old os_inv itself.
- `retire_continuation__retire_state` (local): For safeExec(LastSeen drained,abs_mutex_retire p id,X), RTrans drained locked and drained(p,id,locked), derive safeExec(LastSeen(replace_mutexes(unpublish p locked.os_mutexes)locked),ret tt,X). Construct the scoped atomic normal execution at locked and apply weakestpre. Prove with the existing monad definitions; no additional rely assumption.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_00__retire_state/proof_reuse.md`.

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
      "retire_state"
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
      "retire_state"
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
      "retire_state"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/_coq_builds/MutexDelete-vc-proving-r1/group_00/src/.coq_debug/group_00_retire_state.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_00__retire_state/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_00__retire_state/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
