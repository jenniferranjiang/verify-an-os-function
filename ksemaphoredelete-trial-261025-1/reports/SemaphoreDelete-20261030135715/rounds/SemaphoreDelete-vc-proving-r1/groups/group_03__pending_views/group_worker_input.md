# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `pending_views`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_03__pending_views/SemaphoreDelete_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_which_implies_wit_3`, `proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial`, `proof_of__SemaphoreDelete_which_implies_wit_4`, `proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_1`, `proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial`, `proof_of__SemaphoreDelete_entail_wit_3_1`, `proof_of__SemaphoreDelete_entail_wit_3_1_split_goal_1`, `proof_of__SemaphoreDelete_entail_wit_3_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/groups/group_03__pending_views/SemaphoreDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/SemaphoreDelete_lib.v`
- Every new/adapted helper uses suffix `__pending_views`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreDelete_which_implies_wit_3` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial`: Use aggressive_pre_process on the parent; prove this split only. Focus original in the semaphore management DLL using In and sem=original.addr. Extract its pending DLL, retaining payload/manager/global resources; use wand introduction to package restoration of exactly the same DLL as delete_pending_restore. semaphore_wait_node and sched_link_node are definitionally the same node projection. No node ownership is duplicated.
### `proof_of__SemaphoreDelete_which_implies_wit_4` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_1`: Use aggressive_pre_process on the parent; prove this split only. Unfold semaphore_pending_nodes; instantiate its object witness with original using In original and sem=original.addr, with reflexive map equality.

- Split `proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial`: Use aggressive_pre_process on the parent; prove this split only. Unfold delete_pending_restore and semaphore_pending_head, then eliminate the spatial wand with its matching pending DLL; retain no duplicate DLL after os_inv is restored.
### `proof_of__SemaphoreDelete_entail_wit_3_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_entail_wit_3_1_split_goal_1`: Use aggressive_pre_process on the parent; prove this split only. map sched_link_node original.pending <> nil implies original.pending <> nil by destructing the source list; the other hypotheses need no use.
### `proof_of__SemaphoreDelete_entail_wit_3_2` — `LLM_pre_process`

Choose a whole-goal disjunct and drained := st_lock. map sched_link_node waiting = nil implies waiting = nil. Use the pending DLL with delete_pending_restore by wand elimination to recover os_inv, cancel InsideCritical, and instantiate semaphore_resume_all_effect at its nil identity branch. Establish semaphore_pending_nodes using the existing In original and sem-address equalities. Preserve all existing ID/range/safeExec facts.

## Helpers

- `pending_dll_focus__pending_views` (local): For In original st.os_semaphores and p=original.addr, prove os_inv sg st |-- pending DLL at p with original.pending ** delete_pending_restore sg st p original.pending. Split the outer DLL at original, unfold its payload, and introduce a wand from the untouched concrete frame; restoring the same DLL reconstructs the original outer DLL, module and os_inv. The member/address hypotheses are explicit in which3.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_03__pending_views/proof_reuse.md`.

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
      "pending_views"
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
      "pending_views"
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
      "pending_views"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r1/group_03/src/.coq_debug/group_03_pending_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_03__pending_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r1/groups/group_03__pending_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
