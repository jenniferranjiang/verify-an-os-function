# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `status_observation`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r2/groups/group_06__status_observation/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_15`, `proof_of__SemaphoreObtain_entail_wit_15_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_16`, `proof_of__SemaphoreObtain_entail_wit_17`, `proof_of__SemaphoreObtain_entail_wit_17_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_17_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_15` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_15_split_goal_1`: Apply carried continuation implication at after to safeExec ret(tt) Y.
### `proof_of__SemaphoreObtain_entail_wit_16` — `LLM_pre_process`

Choose observed=st_lock. Specialize semaphore_obtain_after_assign safeExec along Crtos_RTrans scheduled st_lock; its status assertion supplies a descriptor lookup for task. Extract that task-map entry from os_inv and borrow exstatus with same-value restoration wand. Preserve the critical token and rely bridge; do not use running-task identity in the new state as a substitute for the specified original task.
### `proof_of__SemaphoreObtain_entail_wit_17` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_17_split_goal_1`: Crtos_GTrans reflexivity.

- Split `proof_of__SemaphoreObtain_entail_wit_17_split_goal_2`: Unfold after-assign status assertion and atomic observation; use rely scheduled->observed plus task map lookup to select exstatus read, obtaining safeExec ret(exstatus).

- Split `proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial`: Apply same-exstatus restoration wand; frame held token.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_06__status_observation/proof_reuse.md`.

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
      "status_observation"
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
      "status_observation"
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
      "status_observation"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r2/group_06/src/.coq_debug/group_06_status_observation.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_06__status_observation/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_06__status_observation/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
