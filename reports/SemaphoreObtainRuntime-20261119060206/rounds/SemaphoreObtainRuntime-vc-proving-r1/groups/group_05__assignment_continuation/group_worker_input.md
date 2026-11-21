# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `assignment_continuation`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1/groups/group_05__assignment_continuation/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_14_1`, `proof_of__SemaphoreObtain_entail_wit_14_2`, `proof_of__SemaphoreObtain_entail_wit_14_3`, `proof_of__SemaphoreObtain_entail_wit_15`, `proof_of__SemaphoreObtain_entail_wit_15_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_14_1` — `LLM_pre_process`

P has successful finite Delay step, pointer/delay/tick/residual frame and universal restoration entailment. Restore os_inv st_after using that entailment; choose prepared=st_after. Build inr-task locked effect with actual suspended/sd/delay result. Extract assignment continuation Y from safeExec bind (weakest precondition continuation), proving both safeExec abs_ktask_assign Y and the quantified after_assign bridge. GTrans follows existing relation; frame token. Y is a derived continuation, not an extra assumption.
### `proof_of__SemaphoreObtain_entail_wit_14_2` — `LLM_pre_process`

Null-delay successful allocation case: restore os_inv st_after from exact returned resources and the supplied frame entailment; choose prepared=st_after. Build finite-success inr-task effect with delay_after and actual updated state, then decompose safeExec bind to assignment continuation Y and its after_assign bridge. Keep allocation in the abstract step; do not equate states.
### `proof_of__SemaphoreObtain_entail_wit_14_3` — `LLM_pre_process`

P has suspended os_inv, nonpositive nonzero wait with lower bound -1. Derive wait=-1, choose prepared=suspended. Use infinite-delay inr-task locked effect and extract assignment continuation Y via bind, retaining the universal after_assign bridge. No Delay allocation or extra ownership is required.
### `proof_of__SemaphoreObtain_entail_wit_15` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_15_split_goal_1`: For this pure/projection obligation 1: P supplies safeExec(ret tt) Y and the forall-st continuation implication. Instantiate it with the current observed state to obtain safeExec semaphore_obtain_after_assign X; Q uses exactly that state, no old/current-state identification.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_05__assignment_continuation/proof_reuse.md`.

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
      "assignment_continuation"
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
      "assignment_continuation"
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
      "assignment_continuation"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r1/group_05/src/.coq_debug/group_05_assignment_continuation.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_05__assignment_continuation/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_05__assignment_continuation/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
