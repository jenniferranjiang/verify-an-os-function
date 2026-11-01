# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `lookup_views`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_02__lookup_views/SemaphoreDelete_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_which_implies_wit_1`, `proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial`, `proof_of__SemaphoreDelete_which_implies_wit_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_02__lookup_views/SemaphoreDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/SemaphoreDelete_lib.v`
- Every new/adapted helper uses suffix `__lookup_views`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreDelete_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial`: Use aggressive_pre_process on the parent; prove this split only. Unfold os_inv and semaphore_inv. Keep all non-semaphore modules and os_world_wf in delete_global_frame; keep the management DLL and semaphore_context in delete_manager_frame. Rewrite stable global addresses by semaphore_context and cancel.
### `proof_of__SemaphoreDelete_which_implies_wit_2` — `LLM_pre_process`

Unfold store_idmanager_found to expose its selected bucket decomposition, bytes and bucket-wf facts. Convert membership of Build_IdNodeAbs query_id idnode in the semaphore_manager bucket to a semaphore original in st_lock.os_semaphores with matching ID and embedded ID address. Rejoin store_idbuckets_except with the selected bucket and restore the ordinary manager (using the exact existing byte representation, no allocation). Combine delete_manager_frame to os_inv. Obtain original.addr<>0 from the corresponding store_semaphore payload in the outer DLL. Instantiate original and retain all four required facts.

## Helpers

- `semaphore_found_close__lookup_views` (local): Statement shape is the found-manager plus delete_manager_frame bridge to an existing original object with query ID, embedded ID address and nonzero base, returning os_inv unchanged. Recombine bucket-except with its selected bucket, preserve bitmap bytes, reverse the semaphore_manager map/filter to obtain the original object, and obtain nonzero from its payload inside the management DLL. No standalone token grants memory.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_02__lookup_views/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-debug",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-proving-r1",
      "--group",
      "lookup_views"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "lookup_views"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "lookup_views"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r1/group_02/src/.coq_debug/group_02_lookup_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_02__lookup_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_02__lookup_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
