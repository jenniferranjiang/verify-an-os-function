# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `resume_result`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/LinklistResumeSemaphore-20261119085215/LinklistResumeSemaphore-vc-proving-r1/groups/group_02__resume_result/LinklistResumeSemaphore_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResume_return_wit_1`, `proof_of_LinklistResume_return_wit_1_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_LinklistResume_return_wit_1` — `aggressive_pre_process`

- Split `proof_of_LinklistResume_return_wit_1_split_goal_1`: Unfold semaphore_resume_head_effect. From the carried semaphore_pending_nodes before relation obtain obj membership/address and map sched_link_node pending=first-node::map rest; use getData/map projection to show pending=first::rest. Instantiate obj, first, rest, desc. The task-map lookup and wakeup_semaphore_head before after_2 are explicit callee postcondition premises, so all conjuncts follow. No spatial resource or new transition premise is required.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/LinklistResumeSemaphore-20261119085215/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-proving-r1/groups/group_02__resume_result/proof_reuse.md`.

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
      "resume_result"
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
      "resume_result"
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
      "resume_result"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/LinklistResumeSemaphore-20261119085215/_coq_builds/LinklistResumeSemaphore-vc-proving-r1/group_02/src/.coq_debug/group_02_resume_result.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-proving-r1/groups/group_02__resume_result/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-proving-r1/groups/group_02__resume_result/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
