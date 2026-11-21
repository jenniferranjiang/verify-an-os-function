# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `semaphore_views`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r2/groups/group_02__semaphore_views/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_4`, `proof_of__SemaphoreObtain_which_implies_wit_3`, `proof_of__SemaphoreObtain_which_implies_wit_3_split_goal_spatial`, `proof_of__SemaphoreObtain_which_implies_wit_4`, `proof_of__SemaphoreObtain_which_implies_wit_6`, `proof_of__SemaphoreObtain_which_implies_wit_6_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_4` — `LLM_pre_process`

Restore the found ID-manager view and its wand; use semaphore invariant list/ID correspondence to select original with matching id-node address. Obtain value bounds from the UShort resource, membership and nonzero from the semaphore invariant. Return the same held os_inv and InsideCritical, preserving entry safeExec.
### `proof_of__SemaphoreObtain_which_implies_wit_3` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_3_split_goal_spatial`: Open semaphore component of os_inv, expose store_idmanager and construct its exact restoration wand, retaining remaining global resources.
### `proof_of__SemaphoreObtain_which_implies_wit_4` — `LLM_pre_process`

Use original membership and os_inv semaphore list ownership to focus its value cell. Extract UShort bounds and split value=0 versus value>0. Zero branch returns same-value wand; positive branch constructs wand updating semaphore_set_value and replace_semaphores, preserving all unrelated list/map/global resources including dataqueue. Reestablish semaphore uniqueness and range after decrement.
### `proof_of__SemaphoreObtain_which_implies_wit_6` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_6_split_goal_spatial`: Substitute sem_value=0 and apply the exact same-value wand.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_02__semaphore_views/proof_reuse.md`.

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
      "semaphore_views"
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
      "semaphore_views"
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
      "semaphore_views"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r2/group_02/src/.coq_debug/group_02_semaphore_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_02__semaphore_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_02__semaphore_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
