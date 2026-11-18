# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `return_and_irq_frames`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/DeInitDataqueue-vc-proving-r1/groups/group_05__return_and_irq_frames/DeInitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_DeInitDataqueue_return_wit_1`, `proof_of_DeInitDataqueue_partial_solve_wit_1`, `proof_of_DeInitDataqueue_partial_solve_wit_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_DeInitDataqueue_return_wit_1` — `LLM_pre_process`

Choose after=final and cancel retired object and OutsideCritical; continuation is exactly the saved premise.
### `proof_of_DeInitDataqueue_partial_solve_wit_1` — `LLM_pre_process`

Retain original safeExec pure fact and commute private store_dataqueue with OutsideCritical for Disable call; exact frame cancellation.
### `proof_of_DeInitDataqueue_partial_solve_wit_2` — `LLM_pre_process`

Project saved RTrans/safeExec/two quiescent facts and reorder private object/InsideCritical/os_inv; no new condition introduced.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_05__return_and_irq_frames/proof_reuse.md`.

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
      "/home/xinra/crtos-verify",
      "coq-debug",
      "--run",
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--group",
      "return_and_irq_frames"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "return_and_irq_frames"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "return_and_irq_frames"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/_coq_builds/DeInitDataqueue-vc-proving-r1/group_05/src/.coq_debug/group_05_return_and_irq_frames.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_05__return_and_irq_frames/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_05__return_and_irq_frames/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
