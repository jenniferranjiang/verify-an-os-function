# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `invariant_open_failure`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_01__invariant_open_failure/MutexCreate_proof_manual.v`.
- Editable proof spans: `proof_of__MutexCreate_which_implies_wit_2`, `proof_of__MutexCreate_which_implies_wit_2_split_goal_1`, `proof_of__MutexCreate_which_implies_wit_2_split_goal_2`, `proof_of__MutexCreate_which_implies_wit_2_split_goal_3`, `proof_of__MutexCreate_which_implies_wit_2_split_goal_4`, `proof_of__MutexCreate_which_implies_wit_2_split_goal_spatial`, `proof_of__MutexCreate_which_implies_wit_3`, `proof_of__MutexCreate_which_implies_wit_3_split_goal_1`, `proof_of__MutexCreate_which_implies_wit_3_split_goal_2`, `proof_of__MutexCreate_which_implies_wit_3_split_goal_spatial`, `proof_of__MutexCreate_partial_solve_wit_5`, `proof_of__MutexCreate_partial_solve_wit_6`, `proof_of__MutexCreate_partial_solve_wit_7_pure`, `proof_of__MutexCreate_partial_solve_wit_7`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_01__invariant_open_failure/MutexCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/VC/MutexCreate_lib.v`
- Every new/adapted helper uses suffix `__invariant_open_failure`. Preserve the seed.

### `proof_of__MutexCreate_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of__MutexCreate_which_implies_wit_2_split_goal_1`: P=os_inv sg st ** MutexZero p. Open os_inv/mutex_inv and the management store_dll. If p is an existing mutex_addr, expose that member payload (DLL segment split/induction) and its ushort val cell at p+12. MutexZero owns the same cell, contradicting separation. Therefore p is fresh. Global frame stays available; no allocator provenance premise is needed.

- Split `proof_of__MutexCreate_which_implies_wit_2_split_goal_2`: Extract os_world_wf from os_inv and os_wf_context/os_global_context, or the pure context in mutex_inv, to obtain mutex_context sg.os_mutex_stable. Pure heap entailment only.

- Split `proof_of__MutexCreate_which_implies_wit_2_split_goal_3`: Project p alignment from MutexZero while framing os_inv.

- Split `proof_of__MutexCreate_which_implies_wit_2_split_goal_4`: Project p<>0 from MutexZero while framing os_inv.

- Split `proof_of__MutexCreate_which_implies_wit_2_split_goal_spatial`: Open os_inv and mutex_inv, use mutex_context to rewrite the manager/list root addresses to the C globals, and fold all nonmutex resources plus os_world_wf into mutex_create_frame. Open MutexZero, weaken ZeroIdNode to store_idnode_insert_ready by existentially forgetting initial ID/link values, preserving all payload zeros, two NodeZero predicates and the two padding bytes. Reassociate/cancel; no state change.
### `proof_of__MutexCreate_which_implies_wit_3` — `aggressive_pre_process`

- Split `proof_of__MutexCreate_which_implies_wit_3_split_goal_1`: Crtos_GTrans st st follows from the reflexive critical protocol transition. P is the frame, old manager/list, and private allocated object fields; pure conclusion changes no resources.

- Split `proof_of__MutexCreate_which_implies_wit_3_split_goal_2`: Use safeExec(abs_mutex_create sg), LastSeen before, and Crtos_RTrans before st to select the task_atomic_cmd branch at locked st and abs_mutex_create_locked failure transition (-5,st). Transport the continuation to LastSeen st and ret(-5). The failure relation explicitly permits unchanged state regardless of manager fullness. Do not infer fullness from failed ID insertion.

- Split `proof_of__MutexCreate_which_implies_wit_3_split_goal_spatial`: Extract mutex_context through mutex_create_frame -> os_world_wf -> os_global_context. Rewrite the two C global addresses back to the stable roots, fold the old manager/list into mutex_inv, and combine with frame to os_inv sg st. Separately forget all private field zeros, NodeZero link values and padding bytes to build MutexRaw p. store_idnode_insert_ready already has unknown values on this failed insertion route. Alignment/nonzero supplied by PreH1/2; no memset-zero claim about the ID field is used.
### `proof_of__MutexCreate_partial_solve_wit_5` — `LLM_pre_process`

Frame permutation: P InsideCritical sg st ** os_inv sg st ** MutexZero p; Q reorders it to os_inv ** MutexZero ** InsideCritical and repeats only given PreH facts. Introduce pure facts, reassociate and cancel. No fresh state or heap witness.
### `proof_of__MutexCreate_partial_solve_wit_6` — `LLM_pre_process`

Frame permutation before IdInsertObj: move store_idmanager and store_idnode_insert_ready to the front; preserve mutex_create_frame, management DLL, all payload fields, padding, pend/management NodeZero and InsideCritical. Every pure Q fact is an explicit PreH. No allocation or ID-list change occurs here.
### `proof_of__MutexCreate_partial_solve_wit_7_pure` — `LLM_pre_process`

Failure-route projection: Q requires p<>0, alignment, two field addresses nonzero, original safeExec and Crtos_RTrans before st. These are explicit PreH6/7/13/14/20/10 (use statement rather than brittle names); spatial resources remain only to support the entailment.
### `proof_of__MutexCreate_partial_solve_wit_7` — `LLM_pre_process`

Unfold the implication and auxiliary goal. All auxiliary Q pure facts are already quantified PreH facts; reorder old manager/list, private object fields and frame. No need to consume the pure witness assumption or reconstruct missing locals. This prepares the whole which_implies_wit_3 conversion.

## Helpers

- `mutex_fresh_from_separation__invariant_open_failure` (public): Prove forall sg st p, os_inv sg st ** MutexZero p |-- pure (~In p (map mutex_addr (os_mutexes st))). By in_map_iff expose a matching management DLL payload, isolate its val cell, unfold MutexZero to its same-address val cell, and apply disjoint heap contradiction. A list induction/extraction lemma for store_dll may be local to this family. No assumption that malloc directly states freshness.
- `mutex_frame_restore__invariant_open_failure` (public): Prove frame sg st ** store_idmanager stable (mutex_manager st.os_mutexes) global_manager ** store_dll (store_mutex wait) global_list (map mutex_link_node st.os_mutexes) |-- os_inv sg st. Extract context from frame.os_world_wf, rewrite roots and fold definitions; retain exact original state.
- `mutex_failure_continuation__invariant_open_failure` (public): Pure lemma: safeExec (LastSeen before) (abs_mutex_create sg) X -> Crtos_RTrans before st -> safeExec (LastSeen st) (ret (-5)) X. Expand choice/task_atomic_cmd/safeExec via existing monad laws, use the locked failure nrm branch and the witness locked_before=locked_after=st. No heap, full-manager, or success assumption.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_01__invariant_open_failure/proof_reuse.md`.

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
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-debug",
      "--run",
      "MutexCreate-20261101164709",
      "--round",
      "MutexCreate-vc-proving-r1",
      "--group",
      "invariant_open_failure"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-check",
      "--run",
      "MutexCreate-20261101164709",
      "--round",
      "MutexCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "invariant_open_failure"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-check",
      "--run",
      "MutexCreate-20261101164709",
      "--round",
      "MutexCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "invariant_open_failure"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/_coq_builds/MutexCreate-vc-proving-r1/group_01/src/.coq_debug/group_01_invariant_open_failure.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_01__invariant_open_failure/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_01__invariant_open_failure/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
