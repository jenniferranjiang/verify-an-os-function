# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `head_view`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_02__head_view/MutexResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_which_implies_wit_2`, `proof_of_LinklistResumeAll_which_implies_wit_3`, `proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial`, `proof_of_LinklistResumeAll_which_implies_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_02__head_view/MutexResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexResumeAll_lib.v`
- Every new/adapted helper uses suffix `__head_view`. Preserve the seed.

### `proof_of_LinklistResumeAll_which_implies_wit_2` — `LLM_pre_process`

From os_inv and mutex_pending_nodes locate the Mutex payload in the management DLL. Map sched_link_node equality recovers the same pending task sequence. Split the pending DLL head.next field, branch on remaining nil/cons, and retain the exact rest in a wand that reconstructs the original os_inv when the field is returned. Empty gives next=head; nonempty gives next=sched_link_of first and next<>head from exclusive sentinel/node ownership. Choose the corresponding assertion disjunction and exact first/tail witnesses.
### `proof_of_LinklistResumeAll_which_implies_wit_3` — `aggressive_pre_process`

- Split `proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial`: Unfold mutex_resume_next_restore and eliminate the wand using its adjacent head.next cell; the consequent is exactly the original os_inv, with no state change.
### `proof_of_LinklistResumeAll_which_implies_wit_4` — `LLM_pre_process`

Use the spatial disjunct, not the pure-only alternative. Expand the Mutex pending DLL payload and shared task map just enough to derive a registered SUSPEND descriptor for target and its alignment. Choose that desc, rewrite remaining=target::rest and next=sched_link_of target, and return the unchanged os_inv. Membership alone supplies no memory; both the wait predicate and task representation must be used.

## Helpers

- `mutex_pending_head_focus__head_view` (local): For os_inv sg current with matching pure mutex_pending_nodes p current(map sched_link_node remaining), derive the empty/nonempty head.next value and a return wand to the same os_inv. Use generic DLL split/fold and map projection injectivity; prove nonempty next differs from sentinel via separation conflict rather than adding an address premise.
- `mutex_waiter_descriptor__head_view` (local): From os_inv sg st and mutex_pending_nodes p st(sched_link_node task::rest), derive exists desc, st.task_desc_map task=Some desc /\ stat desc=SUSPEND /\ addr_aligned task ALIGN_SIZE while preserving os_inv. The pure wait relation locates the map entry and Task representation yields alignment; reconstruct any borrowed payload.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_02__head_view/proof_reuse.md`.

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
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "MutexResumeAll-20261103170225",
      "--round",
      "MutexResumeAll-vc-proving-r1",
      "--group",
      "head_view"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-check",
      "--run",
      "MutexResumeAll-20261103170225",
      "--round",
      "MutexResumeAll-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "head_view"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-check",
      "--run",
      "MutexResumeAll-20261103170225",
      "--round",
      "MutexResumeAll-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "head_view"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/_coq_builds/MutexResumeAll-vc-proving-r1/group_02/src/.coq_debug/group_02_head_view.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_02__head_view/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_02__head_view/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
