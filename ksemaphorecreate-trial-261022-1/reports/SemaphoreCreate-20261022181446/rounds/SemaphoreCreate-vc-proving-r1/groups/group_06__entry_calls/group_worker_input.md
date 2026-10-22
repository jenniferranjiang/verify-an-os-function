# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `entry_calls`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_06__entry_calls/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_1`, `proof_of__SemaphoreCreate_partial_solve_wit_1_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_1`, `proof_of__SemaphoreCreate_partial_solve_wit_2_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_2`, `proof_of__SemaphoreCreate_partial_solve_wit_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): `proof_of__SemaphoreCreate_entail_wit_1_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_2`.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_06__entry_calls/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__entry_calls`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_1` — `LLM_pre_process`

The two pure splits omit the UShort resource and are not valid for arbitrary X. Choose the whole left disjunct, derive 0<=val_pre<=65535 from the local UShort points-to validity, then retain that same cell and OutsideCritical and safeExec by framing. Do not strengthen the function precondition or attempt the empty-heap disjunct.
### `proof_of__SemaphoreCreate_partial_solve_wit_1_pure` — `LLM_pre_process`

P is four local stores plus OutsideCritical. Q asks only 0<=32<=UINT_MAX; normalize 32-bit unsigned bound and solve arithmetic; no existential or resource transformation.
### `proof_of__SemaphoreCreate_partial_solve_wit_1` — `LLM_pre_process`

Introduce all pure premises; preserve each spatial resource with cancellation/reassociation. Re-establish the displayed pure conjunction from the same antecedent premises; there is no state change or fresh existential. Ignore the wrapper premise if unnecessary; prove constant allocation bounds 0<=32<=UINT_MAX directly, keeping OutsideCritical and original val/safeExec facts.
### `proof_of__SemaphoreCreate_partial_solve_wit_2_pure` — `LLM_pre_process`

P contains allocated CharArray.undef_full plus local/critical frames. Q has only memset length/fill bounds (32 unsigned, zero in signed-char range); normalize machine bounds and solve constants.
### `proof_of__SemaphoreCreate_partial_solve_wit_2` — `LLM_pre_process`

Introduce all pure premises; preserve each spatial resource with cancellation/reassociation. Re-establish the displayed pure conjunction from the same antecedent premises; there is no state change or fresh existential. Keep CharArray.undef_full retval 32 unchanged for memset and preserve malloc positivity/upper bound/alignment. Prove only the constant length/fill bounds; the zero-bytes postcondition is not assumed here.
### `proof_of__SemaphoreCreate_partial_solve_wit_3` — `LLM_pre_process`

Introduce all pure premises; preserve each spatial resource with cancellation/reassociation. Re-establish the displayed pure conjunction from the same antecedent premises; there is no state change or fresh existential. Lock precondition is OutsideCritical; keep SemaphoreZero as frame. Existing sem alignment, both link nonzero facts, zero local id/lock and safeExec are preserved exactly.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_06__entry_calls/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-debug",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--group",
      "entry_calls"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "entry_calls"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "entry_calls"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/_coq_builds/SemaphoreCreate-vc-proving-r1/group_06/src/.coq_debug/group_06_entry_calls.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_06__entry_calls/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_06__entry_calls/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
