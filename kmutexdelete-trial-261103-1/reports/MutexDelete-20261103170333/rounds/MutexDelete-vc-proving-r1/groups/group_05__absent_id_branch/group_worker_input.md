# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `absent_id_branch`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_05__absent_id_branch/MutexDelete_proof_manual.v`.
- Editable proof spans: `proof_of__MutexDelete_entail_wit_3_1`, `proof_of__MutexDelete_entail_wit_3_1_split_goal_1`, `proof_of__MutexDelete_entail_wit_3_1_split_goal_2`, `proof_of__MutexDelete_entail_wit_3_1_split_goal_spatial`, `proof_of__MutexDelete_partial_solve_wit_10_pure`, `proof_of__MutexDelete_partial_solve_wit_10`, `proof_of__MutexDelete_partial_solve_wit_11`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/MutexDelete-vc-proving-r1/groups/group_05__absent_id_branch/MutexDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexDelete_lib.v`
- Every new/adapted helper uses suffix `__absent_id_branch`. Preserve the seed.

### `proof_of__MutexDelete_entail_wit_3_1` — `aggressive_pre_process`

- Split `proof_of__MutexDelete_entail_wit_3_1_split_goal_1`: Both idmanager_query(...)=false and =true are explicit PreH4/PreH11. Derive False by congruence; hence the GTrans conclusion is immediate without unfolding spatial resources.

- Split `proof_of__MutexDelete_entail_wit_3_1_split_goal_2`: The identical query=false/query=true contradiction entails the requested safeExec continuation. Do not fabricate a normal retire witness for this unreachable branch.

- Split `proof_of__MutexDelete_entail_wit_3_1_split_goal_spatial`: The contradictory query booleans close the spatial entailment as well; the branch does not supply detached ID cells, and those must not be manufactured on a feasible path.
### `proof_of__MutexDelete_partial_solve_wit_10_pure` — `LLM_pre_process`

The ID-absence branch carries both query=false and query=true; congruence closes the whole entailment. Alternatively its two requested facts are displayed premises, but the contradiction is the simplest complete route.
### `proof_of__MutexDelete_partial_solve_wit_10` — `LLM_pre_process`

The same query=false/query=true contradiction persists in the pure-to-aux wrapper; close it by contradiction. It is not necessary or sound to recover ID cells that this branch does not return.
### `proof_of__MutexDelete_partial_solve_wit_11` — `LLM_pre_process`

This DLL-call frame on the absent-ID branch retains contradictory query booleans. Use that contradiction; do not invent a detached ID node to support the later retirement state.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_05__absent_id_branch/proof_reuse.md`.

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
      "absent_id_branch"
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
      "absent_id_branch"
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
      "absent_id_branch"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexDelete-20261103170333/_coq_builds/MutexDelete-vc-proving-r1/group_05/src/.coq_debug/group_05_absent_id_branch.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_05__absent_id_branch/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-proving-r1/groups/group_05__absent_id_branch/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
