# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `inspect_continuations`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_02__inspect_continuations/EventDelete_proof_manual.v`.
- Editable proof spans: `proof_of__EventDelete_which_implies_wit_3`, `proof_of__EventDelete_which_implies_wit_3_split_goal_1`, `proof_of__EventDelete_which_implies_wit_3_split_goal_2`, `proof_of__EventDelete_which_implies_wit_4`, `proof_of__EventDelete_which_implies_wit_4_split_goal_1`, `proof_of__EventDelete_which_implies_wit_5`, `proof_of__EventDelete_which_implies_wit_5_split_goal_1`, `proof_of__EventDelete_which_implies_wit_5_split_goal_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_02__inspect_continuations/EventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventDelete_lib.v`
- Every new/adapted helper uses suffix `__inspect_continuations`. Preserve the seed.

### `proof_of__EventDelete_which_implies_wit_3` — `aggressive_pre_process`

- Split `proof_of__EventDelete_which_implies_wit_3_split_goal_1`: P includes safeExec(LastSeen before)(abs_event_delete_at id p)X and a valid inspected state checked with event_pending_at id p waiting checked. Use event_delete_gap to realize the first guarded atomic inspection. In wit_3, map waiting<>[] gives nonempty=true and leaves bind(abs_event_resume_all)(finish true), hence the ResumeAll continuation weakestpre(finish true)X. In wit_5, map waiting=[] gives waiting=[]/nonempty=false and the ret step reduces to event_delete_finish false. Repackage LastSeen checked with the same X; retain no stale waiting snapshot across the subsequent environment gap.

- Split `proof_of__EventDelete_which_implies_wit_3_split_goal_2`: For wit_3 obtain guard false checked directly from event_delete_gap. For wit_5 combine that live guard with event_pending_at and map event_wait_node waiting=[] (hence waiting=[]) to establish guard true checked. These goals are pure and use no hidden ownership.
### `proof_of__EventDelete_which_implies_wit_4` — `aggressive_pre_process`

- Split `proof_of__EventDelete_which_implies_wit_4_split_goal_1`: Unfold event_delete_resume_cont. P is safeExec(LastSeen drained)(ret tt)(fun _ states => weakestpre (event_delete_finish id p true) X states). Ret has identity nrm and no errors, so the same LastSeen witness yields safeExec(LastSeen drained)(event_delete_finish id p true)X. Use ret/WLP connection; do not substitute caller X directly for the ResumeAll continuation.
### `proof_of__EventDelete_which_implies_wit_5` — `aggressive_pre_process`

- Split `proof_of__EventDelete_which_implies_wit_5_split_goal_1`: P includes safeExec(LastSeen before)(abs_event_delete_at id p)X and a valid inspected state checked with event_pending_at id p waiting checked. Use event_delete_gap to realize the first guarded atomic inspection. In wit_3, map waiting<>[] gives nonempty=true and leaves bind(abs_event_resume_all)(finish true), hence the ResumeAll continuation weakestpre(finish true)X. In wit_5, map waiting=[] gives waiting=[]/nonempty=false and the ret step reduces to event_delete_finish false. Repackage LastSeen checked with the same X; retain no stale waiting snapshot across the subsequent environment gap.

- Split `proof_of__EventDelete_which_implies_wit_5_split_goal_2`: For wit_3 obtain guard false checked directly from event_delete_gap. For wit_5 combine that live guard with event_pending_at and map event_wait_node waiting=[] (hence waiting=[]) to establish guard true checked. These goals are pure and use no hidden ownership.

## Helpers

- `event_inspection_residual__inspect_continuations` (local): Statement: event_delete_gap id p false before checked, event_pending_at id p waiting checked and safeExec(LastSeen before)(abs_event_delete_at id p)X imply the branch residual safeExec after the actual inspection, with branch b=negb(length waiting=0). Prove by constructing the inspection nrm step, bind WLP, and ret identity; specialize map-nil facts to b. No restriction on later waiting sequence is introduced.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_02__inspect_continuations/proof_reuse.md`.

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
      "EventDelete-20261103173023",
      "--round",
      "EventDelete-vc-proving-r1",
      "--group",
      "inspect_continuations"
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
      "EventDelete-20261103173023",
      "--round",
      "EventDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "inspect_continuations"
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
      "EventDelete-20261103173023",
      "--round",
      "EventDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "inspect_continuations"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/_coq_builds/EventDelete-vc-proving-r1/group_02/src/.coq_debug/group_02_inspect_continuations.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_02__inspect_continuations/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_02__inspect_continuations/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
