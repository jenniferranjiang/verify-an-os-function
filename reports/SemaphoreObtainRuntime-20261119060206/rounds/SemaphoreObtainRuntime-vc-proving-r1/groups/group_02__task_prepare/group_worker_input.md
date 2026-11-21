# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `task_prepare`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1/groups/group_02__task_prepare/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_7`, `proof_of__SemaphoreObtain_entail_wit_8`, `proof_of__SemaphoreObtain_entail_wit_9`, `proof_of__SemaphoreObtain_entail_wit_9_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_9_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_9_split_goal_3`, `proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial`, `proof_of__SemaphoreObtain_entail_wit_10`, `proof_of__SemaphoreObtain_which_implies_wit_7`, `proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial`, `proof_of__SemaphoreObtain_which_implies_wit_8`, `proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): `proof_of__SemaphoreObtain_entail_wit_7_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_7_split_goal_2`.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_7` — `LLM_pre_process`

Use the spatial alternative of the whole disjunction. P retains os_inv held and original safeExec with before-to-held RTrans. Unfold the valid-input abstract computation and extract semaphore_obtain_entry from assertS. Apply its held-state entailment to the actual os_inv, preserving that resource, then specialize to original semaphore/zero count/nonzero timeout. Q admissibility and future suspended delay legality follow together. Do not attempt the pure splits: they erased the os_inv required by this entailment.
### `proof_of__SemaphoreObtain_entail_wit_8` — `LLM_pre_process`

P has os_inv held, observed current task, nonzero-wait admissibility and future delay condition. Expand task-world/running consistency to select desc from task_desc_map; derive nonzero task. Focus its exstatus field with residual ownership, and construct a wand accepting exstatus=0 to os_inv(semaphore_clear_status task desc held). Rebuild all unchanged fields/global invariants; Q desc is the actual map descriptor and future condition is retained.
### `proof_of__SemaphoreObtain_entail_wit_9` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_9_split_goal_1`: For this pure/projection obligation 1: P supplies exstatus=0 plus its update wand, original descriptor and admissibility. Pure Q: clear_status preserves running, task scheduling fields and pending-list state, hence admissibility; retain and specialize future-delay condition already in P. Spatial Q: apply wand to the zero cell, frame token. Use the exact updated map, not state equality.

- Split `proof_of__SemaphoreObtain_entail_wit_9_split_goal_2`: For this pure/projection obligation 2: P supplies exstatus=0 plus its update wand, original descriptor and admissibility. Pure Q: clear_status preserves running, task scheduling fields and pending-list state, hence admissibility; retain and specialize future-delay condition already in P. Spatial Q: apply wand to the zero cell, frame token. Use the exact updated map, not state equality.

- Split `proof_of__SemaphoreObtain_entail_wit_9_split_goal_3`: For this pure/projection obligation 3: P supplies exstatus=0 plus its update wand, original descriptor and admissibility. Pure Q: clear_status preserves running, task scheduling fields and pending-list state, hence admissibility; retain and specialize future-delay condition already in P. Spatial Q: apply wand to the zero cell, frame token. Use the exact updated map, not state equality.

- Split `proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial`: For this spatial entailment: P supplies exstatus=0 plus its update wand, original descriptor and admissibility. Pure Q: clear_status preserves running, task scheduling fields and pending-list state, hence admissibility; retain and specialize future-delay condition already in P. Spatial Q: apply wand to the zero cell, frame token. Use the exact updated map, not state equality.
### `proof_of__SemaphoreObtain_entail_wit_10` — `LLM_pre_process`

P supplies LinklistSuspend priority effect and returned os_inv after. Choose suspended=after; unpack suspend/enqueue and task-map update to obtain sd for the same task and stat=SUSPEND. Derive positive-time delay eligibility/window from the carried quantified entry condition with this sd. Q resources are the returned os_inv and unchanged critical token.
### `proof_of__SemaphoreObtain_which_implies_wit_7` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial`: For this spatial entailment: P os_inv contains assignment running-task field. Focus pointer ownership and build read restoration wand from residual assign_inv/global resources; choose actual assignRunningTask.
### `proof_of__SemaphoreObtain_which_implies_wit_8` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial`: For this spatial entailment: P contains running-task pointer and corresponding read wand. Consume them to restore os_inv in the same held state; preserve other resources.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_02__task_prepare/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Current repair 1

blocker parent differs from the current manual: proof_of__SemaphoreObtain_entail_wit_8

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
      "SemaphoreObtainRuntime-vc-proving-r1",
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
      "SemaphoreObtainRuntime-vc-proving-r1",
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
      "SemaphoreObtainRuntime-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "task_prepare"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r1/group_02/src/.coq_debug/group_02_task_prepare.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_02__task_prepare/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_02__task_prepare/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
