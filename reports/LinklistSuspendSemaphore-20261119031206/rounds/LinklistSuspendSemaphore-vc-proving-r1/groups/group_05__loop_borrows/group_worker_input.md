# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `loop_borrows`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/LinklistSuspendSemaphore-vc-proving-r1/groups/group_05__loop_borrows/LinklistSuspendSemaphore_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistSuspend_entail_wit_5`, `proof_of_LinklistSuspend_which_implies_wit_3`, `proof_of_LinklistSuspend_which_implies_wit_5`, `proof_of_LinklistSuspend_which_implies_wit_6`, `proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_LinklistSuspend_entail_wit_5` — `LLM_pre_process`

From staged os_inv and pending_nodes/decomposition locate the current member of the sem waiting DLL. Its pure_suspend_sched_link payload supplies an actual current task descriptor, lookup and alignment. Self-owned task_pre and waiting-member current_task are distinct by global scheduler ownership uniqueness; split the task descriptor map at both addresses and expose their UChar cur_prio fields without duplicate ownership. Split the DLL at the current node to expose node_next. Choose current_task=first_task, current_desc from the real map, rest_tasks=rest_tasks_2; split rest to choose either successor=head or successor=sched_link_of(next_task). Build the single wand consuming both priority fields and the next pointer and restoring the exact same staged os_inv. All prefix/comparison/decomposition facts are retained; distinguish pure member facts from spatial resource extraction.
### `proof_of_LinklistSuspend_which_implies_wit_3` — `LLM_pre_process`

Locate the selected sem in os_inv using semaphore_pending_nodes, expose its pending store_dll, and inspect waiting nil/cons. The head.next field is head for empty, sched_link_of first_task for nonempty. Split that one Ptr field and construct the return wand by rebuilding the same DLL, Semaphore and global frame. Choose first_link and list witnesses from this actual list shape, not arbitrary pointers.
### `proof_of_LinklistSuspend_which_implies_wit_5` — `LLM_pre_process`

Unfold the owned waiting store_dll just enough to borrow its sentinel node_prev Ptr. Choose last_link=head for empty waiting, otherwise the canonical address of the last node. Derive the dll_insert_anchor and dll_insert_after_dispatch-at-last equation equals map sched_link_node(waiting++[task_pre]); use the existing new_nodes equality and sched_link_node definition. Build the field return wand retaining all DLL segments and payloads, so no node resource is lost.
### `proof_of_LinklistSuspend_which_implies_wit_6` — `aggressive_pre_process`

- Split `proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial`: Introduce the pure equalities and substitute the actual DLL result/address before spatial normalization. P owns exactly the field or updated DLL and the wand consuming that same resource; reorder/associate sepcon and apply wand elimination to obtain Q. Keep the same sg/staged/after and all framed resources; no os_inv unfolding or new assumptions are needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_05__loop_borrows/proof_reuse.md`.

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
      "loop_borrows"
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
      "loop_borrows"
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
      "loop_borrows"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/_coq_builds/LinklistSuspendSemaphore-vc-proving-r1/group_05/src/.coq_debug/group_05_loop_borrows.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_05__loop_borrows/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_05__loop_borrows/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
