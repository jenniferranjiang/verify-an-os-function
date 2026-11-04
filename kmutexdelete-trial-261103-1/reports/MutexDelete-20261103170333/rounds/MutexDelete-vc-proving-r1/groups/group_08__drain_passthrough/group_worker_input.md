# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `drain_passthrough`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_08__drain_passthrough/MutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of__MutexDelete_partial_solve_wit_1_pure`, `proof_of__MutexDelete_partial_solve_wit_1`, `proof_of__MutexDelete_partial_solve_wit_2`, `proof_of__MutexDelete_partial_solve_wit_3_pure`, `proof_of__MutexDelete_partial_solve_wit_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_08__drain_passthrough/MutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexDelete_lib.v`
- Every new/adapted helper uses suffix `__drain_passthrough`. Preserve the seed.

### `proof_of__MutexDelete_partial_solve_wit_1_pure` — `LLM_pre_process`

The goal is exactly the safeExec(abs_mutex_delete_object) premise. Retain local cells/OutsideCritical as unused frame while extracting that pure fact.
### `proof_of__MutexDelete_partial_solve_wit_1` — `LLM_pre_process`

This is a pure-obligation-to-aux wrapper. After LLM preprocessing, reconstruct every displayed pure fact from the original premises and cancel the unchanged OutsideCritical. The aux antecedent has no local cells, so do not try to fabricate them in order to call its pure-obligation argument.
### `proof_of__MutexDelete_partial_solve_wit_2` — `LLM_pre_process`

Reconstruct live and safeExec(abs_mutex_resume_all, mutex_delete_after_resume) from the displayed premises, and unfold mutex_pending_head for the field-address equality. Preserve/cancel OutsideCritical. This establishes aux directly without assuming local lock/mutex cells which are absent from aux.
### `proof_of__MutexDelete_partial_solve_wit_3_pure` — `LLM_pre_process`

The post-ResumeAll safeExec ret tt (mutex_delete_after_resume p id X) is already a pure premise. Its return-code and drained facts do not need any transformation.
### `proof_of__MutexDelete_partial_solve_wit_3` — `LLM_pre_process`

Reinsert the existing retval=KOK, drained and three continuation/entry facts; cancel OutsideCritical(drained). The pure-to-aux wrapper needs no fresh state or cell witness.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_08__drain_passthrough/proof_reuse.md`.

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
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-vc-proving-r1",
      "--group",
      "drain_passthrough"
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
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "drain_passthrough"
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
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "drain_passthrough"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/_coq_builds/MutexDelete-vc-proving-r1/group_08/src/.coq_debug/group_08_drain_passthrough.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_08__drain_passthrough/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_08__drain_passthrough/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
