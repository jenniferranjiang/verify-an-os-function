# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `rollback_restore`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/EventCreate-vc-proving-r1/groups/group_03__rollback_restore/EventCreate_proof_manual.v`.
- Editable proof spans: `proof_of__EventCreate_which_implies_wit_3`, `proof_of__EventCreate_which_implies_wit_3_split_goal_1`, `proof_of__EventCreate_which_implies_wit_3_split_goal_2`, `proof_of__EventCreate_which_implies_wit_3_split_goal_spatial`, `proof_of__EventCreate_partial_solve_wit_8_pure`, `proof_of__EventCreate_partial_solve_wit_8`, `proof_of__EventCreate_partial_solve_wit_9`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/EventCreate-vc-proving-r1/groups/group_03__rollback_restore/EventCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventcreate-trial-261101-1/VC/EventCreate_lib.v`
- Every new/adapted helper uses suffix `__rollback_restore`. Preserve the seed.

### `proof_of__EventCreate_which_implies_wit_3` — `aggressive_pre_process`

- Split `proof_of__EventCreate_which_implies_wit_3_split_goal_1`: Unfold Crtos_GTrans/CriticalSTS; establish the st_lock self transition. Resources remain irrelevant to the pure target.

- Split `proof_of__EventCreate_which_implies_wit_3_split_goal_2`: Use safeExec choice/task_atomic_cmd: LastSeen before contains st_lock by the explicit RTrans premise; select locked failure result -5 and after=st_lock. The atomic result set is LastSeen st_lock, yielding safeExec(ret -5) X. This branch requires no full-manager claim.

- Split `proof_of__EventCreate_which_implies_wit_3_split_goal_spatial`: Unfold event_create_frame. Obtain event_context from os_world_wf/os_global_context; its global addresses reconnect the unchanged manager and DLL to event_inv. Reassemble os_inv at st_lock. Fold EventRaw from insert-ready ID ownership, forgetting options/events zero values, converting NodeZero to NodeStorage and EventPadding to undef bytes. Nonnull/alignment are explicit premises. Do not claim the ID scalar is still zero after failed insertion.
### `proof_of__EventCreate_partial_solve_wit_8_pure` — `LLM_pre_process`

The required Crtos_GTrans st_lock st_lock is already PreH2; lift it to a pure assertion under the unchanged heap.
### `proof_of__EventCreate_partial_solve_wit_8` — `LLM_pre_process`

Introduce the _pure implication premise, unfold the aux and cancel/reorder os_inv, EventRaw and InsideCritical. Every requested pure assertion, including the self transition and safeExec ret(-5), is already an explicit PreH; do not instantiate absent local cells.
### `proof_of__EventCreate_partial_solve_wit_9` — `LLM_pre_process`

All pure facts are explicit. Commute EventRaw and OutsideCritical and cancel; the full original object remains available for the free call.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_03__rollback_restore/proof_reuse.md`.

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
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-debug",
      "--run",
      "EventCreate-20261101232623",
      "--round",
      "EventCreate-vc-proving-r1",
      "--group",
      "rollback_restore"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-check",
      "--run",
      "EventCreate-20261101232623",
      "--round",
      "EventCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "rollback_restore"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-check",
      "--run",
      "EventCreate-20261101232623",
      "--round",
      "EventCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "rollback_restore"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/_coq_builds/EventCreate-vc-proving-r1/group_03/src/.coq_debug/group_03_rollback_restore.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_03__rollback_restore/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_03__rollback_restore/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
