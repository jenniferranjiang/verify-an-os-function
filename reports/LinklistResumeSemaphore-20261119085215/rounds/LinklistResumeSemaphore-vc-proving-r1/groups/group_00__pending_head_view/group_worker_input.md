# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `pending_head_view`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/LinklistResumeSemaphore-20261119085215/LinklistResumeSemaphore-vc-proving-r1/groups/group_00__pending_head_view/LinklistResumeSemaphore_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResume_which_implies_wit_1`, `proof_of_LinklistResume_which_implies_wit_2`, `proof_of_LinklistResume_which_implies_wit_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_LinklistResume_which_implies_wit_1` — `LLM_pre_process`

Destruct nonempty waiting into first::rest. From semaphore_pending_nodes choose the actual obj in os_semaphores and its address; injectivity of map sched_link_node (project getData) identifies its pending addresses with first::rest. Open only the semaphore component of os_inv, focus obj payload in the management DLL, then its nonempty pending DLL. Borrow head.node_next pointing to sched_link_of first. The head payload pure_suspend_sched_link supplies first task-map lookup; the owned published descriptor supplies addr_aligned first 4. Frame every other object/module, task descriptor and list remainder, and introduce the same-value wand rebuilding the exact original os_inv. Existentials are the actual head/tail, not arbitrary addresses. Preserve pending-node relation and list_pre=head equality. Both generated alternatives have the same shape; select the whole route.
### `proof_of_LinklistResume_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of_LinklistResume_which_implies_wit_2_split_goal_spatial`: Normalize store_ptr to the concrete pointer-cell assertion, then apply wand elimination to head.node_next and its exact same-value restoration wand. No state update or extra frame hypothesis is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/LinklistResumeSemaphore-20261119085215/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-proving-r1/groups/group_00__pending_head_view/proof_reuse.md`.

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
      "LinklistResumeSemaphore-20261119085215",
      "--round",
      "LinklistResumeSemaphore-vc-proving-r1",
      "--group",
      "pending_head_view"
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
      "LinklistResumeSemaphore-20261119085215",
      "--round",
      "LinklistResumeSemaphore-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "pending_head_view"
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
      "LinklistResumeSemaphore-20261119085215",
      "--round",
      "LinklistResumeSemaphore-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "pending_head_view"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/LinklistResumeSemaphore-20261119085215/_coq_builds/LinklistResumeSemaphore-vc-proving-r1/group_00/src/.coq_debug/group_00_pending_head_view.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-proving-r1/groups/group_00__pending_head_view/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-proving-r1/groups/group_00__pending_head_view/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
