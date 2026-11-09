# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `preparation_projection`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/KEventDelete-vc-proving-r1/groups/group_01__preparation_projection/KEventDelete_proof_manual.v`.
- Editable proof spans: `proof_of_KEventDelete_partial_solve_wit_1_pure`, `proof_of_KEventDelete_partial_solve_wit_1`, `proof_of_KEventDelete_partial_solve_wit_2_pure`, `proof_of_KEventDelete_partial_solve_wit_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/KEventDelete-vc-proving-r1/groups/group_01__preparation_projection/KEventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/KEventDelete_lib.v`
- Every new/adapted helper uses suffix `__preparation_projection`. Preserve the seed.

### `proof_of_KEventDelete_partial_solve_wit_1_pure` — `LLM_pre_process`

Pure projection: the antecedent owns the id local and OutsideCritical sg before; the consequent asks only for safeExec abs_event_delete already present as PreH3. Introduce binders and embed PreH3 into the pure assertion; there are no existential witnesses or state changes.
### `proof_of_KEventDelete_partial_solve_wit_1` — `LLM_pre_process`

Unfold the generated implication and auxiliary goal, introduce its pure-VC premise, and prove the auxiliary directly. Keep OutsideCritical sg before unchanged, conjoin the safeExec fact PreH3 twice and bounds PreH1/PreH2. No resource decomposition or existential is needed; the pure-VC argument may be unused because all its conclusions are explicit local premises.
### `proof_of_KEventDelete_partial_solve_wit_2_pure` — `LLM_pre_process`

Project bounds PreH2/PreH3 and lookup safeExec PreH1 into the pure conjunction. The antecedent carries uninitialized event local, initialized id local, and OutsideCritical sg before; no ownership is demanded on the right and no refinement or witness is needed.
### `proof_of_KEventDelete_partial_solve_wit_2` — `LLM_pre_process`

Unfold the implication/auxiliary goal and retain OutsideCritical sg before identically. Every pure conjunct is a repetition of PreH1 through PreH4: lookup safeExec, bounds, and public delete safeExec. Introduce the pure-VC argument but discharge directly from these explicit premises; no heap transformation or abstract-state change.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-proving-r1/groups/group_01__preparation_projection/proof_reuse.md`.

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
      "preparation_projection"
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
      "preparation_projection"
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
      "preparation_projection"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/KEventDelete-20261103211513/_coq_builds/KEventDelete-vc-proving-r1/group_01/src/.coq_debug/group_01_preparation_projection.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-proving-r1/groups/group_01__preparation_projection/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-proving-r1/groups/group_01__preparation_projection/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
