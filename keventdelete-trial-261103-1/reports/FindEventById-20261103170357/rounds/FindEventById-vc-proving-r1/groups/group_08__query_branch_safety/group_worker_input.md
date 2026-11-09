# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `query_branch_safety`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/FindEventById-vc-proving-r1/groups/group_08__query_branch_safety/FindEventById_proof_manual.v`.
- Editable proof spans: `proof_of_FindEventById_safety_wit_6`, `proof_of_FindEventById_safety_wit_7`, `proof_of_FindEventById_safety_wit_8`, `proof_of_FindEventById_safety_wit_9`, `proof_of_FindEventById_safety_wit_10`, `proof_of_FindEventById_safety_wit_11`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/FindEventById-vc-proving-r1/groups/group_08__query_branch_safety/FindEventById_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/FindEventById_lib.v`
- Every new/adapted helper uses suffix `__query_branch_safety`. Preserve the seed.

### `proof_of_FindEventById_safety_wit_6` — `LLM_pre_process`

Introduce binders and derive False directly from the explicit contradictory hypotheses &(k_event_id_manager)=0 and &(k_event_id_manager)<>0. The entire entailment follows by false elimination, with all spatial resources untouched. No abstract program reasoning or helper is needed.
### `proof_of_FindEventById_safety_wit_7` — `LLM_pre_process`

Introduce all binders. The consequent is the constant pair 0<=INT_MAX and INT_MIN<=0; unfold the fixed signed-int bounds if necessary and solve arithmetic. The antecedent local cells/protocol/manager resources can be framed away for this pure target; no pointer/address or state equality premise is needed.
### `proof_of_FindEventById_safety_wit_8` — `LLM_pre_process`

Introduce all binders. The consequent is the constant pair 0<=INT_MAX and INT_MIN<=0; unfold the fixed signed-int bounds if necessary and solve arithmetic. The antecedent local cells/protocol/manager resources can be framed away for this pure target; no pointer/address or state equality premise is needed.
### `proof_of_FindEventById_safety_wit_9` — `LLM_pre_process`

Introduce binders and derive False directly from the explicit contradictory hypotheses retval_2<>0 and retval_2=0. The entire entailment follows by false elimination, with all spatial resources untouched. No abstract program reasoning or helper is needed.
### `proof_of_FindEventById_safety_wit_10` — `LLM_pre_process`

Introduce binders and derive False directly from the explicit contradictory hypotheses retval_2=0 and retval_2<>0. The entire entailment follows by false elimination, with all spatial resources untouched. No abstract program reasoning or helper is needed.
### `proof_of_FindEventById_safety_wit_11` — `LLM_pre_process`

Introduce all binders. The consequent is the constant pair 0<=INT_MAX and INT_MIN<=0; unfold the fixed signed-int bounds if necessary and solve arithmetic. The antecedent local cells/protocol/manager resources can be framed away for this pure target; no pointer/address or state equality premise is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_08__query_branch_safety/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "FindEventById-20261103170357",
      "--round",
      "FindEventById-vc-proving-r1",
      "--group",
      "query_branch_safety"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "FindEventById-20261103170357",
      "--round",
      "FindEventById-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "query_branch_safety"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "FindEventById-20261103170357",
      "--round",
      "FindEventById-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "query_branch_safety"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/_coq_builds/FindEventById-vc-proving-r1/group_08/src/.coq_debug/group_08_query_branch_safety.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_08__query_branch_safety/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_08__query_branch_safety/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
