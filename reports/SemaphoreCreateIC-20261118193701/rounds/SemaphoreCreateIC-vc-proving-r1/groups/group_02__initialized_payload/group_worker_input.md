# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `initialized_payload`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreCreateIC-20261118193701/SemaphoreCreateIC-vc-proving-r1/groups/group_02__initialized_payload/SemaphoreCreateIC_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_3`, `proof_of__SemaphoreCreate_entail_wit_4`, `proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial`, `proof_of__SemaphoreCreate_partial_solve_wit_6_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreCreate_entail_wit_3` — `LLM_pre_process`

Use LLM_pre_process on the whole entailment. Unfold min-free to obtain 0 <= retval < idmax and semaphore_context to rewrite idmax=128. Unfold NodeZero for pending; retain the same zero pointers (existential witnesses 0,0 if using the generated second branch). All object and OS-frame resources are unchanged and cancel. The value cell already contains val_pre, so no missing scalar bridge or invented val range is required.
### `proof_of__SemaphoreCreate_entail_wit_4` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial`: Cancel the unchanged global frame and ID manager. Unfold store_node_self_linked to get the pending sentinel next/prev both equal to itself; fold store_dll wait pending nil. Unfold store_semaphore and semaphore_created and discharge base nonzero/alignment/link equality from retained premises. Combine value=val_pre, padding and empty pending DLL as payload. Forget the two zero management-link values from NodeZero to form occupy_dll_node, preserving both cells. The ID node is already owned by the manager and must not be duplicated into payload.
### `proof_of__SemaphoreCreate_partial_solve_wit_6_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1`: Unfold dll_insert_anchor; choose its anchor=head disjunct by reflexivity. The anchor is k_sem_list itself, so no membership proof or new resource is necessary.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreCreateIC-20261118193701/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/rounds/SemaphoreCreateIC-vc-proving-r1/groups/group_02__initialized_payload/proof_reuse.md`.

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
      "SemaphoreCreateIC-20261118193701",
      "--round",
      "SemaphoreCreateIC-vc-proving-r1",
      "--group",
      "initialized_payload"
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
      "SemaphoreCreateIC-20261118193701",
      "--round",
      "SemaphoreCreateIC-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "initialized_payload"
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
      "SemaphoreCreateIC-20261118193701",
      "--round",
      "SemaphoreCreateIC-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "initialized_payload"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreCreateIC-20261118193701/_coq_builds/SemaphoreCreateIC-vc-proving-r1/group_02/src/.coq_debug/group_02_initialized_payload.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/rounds/SemaphoreCreateIC-vc-proving-r1/groups/group_02__initialized_payload/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/rounds/SemaphoreCreateIC-vc-proving-r1/groups/group_02__initialized_payload/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
