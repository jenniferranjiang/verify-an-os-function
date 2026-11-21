# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `fifo_enqueue`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/LinklistSuspendSemaphore-vc-proving-r1/groups/group_02__fifo_enqueue/LinklistSuspendSemaphore_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistSuspend_entail_wit_3`, `proof_of_LinklistSuspend_which_implies_wit_2`, `proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_LinklistSuspend_entail_wit_3` — `LLM_pre_process`

From staged os_inv, pending_nodes at sem, descriptor status SUSPEND, self-owned task membership and ktask_not_os_service, isolate the selected Semaphore waiting DLL and the task self-loop sched_link. Use global scheduler-owner NoDup/spatial exclusion to show task is not already in any waiting chain and to remove it exactly once from sched_owned_tasks. Choose after as replace_sched_owned_tasks(remove task owned)(semaphore_enqueue_state sem new_waiting staged). Establish linklist_semaphore_enqueue with the actual sem/desc and chosen node list. Expose the DLL plus pure_suspend_sched_link payload plus occupy_dll_node, and build the wand accepting the updated DLL then rebuilding all os_inv components. Prove descriptor/ID/manager frames unchanged, scheduler ownership is a permutation moving task from owned to sem waiting, service restrictions persist, and Dataqueue associations are unchanged because semaphore address/ID/value remain unchanged. Preserve all other task/ready/delay/mutex/event/zombie/service/dataqueue resources; no new readiness/sorting premise. For FIFO take new_waiting=waiting++[task_pre]; derive canonical sched_link address/nonzero from the owned task cell and layout. The head anchor and dll_insert_before_dispatch equation follow from inserting before the sentinel and map_app; choose after_fifo as above.
### `proof_of_LinklistSuspend_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial`: Introduce the pure equalities and substitute the actual DLL result/address before spatial normalization. P owns exactly the field or updated DLL and the wand consuming that same resource; reorder/associate sepcon and apply wand elimination to obtain Q. Keep the same sg/staged/after and all framed resources; no os_inv unfolding or new assumptions are needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_02__fifo_enqueue/proof_reuse.md`.

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
      "fifo_enqueue"
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
      "fifo_enqueue"
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
      "fifo_enqueue"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/_coq_builds/LinklistSuspendSemaphore-vc-proving-r1/group_02/src/.coq_debug/group_02_fifo_enqueue.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_02__fifo_enqueue/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_02__fifo_enqueue/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
