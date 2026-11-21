# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `delay_failure_restoration`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r2/groups/group_03__delay_failure_restoration/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_12_1`, `proof_of__SemaphoreObtain_entail_wit_12_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): `proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_spatial`, `proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_spatial`.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_12_1` — `LLM_pre_process`

Whole-goal composition route: destruct ktask_set_delay_step and retval<>0 to isolate failure, derive retval=-5, delay_after=0 and st_after=suspended. Specialize the carried restoration derivable1 at this exact transition, weaken andp(coq_prop(os_global_context sg),delay_frame) to delay_frame and reassociate resources; restore os_inv suspended while framing InsideCritical held. Retain failure step and all requested facts. Splits are semantically provable but aggressive wrapper normalization prevents mandated split composition; whole route must prove the full unchanged witness.
### `proof_of__SemaphoreObtain_entail_wit_12_2` — `LLM_pre_process`

Whole-goal composition route: destruct ktask_set_delay_step and retval<>0 to isolate failure, derive retval=-5, delay_after=0 and st_after=suspended. Specialize the carried restoration derivable1 at this exact transition, weaken andp(coq_prop(os_global_context sg),delay_frame) to delay_frame and reassociate resources; restore os_inv suspended while framing InsideCritical held. Retain failure step and all requested facts. Splits are semantically provable but aggressive wrapper normalization prevents mandated split composition; whole route must prove the full unchanged witness.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_03__delay_failure_restoration/proof_reuse.md`.

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
      "delay_failure_restoration"
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
      "delay_failure_restoration"
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
      "delay_failure_restoration"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r2/group_03/src/.coq_debug/group_03_delay_failure_restoration.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_03__delay_failure_restoration/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_03__delay_failure_restoration/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
