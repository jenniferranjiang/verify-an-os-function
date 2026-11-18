# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `storage_alignment`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r2/groups/group_00__storage_alignment/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_which_implies_wit_1`, `proof_of_InitDataqueue_which_implies_wit_1_split_goal_1`, `proof_of_InitDataqueue_which_implies_wit_1_split_goal_2`, `proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial`, `proof_of_InitDataqueue_which_implies_wit_2`, `proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial`, `proof_of_InitDataqueue_partial_solve_wit_4_pure`, `proof_of_InitDataqueue_partial_solve_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of_InitDataqueue_which_implies_wit_1_split_goal_1`: Unfold DataqueueStorage; retain the owned 20 bytes. Project alignment/nonzero pure conjuncts and use authorized dataqueue_layout_abi size(DataQueue)=20 to rewrite the spatial length. No new address premise.

- Split `proof_of_InitDataqueue_which_implies_wit_1_split_goal_2`: Unfold DataqueueStorage; retain the owned 20 bytes. Project alignment/nonzero pure conjuncts and use authorized dataqueue_layout_abi size(DataQueue)=20 to rewrite the spatial length. No new address premise.

- Split `proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial`: Unfold DataqueueStorage; retain the owned 20 bytes. Project alignment/nonzero pure conjuncts and use authorized dataqueue_layout_abi size(DataQueue)=20 to rewrite the spatial length. No new address premise.
### `proof_of_InitDataqueue_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial`: Use explicit PreH1 addr_aligned p_queue 4 and authorized dataqueue_layout_abi size/offset facts. Expand or split the 20 known-zero bytes at offsets 0,2,4,6,8,12,16,20. Construct zero UShort stores at p,p+2,p+4, zero Ptr at p+8, zero Int at p+12,p+16; forget values only in padding [p+6,p+8). Derive typed valid_object range from byte ranges and alignment2/4 from PreH1. Cancel each byte exactly once. No spatial resource is introduced by the ABI fact.
### `proof_of_InitDataqueue_partial_solve_wit_4_pure` — `LLM_pre_process`

Preserve every spatial cell at the same address (reorder/cancel only). Required pure facts are already named premises; for implication-shaped partial_solve, introduce the pure premise then unfold auxiliary target. No abstract-state transition is invented. Retain lock/current parameter and caller resources exactly. Specifically PreH4 is exactly addr_aligned p_queue_pre 4; extract it without using the byte array for alignment.
### `proof_of_InitDataqueue_partial_solve_wit_4` — `LLM_pre_process`

Preserve every spatial cell at the same address (reorder/cancel only). Required pure facts are already named premises; for implication-shaped partial_solve, introduce the pure premise then unfold auxiliary target. No abstract-state transition is invented. Retain lock/current parameter and caller resources exactly. The new aux preserves the known full-zero byte array plus os_inv/InsideCritical and reasserts entry alignment.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_00__storage_alignment/proof_reuse.md`.

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
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-vc-proving-r2",
      "--group",
      "storage_alignment"
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
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "storage_alignment"
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
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "storage_alignment"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/_coq_builds/InitDataqueue-vc-proving-r2/group_00/src/.coq_debug/group_00_storage_alignment.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_00__storage_alignment/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_00__storage_alignment/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
