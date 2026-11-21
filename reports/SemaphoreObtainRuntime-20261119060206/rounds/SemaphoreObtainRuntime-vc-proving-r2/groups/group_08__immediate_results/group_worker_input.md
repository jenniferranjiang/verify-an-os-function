# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `immediate_results`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r2/groups/group_08__immediate_results/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_3_1`, `proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial`, `proof_of__SemaphoreObtain_entail_wit_3_2`, `proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial`, `proof_of__SemaphoreObtain_entail_wit_5`, `proof_of__SemaphoreObtain_entail_wit_5_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_5_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial`, `proof_of__SemaphoreObtain_entail_wit_6`, `proof_of__SemaphoreObtain_entail_wit_6_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_6_split_goal_2`, `proof_of__SemaphoreObtain_partial_solve_wit_19_pure`, `proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_3_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_1`: Crtos_GTrans reflexivity, preserve resources.

- Split `proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2`: Restore manager view via wand; os_global_context fixes nonnull manager address, contradict null manager branch.

- Split `proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial`: Reassociate manager resource and its restoration wand; apply wand and frame held token.
### `proof_of__SemaphoreObtain_entail_wit_3_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1`: Crtos_GTrans reflexivity.

- Split `proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2`: Restore os_inv from manager wand; ID query false identifies absent semaphore lookup. Specialize abs_semaphore_obtain safeExec at rely-reached held state and its missing-ID return -1.

- Split `proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial`: Apply manager restoration wand and frame held token.
### `proof_of__SemaphoreObtain_entail_wit_5` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_5_split_goal_1`: Use positive value update transition to derive Crtos_GTrans held (replace_semaphores ... held); retain resource frame.

- Split `proof_of__SemaphoreObtain_entail_wit_5_split_goal_2`: Specialize safeExec via rely and positive semaphore lookup, choose replacement state and locked inl0 branch; restore os_inv through new-value wand as needed.

- Split `proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial`: Rewrite retval=semaphore_addr original, apply decremented-value wand and frame token.
### `proof_of__SemaphoreObtain_entail_wit_6` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_entail_wit_6_split_goal_1`: Crtos_GTrans reflexivity.

- Split `proof_of__SemaphoreObtain_entail_wit_6_split_goal_2`: Select zero-value/zero-wait immediate -2 branch in abs_semaphore_obtain using original membership and id equality; specialize safeExec at held via rely.
### `proof_of__SemaphoreObtain_partial_solve_wit_19_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1`: Unfold semaphore_pending_head to the exact field-address expression; reflexivity and pure-right, framing all locals and os_inv.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_08__immediate_results/proof_reuse.md`.

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
      "SemaphoreObtainRuntime-vc-proving-r2",
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
      "SemaphoreObtainRuntime-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "immediate_results"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r2/group_08/src/.coq_debug/group_08_immediate_results.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_08__immediate_results/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_08__immediate_results/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
