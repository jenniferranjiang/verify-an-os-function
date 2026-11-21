# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `loop_progress`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/LinklistSuspendSemaphore-vc-proving-r1/groups/group_04__loop_progress/LinklistSuspendSemaphore_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistSuspend_entail_wit_4_1`, `proof_of_LinklistSuspend_entail_wit_4_2`, `proof_of_LinklistSuspend_entail_wit_6_1`, `proof_of_LinklistSuspend_entail_wit_6_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_LinklistSuspend_entail_wit_4_1` — `LLM_pre_process`

P owns head.next and its exact restoration wand plus the given staged/global pure facts. Eliminate the wand to restore os_inv. Choose prefix_loop=[] and suffix_loop=waiting; scanned-prefix property is vacuous and map/append identities are immediate. Select the branch matching the actual waiting shape and first_link equation. Preserve task lookup/status/self-owned/non-service and staged suspend/pending facts. Waiting is nil: take the first branch.
### `proof_of_LinklistSuspend_entail_wit_4_2` — `LLM_pre_process`

P owns head.next and its exact restoration wand plus the given staged/global pure facts. Eliminate the wand to restore os_inv. Choose prefix_loop=[] and suffix_loop=waiting; scanned-prefix property is vacuous and map/append identities are immediate. Select the branch matching the actual waiting shape and first_link equation. Preserve task lookup/status/self-owned/non-service and staged suspend/pending facts. Waiting is first_task_2::rest_tasks_2: choose those witnesses and the second branch.
### `proof_of_LinklistSuspend_entail_wit_6_1` — `LLM_pre_process`

Normalize retval=current_task and the concrete sched-link address. Consume the two UChar priority cells and next Ptr cell with their precise wand to restore the identical staged os_inv, retaining any local list cell. Choose prefix_loop=old_prefix++[current_task], suffix_loop=rest_tasks; establish decomposition by app_assoc and extend the quantified prefix property using the actual current_desc lookup and the non-break <= guard. Select the nil/cons successor branch using the supplied rest/next_link shape. All before/staged/flag/ret facts are retained; no state mutation occurs in the loop. Rest is next_task::next_rest and next_link is its canonical sched_link: use the nonempty branch.
### `proof_of_LinklistSuspend_entail_wit_6_2` — `LLM_pre_process`

Normalize retval=current_task and the concrete sched-link address. Consume the two UChar priority cells and next Ptr cell with their precise wand to restore the identical staged os_inv, retaining any local list cell. Choose prefix_loop=old_prefix++[current_task], suffix_loop=rest_tasks; establish decomposition by app_assoc and extend the quantified prefix property using the actual current_desc lookup and the non-break <= guard. Select the nil/cons successor branch using the supplied rest/next_link shape. All before/staged/flag/ret facts are retained; no state mutation occurs in the loop. Rest is empty and next_link=list_pre: use the empty branch; explicitly rewrite the local list cell value via that bridge.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_04__loop_progress/proof_reuse.md`.

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
      "loop_progress"
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
      "loop_progress"
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
      "loop_progress"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/_coq_builds/LinklistSuspendSemaphore-vc-proving-r1/group_04/src/.coq_debug/group_04_loop_progress.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_04__loop_progress/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_04__loop_progress/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
