# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `resume_status`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1/groups/group_06__resume_status/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_16`, `proof_of__SemaphoreObtain_entail_wit_17`, `proof_of__SemaphoreObtain_entail_wit_17_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_17_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_16` — `LLM_pre_process`

P retains newly locked os_inv st_lock, RTrans observation and safeExec after_assign. Extract semaphore_status_entry from assertS and apply its entailment to this actual observed os_inv to find descriptor. Focus the cached task exstatus with read-only restoration wand. Q chooses current descriptor/state, not pre-scheduling ones.
### `proof_of__SemaphoreObtain_entail_wit_17` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_17_split_goal_1`: For this pure/projection obligation 1: P contains observed exstatus cell, restoration wand, descriptor lookup and safeExec after_assign. Spatial: consume read wand and retain critical token. Pure GTrans: existing relation. Refinement: instantiate semaphore_read_status normal step with observed descriptor, unchanged observed state and tdExstatus, then atomic/bind safeExec to ret value.

- Split `proof_of__SemaphoreObtain_entail_wit_17_split_goal_2`: For this pure/projection obligation 2: P contains observed exstatus cell, restoration wand, descriptor lookup and safeExec after_assign. Spatial: consume read wand and retain critical token. Pure GTrans: existing relation. Refinement: instantiate semaphore_read_status normal step with observed descriptor, unchanged observed state and tdExstatus, then atomic/bind safeExec to ret value.

- Split `proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial`: For this spatial entailment: P contains observed exstatus cell, restoration wand, descriptor lookup and safeExec after_assign. Spatial: consume read wand and retain critical token. Pure GTrans: existing relation. Refinement: instantiate semaphore_read_status normal step with observed descriptor, unchanged observed state and tdExstatus, then atomic/bind safeExec to ret value.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_06__resume_status/proof_reuse.md`.

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
      "SemaphoreObtainRuntime-vc-proving-r1",
      "--group",
      "resume_status"
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
      "resume_status"
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
      "resume_status"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r1/group_06/src/.coq_debug/group_06_resume_status.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_06__resume_status/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_06__resume_status/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
