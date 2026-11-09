# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `final_lock_entry`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_16__final_lock_entry/EventDelete_proof_manual.v`.
- Editable proof spans: `proof_of__EventDelete_partial_solve_wit_12_pure`, `proof_of__EventDelete_partial_solve_wit_12`, `proof_of__EventDelete_partial_solve_wit_13_pure`, `proof_of__EventDelete_partial_solve_wit_13`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_16__final_lock_entry/EventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventDelete_lib.v`
- Every new/adapted helper uses suffix `__final_lock_entry`. Preserve the seed.

### `proof_of__EventDelete_partial_solve_wit_12_pure` — `LLM_pre_process`

P has event_delete_guard id p true ready and branch-specific finish(true/false) safeExec; Q projects/repeats the same guard and retains OutsideCritical ready. *_pure needs no heap; each implication wrapper cancels the matching protocol atom and restates resched and continuation. Exact obligation: partial_solve_wit_12_pure.
### `proof_of__EventDelete_partial_solve_wit_12` — `LLM_pre_process`

P has event_delete_guard id p true ready and branch-specific finish(true/false) safeExec; Q projects/repeats the same guard and retains OutsideCritical ready. *_pure needs no heap; each implication wrapper cancels the matching protocol atom and restates resched and continuation. Exact obligation: partial_solve_wit_12.
### `proof_of__EventDelete_partial_solve_wit_13_pure` — `LLM_pre_process`

P has event_delete_guard id p true ready and branch-specific finish(true/false) safeExec; Q projects/repeats the same guard and retains OutsideCritical ready. *_pure needs no heap; each implication wrapper cancels the matching protocol atom and restates resched and continuation. Exact obligation: partial_solve_wit_13_pure.
### `proof_of__EventDelete_partial_solve_wit_13` — `LLM_pre_process`

P has event_delete_guard id p true ready and branch-specific finish(true/false) safeExec; Q projects/repeats the same guard and retains OutsideCritical ready. *_pure needs no heap; each implication wrapper cancels the matching protocol atom and restates resched and continuation. Exact obligation: partial_solve_wit_13.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_16__final_lock_entry/proof_reuse.md`.

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
      "final_lock_entry"
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
      "final_lock_entry"
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
      "final_lock_entry"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/_coq_builds/EventDelete-vc-proving-r1/group_16/src/.coq_debug/group_16_final_lock_entry.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_16__final_lock_entry/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_16__final_lock_entry/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
