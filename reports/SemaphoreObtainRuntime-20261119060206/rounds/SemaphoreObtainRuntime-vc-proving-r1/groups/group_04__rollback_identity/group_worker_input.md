# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `rollback_identity`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1/groups/group_04__rollback_identity/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_which_implies_wit_10`, `proof_of__SemaphoreObtain_which_implies_wit_11`, `proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial`, `proof_of__SemaphoreObtain_entail_wit_13_1`, `proof_of__SemaphoreObtain_entail_wit_13_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): `proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_2`, `proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_1`, `proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_2`.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_which_implies_wit_10` — `LLM_pre_process`

P os_inv suspended and map lookup for cached suspended task. Focus its ID cell and choose rollback_id from that descriptor. Derive range/query/bucket membership get_task_with_idnode_success from task-world and ID-manager consistency, retaining all unborrowed resources in the read restoration wand. Do not assume arbitrary IDs identify the task.
### `proof_of__SemaphoreObtain_which_implies_wit_11` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial`: For this spatial entailment: P contains borrowed task-ID field plus read restoration wand. Apply wand to exact observed ID cell and preserve other resources to reconstitute os_inv suspended.
### `proof_of__SemaphoreObtain_entail_wit_13_1` — `LLM_pre_process`

Select spatial whole alternative. P has os_inv suspended and two get_task_with_idnode_success memberships for rollback_id. Obtain ID uniqueness from os_inv task-ID manager; identify task_2 with original running task, then identify desc_2=sd by map functionality. Contradict desc_2 stat != SUSPEND versus sd stat=SUSPEND. Pure split lacks the manager uniqueness premise; do not use it as a standalone theorem.
### `proof_of__SemaphoreObtain_entail_wit_13_2` — `LLM_pre_process`

Select spatial whole alternative. P has os_inv after and Wakeup step plus two pre-wakeup ID memberships. Wakeup preserves ID manager; derive the pre-manager uniqueness from post os_inv and identify task_2=task and desc_2=sd. Choose after_wakeup=after. Build finite-delay-failure semaphore_obtain_effect with original, desc, suspended, sd, delayed=suspended, ptr0, rc=-5 and actual wakeup step; atomic/bind refinement yields ret(-5). Preserve returned inv/token. Pure split drops uniqueness needed for this identity.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_04__rollback_identity/proof_reuse.md`.

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
      "SemaphoreObtainRuntime-vc-proving-r1",
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
      "SemaphoreObtainRuntime-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "rollback_identity"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r1/group_04/src/.coq_debug/group_04_rollback_identity.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_04__rollback_identity/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_04__rollback_identity/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
