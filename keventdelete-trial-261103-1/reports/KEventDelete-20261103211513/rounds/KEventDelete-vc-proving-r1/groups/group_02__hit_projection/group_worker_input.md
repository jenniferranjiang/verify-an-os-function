# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `hit_projection`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/KEventDelete-vc-proving-r1/groups/group_02__hit_projection/KEventDelete_proof_manual.v`.
- Editable proof spans: `proof_of_KEventDelete_partial_solve_wit_3_pure`, `proof_of_KEventDelete_partial_solve_wit_3`, `proof_of_KEventDelete_partial_solve_wit_4_pure`, `proof_of_KEventDelete_partial_solve_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/KEventDelete-vc-proving-r1/groups/group_02__hit_projection/KEventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/KEventDelete_lib.v`
- Every new/adapted helper uses suffix `__hit_projection`. Preserve the seed.

### `proof_of_KEventDelete_partial_solve_wit_3_pure` — `LLM_pre_process`

Project retval <> 0 (PreH1 or PreH2) and lookup-return safeExec PreH4. The antecedent owns OutsideCritical sg looked_up and the event/id locals; the target is pure. No existential or new transition; nonnull is provided by the branch premises.
### `proof_of_KEventDelete_partial_solve_wit_3` — `LLM_pre_process`

Unfold implication and auxiliary goal. Frame OutsideCritical sg looked_up unchanged; all pure facts on the right, including duplicated nonnull, guard, lookup-return safeExec, lookup safeExec, bounds, and public delete safeExec, are precisely PreH1 through PreH8. Introduce the pure-VC parameter without needing to invoke it. No helper or pointer/state equality is missing.
### `proof_of_KEventDelete_partial_solve_wit_4_pure` — `LLM_pre_process`

Project event_delete_guard from PreH4 and deletion-at-pointer safeExec from PreH1. Antecedent has event/id locals and OutsideCritical sg looked_up, target only pure facts; no existential and no resource transformation.
### `proof_of_KEventDelete_partial_solve_wit_4` — `LLM_pre_process`

Unfold implication/auxiliary goal, preserve OutsideCritical sg looked_up, and conjoin exact PreH1 through PreH9 with the requested duplicates. The key deletion continuation premise is already PreH1; the guard is PreH4 and nonnull/bounds are explicit. This VC only transfers existing facts into the helper-call precondition, with no new refinement transition.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-proving-r1/groups/group_02__hit_projection/proof_reuse.md`.

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
      "KEventDelete-20261103211513",
      "--round",
      "KEventDelete-vc-proving-r1",
      "--group",
      "hit_projection"
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
      "KEventDelete-20261103211513",
      "--round",
      "KEventDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "hit_projection"
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
      "KEventDelete-20261103211513",
      "--round",
      "KEventDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "hit_projection"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/_coq_builds/KEventDelete-vc-proving-r1/group_02/src/.coq_debug/group_02_hit_projection.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-proving-r1/groups/group_02__hit_projection/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-proving-r1/groups/group_02__hit_projection/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
