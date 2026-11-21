# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `immediate_results`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1/groups/group_08__immediate_results/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_3_1`, `proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial`, `proof_of__SemaphoreObtain_entail_wit_3_2`, `proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial`, `proof_of__SemaphoreObtain_entail_wit_5`, `proof_of__SemaphoreObtain_entail_wit_5_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_5_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial`, `proof_of__SemaphoreObtain_entail_wit_6`, `proof_of__SemaphoreObtain_entail_wit_6_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_6_split_goal_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_3_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_1`: For this pure/projection obligation 1: P equates the address of the global semaphore manager with zero. Use addr_of_LE_var_not_zero to eliminate this impossible premise for every split, including spatial; do not invent an invalid-manager return transition.

- Split `proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2`: For this pure/projection obligation 2: P equates the address of the global semaphore manager with zero. Use addr_of_LE_var_not_zero to eliminate this impossible premise for every split, including spatial; do not invent an invalid-manager return transition.

- Split `proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial`: For this spatial entailment: P equates the address of the global semaphore manager with zero. Use addr_of_LE_var_not_zero to eliminate this impossible premise for every split, including spatial; do not invent an invalid-manager return transition.
### `proof_of__SemaphoreObtain_entail_wit_3_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1`: For this pure/projection obligation 1: P contains false ID lookup and the manager restoration wand. For GTrans unfold the existing relation; for safeExec instantiate the no-matching-semaphore branch of semaphore_obtain_effect using manager query consistency, then atomic/bind refinement with inl(-1); for spatial apply the read wand to the unchanged manager and frame InsideCritical.

- Split `proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2`: For this pure/projection obligation 2: P contains false ID lookup and the manager restoration wand. For GTrans unfold the existing relation; for safeExec instantiate the no-matching-semaphore branch of semaphore_obtain_effect using manager query consistency, then atomic/bind refinement with inl(-1); for spatial apply the read wand to the unchanged manager and frame InsideCritical.

- Split `proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial`: For this spatial entailment: P contains false ID lookup and the manager restoration wand. For GTrans unfold the existing relation; for safeExec instantiate the no-matching-semaphore branch of semaphore_obtain_effect using manager query consistency, then atomic/bind refinement with inl(-1); for spatial apply the read wand to the unchanged manager and frame InsideCritical.
### `proof_of__SemaphoreObtain_entail_wit_5` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_5_split_goal_1`: For this pure/projection obligation 1: P contains decremented ushort, its update wand, positive old value and original obtain safeExec. Spatial: consume updated cell/wand to restore replace_semaphores state. GTrans: unfold relation. Refinement: instantiate positive-count semaphore_obtain_effect using original and exact decrement state, then atomic/bind normal step with inl 0. Preserve InsideCritical held.

- Split `proof_of__SemaphoreObtain_entail_wit_5_split_goal_2`: For this pure/projection obligation 2: P contains decremented ushort, its update wand, positive old value and original obtain safeExec. Spatial: consume updated cell/wand to restore replace_semaphores state. GTrans: unfold relation. Refinement: instantiate positive-count semaphore_obtain_effect using original and exact decrement state, then atomic/bind normal step with inl 0. Preserve InsideCritical held.

- Split `proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial`: For this spatial entailment: P contains decremented ushort, its update wand, positive old value and original obtain safeExec. Spatial: consume updated cell/wand to restore replace_semaphores state. GTrans: unfold relation. Refinement: instantiate positive-count semaphore_obtain_effect using original and exact decrement state, then atomic/bind normal step with inl 0. Preserve InsideCritical held.
### `proof_of__SemaphoreObtain_entail_wit_6` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_6_split_goal_1`: For this pure/projection obligation 1: P supplies zero count and wait_ticks=0. Q GTrans is immediate; Q safeExec follows from the zero-timeout semaphore_obtain_effect branch with original semaphore, unchanged held state and inl(-2), followed by atomic/bind refinement.

- Split `proof_of__SemaphoreObtain_entail_wit_6_split_goal_2`: For this pure/projection obligation 2: P supplies zero count and wait_ticks=0. Q GTrans is immediate; Q safeExec follows from the zero-timeout semaphore_obtain_effect branch with original semaphore, unchanged held state and inl(-2), followed by atomic/bind refinement.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_08__immediate_results/proof_reuse.md`.

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
      "immediate_results"
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
      "immediate_results"
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
      "immediate_results"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r1/group_08/src/.coq_debug/group_08_immediate_results.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_08__immediate_results/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_08__immediate_results/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
