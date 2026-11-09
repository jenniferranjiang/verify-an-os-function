# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `removed_passthrough`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_10__removed_passthrough/MutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of__MutexDelete_partial_solve_wit_9_pure`, `proof_of__MutexDelete_partial_solve_wit_9`, `proof_of__MutexDelete_partial_solve_wit_12`, `proof_of__MutexDelete_partial_solve_wit_13_pure`, `proof_of__MutexDelete_partial_solve_wit_13`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_10__removed_passthrough/MutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexDelete_lib.v`
- Every new/adapted helper uses suffix `__removed_passthrough`. Preserve the seed.

### `proof_of__MutexDelete_partial_solve_wit_9_pure` — `LLM_pre_process`

The output is only the old list split and current.addr=mutex_pre, both explicit premises. Post-IdRemoveObj manager/node resources are frame and must not be used to infer old uniqueness.
### `proof_of__MutexDelete_partial_solve_wit_9` — `LLM_pre_process`

Return the explicitly retained old list split, current identity, NoDup facts and query=true, plus the callee-provided idmanager_contains/nonzero facts. Reorder the unchanged removed-manager, three detached IdNode stores, manager_frame and InsideCritical. All old-state facts are already premises.
### `proof_of__MutexDelete_partial_solve_wit_12` — `LLM_pre_process`

Successful DLL-call frame: all pure outputs are retained premises; reorder the unchanged full management DLL, exact non-Mutex frame, removed manager, detached IdNode stores and InsideCritical. No list mutation is performed by this VC itself.
### `proof_of__MutexDelete_partial_solve_wit_13_pure` — `LLM_pre_process`

The required Crtos_GTrans(st_lock,after) is an explicit premise. All local cells, os_inv(after), token and MutexRetired are frame.
### `proof_of__MutexDelete_partial_solve_wit_13` — `LLM_pre_process`

Reassert the existing after=replace_mutexes(...), current.addr identity, safeExec and GTrans facts; cancel InsideCritical(st_lock) ** os_inv(after) ** MutexRetired(current) unchanged. This is the Unlock-call wrapper, not the retirement proof.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_10__removed_passthrough/proof_reuse.md`.

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
      "removed_passthrough"
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
      "removed_passthrough"
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
      "removed_passthrough"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/_coq_builds/MutexDelete-vc-proving-r1/group_10/src/.coq_debug/group_10_removed_passthrough.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_10__removed_passthrough/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_10__removed_passthrough/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
