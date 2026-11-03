# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `return_branches`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/KEventCreate-20261101232854/KEventCreate-vc-proving-r1/groups/group_00__return_branches/KEventCreate_proof_manual.v`.
- Editable proof spans: `proof_of_KEventCreate_return_wit_1`, `proof_of_KEventCreate_return_wit_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/KEventCreate-20261101232854/KEventCreate-vc-proving-r1/groups/group_00__return_branches/KEventCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventcreate-trial-261101-1/VC/KEventCreate_lib.v`
- Every new/adapted helper uses suffix `__return_branches`. Preserve the seed.

### `proof_of_KEventCreate_return_wit_1` — `LLM_pre_process`

Unfold KEventCreate_return_wit_1 and introduce quantified values and PreH1–PreH3. The antecedent owns OutsideCritical sg after_3; instantiate the consequent after existential with after_3, cancel the identical OutsideCritical resource, and discharge retval=-5 and the return safeExec fact directly from PreH1 and PreH2. No state transition, unfolding of OutsideCritical or new helper is required.
### `proof_of_KEventCreate_return_wit_2` — `LLM_pre_process`

Unfold KEventCreate_return_wit_2 and introduce quantified values and PreH1–PreH4. Instantiate after_2 with after_3 and cancel OutsideCritical sg after_3. The bounds 0<=retval and retval<128 are precisely PreH1/PreH2; the return safeExec fact is PreH3. Preserve the resource without unfolding the OS invariant or abstract program. No helper is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/KEventCreate-20261101232854/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/KEventCreate-20261101232854/rounds/KEventCreate-vc-proving-r1/groups/group_00__return_branches/proof_reuse.md`.

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
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-debug",
      "--run",
      "KEventCreate-20261101232854",
      "--round",
      "KEventCreate-vc-proving-r1",
      "--group",
      "return_branches"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-check",
      "--run",
      "KEventCreate-20261101232854",
      "--round",
      "KEventCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "return_branches"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-check",
      "--run",
      "KEventCreate-20261101232854",
      "--round",
      "KEventCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "return_branches"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/KEventCreate-20261101232854/_coq_builds/KEventCreate-vc-proving-r1/group_00/src/.coq_debug/group_00_return_branches.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/KEventCreate-20261101232854/rounds/KEventCreate-vc-proving-r1/groups/group_00__return_branches/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/KEventCreate-20261101232854/rounds/KEventCreate-vc-proving-r1/groups/group_00__return_branches/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
