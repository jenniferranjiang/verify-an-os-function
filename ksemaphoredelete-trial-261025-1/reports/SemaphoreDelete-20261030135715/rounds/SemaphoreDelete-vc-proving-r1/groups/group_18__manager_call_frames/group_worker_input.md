# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `manager_call_frames`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_18__manager_call_frames/SemaphoreDelete_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_partial_solve_wit_15_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_15`, `proof_of__SemaphoreDelete_partial_solve_wit_16_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_16`, `proof_of__SemaphoreDelete_partial_solve_wit_17`, `proof_of__SemaphoreDelete_partial_solve_wit_18`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_18__manager_call_frames/SemaphoreDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/SemaphoreDelete_lib.v`
- Every new/adapted helper uses suffix `__manager_call_frames`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreDelete_partial_solve_wit_15_pure` — `LLM_pre_process`

Use LLM_pre_process. Pure conclusions are projections/reflexivities of the listed hypotheses; substitute sem=original.addr (and current/ID aliases) where needed. Extract those pure facts and leave the spatial frame untouched: os_inv drained and InsideCritical. No new existential state or mutation is needed.
### `proof_of__SemaphoreDelete_partial_solve_wit_15` — `LLM_pre_process`

Use LLM_pre_process. If the statement is a _pure -> _aux wrapper, introduce the implication and unfold the matching _aux; do not require the vanished C-local cells of the separate pure witness. Pure conclusions are projections/reflexivities of the listed hypotheses; substitute sem=original.addr (and current/ID aliases) where needed. Reinsert the pure conjunction and cancel exactly os_inv drained and InsideCritical. No new existential state or mutation is needed.
### `proof_of__SemaphoreDelete_partial_solve_wit_16_pure` — `LLM_pre_process`

Use LLM_pre_process. Pure conclusions are projections/reflexivities of the listed hypotheses; substitute sem=original.addr (and current/ID aliases) where needed. Extract those pure facts and leave the spatial frame untouched: os_inv drained and InsideCritical. No new existential state or mutation is needed.
### `proof_of__SemaphoreDelete_partial_solve_wit_16` — `LLM_pre_process`

Use LLM_pre_process. If the statement is a _pure -> _aux wrapper, introduce the implication and unfold the matching _aux; do not require the vanished C-local cells of the separate pure witness. Pure conclusions are projections/reflexivities of the listed hypotheses; substitute sem=original.addr (and current/ID aliases) where needed. Reinsert the pure conjunction and cancel exactly os_inv drained and InsideCritical. No new existential state or mutation is needed.
### `proof_of__SemaphoreDelete_partial_solve_wit_17` — `LLM_pre_process`

Use LLM_pre_process. If the statement is a _pure -> _aux wrapper, introduce the implication and unfold the matching _aux; do not require the vanished C-local cells of the separate pure witness. Rewrite original.id using original.id=unsigned_last_nbits(id_pre,16); use truncation bounds and addr_of_LE_var_not_zero for k_sem_id_manager. All other pure facts including NoDup are existing premises. Cancel the unchanged complete manager, delete_manager_frame and InsideCritical; do not add old manager wf to any later deletion state.
### `proof_of__SemaphoreDelete_partial_solve_wit_18` — `LLM_pre_process`

Use LLM_pre_process. If the statement is a _pure -> _aux wrapper, introduce the implication and unfold the matching _aux; do not require the vanished C-local cells of the separate pure witness. Rewrite original.id using original.id=unsigned_last_nbits(id_pre,16); use truncation bounds and addr_of_LE_var_not_zero for k_sem_id_manager. All other pure facts including NoDup are existing premises. Cancel the unchanged complete manager, delete_manager_frame and InsideCritical; do not add old manager wf to any later deletion state.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_18__manager_call_frames/proof_reuse.md`.

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
      "manager_call_frames"
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
      "manager_call_frames"
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
      "manager_call_frames"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r1/group_18/src/.coq_debug/group_18_manager_call_frames.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_18__manager_call_frames/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_18__manager_call_frames/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
