# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `atomic_commit`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/FindEventById-vc-proving-r1/groups/group_01__atomic_commit/FindEventById_proof_manual.v`.
- Editable proof spans: `proof_of_FindEventById_which_implies_wit_3`, `proof_of_FindEventById_which_implies_wit_3_split_goal_1`, `proof_of_FindEventById_which_implies_wit_3_split_goal_2`, `proof_of_FindEventById_which_implies_wit_5`, `proof_of_FindEventById_which_implies_wit_5_split_goal_1`, `proof_of_FindEventById_which_implies_wit_5_split_goal_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/FindEventById-vc-proving-r1/groups/group_01__atomic_commit/FindEventById_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/FindEventById_lib.v`
- Every new/adapted helper uses suffix `__atomic_commit`. Preserve the seed.

### `proof_of_FindEventById_which_implies_wit_3` — `aggressive_pre_process`

- Split `proof_of_FindEventById_which_implies_wit_3_split_goal_1`: The target is Crtos_GTrans st_lock st_lock. Use the existing reflexive critical transition (or unfold GTrans/current True relation); all safeExec/lookup hypotheses are irrelevant to this pure reflexivity.

- Split `proof_of_FindEventById_which_implies_wit_3_split_goal_2`: Use a new pure commit lemma instantiated with result 0. Input safeExec(LastSeen before,abs_find_event id,X), RTrans before st, 0<=id and event_lookup_result id 0 st all occur as hypotheses. Rewrite Z.ltb id 0=false, unpack safeExec and its actual state-set witness. LastSeen equates that set to RTrans before, so st is an allowed atomic observation. Exhibit the locked nrm with before=after=st and result=0, and post-set Crtos_RTrans st; the weakest-precondition normal clause yields X 0 on that set. Repackage safeExec for ret 0 and LastSeen st, retaining the SAME X. No heap premise is needed.
### `proof_of_FindEventById_which_implies_wit_5` — `aggressive_pre_process`

- Split `proof_of_FindEventById_which_implies_wit_5_split_goal_1`: Prove Crtos_GTrans st_lock st_lock by the existing reflexive critical relation; preserve no spatial resources because this split is pure.

- Split `proof_of_FindEventById_which_implies_wit_5_split_goal_2`: Use a new pure commit lemma instantiated with result event. Input safeExec(LastSeen before,abs_find_event id,X), RTrans before st, 0<=id and event_lookup_result id event st all occur as hypotheses. Rewrite Z.ltb id 0=false, unpack safeExec and its actual state-set witness. LastSeen equates that set to RTrans before, so st is an allowed atomic observation. Exhibit the locked nrm with before=after=st and result=event, and post-set Crtos_RTrans st; the weakest-precondition normal clause yields X event on that set. Repackage safeExec for ret event and LastSeen st, retaining the SAME X. No heap premise is needed.

## Helpers

- `find_event_atomic_commit__atomic_commit` (local): Prove forall id p before st X, 0<=id -> Crtos_RTrans before st -> event_lookup_result id p st -> safeExec (LastSeen before) (abs_find_event id) X -> safeExec (LastSeen st) (MonadErr.ret p) X. Unfold abs_find_event, use Z.ltb_ge, then unfold safeExec/safe/weakestpre/task_atomic_cmd/abs_find_event_locked/LastSeen as needed. Choose the post set Crtos_RTrans st and nrm before=after=st; equality-of-sets in LastSeen gives membership of st from RTrans. Ret has no err, and its only result/state is the selected p/post-set. All premises are explicit in both split-goal-2 VCs.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_01__atomic_commit/proof_reuse.md`.

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
      "atomic_commit"
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
      "atomic_commit"
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
      "atomic_commit"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/_coq_builds/FindEventById-vc-proving-r1/group_01/src/.coq_debug/group_01_atomic_commit.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_01__atomic_commit/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_01__atomic_commit/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
