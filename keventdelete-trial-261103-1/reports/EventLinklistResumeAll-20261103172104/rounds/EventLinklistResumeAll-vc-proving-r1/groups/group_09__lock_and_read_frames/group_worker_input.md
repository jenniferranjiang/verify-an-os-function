# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `lock_and_read_frames`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_09__lock_and_read_frames/EventLinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_partial_solve_wit_2_pure`, `proof_of_LinklistResumeAll_partial_solve_wit_2`, `proof_of_LinklistResumeAll_partial_solve_wit_3_pure`, `proof_of_LinklistResumeAll_partial_solve_wit_3`, `proof_of_LinklistResumeAll_partial_solve_wit_4`, `proof_of_LinklistResumeAll_partial_solve_wit_5`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_09__lock_and_read_frames/EventLinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventLinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__lock_and_read_frames`. Preserve the seed.

### `proof_of_LinklistResumeAll_partial_solve_wit_2_pure` — `LLM_pre_process`

Project the live gap returned by the trusted scoped lock; local cells and shared invariant are untouched.
### `proof_of_LinklistResumeAll_partial_solve_wit_2` — `LLM_pre_process`

After the pure premise theorem, reorder os_inv(locked) and InsideCritical(locked), retaining the same gap and original continuation facts.
### `proof_of_LinklistResumeAll_partial_solve_wit_3_pure` — `LLM_pre_process`

Project list_pre=event_pending_head p and current pending relation directly from the loop invariant premises.
### `proof_of_LinklistResumeAll_partial_solve_wit_3` — `LLM_pre_process`

Cancel os_inv(current) and InsideCritical(locked); retain the exact list/head/pending/progress/continuation facts without changing any logical state.
### `proof_of_LinklistResumeAll_partial_solve_wit_4` — `LLM_pre_process`

This nonempty branch is a pure-fact propagation around an already borrowed sentinel next cell. Cancel the identical pointer store, next-restore wand and saved critical token; all output facts are existing PreHs.
### `proof_of_LinklistResumeAll_partial_solve_wit_5` — `LLM_pre_process`

Empty counterpart of partial_solve_wit_4: remaining=nil and next=list_pre are present. Cancel the same borrowed pointer cell, wand and critical frame.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_09__lock_and_read_frames/proof_reuse.md`.

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
      "lock_and_read_frames"
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
      "lock_and_read_frames"
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
      "lock_and_read_frames"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/_coq_builds/EventLinklistResumeAll-vc-proving-r1/group_09/src/.coq_debug/group_09_lock_and_read_frames.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_09__lock_and_read_frames/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_09__lock_and_read_frames/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
