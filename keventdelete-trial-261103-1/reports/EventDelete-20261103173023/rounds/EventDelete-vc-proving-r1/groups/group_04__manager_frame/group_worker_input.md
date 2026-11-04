# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `manager_frame`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_04__manager_frame/EventDelete_proof_manual.v`.
- Editable proof spans: `proof_of__EventDelete_which_implies_wit_7`, `proof_of__EventDelete_which_implies_wit_7_split_goal_spatial`, `proof_of__EventDelete_which_implies_wit_8`, `proof_of__EventDelete_which_implies_wit_8_split_goal_spatial`, `proof_of__EventDelete_partial_solve_wit_20_pure`, `proof_of__EventDelete_partial_solve_wit_20_pure_split_goal_1`, `proof_of__EventDelete_partial_solve_wit_21_pure`, `proof_of__EventDelete_partial_solve_wit_21_pure_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_04__manager_frame/EventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventDelete_lib.v`
- Every new/adapted helper uses suffix `__manager_frame`. Preserve the seed.

### `proof_of__EventDelete_which_implies_wit_7` — `aggressive_pre_process`

- Split `proof_of__EventDelete_which_implies_wit_7_split_goal_spatial`: Unfold event_delete_id_restore; consume the UShort ID field together with its wand by wand elimination. The exact address already matches the restored old os_inv; no snapshot changes.
### `proof_of__EventDelete_which_implies_wit_8` — `aggressive_pre_process`

- Split `proof_of__EventDelete_which_implies_wit_8_split_goal_spatial`: P is os_inv locked and locked.events=prefix++original::suffix with original.addr=p. Unfold only os_inv/event_inv and event_create_frame, use os_global_context/event_context for manager pointer=&k_event_id_manager, rewrite map_app/map_cons and event_link_node. Cancel all unchanged module resources; Q is full manager + exact frame + original management DLL with explicit target node.
### `proof_of__EventDelete_partial_solve_wit_20_pure` — `aggressive_pre_process`

- Split `proof_of__EventDelete_partial_solve_wit_20_pure_split_goal_1`: Q is the address of the global k_event_id_manager being nonzero. Apply the standard CNotation addr_of_LE_var_not_zero fact for this exact global variable; the scalar ID bounds are already premises of the parent and not required by this split. Do not infer arbitrary struct bases nonzero solely from nonzero offset fields.
### `proof_of__EventDelete_partial_solve_wit_21_pure` — `aggressive_pre_process`

- Split `proof_of__EventDelete_partial_solve_wit_21_pure_split_goal_1`: Q is the address of the global k_event_id_manager being nonzero. Apply the standard CNotation addr_of_LE_var_not_zero fact for this exact global variable; the scalar ID bounds are already premises of the parent and not required by this split. Do not infer arbitrary struct bases nonzero solely from nonzero offset fields.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_04__manager_frame/proof_reuse.md`.

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
      "manager_frame"
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
      "manager_frame"
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
      "manager_frame"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/_coq_builds/EventDelete-vc-proving-r1/group_04/src/.coq_debug/group_04_manager_frame.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_04__manager_frame/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_04__manager_frame/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
