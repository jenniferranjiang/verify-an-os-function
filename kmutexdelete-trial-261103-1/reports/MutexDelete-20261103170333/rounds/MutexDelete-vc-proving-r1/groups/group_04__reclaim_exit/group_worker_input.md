# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `reclaim_exit`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_04__reclaim_exit/MutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of__MutexDelete_which_implies_wit_7`, `proof_of__MutexDelete_which_implies_wit_7_split_goal_spatial`, `proof_of__MutexDelete_partial_solve_wit_14`, `proof_of__MutexDelete_partial_solve_wit_15`, `proof_of__MutexDelete_return_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_04__reclaim_exit/MutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexDelete_lib.v`
- Every new/adapted helper uses suffix `__reclaim_exit`. Preserve the seed.

### `proof_of__MutexDelete_which_implies_wit_7` — `aggressive_pre_process`

- Split `proof_of__MutexDelete_which_implies_wit_7_split_goal_spatial`: Unfold MutexRetired and MutexRaw. Preserve p<>0/alignment and obtain embedded ID/link nonzero from the retired pure facts and store_idnode. Normalize nested IdNode addresses; forget known ushort/uchar/pointer values into undef stores, convert the two detached self-links and empty pending head to the corresponding NodeStorage/insert-ready resources, and forget the two zero padding bytes to CharArray.undef_full. All 36 object bytes are retained exactly once; no task node or external resource is consumed.
### `proof_of__MutexDelete_partial_solve_wit_14` — `LLM_pre_process`

Rearrange OutsideCritical(after) ** MutexRetired(current) to the opposite order, preserving all existing pure facts. The retired object is private across unlock; no os_inv is reclaimed here.
### `proof_of__MutexDelete_partial_solve_wit_15` — `LLM_pre_process`

Rewrite mutex_pre=current.mutex_addr and cancel MutexRaw plus OutsideCritical. The equality is explicit; no stale lookup scalar or ownership assumption is needed.
### `proof_of__MutexDelete_return_wit_1` — `LLM_pre_process`

Choose after := after_2. The exact safeExec LastSeen(after_2) ret tt X fact is PreH3 and the sole OutsideCritical resource is unchanged. Cancel it; no state relation stronger than the given one is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_04__reclaim_exit/proof_reuse.md`.

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
      "reclaim_exit"
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
      "reclaim_exit"
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
      "reclaim_exit"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/_coq_builds/MutexDelete-vc-proving-r1/group_04/src/.coq_debug/group_04_reclaim_exit.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_04__reclaim_exit/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_04__reclaim_exit/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
