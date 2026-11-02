# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `failed_exit_frames`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_09__failed_exit_frames/MutexCreate_proof_manual.v`.
- Editable proof spans: `proof_of__MutexCreate_partial_solve_wit_8_pure`, `proof_of__MutexCreate_partial_solve_wit_8`, `proof_of__MutexCreate_partial_solve_wit_9`, `proof_of__MutexCreate_return_wit_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_09__failed_exit_frames/MutexCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/VC/MutexCreate_lib.v`
- Every new/adapted helper uses suffix `__failed_exit_frames`. Preserve the seed.

### `proof_of__MutexCreate_partial_solve_wit_8_pure` — `LLM_pre_process`

Project Crtos_GTrans st st from explicit PreH2 after failure invariant restoration; no new protocol fact required.
### `proof_of__MutexCreate_partial_solve_wit_8` — `LLM_pre_process`

Auxiliary permutes os_inv sg st ** MutexRaw p ** InsideCritical sg st to the unlock footprint and preserves MutexRaw. Every pure Q fact is already a quantified PreH, including failure continuation and GTrans; reassociate/cancel.
### `proof_of__MutexCreate_partial_solve_wit_9` — `LLM_pre_process`

After unlock, permute OutsideCritical sg st ** MutexRaw p so x_free gets the same original malloc base p and exact raw resource. Preserve OutsideCritical and all pure facts. No zero-ID or full-manager assumption.
### `proof_of__MutexCreate_return_wit_2` — `LLM_pre_process`

Instantiate after:=st_lock. Q (-5=-5) is reflexive, continuation is PreH1, and OutsideCritical exactly matches P. No state change after free is introduced.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_09__failed_exit_frames/proof_reuse.md`.

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
      "failed_exit_frames"
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
      "failed_exit_frames"
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
      "failed_exit_frames"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/_coq_builds/MutexCreate-vc-proving-r1/group_09/src/.coq_debug/group_09_failed_exit_frames.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_09__failed_exit_frames/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_09__failed_exit_frames/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
