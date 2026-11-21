# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `semaphore_views`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1/groups/group_01__semaphore_views/SemaphoreObtainRuntime_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreObtain_entail_wit_4`, `proof_of__SemaphoreObtain_which_implies_wit_3`, `proof_of__SemaphoreObtain_which_implies_wit_3_split_goal_spatial`, `proof_of__SemaphoreObtain_which_implies_wit_4`, `proof_of__SemaphoreObtain_which_implies_wit_6`, `proof_of__SemaphoreObtain_which_implies_wit_6_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreObtain_entail_wit_4` — `LLM_pre_process`

Whole P contains manager ownership, successful node observation, restoration wand and held current-state bridge. Extract the selected SemaphoreAbs from bucket/list consistency, choose that original with its address/id, obtain nonzero address and UInt16 count from ownership; apply the wand to restore os_inv held. Q existential values come from this same selected object, never from a fresh arbitrary semaphore.
### `proof_of__SemaphoreObtain_which_implies_wit_3` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_3_split_goal_spatial`: For this spatial entailment: P os_inv held contains semaphore manager. Focus that conjunct as manager ownership and read-only restoration wand, retaining all remaining os_inv resources in the wand. Q chooses no new state.
### `proof_of__SemaphoreObtain_which_implies_wit_4` — `LLM_pre_process`

P os_inv held and selected original semaphore membership/map consistency. Split zero/positive count, focus exact ushort value via semaphore DLL ownership and unique address. Construct read wand in zero branch; in positive branch construct update wand rebuilding exact semaphore_set_value state, ID manager unchanged. Preserve global/task/Dataqueue compatibility because membership, IDs and pending sets are unchanged; use selected actual original value and its UInt16 bound.
### `proof_of__SemaphoreObtain_which_implies_wit_6` — `aggressive_pre_process`

- Split `proof_of__SemaphoreObtain_which_implies_wit_6_split_goal_spatial`: For this spatial entailment: P contains unchanged zero ushort and read restoration wand. Apply wand and frame untouched resources to obtain os_inv held; no semantic transition.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_01__semaphore_views/proof_reuse.md`.

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
      "semaphore_views"
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
      "semaphore_views"
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
      "semaphore_views"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/_coq_builds/SemaphoreObtainRuntime-vc-proving-r1/group_01/src/.coq_debug/group_01_semaphore_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_01__semaphore_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_01__semaphore_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
