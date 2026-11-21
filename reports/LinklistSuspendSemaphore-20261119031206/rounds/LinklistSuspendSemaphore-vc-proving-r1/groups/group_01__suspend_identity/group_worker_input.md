# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `suspend_identity`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/LinklistSuspendSemaphore-vc-proving-r1/groups/group_01__suspend_identity/LinklistSuspendSemaphore_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistSuspend_entail_wit_1_1`, `proof_of_LinklistSuspend_entail_wit_1_2`, `proof_of_LinklistSuspend_entail_wit_2_1`, `proof_of_LinklistSuspend_entail_wit_2_2`, `proof_of_LinklistSuspend_which_implies_wit_1`, `proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_LinklistSuspend_entail_wit_1_1` — `LLM_pre_process`

Choose the spatial arm of this whole-goal disjunction. From linklist_suspend_admissible obtain the registered TaskDescriptor for task_pre; from task_inv/os_inv and its ID-manager/descriptor consistency obtain its uint16 ID and get_task_with_idnode_success. Split the relevant ID bucket/member and descriptor resource only as necessary to expose the nested id.id UShort cell; its valid typed store supplies 0<=id<65536. Construct the return wand by reassembling the same ID/descriptor map and untouched os_inv frame. All current/pre pointer facts already use task_pre and the branch flag; retain them, with the existential task_id chosen from the actual registered descriptor. Do not merely use a pure lookup as ownership. This instance has flag0.
### `proof_of_LinklistSuspend_entail_wit_1_2` — `LLM_pre_process`

Choose the spatial arm of this whole-goal disjunction. From linklist_suspend_admissible obtain the registered TaskDescriptor for task_pre; from task_inv/os_inv and its ID-manager/descriptor consistency obtain its uint16 ID and get_task_with_idnode_success. Split the relevant ID bucket/member and descriptor resource only as necessary to expose the nested id.id UShort cell; its valid typed store supplies 0<=id<65536. Construct the return wand by reassembling the same ID/descriptor map and untouched os_inv frame. All current/pre pointer facts already use task_pre and the branch flag; retain them, with the existential task_id chosen from the actual registered descriptor. Do not merely use a pure lookup as ownership. This instance has flag1.
### `proof_of_LinklistSuspend_entail_wit_2_1` — `LLM_pre_process`

Use the spatial disjunct so os_inv(after) is available. The two get_task_with_idnode_success facts at the same before/id identify found=task_pre via the functional/unique ID-to-task relation in the registered task model. Unpack admissibility and ktask_suspend_step: a valid branch either keeps an already SUSPEND self-owned task unchanged or suspends the running READY/RUNNING task then unsets delay. In each case choose staged=after and ignored=retval, obtain the actual post descriptor with status SUSPEND and membership in sched_owned_tasks, and transport semaphore pending nodes and non-service facts using the step frame fields, including the unset-delay relation. Preserve after os_inv unchanged. The no-resource pure disjunct need not be used if it would discard model consistency. This instance retains flag1.
### `proof_of_LinklistSuspend_entail_wit_2_2` — `LLM_pre_process`

Use the spatial disjunct so os_inv(after) is available. The two get_task_with_idnode_success facts at the same before/id identify found=task_pre via the functional/unique ID-to-task relation in the registered task model. Unpack admissibility and ktask_suspend_step: a valid branch either keeps an already SUSPEND self-owned task unchanged or suspends the running READY/RUNNING task then unsets delay. In each case choose staged=after and ignored=retval, obtain the actual post descriptor with status SUSPEND and membership in sched_owned_tasks, and transport semaphore pending nodes and non-service facts using the step frame fields, including the unset-delay relation. Preserve after os_inv unchanged. The no-resource pure disjunct need not be used if it would discard model consistency. This instance retains flag0.
### `proof_of_LinklistSuspend_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial`: Introduce the pure equalities and substitute the actual DLL result/address before spatial normalization. P owns exactly the field or updated DLL and the wand consuming that same resource; reorder/associate sepcon and apply wand elimination to obtain Q. Keep the same sg/staged/after and all framed resources; no os_inv unfolding or new assumptions are needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_01__suspend_identity/proof_reuse.md`.

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
      "suspend_identity"
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
      "suspend_identity"
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
      "suspend_identity"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/_coq_builds/LinklistSuspendSemaphore-vc-proving-r1/group_01/src/.coq_debug/group_01_suspend_identity.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_01__suspend_identity/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-proving-r1/groups/group_01__suspend_identity/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
