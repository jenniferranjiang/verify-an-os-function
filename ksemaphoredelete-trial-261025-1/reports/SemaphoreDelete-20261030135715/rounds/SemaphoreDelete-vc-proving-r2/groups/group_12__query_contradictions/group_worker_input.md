# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `query_contradictions`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r2/groups/group_12__query_contradictions/SemaphoreDelete_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_partial_solve_wit_20_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_20`, `proof_of__SemaphoreDelete_partial_solve_wit_22_pure`, `proof_of__SemaphoreDelete_partial_solve_wit_22`, `proof_of__SemaphoreDelete_partial_solve_wit_23`, `proof_of__SemaphoreDelete_partial_solve_wit_25`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r2/groups/group_12__query_contradictions/SemaphoreDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/SemaphoreDelete_lib.v`
- Every new/adapted helper uses suffix `__query_contradictions`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreDelete_partial_solve_wit_20_pure` — `LLM_pre_process`

Use LLM_pre_process. P contains query(old,id)=false and query(old,id)=true. After LLM_pre_process (and unfolding the _aux for the non-pure wrapper) discriminate these equalities; no manager or DLL transformation is required.
### `proof_of__SemaphoreDelete_partial_solve_wit_20` — `LLM_pre_process`

Use LLM_pre_process. P contains query(old,id)=false and query(old,id)=true. After LLM_pre_process (and unfolding the _aux for the non-pure wrapper) discriminate these equalities; no manager or DLL transformation is required.
### `proof_of__SemaphoreDelete_partial_solve_wit_22_pure` — `LLM_pre_process`

Use LLM_pre_process. P contains query(old,id)=false and query(old,id)=true. After LLM_pre_process (and unfolding the _aux for the non-pure wrapper) discriminate these equalities; no manager or DLL transformation is required.
### `proof_of__SemaphoreDelete_partial_solve_wit_22` — `LLM_pre_process`

Use LLM_pre_process. P contains query(old,id)=false and query(old,id)=true. After LLM_pre_process (and unfolding the _aux for the non-pure wrapper) discriminate these equalities; no manager or DLL transformation is required.
### `proof_of__SemaphoreDelete_partial_solve_wit_23` — `LLM_pre_process`

Use LLM_pre_process. The retained query=false and query=true hypotheses contradict. Close the entire frame/permutation goal from False.
### `proof_of__SemaphoreDelete_partial_solve_wit_25` — `LLM_pre_process`

Use LLM_pre_process. The retained query=false and query=true hypotheses contradict. Close the entire frame/permutation goal from False.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r2/groups/group_12__query_contradictions/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-debug",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-proving-r2",
      "--group",
      "query_contradictions"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "query_contradictions"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "query_contradictions"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r2/group_12/src/.coq_debug/group_12_query_contradictions.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r2/groups/group_12__query_contradictions/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-proving-r2/groups/group_12__query_contradictions/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
