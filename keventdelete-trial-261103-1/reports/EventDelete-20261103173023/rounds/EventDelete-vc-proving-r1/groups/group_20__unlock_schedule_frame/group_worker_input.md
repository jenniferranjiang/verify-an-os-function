# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `unlock_schedule_frame`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_20__unlock_schedule_frame/EventDelete_proof_manual.v`.
- Editable proof spans: `proof_of__EventDelete_partial_solve_wit_26_pure`, `proof_of__EventDelete_partial_solve_wit_26`, `proof_of__EventDelete_partial_solve_wit_27_pure`, `proof_of__EventDelete_partial_solve_wit_27`, `proof_of__EventDelete_partial_solve_wit_32_pure`, `proof_of__EventDelete_partial_solve_wit_32`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_20__unlock_schedule_frame/EventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventDelete_lib.v`
- Every new/adapted helper uses suffix `__unlock_schedule_frame`. Preserve the seed.

### `proof_of__EventDelete_partial_solve_wit_26_pure` — `LLM_pre_process`

For 26/27 P already has Crtos_GTrans locked after, InsideCritical locked, os_inv after and EventRetired; pure targets project GTrans, wrappers restate the after-state/resched/continuation facts and cancel the identical resources. For 32 the post-free OutsideCritical and safeExec abs_ktask_assign are already given; project/restate them without reintroducing retired bytes. The resched=1/0 continuations remain distinct. Exact obligation: partial_solve_wit_26_pure.
### `proof_of__EventDelete_partial_solve_wit_26` — `LLM_pre_process`

For 26/27 P already has Crtos_GTrans locked after, InsideCritical locked, os_inv after and EventRetired; pure targets project GTrans, wrappers restate the after-state/resched/continuation facts and cancel the identical resources. For 32 the post-free OutsideCritical and safeExec abs_ktask_assign are already given; project/restate them without reintroducing retired bytes. The resched=1/0 continuations remain distinct. Exact obligation: partial_solve_wit_26.
### `proof_of__EventDelete_partial_solve_wit_27_pure` — `LLM_pre_process`

For 26/27 P already has Crtos_GTrans locked after, InsideCritical locked, os_inv after and EventRetired; pure targets project GTrans, wrappers restate the after-state/resched/continuation facts and cancel the identical resources. For 32 the post-free OutsideCritical and safeExec abs_ktask_assign are already given; project/restate them without reintroducing retired bytes. The resched=1/0 continuations remain distinct. Exact obligation: partial_solve_wit_27_pure.
### `proof_of__EventDelete_partial_solve_wit_27` — `LLM_pre_process`

For 26/27 P already has Crtos_GTrans locked after, InsideCritical locked, os_inv after and EventRetired; pure targets project GTrans, wrappers restate the after-state/resched/continuation facts and cancel the identical resources. For 32 the post-free OutsideCritical and safeExec abs_ktask_assign are already given; project/restate them without reintroducing retired bytes. The resched=1/0 continuations remain distinct. Exact obligation: partial_solve_wit_27.
### `proof_of__EventDelete_partial_solve_wit_32_pure` — `LLM_pre_process`

For 26/27 P already has Crtos_GTrans locked after, InsideCritical locked, os_inv after and EventRetired; pure targets project GTrans, wrappers restate the after-state/resched/continuation facts and cancel the identical resources. For 32 the post-free OutsideCritical and safeExec abs_ktask_assign are already given; project/restate them without reintroducing retired bytes. The resched=1/0 continuations remain distinct. Exact obligation: partial_solve_wit_32_pure.
### `proof_of__EventDelete_partial_solve_wit_32` — `LLM_pre_process`

For 26/27 P already has Crtos_GTrans locked after, InsideCritical locked, os_inv after and EventRetired; pure targets project GTrans, wrappers restate the after-state/resched/continuation facts and cancel the identical resources. For 32 the post-free OutsideCritical and safeExec abs_ktask_assign are already given; project/restate them without reintroducing retired bytes. The resched=1/0 continuations remain distinct. Exact obligation: partial_solve_wit_32.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_20__unlock_schedule_frame/proof_reuse.md`.

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
      "unlock_schedule_frame"
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
      "unlock_schedule_frame"
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
      "unlock_schedule_frame"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/_coq_builds/EventDelete-vc-proving-r1/group_20/src/.coq_debug/group_20_unlock_schedule_frame.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_20__unlock_schedule_frame/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_20__unlock_schedule_frame/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
