# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `task_prepare`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r2/groups/group_00__task_prepare/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_7`, `proof_of__SemaphoreObtain_entail_wit_8`, `proof_of__SemaphoreObtain_entail_wit_9`, `proof_of__SemaphoreObtain_entail_wit_9_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_9_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_9_split_goal_3`, `proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial`, `proof_of__SemaphoreObtain_entail_wit_10`, `proof_of__SemaphoreObtain_which_implies_wit_7`, `proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial`, `proof_of__SemaphoreObtain_which_implies_wit_8`, `proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): `proof_of__SemaphoreObtain_entail_wit_7_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_7_split_goal_2`.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_7` — `LLM_pre_process`

Keep os_inv spatially while extracting its global context/world facts. Specialize safeExec of abs_semaphore_obtain at the rely-reached held state, select original by ID and zero value/nonzero wait, and extract semaphore_obtain_entry: admissibility and universally quantified future-delay obligation. Preserve all resources and pure guards; do not try the resource-free split route.
### `proof_of__SemaphoreObtain_entail_wit_8` — `LLM_pre_process`

From os_inv assign/task-map consistency and linklist_suspend_admissible obtain a descriptor for running task. Select that desc, split its store_map entry, borrow tdExstatus as Int, and construct the wand for writing zero. Reassemble TaskInv/store_map and all os_inv conjuncts at semaphore_clear_status; retain scheduler ownership, ID manager, delay and dataqueue frames. Only exstatus changes. No task<>0 premise is available or required here. Preserve future-delay universal premise literally.
### `proof_of__SemaphoreObtain_entail_wit_9` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_9_split_goal_1`: Clear exstatus only; simplify task-map update at task and preserve scheduler/status/owner fields, transferring admissibility from held to semaphore_clear_status.

- Split `proof_of__SemaphoreObtain_entail_wit_9_split_goal_2`: semaphore_clear_status preserves semaphore list, choose original and supplied map sched_link_node pending list in semaphore_pending_nodes.

- Split `proof_of__SemaphoreObtain_entail_wit_9_split_goal_3`: Re-use exact universally quantified future-delay premise after rewriting task=running task.

- Split `proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial`: Apply exstatus-zero restoration wand, frame critical token.
### `proof_of__SemaphoreObtain_entail_wit_10` — `LLM_pre_process`

Choose suspended=after and the descriptor supplied by linklist_suspend_prio. Unfold successful flag-1 relation through linklist_suspend_step and ktask_suspend_step to obtain task<>0 and suspended status/map lookup. Instantiate the carried future-delay universal premise with original desc, after and sd; rewrite task and sem equalities. Cancel unchanged os_inv after and InsideCritical held.
### `proof_of__SemaphoreObtain_which_implies_wit_7` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial`: Open assign component, borrow Assign.os_running_task pointer, construct same-value wand for os_inv held.
### `proof_of__SemaphoreObtain_which_implies_wit_8` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial`: Use task equality, then apply same-running-pointer restoration wand.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_00__task_prepare/proof_reuse.md`.

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
      "SemaphoreObtainRuntime-20261119060206",
      "--round",
      "SemaphoreObtainRuntime-vc-proving-r2",
      "--group",
      "task_prepare"
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
      "SemaphoreObtainRuntime-20261119060206",
      "--round",
      "SemaphoreObtainRuntime-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "task_prepare"
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
      "SemaphoreObtainRuntime-20261119060206",
      "--round",
      "SemaphoreObtainRuntime-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "task_prepare"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r2/group_00/src/.coq_debug/group_00_task_prepare.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_00__task_prepare/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_00__task_prepare/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
