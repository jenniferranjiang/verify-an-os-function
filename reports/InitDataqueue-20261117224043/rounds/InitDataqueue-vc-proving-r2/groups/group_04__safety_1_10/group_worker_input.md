# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `safety_1_10`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r2/groups/group_04__safety_1_10/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_safety_wit_1`, `proof_of_InitDataqueue_safety_wit_2`, `proof_of_InitDataqueue_safety_wit_3`, `proof_of_InitDataqueue_safety_wit_4`, `proof_of_InitDataqueue_safety_wit_5`, `proof_of_InitDataqueue_safety_wit_6`, `proof_of_InitDataqueue_safety_wit_7`, `proof_of_InitDataqueue_safety_wit_8`, `proof_of_InitDataqueue_safety_wit_9`, `proof_of_InitDataqueue_safety_wit_10`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_safety_wit_1` — `LLM_pre_process`

After LLM_pre_process, prove displayed constant Int bounds or inequality by integer arithmetic. Frame all spatial resources; no object unfolding required.
### `proof_of_InitDataqueue_safety_wit_2` — `LLM_pre_process`

After LLM_pre_process, prove displayed constant Int bounds or inequality by integer arithmetic. Frame all spatial resources; no object unfolding required.
### `proof_of_InitDataqueue_safety_wit_3` — `LLM_pre_process`

After LLM_pre_process, prove displayed constant Int bounds or inequality by integer arithmetic. Frame all spatial resources; no object unfolding required.
### `proof_of_InitDataqueue_safety_wit_4` — `LLM_pre_process`

After LLM_pre_process, prove displayed constant Int bounds or inequality by integer arithmetic. Frame all spatial resources; no object unfolding required.
### `proof_of_InitDataqueue_safety_wit_5` — `LLM_pre_process`

After LLM_pre_process, prove displayed constant Int bounds or inequality by integer arithmetic. Frame all spatial resources; no object unfolding required.
### `proof_of_InitDataqueue_safety_wit_6` — `LLM_pre_process`

After LLM_pre_process, prove displayed constant Int bounds or inequality by integer arithmetic. Frame all spatial resources; no object unfolding required.
### `proof_of_InitDataqueue_safety_wit_7` — `LLM_pre_process`

After LLM_pre_process, prove displayed constant Int bounds or inequality by integer arithmetic. Frame all spatial resources; no object unfolding required.
### `proof_of_InitDataqueue_safety_wit_8` — `LLM_pre_process`

After LLM_pre_process, prove displayed constant Int bounds or inequality by integer arithmetic. Frame all spatial resources; no object unfolding required.
### `proof_of_InitDataqueue_safety_wit_9` — `LLM_pre_process`

After LLM_pre_process use the incompatible branch premises (zero/nonzero malloc or negative/nonnegative Create return) to prove False. No missing resources are inferred from arbitrary states.
### `proof_of_InitDataqueue_safety_wit_10` — `LLM_pre_process`

After LLM_pre_process use the incompatible branch premises (zero/nonzero malloc or negative/nonnegative Create return) to prove False. No missing resources are inferred from arbitrary states.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_04__safety_1_10/proof_reuse.md`.

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
      "/home/xinra/crtos-verify",
      "coq-debug",
      "--run",
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-vc-proving-r2",
      "--group",
      "safety_1_10"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "safety_1_10"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "safety_1_10"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/_coq_builds/InitDataqueue-vc-proving-r2/group_04/src/.coq_debug/group_04_safety_1_10.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_04__safety_1_10/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_04__safety_1_10/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
