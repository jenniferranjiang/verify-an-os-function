# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `entry_calls`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r2/groups/group_03__entry_calls/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_1`, `proof_of__SemaphoreCreate_partial_solve_wit_1_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_1`, `proof_of__SemaphoreCreate_partial_solve_wit_2_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_2`, `proof_of__SemaphoreCreate_partial_solve_wit_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): `proof_of__SemaphoreCreate_entail_wit_1_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_2`.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r2/groups/group_03__entry_calls/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__entry_calls`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_1` — `LLM_pre_process`

Choose the full-resource disjunct. Extract 0<=val_pre<=65535 from the UShort points-to predicate, retain safeExec from the hypothesis, and cancel the same UShort cell and OutsideCritical. The pure-only split goals discard this typed-cell source and are not selected.
### `proof_of__SemaphoreCreate_partial_solve_wit_1_pure` — `LLM_pre_process`

Lift reflexivity 32=32 through the full spatial antecedent. This is the folded OS allocation size argument; no sizeof/layout premise remains.
### `proof_of__SemaphoreCreate_partial_solve_wit_1` — `LLM_pre_process`

Unfold the implication and auxiliary target, introduce parameters, prove 32=32 by reflexivity and reuse given value bounds/safeExec. Cancel unchanged OutsideCritical sg before.
### `proof_of__SemaphoreCreate_partial_solve_wit_2_pure` — `LLM_pre_process`

Lift reflexivity for 0=0 and 32=32 under the full spatial frame; neither equality depends on layout.
### `proof_of__SemaphoreCreate_partial_solve_wit_2` — `LLM_pre_process`

Unfold the implication and auxiliary target; reinsert reflexive constants and all supplied bounds/nonzero/id/lock/safeExec hypotheses. Commute OutsideCritical and SemaphoreRaw and cancel. Preserve both embedded-node inequalities explicitly.
### `proof_of__SemaphoreCreate_partial_solve_wit_3` — `LLM_pre_process`

Reinsert retval=sem and the given bounds/nonzero/id/lock/safeExec facts. Commute SemaphoreZero sem with OutsideCritical sg before and cancel; the semaphore address remains sem on both sides.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_03__entry_calls/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

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
      "SemaphoreCreate-vc-proving-r2",
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
      "SemaphoreCreate-vc-proving-r2",
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
      "SemaphoreCreate-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "entry_calls"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/_coq_builds/SemaphoreCreate-vc-proving-r2/group_03/src/.coq_debug/group_03_entry_calls.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_03__entry_calls/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_03__entry_calls/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
