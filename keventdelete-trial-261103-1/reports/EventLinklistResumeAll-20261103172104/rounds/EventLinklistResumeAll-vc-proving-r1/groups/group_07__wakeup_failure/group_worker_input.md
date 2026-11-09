# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `wakeup_failure`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_07__wakeup_failure/EventLinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_entail_wit_4_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_07__wakeup_failure/EventLinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventLinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__wakeup_failure`. Preserve the seed.

### `proof_of_LinklistResumeAll_entail_wit_4_1` — `LLM_pre_process`

Select the spatial first arm. Rewrite after=marked and use os_inv(marked) to establish ID-query uniqueness for the two equal task_id lookups, hence returned task=target. Rewrite the exstatus-only marked-map update and original target descriptor equality; returned desc_2 is set_task_desc_exstatus desc (-1), whose status remains SUSPEND. This contradicts the generic failure branch non-SUSPEND premise, so the entire branch entailment follows. Do not attempt to establish remaining-progress in a genuine failure state.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_07__wakeup_failure/proof_reuse.md`.

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
      "wakeup_failure"
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
      "wakeup_failure"
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
      "wakeup_failure"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/_coq_builds/EventLinklistResumeAll-vc-proving-r1/group_07/src/.coq_debug/group_07_wakeup_failure.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_07__wakeup_failure/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_07__wakeup_failure/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
