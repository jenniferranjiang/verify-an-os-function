# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `atomic_exit`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_05__atomic_exit/EventLinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_which_implies_wit_9`, `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1`, `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2`, `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3`, `proof_of_LinklistResumeAll_partial_solve_wit_15_pure`, `proof_of_LinklistResumeAll_partial_solve_wit_15`, `proof_of_LinklistResumeAll_partial_solve_wit_16_pure`, `proof_of_LinklistResumeAll_partial_solve_wit_16`, `proof_of_LinklistResumeAll_return_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_05__atomic_exit/EventLinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventLinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__atomic_exit`. Preserve the seed.

### `proof_of_LinklistResumeAll_which_implies_wit_9` — `aggressive_pre_process`

- Split `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1`: Use remaining=nil and event_resume_remaining_effect to obtain event_resume_all_effect p waiting locked current by supplying the empty remaining effect current=current. Unfold the guarded atomic program in the original safeExec; gap provides allowed locked observation and initial pending. Instantiate its normal transition with locked,current to derive safeExec(LastSeen current,ret tt,X). The helper guarded_resume_commit__atomic_exit may package this pure bridge.

- Split `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2`: Unfold Crtos_GTrans and the existing universal transition; the result holds for locked/current without a state-equality premise.

- Split `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3`: Unfold the old live gap to retain p<>0. Combine it with event_pending_at id p nil current (from remaining=nil) to build the empty guard. Do not use an unavailable post-state heap or assume pointer nonzero from a pure address alone.
### `proof_of_LinklistResumeAll_partial_solve_wit_15_pure` — `LLM_pre_process`

All six required exit facts are explicit PreHs: current pending, remaining-progress, nil remaining, original gap, locked waiting and original safeExec. Project them without unfolding the loop effect.
### `proof_of_LinklistResumeAll_partial_solve_wit_15` — `LLM_pre_process`

Introduce the pure helper premise; unfold auxiliary goal and cancel unchanged os_inv(current)/InsideCritical(locked). Reassert all listed exit facts, with next=list_pre and remaining=nil from the branch.
### `proof_of_LinklistResumeAll_partial_solve_wit_16_pure` — `LLM_pre_process`

Project Crtos_GTrans locked current already established at the commit which-implies step; spatial resources are framed.
### `proof_of_LinklistResumeAll_partial_solve_wit_16` — `LLM_pre_process`

Unfold the auxiliary goal after introducing its pure theorem argument; retain the same current os_inv and locked critical token, reordering separating conjunction as required. All post pure facts are already premises.
### `proof_of_LinklistResumeAll_return_wit_1` — `LLM_pre_process`

Choose after=current. Use the empty guard and completed continuation already in context; 0=0 is reflexive. Return the existing OutsideCritical sg current unchanged.

## Helpers

- `guarded_resume_commit__atomic_exit` (public): Pure bridge: event_delete_gap id p false before locked, event_pending_at id p waiting locked, event_resume_all_effect p waiting locked current, and safeExec(LastSeen before,abs_event_resume_all id p,X) imply safeExec(LastSeen current,ret tt,X). Unfold LastSeen/guarded atomic normal relation, use the actual locked/current transition and the same allowed state-set witness; use weakest-precondition/normal-step safeExec elimination. No added transition, heap or environmental assumption.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_05__atomic_exit/proof_reuse.md`.

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
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-vc-proving-r1",
      "--group",
      "atomic_exit"
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
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "atomic_exit"
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
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "atomic_exit"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/_coq_builds/EventLinklistResumeAll-vc-proving-r1/group_05/src/.coq_debug/group_05_atomic_exit.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_05__atomic_exit/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_05__atomic_exit/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
