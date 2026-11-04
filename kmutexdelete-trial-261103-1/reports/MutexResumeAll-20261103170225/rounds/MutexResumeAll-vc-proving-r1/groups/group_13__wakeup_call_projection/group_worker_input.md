# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `wakeup_call_projection`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_13__wakeup_call_projection/MutexResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_partial_solve_wit_11_pure`, `proof_of_LinklistResumeAll_partial_solve_wit_11`, `proof_of_LinklistResumeAll_partial_solve_wit_14_pure`, `proof_of_LinklistResumeAll_partial_solve_wit_14`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_13__wakeup_call_projection/MutexResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexResumeAll_lib.v`
- Every new/adapted helper uses suffix `__wakeup_call_projection`. Preserve the seed.

### `proof_of_LinklistResumeAll_partial_solve_wit_11_pure` — `LLM_pre_process`

Projection pattern: marked is exactly the exstatus update, remaining is target::rest, original source membership is retained; os_inv marked is the resource. All requested pure conjuncts occur verbatim among PreH hypotheses (or by trivial equality substitution); introduce and select them without consuming owned resources.
### `proof_of_LinklistResumeAll_partial_solve_wit_11` — `LLM_pre_process`

Frame-copy pattern: unfold the implication/aux definition, retain the supplied pure-witness premise, copy existing PreH facts and cancel the unchanged resource conjunction, modulo associativity/commutativity. marked is exactly the exstatus update, remaining is target::rest, original source membership is retained; os_inv marked is the resource.
### `proof_of_LinklistResumeAll_partial_solve_wit_14_pure` — `LLM_pre_process`

Projection pattern: task_id<65536 is the existing UShort bound; the callee receives os_inv marked, with InsideCritical framed. All requested pure conjuncts occur verbatim among PreH hypotheses (or by trivial equality substitution); introduce and select them without consuming owned resources.
### `proof_of_LinklistResumeAll_partial_solve_wit_14` — `LLM_pre_process`

Frame-copy pattern: unfold the implication/aux definition, retain the supplied pure-witness premise, copy existing PreH facts and cancel the unchanged resource conjunction, modulo associativity/commutativity. task_id<65536 is the existing UShort bound; the callee receives os_inv marked, with InsideCritical framed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_13__wakeup_call_projection/proof_reuse.md`.

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
      "wakeup_call_projection"
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
      "wakeup_call_projection"
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
      "wakeup_call_projection"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/_coq_builds/MutexResumeAll-vc-proving-r1/group_13/src/.coq_debug/group_13_wakeup_call_projection.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_13__wakeup_call_projection/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_13__wakeup_call_projection/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
