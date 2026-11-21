# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `rollback_identity`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r2/groups/group_04__rollback_identity/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_13_1`, `proof_of__SemaphoreObtain_entail_wit_13_2`, `proof_of__SemaphoreObtain_which_implies_wit_10`, `proof_of__SemaphoreObtain_which_implies_wit_11`, `proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): `proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_2`.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_13_1` — `LLM_pre_process`

Retain os_inv after to obtain task ID uniqueness/global context. The two successful ID lookups identify task_2 with task; map lookup injectivity identifies desc_2 with sd. Contradict not-suspended versus sd suspended, closing entire branch. Pure splits omit invariant facts needed for this identity.
### `proof_of__SemaphoreObtain_entail_wit_13_2` — `LLM_pre_process`

Choose after_wakeup=after. From os_inv after and wakeup transition preservation recover suspended ID uniqueness and identify task_2=task, desc_2=sd. Compose clear-status, prio suspend, delay allocation failure and actual wakeup transition into abs_semaphore_obtain locked result inl(-5), then specialize entry safeExec via rely before->held. Obtain Crtos_GTrans held after and ret(-5); cancel os_inv after and held token. No independent rollback axiom.
### `proof_of__SemaphoreObtain_which_implies_wit_10` — `LLM_pre_process`

Use task_desc_map lookup and os_inv ID-manager correspondence/uniqueness to choose rollback_id=tdId of sd. Borrow nested id.id UShort, obtain 0<=id<65536 and get_task_with_idnode_success for this exact task, and construct same-value restoration wand; retain every unrelated frame.
### `proof_of__SemaphoreObtain_which_implies_wit_11` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial`: Apply rollback-ID cell same-value wand to restore os_inv suspended.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_04__rollback_identity/proof_reuse.md`.

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
      "rollback_identity"
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
      "rollback_identity"
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
      "rollback_identity"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r2/group_04/src/.coq_debug/group_04_rollback_identity.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_04__rollback_identity/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r2/groups/group_04__rollback_identity/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
