# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `spec_and_results`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/LinklistSuspendSemaphore-vc-proving-r1/groups/group_00__spec_and_results/LinklistSuspendSemaphore_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic`, `proof_of_LinklistSuspend_return_wit_1`, `proof_of_LinklistSuspend_return_wit_1_split_goal_1`, `proof_of_LinklistSuspend_return_wit_2`, `proof_of_LinklistSuspend_return_wit_2_split_goal_1`, `proof_of_LinklistSuspend_return_wit_3`, `proof_of_LinklistSuspend_return_wit_3_split_goal_1`, `proof_of_LinklistSuspend_return_wit_4`, `proof_of_LinklistSuspend_return_wit_4_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic` — `LLM_pre_process`

P is the priority caller precondition with flag=1 and os_inv(sg,before). Choose the same sg,before,sem,waiting as the existential base-spec parameters. Frame the unchanged base precondition and introduce the universally quantified return-value wand on emp. On its antecedent, unpack after and linklist_suspend_step; the invalid-flag arm contradicts flag=1 and the valid arm forces retval=0. Rewrite flag=1 and select this same after to establish linklist_suspend_prio (its definition is the base step at flag1/result0), returning exactly the same os_inv. This proves the real derived-contract entailment without adding a function-body assumption.
### `proof_of_LinklistSuspend_return_wit_1` — `aggressive_pre_process`

- Split `proof_of_LinklistSuspend_return_wit_1_split_goal_1`: Pure split only: instantiate the valid-flag arm of linklist_suspend_step with flag=0, result=0 and the existing staged/ignored witnesses. The antecedent already supplies ktask_suspend_step and FIFO linklist_semaphore_enqueue. No new state is constructed and spatial os_inv remains handled by the generated split route.
### `proof_of_LinklistSuspend_return_wit_2` — `aggressive_pre_process`

- Split `proof_of_LinklistSuspend_return_wit_2_split_goal_1`: Pure split only: select valid flag=1, result=0 in linklist_suspend_step; use the existing staged/ignored and after_prio together with their suspend/enqueue facts. The break-position insertion evidence is already established earlier; do not assume any global sorting.
### `proof_of_LinklistSuspend_return_wit_3` — `aggressive_pre_process`

- Split `proof_of_LinklistSuspend_return_wit_3_split_goal_1`: Pure split only: same valid priority arm, now the end-of-list after_prio is the target state. Reuse the given ktask_suspend_step and linklist_semaphore_enqueue, with result zero; tail pointer and dispatch equations need no additional semantic strengthening.
### `proof_of_LinklistSuspend_return_wit_4` — `aggressive_pre_process`

- Split `proof_of_LinklistSuspend_return_wit_4_split_goal_1`: Pure split only: take the invalid-flag arm of linklist_suspend_step using both guards flag<>0 and flag<>1, result -10, and unchanged before state. No call to SuspendKTask or ownership transfer is required.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_00__spec_and_results/proof_reuse.md`.

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
      "LinklistSuspendSemaphore-20261119031206",
      "--round",
      "LinklistSuspendSemaphore-vc-proving-r1",
      "--group",
      "spec_and_results"
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
      "LinklistSuspendSemaphore-20261119031206",
      "--round",
      "LinklistSuspendSemaphore-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "spec_and_results"
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
      "LinklistSuspendSemaphore-20261119031206",
      "--round",
      "LinklistSuspendSemaphore-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "spec_and_results"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/_coq_builds/LinklistSuspendSemaphore-vc-proving-r1/group_00/src/.coq_debug/group_00_spec_and_results.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_00__spec_and_results/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_00__spec_and_results/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
