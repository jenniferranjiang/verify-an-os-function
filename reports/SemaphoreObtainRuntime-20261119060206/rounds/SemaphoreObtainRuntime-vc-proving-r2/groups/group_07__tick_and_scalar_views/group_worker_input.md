# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `tick_and_scalar_views`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r2/groups/group_07__tick_and_scalar_views/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_1_1`, `proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_1_2`, `proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_1_3`, `proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3`, `proof_of__SemaphoreObtain_which_implies_wit_1`, `proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial`, `proof_of__SemaphoreObtain_which_implies_wit_2`, `proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_1_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1`: Unfold KTICK_HALF_RANGE; numeric positive bound.

- Split `proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2`: Unfold semaphore_wait_ticks at zero; select zero branch by arithmetic.
### `proof_of__SemaphoreObtain_entail_wit_1_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1`: Unfold KTICK_HALF_RANGE; prove -1 below bound.

- Split `proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2`: Unfold semaphore_wait_ticks at -1 and select infinite branch.
### `proof_of__SemaphoreObtain_entail_wit_1_3` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1`: Use msec positive and <=INT_MAX, tick_from_time_ms divisor100Hz/1000 bounds to show retval<KTICK_HALF_RANGE. Normalize signed_last_nbits using signed32 range.

- Split `proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2`: Same tick bounds imply retval>=0; signed32 normalization yields requested lower bound.

- Split `proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3`: Use retval=tick_from_time_ms msec and msec>0 to select semaphore_wait_ticks finite branch, normalize signed32 conversion.
### `proof_of__SemaphoreObtain_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial`: Use existing Int/store_integer representation equivalence at 4-byte alignment; supplied signed bounds agree. No new ABI assumption.
### `proof_of__SemaphoreObtain_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial`: Reverse same store_integer/Int representation equivalence; same address/value.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_07__tick_and_scalar_views/proof_reuse.md`.

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
      "tick_and_scalar_views"
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
      "tick_and_scalar_views"
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
      "tick_and_scalar_views"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r2/group_07/src/.coq_debug/group_07_tick_and_scalar_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_07__tick_and_scalar_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_07__tick_and_scalar_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
