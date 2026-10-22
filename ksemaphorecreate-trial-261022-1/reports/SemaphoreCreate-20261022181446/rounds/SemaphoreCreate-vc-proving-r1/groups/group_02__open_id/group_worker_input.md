# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `open_id`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_02__open_id/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_3`, `proof_of__SemaphoreCreate_entail_wit_3_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_3_split_goal_2`, `proof_of__SemaphoreCreate_entail_wit_3_split_goal_3`, `proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial`, `proof_of__SemaphoreCreate_partial_solve_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_02__open_id/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__open_id`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_3` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_3_split_goal_1`: From InsideCritical ** os_inv ** SemaphoreZero derive fresh sem not in map semaphore_addr. Open semaphore DLL ownership within os_inv; a hypothetical member at sem exposes a value cell conflicting under separating conjunction with SemaphoreZero at the same address. Use the frozen SemaphoreOwnership facts or a local disjointness proof. No freshness is inferred from malloc pure bounds alone.

- Split `proof_of__SemaphoreCreate_entail_wit_3_split_goal_2`: Open os_inv then semaphore_inv to extract semaphore_context for os_semaphore_stable sg; spatial resources may be discarded in this pure entailment.

- Split `proof_of__SemaphoreCreate_entail_wit_3_split_goal_3`: Open os_inv and project its os_world_wf fact. Keep the state exactly st_lock; this is independent of before except the given rely relation.

- Split `proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial`: Open os_inv into the displayed task/tick/delay/assign/recycler/idle/etc frame and semaphore manager/full DLL. Open SemaphoreZero into ZeroIdNode/value/nodes/padding and weaken the zero ID node to VRTOS store_idnode_insert_ready using the imported bridge. Reassociate/cancel InsideCritical; no heap or abstract state update.
### `proof_of__SemaphoreCreate_partial_solve_wit_4` — `LLM_pre_process`

Introduce all pure premises; preserve each spatial resource with cancellation/reassociation. Re-establish the displayed pure conjunction from the same antecedent premises; there is no state change or fresh existential. Only expose and move the existing manager and insert-ready node to the front for IdInsertObj. Preserve value zero, pend/link NodeZero and padding as frames.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_02__open_id/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-debug",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--group",
      "open_id"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "open_id"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "open_id"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/_coq_builds/SemaphoreCreate-vc-proving-r1/group_02/src/.coq_debug/group_02_open_id.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_02__open_id/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_02__open_id/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
