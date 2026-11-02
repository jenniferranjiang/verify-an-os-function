# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `publish_invariant`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_02__publish_invariant/MutexCreate_proof_manual.v`.
- Editable proof spans: `proof_of__MutexCreate_which_implies_wit_6`, `proof_of__MutexCreate_which_implies_wit_6_split_goal_1`, `proof_of__MutexCreate_which_implies_wit_6_split_goal_2`, `proof_of__MutexCreate_which_implies_wit_6_split_goal_3`, `proof_of__MutexCreate_which_implies_wit_6_split_goal_4`, `proof_of__MutexCreate_which_implies_wit_6_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_02__publish_invariant/MutexCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/VC/MutexCreate_lib.v`
- Every new/adapted helper uses suffix `__publish_invariant`. Preserve the seed.

### `proof_of__MutexCreate_which_implies_wit_6` — `aggressive_pre_process`

- Split `proof_of__MutexCreate_which_implies_wit_6_split_goal_1`: Unfold the shared Crtos_GTrans/CriticalSTS relation. Crtos_CS.critical_STS_transition is fun _ _ => True, so the required guarantee between locked st and its published state is permitted by the shared protocol; use the existing relation constructors/closure facts. Do not invent a stronger task-preservation protocol or fabricate an InsideCritical token. This is a pure relation, not ownership.

- Split `proof_of__MutexCreate_which_implies_wit_6_split_goal_2`: Use original safeExec and Crtos_RTrans before st to select locked st in task_atomic_cmd. abs_mutex_create_locked succeeds with p=mutex, id=id and after=replace_mutexes (mutex_publish p id st.os_mutexes) st. Nonzero/alignment/fresh/min-free are exactly PreH1/2/5/4. Derive continuation safeExec on LastSeen after and ret id from that normal transition.

- Split `proof_of__MutexCreate_which_implies_wit_6_split_goal_3`: Unfold idmanager_min_free_id and mutex_context; manager idmax=128. Its range component gives id<128. Spatial frame is irrelevant to the arithmetic.

- Split `proof_of__MutexCreate_which_implies_wit_6_split_goal_4`: Same min-free range component yields 0<=id; do not infer this merely from the C branch.

- Split `proof_of__MutexCreate_which_implies_wit_6_split_goal_spatial`: Rewrite dll_insert_after_dispatch at head to cons, matching map mutex_link_node (mutex_publish p id old). Prove mutex_manager_publish__publish_invariant to identify updated bitmap ID list and hash bucket sequence with the derived manager of the published object list. Extract os_world_wf from the frame; empty new pending_addrs preserves mutex_waiters and os_sched_owners, every other state projection and service-slot fact. Fold new mutex_inv using the unchanged mutex_context, transport nonmutex resources through replace_mutexes, and reconstruct os_inv of the exact published state.

## Helpers

- `mutex_manager_publish__publish_invariant` (public): For stable ms with hoffset=16 and id within the min-free range, prove mutex_manager (mutex_created p id::old) = idmanager_link ms (idmanager_add (mutex_manager old) id) id (&(p#Mutex->id)). Record equality reduces to id::map mutex_id old and 16 hash buckets. Use pointwise list equality/Znth; at index id mod16, filtered cons adds the new ID node, at every other index it does not. Prove 0<=id mod16<16, length(seq 0 16)=16 and replace_Znth bounds explicitly.
- `mutex_publish_world_wf__publish_invariant` (public): Prove os_world_wf sg st -> os_world_wf sg (replace_mutexes (mutex_publish p id st.os_mutexes) st). New pending list=nil, so mutex_waiters and os_sched_owners remain equal; tasks, recycler, idle and all referenced task-map fields remain unchanged. Rebuild all record fields.
- `mutex_success_continuation__publish_invariant` (public): Given safeExec (LastSeen before) (abs_mutex_create sg) X, Crtos_RTrans before st, p<>0, alignment, freshness in old object addresses and min-free id, prove safeExec (LastSeen (replace_mutexes (mutex_publish p id st.os_mutexes) st)) (ret id) X. Use choice/task_atomic normal execution, existential p, and exact post-state equality; prove using monad semantics without introducing trusted declarations.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_02__publish_invariant/proof_reuse.md`.

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
      "publish_invariant"
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
      "publish_invariant"
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
      "publish_invariant"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/_coq_builds/MutexCreate-vc-proving-r1/group_02/src/.coq_debug/group_02_publish_invariant.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_02__publish_invariant/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_02__publish_invariant/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
