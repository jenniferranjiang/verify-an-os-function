# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `inspection_entry`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_12__inspection_entry/EventDelete_proof_manual.v`.
- Editable proof spans: `proof_of__EventDelete_partial_solve_wit_1_pure`, `proof_of__EventDelete_partial_solve_wit_1`, `proof_of__EventDelete_partial_solve_wit_2_pure`, `proof_of__EventDelete_partial_solve_wit_2`, `proof_of__EventDelete_partial_solve_wit_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_12__inspection_entry/EventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventDelete_lib.v`
- Every new/adapted helper uses suffix `__inspection_entry`. Preserve the seed.

### `proof_of__EventDelete_partial_solve_wit_1_pure` — `LLM_pre_process`

P/Q retain the initial OutsideCritical or newly acquired InsideCritical/os_inv and unchanged locals. Guard/gap facts in Q are already PreH premises. For *_pure project them; for implication wrappers introduce the named pure premise and prove the aux by pure restatement and sep cancellation. For wit_3 the same pending DLL/wand/InsideCritical are merely re-presented. Exact obligation: partial_solve_wit_1_pure.
### `proof_of__EventDelete_partial_solve_wit_1` — `LLM_pre_process`

P/Q retain the initial OutsideCritical or newly acquired InsideCritical/os_inv and unchanged locals. Guard/gap facts in Q are already PreH premises. For *_pure project them; for implication wrappers introduce the named pure premise and prove the aux by pure restatement and sep cancellation. For wit_3 the same pending DLL/wand/InsideCritical are merely re-presented. Exact obligation: partial_solve_wit_1.
### `proof_of__EventDelete_partial_solve_wit_2_pure` — `LLM_pre_process`

P/Q retain the initial OutsideCritical or newly acquired InsideCritical/os_inv and unchanged locals. Guard/gap facts in Q are already PreH premises. For *_pure project them; for implication wrappers introduce the named pure premise and prove the aux by pure restatement and sep cancellation. For wit_3 the same pending DLL/wand/InsideCritical are merely re-presented. Exact obligation: partial_solve_wit_2_pure.
### `proof_of__EventDelete_partial_solve_wit_2` — `LLM_pre_process`

P/Q retain the initial OutsideCritical or newly acquired InsideCritical/os_inv and unchanged locals. Guard/gap facts in Q are already PreH premises. For *_pure project them; for implication wrappers introduce the named pure premise and prove the aux by pure restatement and sep cancellation. For wit_3 the same pending DLL/wand/InsideCritical are merely re-presented. Exact obligation: partial_solve_wit_2.
### `proof_of__EventDelete_partial_solve_wit_3` — `LLM_pre_process`

P/Q retain the initial OutsideCritical or newly acquired InsideCritical/os_inv and unchanged locals. Guard/gap facts in Q are already PreH premises. For *_pure project them; for implication wrappers introduce the named pure premise and prove the aux by pure restatement and sep cancellation. For wit_3 the same pending DLL/wand/InsideCritical are merely re-presented. Exact obligation: partial_solve_wit_3.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_12__inspection_entry/proof_reuse.md`.

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
      "inspection_entry"
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
      "inspection_entry"
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
      "inspection_entry"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/_coq_builds/EventDelete-vc-proving-r1/group_12/src/.coq_debug/group_12_inspection_entry.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_12__inspection_entry/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_12__inspection_entry/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
