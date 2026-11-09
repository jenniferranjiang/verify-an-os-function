# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `locked_passthrough`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_09__locked_passthrough/MutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of__MutexDelete_partial_solve_wit_4`, `proof_of__MutexDelete_partial_solve_wit_5`, `proof_of__MutexDelete_partial_solve_wit_6`, `proof_of__MutexDelete_partial_solve_wit_7`, `proof_of__MutexDelete_partial_solve_wit_8`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_09__locked_passthrough/MutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexDelete_lib.v`
- Every new/adapted helper uses suffix `__locked_passthrough`. Preserve the seed.

### `proof_of__MutexDelete_partial_solve_wit_4` — `LLM_pre_process`

All aux facts are preexisting drained/continuation/entry facts; return the same OutsideCritical(drained). Do not use the pure argument by supplying nonexistent local cells; the facts can be proved directly.
### `proof_of__MutexDelete_partial_solve_wit_5` — `LLM_pre_process`

Return all given pure facts and rearrange InsideCritical(sg,st_lock) ** os_inv(sg,st_lock). These are unchanged resources; no transfer or new abstract state is performed.
### `proof_of__MutexDelete_partial_solve_wit_6` — `LLM_pre_process`

Pure-context passthrough after the ID view is exposed. Reuse the list split, current address/ID/empty pending, both NoDup facts, query=true, rely and continuation premises. Cancel the exact UShort field at mutex_pre.id.id, its mutex_delete_id_restore wand and the lock token.
### `proof_of__MutexDelete_partial_solve_wit_7` — `LLM_pre_process`

The same stored pure context is reasserted with full os_inv restored. Every pure output is a premise, and os_inv plus InsideCritical cancel unchanged. No resource conversion is needed in this wrapper.
### `proof_of__MutexDelete_partial_solve_wit_8` — `LLM_pre_process`

Prove the aux guard directly: id bounds follow from mutex_delete_drained (not from a local delete_mutex_id cell absent in aux); the named global manager address is nonzero by the existing addr_of_LE_var_not_zero fact. Reinsert all old pure facts and cancel manager ** manager_frame ** InsideCritical.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_09__locked_passthrough/proof_reuse.md`.

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
      "locked_passthrough"
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
      "locked_passthrough"
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
      "locked_passthrough"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/_coq_builds/MutexDelete-vc-proving-r1/group_09/src/.coq_debug/group_09_locked_passthrough.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_09__locked_passthrough/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_09__locked_passthrough/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
