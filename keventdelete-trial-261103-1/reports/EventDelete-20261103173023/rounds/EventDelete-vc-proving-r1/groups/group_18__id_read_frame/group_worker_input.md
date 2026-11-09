# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `id_read_frame`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_18__id_read_frame/EventDelete_proof_manual.v`.
- Editable proof spans: `proof_of__EventDelete_partial_solve_wit_16`, `proof_of__EventDelete_partial_solve_wit_17`, `proof_of__EventDelete_partial_solve_wit_18_pure`, `proof_of__EventDelete_partial_solve_wit_18`, `proof_of__EventDelete_partial_solve_wit_19_pure`, `proof_of__EventDelete_partial_solve_wit_19`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_18__id_read_frame/EventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventDelete_lib.v`
- Every new/adapted helper uses suffix `__id_read_frame`. Preserve the seed.

### `proof_of__EventDelete_partial_solve_wit_16` — `LLM_pre_process`

P/Q preserve either the borrowed UShort ID cell plus event_delete_id_restore and InsideCritical (16/17), or the restored os_inv plus InsideCritical (18/19). All prefix/original/suffix, ID bounds, address/ID NoDup and manager-projection equations are existing premises from which_implies_wit_6. Project the decomposition/address in *_pure; wrappers restate pure facts and cancel the same resources. This group does not rederive uniqueness or use the new manager to reconstruct lost old facts. Exact obligation: partial_solve_wit_16.
### `proof_of__EventDelete_partial_solve_wit_17` — `LLM_pre_process`

P/Q preserve either the borrowed UShort ID cell plus event_delete_id_restore and InsideCritical (16/17), or the restored os_inv plus InsideCritical (18/19). All prefix/original/suffix, ID bounds, address/ID NoDup and manager-projection equations are existing premises from which_implies_wit_6. Project the decomposition/address in *_pure; wrappers restate pure facts and cancel the same resources. This group does not rederive uniqueness or use the new manager to reconstruct lost old facts. Exact obligation: partial_solve_wit_17.
### `proof_of__EventDelete_partial_solve_wit_18_pure` — `LLM_pre_process`

P/Q preserve either the borrowed UShort ID cell plus event_delete_id_restore and InsideCritical (16/17), or the restored os_inv plus InsideCritical (18/19). All prefix/original/suffix, ID bounds, address/ID NoDup and manager-projection equations are existing premises from which_implies_wit_6. Project the decomposition/address in *_pure; wrappers restate pure facts and cancel the same resources. This group does not rederive uniqueness or use the new manager to reconstruct lost old facts. Exact obligation: partial_solve_wit_18_pure.
### `proof_of__EventDelete_partial_solve_wit_18` — `LLM_pre_process`

P/Q preserve either the borrowed UShort ID cell plus event_delete_id_restore and InsideCritical (16/17), or the restored os_inv plus InsideCritical (18/19). All prefix/original/suffix, ID bounds, address/ID NoDup and manager-projection equations are existing premises from which_implies_wit_6. Project the decomposition/address in *_pure; wrappers restate pure facts and cancel the same resources. This group does not rederive uniqueness or use the new manager to reconstruct lost old facts. Exact obligation: partial_solve_wit_18.
### `proof_of__EventDelete_partial_solve_wit_19_pure` — `LLM_pre_process`

P/Q preserve either the borrowed UShort ID cell plus event_delete_id_restore and InsideCritical (16/17), or the restored os_inv plus InsideCritical (18/19). All prefix/original/suffix, ID bounds, address/ID NoDup and manager-projection equations are existing premises from which_implies_wit_6. Project the decomposition/address in *_pure; wrappers restate pure facts and cancel the same resources. This group does not rederive uniqueness or use the new manager to reconstruct lost old facts. Exact obligation: partial_solve_wit_19_pure.
### `proof_of__EventDelete_partial_solve_wit_19` — `LLM_pre_process`

P/Q preserve either the borrowed UShort ID cell plus event_delete_id_restore and InsideCritical (16/17), or the restored os_inv plus InsideCritical (18/19). All prefix/original/suffix, ID bounds, address/ID NoDup and manager-projection equations are existing premises from which_implies_wit_6. Project the decomposition/address in *_pure; wrappers restate pure facts and cancel the same resources. This group does not rederive uniqueness or use the new manager to reconstruct lost old facts. Exact obligation: partial_solve_wit_19.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_18__id_read_frame/proof_reuse.md`.

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
      "id_read_frame"
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
      "id_read_frame"
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
      "id_read_frame"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/_coq_builds/EventDelete-vc-proving-r1/group_18/src/.coq_debug/group_18_id_read_frame.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_18__id_read_frame/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_18__id_read_frame/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
