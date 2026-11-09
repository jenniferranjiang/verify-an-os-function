# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `safeexec_routes`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/KMutexDelete-vc-proving-r1/groups/group_01__safeexec_routes/KMutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of_KMutexDelete_return_wit_1`, `proof_of_KMutexDelete_return_wit_1_split_goal_1`, `proof_of_KMutexDelete_return_wit_2`, `proof_of_KMutexDelete_return_wit_2_split_goal_1`, `proof_of_KMutexDelete_return_wit_3`, `proof_of_KMutexDelete_return_wit_3_split_goal_1`, `proof_of_KMutexDelete_partial_solve_wit_11_pure`, `proof_of_KMutexDelete_partial_solve_wit_11_pure_split_goal_1`, `proof_of_KMutexDelete_partial_solve_wit_11`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/KMutexDelete-vc-proving-r1/groups/group_01__safeexec_routes/KMutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/KMutexDelete_lib.v`
- Every new/adapted helper uses suffix `__safeexec_routes`. Preserve the seed.

### `proof_of_KMutexDelete_return_wit_1` — `aggressive_pre_process`

- Split `proof_of_KMutexDelete_return_wit_1_split_goal_1`: Pure safeExec obligation; there is no os_inv or query-false fact in this split. Use the current frozen protocol deliberately: Crtos_RTrans is the total relation, so LastSeen observations have the same extensional full state set. For id>=0, construct a normal lookup-miss execution of abs_mutex_delete at replace_mutexes nil st_lock, followed by ret tt. The initial safeExec then yields the same continuation at LastSeen st_lock. Use the planned void-continuation helper; do not invent manager-nonzero or a query-false premise. This proof relies on the actual current broad protocol, not a source-level null-manager execution.
### `proof_of_KMutexDelete_return_wit_2` — `aggressive_pre_process`

- Split `proof_of_KMutexDelete_return_wit_2_split_goal_1`: Use the actual miss route when convenient: idmanager_query (mutex_manager st_lock.os_mutexes) key=false excludes an equal mutex ID by its mapped idlist definition; task_atomic_cmd can choose st_lock using the given RTrans, then lookup None and ret tt. Alternatively the void-continuation helper covers this same pure conclusion. No spatial resources are needed.
### `proof_of_KMutexDelete_return_wit_3` — `aggressive_pre_process`

- Split `proof_of_KMutexDelete_return_wit_3_split_goal_1`: id_pre<0 makes abs_mutex_delete definitionally MonadErr.ret tt. Rewrite the Z.ltb test using the supplied guard; the desired safeExec is precisely the precondition with unchanged LastSeen before and X.
### `proof_of_KMutexDelete_partial_solve_wit_11_pure` — `aggressive_pre_process`

- Split `proof_of_KMutexDelete_partial_solve_wit_11_pure_split_goal_1`: All current/local cells are frame for a pure obligation. Substitute retval=original.mutex_addr and key=unsigned_last_nbits id_pre 16. The given mutex_delete_live and RTrans make the actual locked lookup return Some(p,key) at st_lock without a state update. Apply the bind/normal-execution continuation property to safeExec of abs_mutex_delete, obtaining safeExec LastSeen st_lock abs_mutex_delete_object p key X. Do not open or assume the drain/retire body effects.
### `proof_of_KMutexDelete_partial_solve_wit_11` — `LLM_pre_process`

Introduce the assumed pure VC and prove the auxiliary entailment directly using the same found-continuation helper: supplied equalities/live/RTrans establish its premises. Retain OutsideCritical(sg,st_lock) exactly; return all input pure facts and the existing live fact after rewriting retval. The pure VC argument is available but need not be applied with invented C-local cells.

## Helpers

- `mutex_delete_void_continuation__safeexec_routes` (local): Statement shape: forall id before observed X, 0<=id -> safeExec (LastSeen before) (abs_mutex_delete id) X -> safeExec (LastSeen observed) (MonadErr.ret tt) X. Prove from the actual definitions of LastSeen/Crtos_RTrans (total relation), safeExec and task_atomic_cmd. Choose the observation replace_mutexes nil observed for a normal no-hit lookup; its mutex sequence is empty, so the no-hit clause holds for every truncated id. Bind with the ret branch. All possible observation sets in LastSeen are extensionally the total relation; transfer the obtained X result and normal/safe conditions to ret. This is a theorem about the current pure abstraction, not a new trusted assumption.
- `mutex_delete_found_continuation__safeexec_routes` (local): Statement shape: forall id before observed p key X, 0<=id -> key=unsigned_last_nbits id 16 -> mutex_delete_live p key observed -> Crtos_RTrans before observed -> safeExec (LastSeen before) (abs_mutex_delete id) X -> safeExec (LastSeen observed) (abs_mutex_delete_object p key) X. Unfold the nonnegative branch; build the ordinary lookup atomic normal transition to Some(p,key) with after=observed, then use the monadic bind continuation rule. The output set is precisely Crtos_RTrans observed. No heap, new lifetime guard, or unrelated-state equality is assumed.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_01__safeexec_routes/proof_reuse.md`.

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
      "safeexec_routes"
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
      "safeexec_routes"
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
      "safeexec_routes"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/_coq_builds/KMutexDelete-vc-proving-r1/group_01/src/.coq_debug/group_01_safeexec_routes.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_01__safeexec_routes/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_01__safeexec_routes/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
