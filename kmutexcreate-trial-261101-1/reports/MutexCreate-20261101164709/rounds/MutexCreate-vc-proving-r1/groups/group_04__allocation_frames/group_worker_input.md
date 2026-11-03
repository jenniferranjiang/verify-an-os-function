# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `allocation_frames`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_04__allocation_frames/MutexCreate_proof_manual.v`.
- Editable proof spans: `proof_of__MutexCreate_partial_solve_wit_1_pure`, `proof_of__MutexCreate_partial_solve_wit_1`, `proof_of__MutexCreate_partial_solve_wit_2_pure`, `proof_of__MutexCreate_partial_solve_wit_2`, `proof_of__MutexCreate_partial_solve_wit_3_pure`, `proof_of__MutexCreate_partial_solve_wit_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_04__allocation_frames/MutexCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/VC/MutexCreate_lib.v`
- Every new/adapted helper uses suffix `__allocation_frames`. Preserve the seed.

### `proof_of__MutexCreate_partial_solve_wit_1_pure` — `LLM_pre_process`

Q is 0<=sizeof(Mutex)<=UINT_MAX. Rewrite existing size_Mutex=36 and integer bounds; lia. Heap is only locals plus OutsideCritical, so prove pure entailment.
### `proof_of__MutexCreate_partial_solve_wit_1` — `LLM_pre_process`

Unfold auxiliary goal, establish size bounds directly from the existing 36-byte layout and preserve OutsideCritical; repeat safeExec premise. Do not require constructing omitted stack-local cells from the pure witness implication.
### `proof_of__MutexCreate_partial_solve_wit_2_pure` — `LLM_pre_process`

Establish size bounds as 36 plus literal 0<=0<=127. P includes raw malloc bytes, locals and OutsideCritical; pure conclusion only.
### `proof_of__MutexCreate_partial_solve_wit_2` — `LLM_pre_process`

Auxiliary keeps CharArray.undef_full p sizeof(Mutex) ** OutsideCritical. Add size bounds and zero-fill byte range from literal arithmetic, repeat allocation nonzero/range/alignment and safeExec PreH, then cancel the exact heap.
### `proof_of__MutexCreate_partial_solve_wit_3_pure` — `LLM_pre_process`

Project positive p, p<=UINT_MAX-sizeof(Mutex), and alignment from the allocation PreH. memset result heap remains zero CharArray; no type conversion happens in this VC.
### `proof_of__MutexCreate_partial_solve_wit_3` — `LLM_pre_process`

Auxiliary keeps the same zero CharArray ** OutsideCritical and repeats known allocation/address/result-equality facts. Introduce conjunctions and cancel; no need to infer equality between unrelated retval variables.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_04__allocation_frames/proof_reuse.md`.

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
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-debug",
      "--run",
      "MutexCreate-20261101164709",
      "--round",
      "MutexCreate-vc-proving-r1",
      "--group",
      "allocation_frames"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-check",
      "--run",
      "MutexCreate-20261101164709",
      "--round",
      "MutexCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "allocation_frames"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-check",
      "--run",
      "MutexCreate-20261101164709",
      "--round",
      "MutexCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "allocation_frames"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/_coq_builds/MutexCreate-vc-proving-r1/group_04/src/.coq_debug/group_04_allocation_frames.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_04__allocation_frames/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_04__allocation_frames/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
