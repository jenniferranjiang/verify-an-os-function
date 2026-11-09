# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `query_context`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/KMutexDelete-vc-proving-r1/groups/group_04__query_context/KMutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of_KMutexDelete_safety_wit_5`, `proof_of_KMutexDelete_safety_wit_6`, `proof_of_KMutexDelete_safety_wit_7`, `proof_of_KMutexDelete_partial_solve_wit_2`, `proof_of_KMutexDelete_partial_solve_wit_4`, `proof_of_KMutexDelete_partial_solve_wit_5`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/KMutexDelete-vc-proving-r1/groups/group_04__query_context/KMutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/KMutexDelete_lib.v`
- Every new/adapted helper uses suffix `__query_context`. Preserve the seed.

### `proof_of_KMutexDelete_safety_wit_5` — `LLM_pre_process`

As for initialization safety: the consequent is only the representable constant-zero bounds. Manager/frame/token/current local cells may be present but supply no needed extra fact; prove the numerical constants and retain no claim about lookup semantics.
### `proof_of_KMutexDelete_safety_wit_6` — `LLM_pre_process`

As for initialization safety: the consequent is only the representable constant-zero bounds. Manager/frame/token/current local cells may be present but supply no needed extra fact; prove the numerical constants and retain no claim about lookup semantics.
### `proof_of_KMutexDelete_safety_wit_7` — `LLM_pre_process`

As for initialization safety: the consequent is only the representable constant-zero bounds. Manager/frame/token/current local cells may be present but supply no needed extra fact; prove the numerical constants and retain no claim about lookup semantics.
### `proof_of_KMutexDelete_partial_solve_wit_2` — `LLM_pre_process`

Repeat supplied RTrans, nonnegative-id, signed bounds and safeExec facts. Use commutativity/associativity to reorder InsideCritical ** os_inv into os_inv ** InsideCritical; states remain st_lock.
### `proof_of_KMutexDelete_partial_solve_wit_4` — `LLM_pre_process`

Repeat all miss-branch pure facts (retval=0, global manager nonzero, query=false, RTrans, bounds and safeExec) and cancel unchanged store_idmanager, exact lookup frame and InsideCritical.
### `proof_of_KMutexDelete_partial_solve_wit_5` — `LLM_pre_process`

Repeat all null-manager-branch pure facts, without trying to invent query=false. All three manager/frame/token resources remain identical; straightforward cancellation suffices even if the branch is inconsistent at lower levels.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_04__query_context/proof_reuse.md`.

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
      "KMutexDelete-20261103170333",
      "--round",
      "KMutexDelete-vc-proving-r1",
      "--group",
      "query_context"
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
      "KMutexDelete-20261103170333",
      "--round",
      "KMutexDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "query_context"
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
      "KMutexDelete-20261103170333",
      "--round",
      "KMutexDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "query_context"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/KMutexDelete-20261103170333/_coq_builds/KMutexDelete-vc-proving-r1/group_04/src/.coq_debug/group_04_query_context.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_04__query_context/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/KMutexDelete-20261103170333/rounds/KMutexDelete-vc-proving-r1/groups/group_04__query_context/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
