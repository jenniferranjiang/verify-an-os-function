# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `import_sem_refinement`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_01__import_sem_refinement/EventLinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_01__import_sem_refinement/EventLinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventLinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__import_sem_refinement`. Preserve the seed.

### `proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic` — `LLM_pre_process`

Introduce the strong source contract and choose sg_wakeup_by_id_ic=sg_semaphore_pending_head_ic,before_wakeup_by_id_ic=before_semaphore_pending_head_ic. Before passing os_inv to the generic precondition, extract pure task-ID uniqueness, SUSPEND-at-head, queue ownership NoDup and source-head membership from it. Prove the residual wand by introducing each generic post branch. The non-SUSPEND branch contradicts the identified head descriptor; in success identify task/desc, use generic_wakeup_sem_head__import_sem_refinement to obtain exact source-head removal and full frame, instantiate after/desc/retval=0 and cancel os_inv(after). This is an imported-contract refinement obligation, not KTaskWakeup body verification.

## Helpers

- `generic_wakeup_sem_head__import_sem_refinement` (public): Derive from a valid os_inv before with semaphore_pending_nodes sem before (sched_link_node task::rest) and matching get_task_with_idnode_success the pure facts sufficient to refine any generic successful ktask_wakeup_step for that ID to wakeup_semaphore_head sem task desc before after and semaphore_pending_nodes sem after rest. Extract old exclusive queue ownership and ID uniqueness while before resources are available, then unfold generic record: remove_found on the source head is deterministic, other event/mutex/semaphore queues and self-owned list are unchanged by absence; ready/map/delay and remaining fields are exact projections. Package this as a pure fact retained when constructing the wand, not as an extra assumed precondition.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_01__import_sem_refinement/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Current repair 1

Infrastructure resolution: 2026-11-04 direct user answer: 明确授权继续实现证明. The answered question explicitly authorizes symbolic, VC and Rocq implementation proofs for KEventDelete and overrides the earlier design-only restriction. Reopen only this infrastructure-blocked group with the same owner; all proof checks remain required.

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
      "import_sem_refinement"
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
      "import_sem_refinement"
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
      "import_sem_refinement"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/_coq_builds/EventLinklistResumeAll-vc-proving-r1/group_01/src/.coq_debug/group_01_import_sem_refinement.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_01__import_sem_refinement/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_01__import_sem_refinement/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
