# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `branch_safety`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/EventCreate-vc-proving-r1/groups/group_07__branch_safety/EventCreate_proof_manual.v`.
- Editable proof spans: `proof_of__EventCreate_safety_wit_6`, `proof_of__EventCreate_safety_wit_7`, `proof_of__EventCreate_safety_wit_8`, `proof_of__EventCreate_safety_wit_9`, `proof_of__EventCreate_safety_wit_15`, `proof_of__EventCreate_safety_wit_16`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/EventCreate-vc-proving-r1/groups/group_07__branch_safety/EventCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventcreate-trial-261101-1/VC/EventCreate_lib.v`
- Every new/adapted helper uses suffix `__branch_safety`. Preserve the seed.

### `proof_of__EventCreate_safety_wit_6` — `LLM_pre_process`

Use retval<>0 and retval=0 to derive False; the heap is irrelevant.
### `proof_of__EventCreate_safety_wit_7` — `LLM_pre_process`

Use retval=0 and 0<retval to derive False; the heap is irrelevant.
### `proof_of__EventCreate_safety_wit_8` — `LLM_pre_process`

Unfold INT_MIN; prove 5<>INT_MIN by arithmetic under the frame.
### `proof_of__EventCreate_safety_wit_9` — `LLM_pre_process`

Unfold signed bounds and prove INT_MIN<=5<=INT_MAX.
### `proof_of__EventCreate_safety_wit_15` — `LLM_pre_process`

Unfold INT_MIN; prove 5<>INT_MIN. All rollback resources remain a frame.
### `proof_of__EventCreate_safety_wit_16` — `LLM_pre_process`

Unfold signed bounds and prove INT_MIN<=5<=INT_MAX under OutsideCritical and locals.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_07__branch_safety/proof_reuse.md`.

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
      "branch_safety"
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
      "branch_safety"
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
      "branch_safety"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/_coq_builds/EventCreate-vc-proving-r1/group_07/src/.coq_debug/group_07_branch_safety.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_07__branch_safety/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_07__branch_safety/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
