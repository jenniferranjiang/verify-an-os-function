# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `numeric_call_bounds`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_06__numeric_call_bounds/SemaphoreDelete_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_entail_wit_1`, `proof_of__SemaphoreDelete_partial_solve_wit_3_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1`, `proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2`, `proof_of__SemaphoreDelete_partial_solve_wit_3`, `proof_of__SemaphoreDelete_partial_solve_wit_17_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1`, `proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2`, `proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3`, `proof_of__SemaphoreDelete_partial_solve_wit_18_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1`, `proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2`, `proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_06__numeric_call_bounds/SemaphoreDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/SemaphoreDelete_lib.v`
- Every new/adapted helper uses suffix `__numeric_call_bounds`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreDelete_entail_wit_1` — `LLM_pre_process`

After LLM_pre_process obtain the signed 32-bit range of id_pre from the existing Int cell at &id using the store-Int range entailment. Keep that cell and OutsideCritical unchanged and reintroduce the given safeExec pure fact.
### `proof_of__SemaphoreDelete_partial_solve_wit_3_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1`: Use aggressive_pre_process on the parent; prove this split only. unsigned_last_nbits id_pre 16 is nonnegative by the standard unsigned truncation/modulo bound; 2^16=65536>0.

- Split `proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2`: Use aggressive_pre_process on the parent; prove this split only. Use the strict upper truncation bound unsigned_last_nbits id_pre 16 < 2^16 = 65536.
### `proof_of__SemaphoreDelete_partial_solve_wit_3` — `LLM_pre_process`

Use LLM_pre_process. If the statement is a _pure -> _aux wrapper, introduce the implication and unfold the matching _aux; do not require the vanished C-local cells of the separate pure witness. The remaining manager, delete_manager_frame and InsideCritical are identical on both sides. Derive unsigned_last_nbits(id_pre,16) in [0,65536) from its mathematical definition, reinsert the existing bounds/rely/safeExec facts and cancel resources.
### `proof_of__SemaphoreDelete_partial_solve_wit_17_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1`: Use aggressive_pre_process on the parent; prove this split only. Use CNotation.addr_of_LE_var_not_zero for the global k_sem_id_manager address.

- Split `proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2`: Use aggressive_pre_process on the parent; prove this split only. Rewrite original.id=unsigned_last_nbits(id_pre,16) and use nonnegative truncation bound.

- Split `proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3`: Use aggressive_pre_process on the parent; prove this split only. Rewrite original.id=unsigned_last_nbits(id_pre,16) and use strict upper bound 2^16=65536.
### `proof_of__SemaphoreDelete_partial_solve_wit_18_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1`: Use aggressive_pre_process on the parent; prove this split only. Use CNotation.addr_of_LE_var_not_zero for k_sem_id_manager.

- Split `proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2`: Use aggressive_pre_process on the parent; prove this split only. Rewrite original.id by the given uint16 truncation equality, then use its lower bound.

- Split `proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3`: Use aggressive_pre_process on the parent; prove this split only. Rewrite original.id by the given uint16 truncation equality, then use its strict 65536 upper bound.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_06__numeric_call_bounds/proof_reuse.md`.

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
      "numeric_call_bounds"
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
      "numeric_call_bounds"
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
      "numeric_call_bounds"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r1/group_06/src/.coq_debug/group_06_numeric_call_bounds.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_06__numeric_call_bounds/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_06__numeric_call_bounds/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
