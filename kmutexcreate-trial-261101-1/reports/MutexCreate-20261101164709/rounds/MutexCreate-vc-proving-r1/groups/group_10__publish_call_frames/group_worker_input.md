# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `publish_call_frames`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_10__publish_call_frames/MutexCreate_proof_manual.v`.
- Editable proof spans: `proof_of__MutexCreate_partial_solve_wit_13_pure`, `proof_of__MutexCreate_partial_solve_wit_13_pure_split_goal_1`, `proof_of__MutexCreate_partial_solve_wit_13`, `proof_of__MutexCreate_partial_solve_wit_14_pure`, `proof_of__MutexCreate_partial_solve_wit_14`, `proof_of__MutexCreate_partial_solve_wit_15_pure`, `proof_of__MutexCreate_partial_solve_wit_15`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_10__publish_call_frames/MutexCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/VC/MutexCreate_lib.v`
- Every new/adapted helper uses suffix `__publish_call_frames`. Preserve the seed.

### `proof_of__MutexCreate_partial_solve_wit_13_pure` — `aggressive_pre_process`

- Split `proof_of__MutexCreate_partial_solve_wit_13_pure_split_goal_1`: Unfold dll_insert_anchor and select its head-anchor case: the insertion position equals the global head by reflexivity. Existing DLL resources are framed. No nonempty-list hypothesis or node extraction is needed.
### `proof_of__MutexCreate_partial_solve_wit_13` — `LLM_pre_process`

Auxiliary prepares store_dll ** new store_mutex ** occupy_dll_node, preserving updated manager/frame/InsideCritical. Link nonzero is given; head anchor follows by definition. Repeat PreH and cancel. Avoid trying to apply the pure witness to a heap lacking the removed locals; prove its required pure facts directly.
### `proof_of__MutexCreate_partial_solve_wit_14_pure` — `LLM_pre_process`

Project p nonzero/aligned, mutex_context, min-free, freshness, original safeExec and rely from the retained PreH after insertion. The new DLL at dll_insert_after_dispatch and updated manager are not transformed here.
### `proof_of__MutexCreate_partial_solve_wit_14` — `LLM_pre_process`

Reorder insertion-result DLL, updated manager, frame and InsideCritical for which_implies_wit_6; all added pure facts are PreH projections. No post-state invariant is assumed in this preparation step.
### `proof_of__MutexCreate_partial_solve_wit_15_pure` — `LLM_pre_process`

Project exact Crtos_GTrans st (replace_mutexes (mutex_publish p id old) st) from PreH4 after conversion; do not replace with an arbitrary after state.
### `proof_of__MutexCreate_partial_solve_wit_15` — `LLM_pre_process`

Permute os_inv sg published_state ** InsideCritical sg st to unlock footprint, add only explicit id bounds/continuation/GTrans and remaining PreH facts, cancel. InsideCritical still indexes the locked pre-state, matching its contract.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_10__publish_call_frames/proof_reuse.md`.

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
      "publish_call_frames"
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
      "publish_call_frames"
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
      "publish_call_frames"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/_coq_builds/MutexCreate-vc-proving-r1/group_10/src/.coq_debug/group_10_publish_call_frames.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_10__publish_call_frames/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_10__publish_call_frames/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
