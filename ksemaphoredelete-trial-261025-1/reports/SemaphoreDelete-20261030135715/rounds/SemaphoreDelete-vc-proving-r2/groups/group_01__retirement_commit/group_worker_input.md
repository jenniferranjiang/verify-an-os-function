# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `retirement_commit`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r2/groups/group_01__retirement_commit/SemaphoreDelete_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_entail_wit_4_2`, `proof_of__SemaphoreDelete_entail_wit_4_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r2/groups/group_01__retirement_commit/SemaphoreDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/SemaphoreDelete_lib.v`
- Every new/adapted helper uses suffix `__retirement_commit`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreDelete_entail_wit_4_2` — `LLM_pre_process`

Choose a whole-goal disjunct. Use old ID NoDup (PreH16), the list decomposition/current ID equality and idmanager_contains to identify idnode_2 with the target embedded ID. Rewrite the removed manager to semaphore_manager(prefix++suffix). From remaining DLL plus current payload/self node derive target-address exclusion from all remaining payloads, so semaphore_unpublish equals removing exactly current. Instantiate after := replace_semaphores (semaphore_unpublish original.addr drained.os_semaphores) drained. Rebuild os_inv: the empty current pending contributes no sched owners, task map and all non-semaphore modules stay unchanged, so delete_global_frame can be reindexed. Reassemble ID=65535, ID-link self, value/padding, empty pending and management self as SemaphoreRetired. Build the successful locked-effect witness original,drained; original.pending=nil fixes resched=false, and transfer entry safeExec through RTrans/atomic/bind to ret tt. Crtos_GTrans holds by the existing protocol. No old-manager wf may be invented after deletion. Import repair for this round: use `From Coq Require Import Lia Sorting.Permutation.` in the supplemental library imports; omit redundant `Bool.Bool`. The merger hoists supplemental imports before all helper declarations, and importing Bool.Bool there makes assertion && parse as bool. Rocq MCP compiled the entire prior merged helper library successfully with only this import token removed, retaining Lia, Sorting.Permutation and Coq.micromega.Lia. Preserve every helper proposition and proof body unless a current check gives a further concrete error; no specification or generated-goal changes are needed.
### `proof_of__SemaphoreDelete_entail_wit_4_4` — `LLM_pre_process`

Same concrete resource reconstruction as entail_wit_4_2, with the preserved old ID NoDup and contains fact identifying idnode_2. Instantiate after by unpublishing the empty current object from drained. Preserve every non-semaphore resource and derive the unchanged scheduling-owner list from current.pending=nil. Construct the locked successful effect from original and drained. Here original.pending<>nil fixes resched=true, so the resulting safeExec continuation is abs_ktask_assign, not ret tt. Preserve InsideCritical and return the full private SemaphoreRetired. Import repair for this round: use `From Coq Require Import Lia Sorting.Permutation.` in the supplemental library imports; omit redundant `Bool.Bool`. The merger hoists supplemental imports before all helper declarations, and importing Bool.Bool there makes assertion && parse as bool. Rocq MCP compiled the entire prior merged helper library successfully with only this import token removed, retaining Lia, Sorting.Permutation and Coq.micromega.Lia. Preserve every helper proposition and proof body unless a current check gives a further concrete error; no specification or generated-goal changes are needed.

## Helpers

- `deleted_id_node_unique__retirement_commit` (local): Pure statement shape: semaphore_context sg, sems=prefix++current::suffix, NoDup(map semaphore_id sems), and idmanager_contains sg.manager_stable (semaphore_manager sems) current.id returned imply returned=&current.addr.id. Expand contains/bucket membership and map/filter membership; equal IDs under NoDup identify the same list element. Every premise appears in the retirement VC.
- `manager_remove_current__retirement_commit` (local): Prove with hoffset=16, sems=prefix++current::suffix and NoDup(mapped IDs): idmanager_remove sm (semaphore_manager sems) current.id = semaphore_manager(prefix++suffix). Induct/filter/map per bucket and show remove deletes exactly this unique ID; do not assume old manager spatial ownership after the call.
- `retire_empty_semaphore_memory__retirement_commit` (local): Prove a reusable assertion bridge from the exact post-removal resources: delete_global_frame sg drained, remaining mapped management DLL, current payload with pending=nil, current management self node, removed manager, returned target ID=65535 plus its self-link. Include semaphore_context, list decomposition, current field equalities and old ID NoDup/contains as premises. Infer address exclusion from separating payload ownership, identify the target ID with deleted_id_node_unique, rewrite manager via manager_remove_current, and set after=replace_semaphores(semaphore_unpublish p drained.os_semaphores) drained. Empty pending makes os_sched_owners unchanged; reconstruct os_world_wf and every framed module, then os_inv after * SemaphoreRetired p value. All premises are already in entail4_2/4_4; no missing wf may be assumed.
- `delete_atomic_continuation__retirement_commit` (local): Pure statement shape: id>=0, Crtos_RTrans before st_lock, nrm(abs_semaphore_delete_locked id) st_lock resched after, and safeExec(LastSeen before,abs_semaphore_delete sg id,X) imply safeExec(LastSeen after,(if resched then abs_ktask_assign else ret tt),X). Unfold/compose safeExec bind and task_atomic_cmd/LastSeen; use the supplied RTrans and locked-step witness. Instantiate the successful locked step with original/drained from the VCs. The protocol GTrans is unchanged.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r2/groups/group_01__retirement_commit/proof_reuse.md`.

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
      "SemaphoreDelete-vc-proving-r2",
      "--group",
      "retirement_commit"
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
      "SemaphoreDelete-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "retirement_commit"
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
      "SemaphoreDelete-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "retirement_commit"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r2/group_01/src/.coq_debug/group_01_retirement_commit.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r2/groups/group_01__retirement_commit/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r2/groups/group_01__retirement_commit/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
