# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `exstatus_write_view`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_04__exstatus_write_view/EventLinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_which_implies_wit_5`, `proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial`, `proof_of_LinklistResumeAll_partial_solve_wit_8_pure`, `proof_of_LinklistResumeAll_partial_solve_wit_8`, `proof_of_LinklistResumeAll_partial_solve_wit_9`, `proof_of_LinklistResumeAll_partial_solve_wit_10`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_04__exstatus_write_view/EventLinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventLinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__exstatus_write_view`. Preserve the seed.

### `proof_of_LinklistResumeAll_which_implies_wit_5` — `aggressive_pre_process`

- Split `proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial`: Given current.task_map target=Some desc, apply exstatus_borrow_update__exstatus_write_view to os_inv(current). The split goal has the explicit updated state, so no existential choice remains. Borrow the old exstatus Int field and produce the wand to os_inv with only that task descriptor exstatus changed; preserve all other ownership.
### `proof_of_LinklistResumeAll_partial_solve_wit_8_pure` — `LLM_pre_process`

Project the existing descriptor-map equality from the pure context; all spatial resources may remain as frame.
### `proof_of_LinklistResumeAll_partial_solve_wit_8` — `LLM_pre_process`

Introduce the pure premise theorem, then unfold the auxiliary goal; every reasserted fact is already a PreH. Cancel the same os_inv(current) and InsideCritical(locked), with no state transition.
### `proof_of_LinklistResumeAll_partial_solve_wit_9` — `LLM_pre_process`

Substitute retval=target, forget the old Int exstatus value to undef for the store, and cancel the unchanged exstatus-update wand and InsideCritical. Reassert the pure state relations verbatim.
### `proof_of_LinklistResumeAll_partial_solve_wit_10` — `LLM_pre_process`

Substitute retval=target to align field addresses after the write; the two sides own exactly the same Int -1 field, reassembly wand and InsideCritical. Cancel and preserve all pure historical facts.

## Helpers

- `exstatus_borrow_update__exstatus_write_view` (public): For current.task_desc_map target=Some desc, prove os_inv sg current entails the old target exstatus Int cell separated from a wand accepting Int -1 and restoring os_inv sg (replace_task_desc_map (update_task_desc_map target (set_task_desc_exstatus desc (-1)) old_map) current). Split store_map at target; exstatus is the only changed descriptor field. Show task/world/pending and service-slot pure links are insensitive to exstatus; use -1 representability and frame every unchanged module. No new validity premise beyond old os_inv and map lookup.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_04__exstatus_write_view/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-vc-proving-r1",
      "--group",
      "exstatus_write_view"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "exstatus_write_view"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "exstatus_write_view"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/_coq_builds/EventLinklistResumeAll-vc-proving-r1/group_04/src/.coq_debug/group_04_exstatus_write_view.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_04__exstatus_write_view/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_04__exstatus_write_view/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
