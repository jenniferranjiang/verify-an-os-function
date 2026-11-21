# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `time_and_representation`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1/groups/group_07__time_and_representation/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_1_1`, `proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_1_2`, `proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_1_3`, `proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3`, `proof_of__SemaphoreObtain_which_implies_wit_1`, `proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial`, `proof_of__SemaphoreObtain_which_implies_wit_2`, `proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial`, `proof_of__SemaphoreObtain_partial_solve_wit_19_pure`, `proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_1_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1`: For this pure/projection obligation 1: P supplies msec=0 and the old Int cell; Q asks wait_ticks=0 and its half-range bound. Unfold semaphore_wait_ticks, select its first equality decision, use the positive constant KTICK_HALF_RANGE; no spatial mutation or fresh witness.

- Split `proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2`: For this pure/projection obligation 2: P supplies msec=0 and the old Int cell; Q asks wait_ticks=0 and its half-range bound. Unfold semaphore_wait_ticks, select its first equality decision, use the positive constant KTICK_HALF_RANGE; no spatial mutation or fresh witness.
### `proof_of__SemaphoreObtain_entail_wit_1_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1`: For this pure/projection obligation 1: P supplies msec=-1; Q asks the infinite-wait normalization and half-range bound. Unfold semaphore_wait_ticks, decide 0/-1, compute the range; carry the unchanged old cell.

- Split `proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2`: For this pure/projection obligation 2: P supplies msec=-1; Q asks the infinite-wait normalization and half-range bound. Unfold semaphore_wait_ticks, decide 0/-1, compute the range; carry the unchanged old cell.
### `proof_of__SemaphoreObtain_entail_wit_1_3` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1`: For this pure/projection obligation 1: P supplies positive signed-int msec and tick_from_time_ms result; Q asks signed conversion identity and [-1,KTICK_HALF_RANGE) bounds. Unfold the 100 Hz quotient/remainder/minimum-one conversion; derive its nonnegative signed-int bound from msec<=INT_MAX, then rewrite signed_last_nbits as identity. No extra msec restriction.

- Split `proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2`: For this pure/projection obligation 2: P supplies positive signed-int msec and tick_from_time_ms result; Q asks signed conversion identity and [-1,KTICK_HALF_RANGE) bounds. Unfold the 100 Hz quotient/remainder/minimum-one conversion; derive its nonnegative signed-int bound from msec<=INT_MAX, then rewrite signed_last_nbits as identity. No extra msec restriction.

- Split `proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3`: For this pure/projection obligation 3: P supplies positive signed-int msec and tick_from_time_ms result; Q asks signed conversion identity and [-1,KTICK_HALF_RANGE) bounds. Unfold the 100 Hz quotient/remainder/minimum-one conversion; derive its nonnegative signed-int bound from msec<=INT_MAX, then rewrite signed_last_nbits as identity. No extra msec restriction.
### `proof_of__SemaphoreObtain_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial`: For this spatial entailment: P owns Int storage; Q uses the existing four-byte integer predicate with the same address/value. Unfold the typed storage view and cancel; no new allocation, no range strengthening.
### `proof_of__SemaphoreObtain_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial`: For this spatial entailment: P owns the integer storage view; Q is the same Int field/cell representation. Unfold the existing integer predicate and cancel with the supplied bounds; same address and value.
### `proof_of__SemaphoreObtain_partial_solve_wit_19_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1`: For this pure/projection obligation 1: P identifies sem with original semaphore address. Q equates concrete pend_list field address to semaphore_pending_head. Unfold named ABI address definition and rewrite sem equality; retain spatial antecedent. Use existing layout facts, add no ABI axiom.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_07__time_and_representation/proof_reuse.md`.

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
      "time_and_representation"
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
      "time_and_representation"
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
      "time_and_representation"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r1/group_07/src/.coq_debug/group_07_time_and_representation.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_07__time_and_representation/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_07__time_and_representation/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
