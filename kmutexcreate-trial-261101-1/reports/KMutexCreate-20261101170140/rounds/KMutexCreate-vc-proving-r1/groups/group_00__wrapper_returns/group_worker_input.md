# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `wrapper_returns`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/KMutexCreate-20261101170140/KMutexCreate-vc-proving-r1/groups/group_00__wrapper_returns/KMutexCreate_proof_manual.v`.
- Editable proof spans: `proof_of_KMutexCreate_return_wit_1`, `proof_of_KMutexCreate_return_wit_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/KMutexCreate-20261101170140/KMutexCreate-vc-proving-r1/groups/group_00__wrapper_returns/KMutexCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/VC/KMutexCreate_lib.v`
- Every new/adapted helper uses suffix `__wrapper_returns`. Preserve the seed.

### `proof_of_KMutexCreate_return_wit_1` — `LLM_pre_process`

Unfold KMutexCreate_return_wit_1 and introduce all quantified variables and hypotheses. The antecedent owns OutsideCritical sg_outside_critical after_3. Choose after := after_3 in the consequent. Discharge retval = -5 with PreH1 and safeExec(LastSeen after_3, ret retval, X_outside_critical) with PreH2; preserve/cancel the identical OutsideCritical resource by entailment reflexivity. Pure-conjunction introduction and existential introduction suffice (the standard Exists/entailer route). PreH3 is an unused earlier abstract-operation premise. Do not unfold OutsideCritical, LastSeen or safeExec: there is no new state transition or helper obligation.
### `proof_of_KMutexCreate_return_wit_2` — `LLM_pre_process`

Unfold KMutexCreate_return_wit_2 and introduce variables and premises. Instantiate after_2 := after_3. The identical OutsideCritical sg_outside_critical after_3 resource is retained. Introduce the pure conjunctions from PreH1 (0 <= retval), PreH2 (retval < 128), and PreH3 (safeExec at after_3 with ret retval and the same X). Close resource identity by reflexivity/cancellation. The bounds are already assumptions; no arithmetic derivation or new refinement transition is needed. PreH4 need not be unfolded. Follow the same existential/pure introduction pattern as return_wit_1.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/KMutexCreate-20261101170140/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/KMutexCreate-20261101170140/rounds/KMutexCreate-vc-proving-r1/groups/group_00__wrapper_returns/proof_reuse.md`.

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
      "KMutexCreate-20261101170140",
      "--round",
      "KMutexCreate-vc-proving-r1",
      "--group",
      "wrapper_returns"
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
      "KMutexCreate-20261101170140",
      "--round",
      "KMutexCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "wrapper_returns"
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
      "KMutexCreate-20261101170140",
      "--round",
      "KMutexCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "wrapper_returns"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/KMutexCreate-20261101170140/_coq_builds/KMutexCreate-vc-proving-r1/group_00/src/.coq_debug/group_00_wrapper_returns.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/KMutexCreate-20261101170140/rounds/KMutexCreate-vc-proving-r1/groups/group_00__wrapper_returns/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/KMutexCreate-20261101170140/rounds/KMutexCreate-vc-proving-r1/groups/group_00__wrapper_returns/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
