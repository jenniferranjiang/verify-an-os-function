# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `import_detached_refinement`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_02__import_detached_refinement/EventLinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_02__import_detached_refinement/EventLinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventLinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__import_detached_refinement`. Preserve the seed.

### `proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic` — `LLM_pre_process`

Instantiate generic sg/before with the source sg/before and frame the specialization as a wand. Extract old ownership uniqueness from source os_inv before relinquishing it. On either generic post branch apply ktask_wakeup_detached_null_condition to the returned task/desc lookup to obtain tdDelay=0; failure returns the same state directly. In SUSPEND success, the same condition gives task in sched_owned_tasks; old global NoDup excludes it from all modeled pending queues, so generic removal only changes the self-owned sequence. Use the helper to assemble ktask_wakeup_detached_null_step, with unchanged delays from the NULL branch. Instantiate all returned existential values from the generic post and cancel os_inv(after).

## Helpers

- `generic_wakeup_detached_null__import_detached_refinement` (public): From the pure consequences of an owned old os_inv, a matching returned task/desc, tdDelay=0, SUSPEND, task in sched_owned_tasks, and ktask_wakeup_step task desc before after, prove ktask_wakeup_detached_null_step task desc before after. NoDup yields a unique owned-list removal and target absence from all event/mutex/semaphore pending lists. In ktask_unset_delay_step the nonzero alternatives contradict tdDelay=0, giving unchanged delays; remaining fields are the exact generic frame. Establish needed old pure consequences from source os_inv in the main wand proof before it is transferred.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_02__import_detached_refinement/proof_reuse.md`.

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
      "import_detached_refinement"
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
      "import_detached_refinement"
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
      "import_detached_refinement"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/_coq_builds/EventLinklistResumeAll-vc-proving-r1/group_02/src/.coq_debug/group_02_import_detached_refinement.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_02__import_detached_refinement/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_02__import_detached_refinement/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
