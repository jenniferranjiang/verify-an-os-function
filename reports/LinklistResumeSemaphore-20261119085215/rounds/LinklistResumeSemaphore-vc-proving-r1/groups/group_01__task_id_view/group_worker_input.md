# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `task_id_view`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/LinklistResumeSemaphore-20261119085215/LinklistResumeSemaphore-vc-proving-r1/groups/group_01__task_id_view/LinklistResumeSemaphore_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResume_which_implies_wit_3`, `proof_of_LinklistResume_which_implies_wit_4`, `proof_of_LinklistResume_which_implies_wit_4_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_LinklistResume_which_implies_wit_3` — `LLM_pre_process`

From the nonempty semaphore_pending_nodes witness and os_inv derive first is a published suspended task (pending DLL pure payload, or world ownership-domain). Obtain its descriptor lookup and focus store_published_task in task_inv.store_map. Choose task_id=desc.tdId. Use task_world_wf/registered ID correspondence plus the owned task ID manager to establish get_task_with_idnode_success at this same task; extract unsigned-short range 0<=task_id<65536 from the real id.id cell. Borrow that cell and construct a same-value wand restoring task ID/descriptor map and the exact original os_inv; retain all semaphore and other module resources. The pending relation is unchanged. Do not infer task identity from a bare numeric ID or strengthen the contract.
### `proof_of_LinklistResume_which_implies_wit_4` — `aggressive_pre_process`

- Split `proof_of_LinklistResume_which_implies_wit_4_split_goal_spatial`: Normalize store_ushort to the UShort cell and eliminate its same-value wand, recovering os_inv at the unchanged before state.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/LinklistResumeSemaphore-20261119085215/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-proving-r1/groups/group_01__task_id_view/proof_reuse.md`.

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
      "task_id_view"
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
      "task_id_view"
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
      "task_id_view"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/LinklistResumeSemaphore-20261119085215/_coq_builds/LinklistResumeSemaphore-vc-proving-r1/group_01/src/.coq_debug/group_01_task_id_view.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-proving-r1/groups/group_01__task_id_view/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-proving-r1/groups/group_01__task_id_view/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
