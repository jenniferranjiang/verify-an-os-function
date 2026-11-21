# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `schedule_continuation`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r2/groups/group_05__schedule_continuation/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_14_1`, `proof_of__SemaphoreObtain_entail_wit_14_2`, `proof_of__SemaphoreObtain_entail_wit_14_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_14_1` — `LLM_pre_process`

Select prepared=st_after and restore os_inv using the universal delay-frame entailment and successful ktask_set_delay_step; retain InsideCritical held. Compose clear-status, prio suspension and optional successful delay step into the locked inr(task) transition of abs_semaphore_obtain. Specialize entry safeExec through rely before->held, then use bind decomposition for abs_ktask_assign to obtain existential continuation Y and its ret(tt)->semaphore_obtain_after_assign implication. Show Crtos_GTrans held prepared. Select actual transition state, not an arbitrary poststate.
### `proof_of__SemaphoreObtain_entail_wit_14_2` — `LLM_pre_process`

Select prepared=st_after and restore os_inv using the universal delay-frame entailment and successful ktask_set_delay_step; retain InsideCritical held. Compose clear-status, prio suspension and optional successful delay step into the locked inr(task) transition of abs_semaphore_obtain. Specialize entry safeExec through rely before->held, then use bind decomposition for abs_ktask_assign to obtain existential continuation Y and its ret(tt)->semaphore_obtain_after_assign implication. Show Crtos_GTrans held prepared. Select actual transition state, not an arbitrary poststate.
### `proof_of__SemaphoreObtain_entail_wit_14_3` — `LLM_pre_process`

Select prepared=suspended; wait<=0, wait<>0 and -1<=wait force wait=-1, so no delay step. Preserve existing os_inv suspended and held token. Compose clear-status, prio suspension and optional successful delay step into the locked inr(task) transition of abs_semaphore_obtain. Specialize entry safeExec through rely before->held, then use bind decomposition for abs_ktask_assign to obtain existential continuation Y and its ret(tt)->semaphore_obtain_after_assign implication. Show Crtos_GTrans held prepared. Select actual transition state, not an arbitrary poststate.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_05__schedule_continuation/proof_reuse.md`.

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
      "schedule_continuation"
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
      "schedule_continuation"
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
      "schedule_continuation"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r2/group_05/src/.coq_debug/group_05_schedule_continuation.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_05__schedule_continuation/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_05__schedule_continuation/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
