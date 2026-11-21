# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `borrow_fields`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreDeleteIC-20261118235913/SemaphoreDeleteIC-vc-proving-r1/groups/group_01__borrow_fields/SemaphoreDeleteIC_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_which_implies_wit_2`, `proof_of__SemaphoreDelete_which_implies_wit_2_split_goal_spatial`, `proof_of__SemaphoreDelete_which_implies_wit_3`, `proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial`, `proof_of__SemaphoreDelete_which_implies_wit_4`, `proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial`, `proof_of__SemaphoreDelete_which_implies_wit_5`, `proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreDelete_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_which_implies_wit_2_split_goal_spatial`: Borrow the empty pending DLL from the payload of original in the global management DLL. Substitute sem=original.addr and use In to split the list around original. Unfold os_inv/semaphore_inv/store_semaphore only as needed; pending_addrs=nil makes its mapped pending list empty. Keep all remaining cells and global modules, including dataqueue_inv, in the residual frame. Use separating implication introduction to construct the exact wand from the borrowed DLL back to the original os_inv; no ownership may be dropped.
### `proof_of__SemaphoreDelete_which_implies_wit_3` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial`: The left spatial assertion is exactly pending_DLL ** wand pending_DLL os_inv at the same sem address. Apply wand elimination, preserving the equality bridge from the antecedent; there are no existential state changes.
### `proof_of__SemaphoreDelete_which_implies_wit_4` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial`: Borrow original.id UShort from the ID manager, not from store_semaphore (which owns no ID fields). In original old supplies its semaphore_idnode in the derived bucket. Expose store_idmanager/idbucket containing that node, split its DLL around the matching node, and expose store_idnode. The embedded/nested IdNode address is the same generated address; use the established layout/nested-field identities if necessary. Carry the remaining manager and every module into a wand restoring the same os_inv, using wand introduction. Do not change the value or state, and do not assume extra address uniqueness.
### `proof_of__SemaphoreDelete_which_implies_wit_5` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial`: Identify the generated UShort notation with store_ushort at the identical nested address. Apply wand elimination to UShort ** wand UShort os_inv. No list change or abstract transition is involved.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreDeleteIC-20261118235913/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/rounds/SemaphoreDeleteIC-vc-proving-r1/groups/group_01__borrow_fields/proof_reuse.md`.

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
      "SemaphoreDeleteIC-20261118235913",
      "--round",
      "SemaphoreDeleteIC-vc-proving-r1",
      "--group",
      "borrow_fields"
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
      "SemaphoreDeleteIC-20261118235913",
      "--round",
      "SemaphoreDeleteIC-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "borrow_fields"
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
      "SemaphoreDeleteIC-20261118235913",
      "--round",
      "SemaphoreDeleteIC-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "borrow_fields"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreDeleteIC-20261118235913/_coq_builds/SemaphoreDeleteIC-vc-proving-r1/group_01/src/.coq_debug/group_01_borrow_fields.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/rounds/SemaphoreDeleteIC-vc-proving-r1/groups/group_01__borrow_fields/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/rounds/SemaphoreDeleteIC-vc-proving-r1/groups/group_01__borrow_fields/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
