# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `delay_failure_restoration`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1/groups/group_03__delay_failure_restoration/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_12_1`, `proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_spatial`, `proof_of__SemaphoreObtain_entail_wit_12_2`, `proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_12_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_1`: For this pure/projection obligation 1: P supplies nonzero return and ktask_set_delay_step plus returned pointer/delay/tick/frame. Unfold step: success is excluded, so result=-5, delay_after=0, state=suspended. Pure Q retains this exact failure step; spatial Q applies the explicit universal restoration premise to returned resources and frames InsideCritical. No new frame property is postulated here.

- Split `proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_spatial`: For this spatial entailment: P supplies nonzero return and ktask_set_delay_step plus returned pointer/delay/tick/frame. Unfold step: success is excluded, so result=-5, delay_after=0, state=suspended. Pure Q retains this exact failure step; spatial Q applies the explicit universal restoration premise to returned resources and frames InsideCritical. No new frame property is postulated here.
### `proof_of__SemaphoreObtain_entail_wit_12_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_1`: For this pure/projection obligation 1: P is the null-delay branch with nonzero return and returned resources. Unfold ktask_set_delay_step to get result=-5, unchanged suspended and pointer0. Pure split records the failure step; spatial split instantiates the supplied residual restoration entailment and cancels InsideCritical. Null delay needs no inactive object.

- Split `proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_spatial`: For this spatial entailment: P is the null-delay branch with nonzero return and returned resources. Unfold ktask_set_delay_step to get result=-5, unchanged suspended and pointer0. Pure split records the failure step; spatial split instantiates the supplied residual restoration entailment and cancels InsideCritical. Null delay needs no inactive object.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_03__delay_failure_restoration/proof_reuse.md`.

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
      "SemaphoreObtainRuntime-vc-proving-r1",
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
      "SemaphoreObtainRuntime-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "delay_failure_restoration"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r1/group_03/src/.coq_debug/group_03_delay_failure_restoration.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_03__delay_failure_restoration/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_03__delay_failure_restoration/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
