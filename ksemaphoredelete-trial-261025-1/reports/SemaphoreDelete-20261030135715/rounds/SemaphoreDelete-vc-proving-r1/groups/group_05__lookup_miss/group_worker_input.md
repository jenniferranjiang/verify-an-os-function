# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `lookup_miss`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_05__lookup_miss/SemaphoreDelete_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_entail_wit_2_1`, `proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_1`, `proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_2`, `proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_spatial`, `proof_of__SemaphoreDelete_entail_wit_2_2`, `proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_1`, `proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_2`, `proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_05__lookup_miss/SemaphoreDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/SemaphoreDelete_lib.v`
- Every new/adapted helper uses suffix `__lookup_miss`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreDelete_entail_wit_2_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_1`: Use aggressive_pre_process on the parent; prove this split only. Crtos_GTrans st_lock st_lock is reflexive in the existing protocol.

- Split `proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_2`: Use aggressive_pre_process on the parent; prove this split only. The premise &(k_sem_id_manager)=0 contradicts CNotation.addr_of_LE_var_not_zero. Close the requested safeExec fact from that contradiction.

- Split `proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_spatial`: Use aggressive_pre_process on the parent; prove this split only. The same impossible global-address equality suffices; alternatively unfold delete_manager_frame/os_inv/semaphore_inv and refold the unchanged manager plus frame.
### `proof_of__SemaphoreDelete_entail_wit_2_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_1`: Use aggressive_pre_process on the parent; prove this split only. Apply the existing GTrans reflexivity for st_lock.

- Split `proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_2`: Use aggressive_pre_process on the parent; prove this split only. From query=false and semaphore_manager.idlist=map semaphore_id sems derive no object has semaphore_query_id id_pre (rewrite uint16 truncation to mod65536). Build the miss/false locked-effect at st_lock unchanged. Entry safeExec and RTrans to st_lock then yield the ret tt continuation through the atomic-command and bind semantics. The spatial context is unchanged.

- Split `proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_spatial`: Use aggressive_pre_process on the parent; prove this split only. Unfold delete_manager_frame, semaphore_inv and os_inv; use semaphore_context to rewrite global manager/list addresses and cancel/reassemble all unchanged module resources and InsideCritical.

## Helpers

- `delete_miss_continuation__lookup_miss` (local): From id>=0, RTrans before st_lock, query(semaphore_manager st_lock.semaphores,unsigned_last_nbits id 16)=false and safeExec of abs_semaphore_delete, derive safeExec LastSeen st_lock (ret tt) X. Use id_in_ids_false_iff plus semaphore_query_id=mod65536 to establish the miss branch with p=0,resched=false,after=st_lock, then unfold atomic/bind semantics. All premises are explicit in entail2_2; the global-null alternative is contradictory by addr_of_LE_var_not_zero.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_05__lookup_miss/proof_reuse.md`.

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
      "lookup_miss"
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
      "lookup_miss"
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
      "lookup_miss"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r1/group_05/src/.coq_debug/group_05_lookup_miss.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_05__lookup_miss/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_05__lookup_miss/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
