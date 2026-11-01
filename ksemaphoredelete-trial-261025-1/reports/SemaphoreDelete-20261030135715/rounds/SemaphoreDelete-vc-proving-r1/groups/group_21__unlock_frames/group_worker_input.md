# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `unlock_frames`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_21__unlock_frames/SemaphoreDelete_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_partial_solve_wit_4_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_4`, `proof_of__SemaphoreDelete_partial_solve_wit_27_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_27`, `proof_of__SemaphoreDelete_partial_solve_wit_28_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_28`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_21__unlock_frames/SemaphoreDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/SemaphoreDelete_lib.v`
- Every new/adapted helper uses suffix `__unlock_frames`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreDelete_partial_solve_wit_4_pure` — `LLM_pre_process`

Use LLM_pre_process. Pure conclusions are projections/reflexivities of the listed hypotheses; substitute sem=original.addr (and current/ID aliases) where needed. Extract those pure facts and leave the spatial frame untouched: InsideCritical and os_inv st_lock. No new existential state or mutation is needed.
### `proof_of__SemaphoreDelete_partial_solve_wit_4` — `LLM_pre_process`

Use LLM_pre_process. If the statement is a _pure -> _aux wrapper, introduce the implication and unfold the matching _aux; do not require the vanished C-local cells of the separate pure witness. Pure conclusions are projections/reflexivities of the listed hypotheses; substitute sem=original.addr (and current/ID aliases) where needed. Reinsert the pure conjunction and cancel exactly InsideCritical and os_inv st_lock. No new existential state or mutation is needed.
### `proof_of__SemaphoreDelete_partial_solve_wit_27_pure` — `LLM_pre_process`

Use LLM_pre_process. Pure conclusions are projections/reflexivities of the listed hypotheses; substitute sem=original.addr (and current/ID aliases) where needed. Extract those pure facts and leave the spatial frame untouched: InsideCritical st_lock, os_inv after and SemaphoreRetired (retirement is only framed). No new existential state or mutation is needed.
### `proof_of__SemaphoreDelete_partial_solve_wit_27` — `LLM_pre_process`

Use LLM_pre_process. If the statement is a _pure -> _aux wrapper, introduce the implication and unfold the matching _aux; do not require the vanished C-local cells of the separate pure witness. Pure conclusions are projections/reflexivities of the listed hypotheses; substitute sem=original.addr (and current/ID aliases) where needed. Reinsert the pure conjunction and cancel exactly InsideCritical st_lock, os_inv after and SemaphoreRetired (retirement is only framed). No new existential state or mutation is needed.
### `proof_of__SemaphoreDelete_partial_solve_wit_28_pure` — `LLM_pre_process`

Use LLM_pre_process. Pure conclusions are projections/reflexivities of the listed hypotheses; substitute sem=original.addr (and current/ID aliases) where needed. Extract those pure facts and leave the spatial frame untouched: InsideCritical st_lock, os_inv after and SemaphoreRetired (retirement is only framed). No new existential state or mutation is needed.
### `proof_of__SemaphoreDelete_partial_solve_wit_28` — `LLM_pre_process`

Use LLM_pre_process. If the statement is a _pure -> _aux wrapper, introduce the implication and unfold the matching _aux; do not require the vanished C-local cells of the separate pure witness. Pure conclusions are projections/reflexivities of the listed hypotheses; substitute sem=original.addr (and current/ID aliases) where needed. Reinsert the pure conjunction and cancel exactly InsideCritical st_lock, os_inv after and SemaphoreRetired (retirement is only framed). No new existential state or mutation is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_21__unlock_frames/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-debug",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-proving-r1",
      "--group",
      "unlock_frames"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "unlock_frames"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "unlock_frames"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r1/group_21/src/.coq_debug/group_21_unlock_frames.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_21__unlock_frames/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_21__unlock_frames/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
