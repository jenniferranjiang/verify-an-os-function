# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `resume_call_frame`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_15__resume_call_frame/EventDelete_proof_manual.v`.
- Editable proof spans: `proof_of__EventDelete_partial_solve_wit_8_pure`, `proof_of__EventDelete_partial_solve_wit_8`, `proof_of__EventDelete_partial_solve_wit_9_pure`, `proof_of__EventDelete_partial_solve_wit_9`, `proof_of__EventDelete_partial_solve_wit_11_pure`, `proof_of__EventDelete_partial_solve_wit_11`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_15__resume_call_frame/EventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventDelete_lib.v`
- Every new/adapted helper uses suffix `__resume_call_frame`. Preserve the seed.

### `proof_of__EventDelete_partial_solve_wit_8_pure` — `LLM_pre_process`

P/Q preserve OutsideCritical checked and already derived inspection/member/continuation facts. For 8 and 11, project the pending/gap/map-nil or nonnil/safeExec tuple; for 9 the ResumeAll guard and WLP continuation already occur in P, and pending_head address equality is definitional or symmetric to its premise. Implication wrappers repeat these pure facts and cancel the same OutsideCritical. No new resource or stale-state equality is inferred. Exact obligation: partial_solve_wit_8_pure.
### `proof_of__EventDelete_partial_solve_wit_8` — `LLM_pre_process`

P/Q preserve OutsideCritical checked and already derived inspection/member/continuation facts. For 8 and 11, project the pending/gap/map-nil or nonnil/safeExec tuple; for 9 the ResumeAll guard and WLP continuation already occur in P, and pending_head address equality is definitional or symmetric to its premise. Implication wrappers repeat these pure facts and cancel the same OutsideCritical. No new resource or stale-state equality is inferred. Exact obligation: partial_solve_wit_8.
### `proof_of__EventDelete_partial_solve_wit_9_pure` — `LLM_pre_process`

P/Q preserve OutsideCritical checked and already derived inspection/member/continuation facts. For 8 and 11, project the pending/gap/map-nil or nonnil/safeExec tuple; for 9 the ResumeAll guard and WLP continuation already occur in P, and pending_head address equality is definitional or symmetric to its premise. Implication wrappers repeat these pure facts and cancel the same OutsideCritical. No new resource or stale-state equality is inferred. Exact obligation: partial_solve_wit_9_pure.
### `proof_of__EventDelete_partial_solve_wit_9` — `LLM_pre_process`

P/Q preserve OutsideCritical checked and already derived inspection/member/continuation facts. For 8 and 11, project the pending/gap/map-nil or nonnil/safeExec tuple; for 9 the ResumeAll guard and WLP continuation already occur in P, and pending_head address equality is definitional or symmetric to its premise. Implication wrappers repeat these pure facts and cancel the same OutsideCritical. No new resource or stale-state equality is inferred. Exact obligation: partial_solve_wit_9.
### `proof_of__EventDelete_partial_solve_wit_11_pure` — `LLM_pre_process`

P/Q preserve OutsideCritical checked and already derived inspection/member/continuation facts. For 8 and 11, project the pending/gap/map-nil or nonnil/safeExec tuple; for 9 the ResumeAll guard and WLP continuation already occur in P, and pending_head address equality is definitional or symmetric to its premise. Implication wrappers repeat these pure facts and cancel the same OutsideCritical. No new resource or stale-state equality is inferred. Exact obligation: partial_solve_wit_11_pure.
### `proof_of__EventDelete_partial_solve_wit_11` — `LLM_pre_process`

P/Q preserve OutsideCritical checked and already derived inspection/member/continuation facts. For 8 and 11, project the pending/gap/map-nil or nonnil/safeExec tuple; for 9 the ResumeAll guard and WLP continuation already occur in P, and pending_head address equality is definitional or symmetric to its premise. Implication wrappers repeat these pure facts and cancel the same OutsideCritical. No new resource or stale-state equality is inferred. Exact obligation: partial_solve_wit_11.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_15__resume_call_frame/proof_reuse.md`.

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
      "resume_call_frame"
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
      "resume_call_frame"
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
      "resume_call_frame"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/_coq_builds/EventDelete-vc-proving-r1/group_15/src/.coq_debug/group_15_resume_call_frame.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_15__resume_call_frame/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_15__resume_call_frame/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
