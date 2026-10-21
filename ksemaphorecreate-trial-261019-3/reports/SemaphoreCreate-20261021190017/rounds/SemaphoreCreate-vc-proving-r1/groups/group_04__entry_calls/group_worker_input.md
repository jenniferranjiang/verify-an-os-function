# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `entry_calls`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_04__entry_calls/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_1`, `proof_of__SemaphoreCreate_partial_solve_wit_1_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_1`, `proof_of__SemaphoreCreate_partial_solve_wit_2_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_2`, `proof_of__SemaphoreCreate_partial_solve_wit_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): `proof_of__SemaphoreCreate_entail_wit_1_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_2`.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_04__entry_calls/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__entry_calls`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_1` — `LLM_pre_process`

Select the original full-resource disjunct. From the UShort points-to at local val extract 0 <= val_pre <= 65535 using the typed-store range fact. Rebuild all pure conjuncts (safeExec is PreH1) and cancel the unchanged val cell plus OutsideCritical. The two generated pure splits erased the cell and are not formal targets; safeExec alone imposes no numeric range.
### `proof_of__SemaphoreCreate_partial_solve_wit_1_pure` — `LLM_pre_process`

Pure sizeof Semaphore=32 follows from the current registered ILP32 layout facts imported by the goal. Introduce quantifiers and establish the layout equality under the heap, without adding an axiom. Retain the allocation-call frame conceptually.
### `proof_of__SemaphoreCreate_partial_solve_wit_1` — `LLM_pre_process`

Introduce quantified values and hypotheses, unfold the named whole VC (and auxiliary definition if present), introduce its pure-witness implication without importing any admitted theorem. Establish the consequent pure conjuncts from the explicit PreH hypotheses; use sep_apply/entailer and cancellation to reorder the identical spatial resources. No existential or abstract state change is needed. Establish sizeof Semaphore=32 from the same current layout fact independently of any unavailable local cells; preserve OutsideCritical.
### `proof_of__SemaphoreCreate_partial_solve_wit_2_pure` — `LLM_pre_process`

Prove 0=0 and sizeof Semaphore=32 by reflexivity/current layout facts under the SemaphoreRaw plus local/OutsideCritical heap; no change to raw bytes.
### `proof_of__SemaphoreCreate_partial_solve_wit_2` — `LLM_pre_process`

Introduce quantified values and hypotheses, unfold the named whole VC (and auxiliary definition if present), introduce its pure-witness implication without importing any admitted theorem. Establish the consequent pure conjuncts from the explicit PreH hypotheses; use sep_apply/entailer and cancellation to reorder the identical spatial resources. No existential or abstract state change is needed. Prove the zero-fill size and value facts from layout/reflexivity, retain SemaphoreRaw retval and OutsideCritical; retval equalities/nonzero come directly from PreH.
### `proof_of__SemaphoreCreate_partial_solve_wit_3` — `LLM_pre_process`

Introduce quantified values and hypotheses, unfold the named whole VC (and auxiliary definition if present), introduce its pure-witness implication without importing any admitted theorem. Establish the consequent pure conjuncts from the explicit PreH hypotheses; use sep_apply/entailer and cancellation to reorder the identical spatial resources. No existential or abstract state change is needed. Only swap SemaphoreZero retval and OutsideCritical; retval_2=retval is explicitly supplied by memset postcondition.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_04__entry_calls/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Current repair 1

entry_calls: witness `proof_of__SemaphoreCreate_entail_wit_1` contains Admitted/Abort
entry_calls: witness `proof_of__SemaphoreCreate_partial_solve_wit_1_pure` contains Admitted/Abort
entry_calls: witness `proof_of__SemaphoreCreate_partial_solve_wit_1` contains Admitted/Abort
entry_calls: witness `proof_of__SemaphoreCreate_partial_solve_wit_2_pure` contains Admitted/Abort
entry_calls: witness `proof_of__SemaphoreCreate_partial_solve_wit_2` contains Admitted/Abort
entry_calls: witness `proof_of__SemaphoreCreate_partial_solve_wit_3` contains Admitted/Abort

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-debug",
      "--run",
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--group",
      "entry_calls"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "entry_calls"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "entry_calls"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/_coq_builds/SemaphoreCreate-vc-proving-r1/group_04/src/.coq_debug/group_04_entry_calls.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_04__entry_calls/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_04__entry_calls/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
