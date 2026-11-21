# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `priority_enqueue`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/LinklistSuspendSemaphore-vc-proving-r1/groups/group_03__priority_enqueue/LinklistSuspendSemaphore_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistSuspend_entail_wit_7_1`, `proof_of_LinklistSuspend_entail_wit_7_2`, `proof_of_LinklistSuspend_entail_wit_7_3`, `proof_of_LinklistSuspend_entail_wit_7_4`, `proof_of_LinklistSuspend_which_implies_wit_4`, `proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial`, `proof_of_LinklistSuspend_which_implies_wit_7`, `proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_LinklistSuspend_entail_wit_7_1` — `LLM_pre_process`

Use prefix_done=waiting and suffix_done=[] after rewriting the loop decomposition; build linklist_priority_insert with prefix=map sched_link_node waiting, suffix=[], actual desc and Forall obtained from the quantified scanned-member premise. The end-of-list guard makes the non-head anchor implication vacuous and forces append new_nodes. From staged os_inv, pending_nodes at sem, descriptor status SUSPEND, self-owned task membership and ktask_not_os_service, isolate the selected Semaphore waiting DLL and the task self-loop sched_link. Use global scheduler-owner NoDup/spatial exclusion to show task is not already in any waiting chain and to remove it exactly once from sched_owned_tasks. Choose after as replace_sched_owned_tasks(remove task owned)(semaphore_enqueue_state sem new_waiting staged). Establish linklist_semaphore_enqueue with the actual sem/desc and chosen node list. Expose the DLL plus pure_suspend_sched_link payload plus occupy_dll_node, and build the wand accepting the updated DLL then rebuilding all os_inv components. Prove descriptor/ID/manager frames unchanged, scheduler ownership is a permutation moving task from owned to sem waiting, service restrictions persist, and Dataqueue associations are unchanged because semaphore address/ID/value remain unchanged. Preserve all other task/ready/delay/mutex/event/zombie/service/dataqueue resources; no new readiness/sorting premise. Use the first or normalized spatial disjunct; end suffix is already empty.
### `proof_of_LinklistSuspend_entail_wit_7_2` — `LLM_pre_process`

The antecedent says node=head but also node=sched_link_of(first_task) for a member of the nonempty suffix. Extract the matching managed semaphore DLL from staged os_inv. Its sentinel is disjoint from every member node; derive contradiction (or duplicate field ownership) and close either whole-goal arm. Do not infer suffix=[] solely from the pointer equality without using spatial ownership.
### `proof_of_LinklistSuspend_entail_wit_7_3` — `LLM_pre_process`

First consume the two priority cells and next cell with their saved wand to restore staged os_inv (using retval=current_task and address bridges; preserve the local list cell where present). Choose prefix_done=prefix_loop, suffix_done=current_task::rest_tasks and new_nodes=map sched_link_node(prefix_loop++task_pre::suffix_done). The loop prefix premise gives Forall of non-lower priorities; the strict break guard and lookup current_desc prove the first suffix item is strictly lower. Translate map/app/cons to the exact linklist_priority_insert relation and prove the before-anchor dispatch equation using node=current sched_link, node<>head and NoDup node addresses from the owned DLL. From staged os_inv, pending_nodes at sem, descriptor status SUSPEND, self-owned task membership and ktask_not_os_service, isolate the selected Semaphore waiting DLL and the task self-loop sched_link. Use global scheduler-owner NoDup/spatial exclusion to show task is not already in any waiting chain and to remove it exactly once from sched_owned_tasks. Choose after as replace_sched_owned_tasks(remove task owned)(semaphore_enqueue_state sem new_waiting staged). Establish linklist_semaphore_enqueue with the actual sem/desc and chosen node list. Expose the DLL plus pure_suspend_sched_link payload plus occupy_dll_node, and build the wand accepting the updated DLL then rebuilding all os_inv components. Prove descriptor/ID/manager frames unchanged, scheduler ownership is a permutation moving task from owned to sem waiting, service restrictions persist, and Dataqueue associations are unchanged because semaphore address/ID/value remain unchanged. Preserve all other task/ready/delay/mutex/event/zombie/service/dataqueue resources; no new readiness/sorting premise. This break has nonempty remaining rest; preserve its next-link resource when restoring the wand.
### `proof_of_LinklistSuspend_entail_wit_7_4` — `LLM_pre_process`

First consume the two priority cells and next cell with their saved wand to restore staged os_inv (using retval=current_task and address bridges; preserve the local list cell where present). Choose prefix_done=prefix_loop, suffix_done=current_task::rest_tasks and new_nodes=map sched_link_node(prefix_loop++task_pre::suffix_done). The loop prefix premise gives Forall of non-lower priorities; the strict break guard and lookup current_desc prove the first suffix item is strictly lower. Translate map/app/cons to the exact linklist_priority_insert relation and prove the before-anchor dispatch equation using node=current sched_link, node<>head and NoDup node addresses from the owned DLL. From staged os_inv, pending_nodes at sem, descriptor status SUSPEND, self-owned task membership and ktask_not_os_service, isolate the selected Semaphore waiting DLL and the task self-loop sched_link. Use global scheduler-owner NoDup/spatial exclusion to show task is not already in any waiting chain and to remove it exactly once from sched_owned_tasks. Choose after as replace_sched_owned_tasks(remove task owned)(semaphore_enqueue_state sem new_waiting staged). Establish linklist_semaphore_enqueue with the actual sem/desc and chosen node list. Expose the DLL plus pure_suspend_sched_link payload plus occupy_dll_node, and build the wand accepting the updated DLL then rebuilding all os_inv components. Prove descriptor/ID/manager frames unchanged, scheduler ownership is a permutation moving task from owned to sem waiting, service restrictions persist, and Dataqueue associations are unchanged because semaphore address/ID/value remain unchanged. Preserve all other task/ready/delay/mutex/event/zombie/service/dataqueue resources; no new readiness/sorting premise. Here rest_tasks=[] and next_link=head; rewrite the explicit next_link=list_pre bridge, preserving the local list cell in the chosen arm. The break position is still before the current last task, not append.
### `proof_of_LinklistSuspend_which_implies_wit_4` — `aggressive_pre_process`

- Split `proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial`: Introduce the pure equalities and substitute the actual DLL result/address before spatial normalization. P owns exactly the field or updated DLL and the wand consuming that same resource; reorder/associate sepcon and apply wand elimination to obtain Q. Keep the same sg/staged/after and all framed resources; no os_inv unfolding or new assumptions are needed.
### `proof_of_LinklistSuspend_which_implies_wit_7` — `aggressive_pre_process`

- Split `proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial`: Introduce the pure equalities and substitute the actual DLL result/address before spatial normalization. P owns exactly the field or updated DLL and the wand consuming that same resource; reorder/associate sepcon and apply wand elimination to obtain Q. Keep the same sg/staged/after and all framed resources; no os_inv unfolding or new assumptions are needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_03__priority_enqueue/proof_reuse.md`.

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
      "priority_enqueue"
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
      "priority_enqueue"
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
      "priority_enqueue"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/_coq_builds/LinklistSuspendSemaphore-vc-proving-r1/group_03/src/.coq_debug/group_03_priority_enqueue.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_03__priority_enqueue/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_03__priority_enqueue/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
