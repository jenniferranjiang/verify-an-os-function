# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `lookup_continuation`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/KEventDelete-vc-proving-r1/groups/group_00__lookup_continuation/KEventDelete_proof_manual.v`.
- Editable proof spans: `proof_of_KEventDelete_return_wit_1`, `proof_of_KEventDelete_return_wit_1_split_goal_1`, `proof_of_KEventDelete_which_implies_wit_1`, `proof_of_KEventDelete_which_implies_wit_1_split_goal_1`, `proof_of_KEventDelete_which_implies_wit_2`, `proof_of_KEventDelete_which_implies_wit_2_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/KEventDelete-vc-proving-r1/groups/group_00__lookup_continuation/KEventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/KEventDelete_lib.v`
- Every new/adapted helper uses suffix `__lookup_continuation`. Preserve the seed.

### `proof_of_KEventDelete_return_wit_1` — `aggressive_pre_process`

- Split `proof_of_KEventDelete_return_wit_1_split_goal_1`: Pure target, no spatial resources or existential. PreH3 gives safeExec (LastSeen looked_up) (ret 0) (kevent_delete_lookup_cont id_pre X). Open safeExec, retain the same semantic-state witness and LastSeen fact, use wp_ret to obtain the continuation at pointer 0, unfold kevent_delete_lookup_cont and reduce Z.eqb 0 0. This is weakestpre (ret tt) X at that same state; reconstruct safeExec. No transition of looked_up or new heap resource is required.
### `proof_of_KEventDelete_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of_KEventDelete_which_implies_wit_1_split_goal_1`: Pure target, no spatial resources. PreH1 supplies safeExec (LastSeen before) (abs_event_delete id) X. Open safeExec and retain its state witness and LastSeen fact. Unfold abs_event_delete into bind (abs_find_event id) (fun p => if Z.eqb p 0 then ret tt else abs_event_delete_at id p); wp_bind changes weakestpre of this bind into weakestpre of abs_find_event under the continuation. Fold kevent_delete_lookup_cont and rebuild safeExec using the same source state. Use the imported MonadErrHoare.wp_bind equality pointwise; no extra guard or helper premise is needed.
### `proof_of_KEventDelete_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of_KEventDelete_which_implies_wit_2_split_goal_1`: Pure target, no spatial resources. PreH2 supplies safeExec (LastSeen looked_up) (ret event) (kevent_delete_lookup_cont id X). Preserve its semantic-state witness and LastSeen fact, use wp_ret, and unfold the continuation. PreH1 event <> 0 proves Z.eqb event 0 = false. The remaining weakestpre is abs_event_delete_at id event under X; rebuild safeExec at the same looked_up state. This exposes the pending deletion, without asserting any post-deletion state.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-proving-r1/groups/group_00__lookup_continuation/proof_reuse.md`.

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
      "KEventDelete-20261103211513",
      "--round",
      "KEventDelete-vc-proving-r1",
      "--group",
      "lookup_continuation"
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
      "KEventDelete-20261103211513",
      "--round",
      "KEventDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "lookup_continuation"
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
      "KEventDelete-20261103211513",
      "--round",
      "KEventDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "lookup_continuation"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/_coq_builds/KEventDelete-vc-proving-r1/group_00/src/.coq_debug/group_00_lookup_continuation.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-proving-r1/groups/group_00__lookup_continuation/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-proving-r1/groups/group_00__lookup_continuation/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
