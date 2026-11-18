# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `returns`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r1/groups/group_04__returns/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_return_wit_1`, `proof_of_InitDataqueue_return_wit_2`, `proof_of_InitDataqueue_return_wit_3`, `proof_of_InitDataqueue_return_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_return_wit_1` — `LLM_pre_process`

Choose failure disjunct 1, q_2=dataqueue_retired q_3, after_2=after_4. Unfold retired projections only, decide Z.leb by supplied sem ID signs, and use PreH8 at after_4 with returned safeExec tt to obtain safeExec -1. Preserve the exact store_dataqueue and OutsideCritical resources; no os_inv needed.
### `proof_of_InitDataqueue_return_wit_2` — `LLM_pre_process`

Choose failure disjunct 2, q_2=dataqueue_retired q_3, after_2=after_4. Unfold retired projections only, decide Z.leb by supplied sem ID signs, and use PreH8 at after_4 with returned safeExec tt to obtain safeExec -1. Preserve the exact store_dataqueue and OutsideCritical resources; no os_inv needed.
### `proof_of_InitDataqueue_return_wit_3` — `LLM_pre_process`

Choose failure disjunct 3, q_2=dataqueue_retired q_3, after_2=after_4. Unfold retired projections only, decide Z.leb by supplied sem ID signs, and use PreH8 at after_4 with returned safeExec tt to obtain safeExec -1. Preserve the exact store_dataqueue and OutsideCritical resources; no os_inv needed.
### `proof_of_InitDataqueue_return_wit_4` — `LLM_pre_process`

Choose success whole left alternative, q=q_3 and after=after_3. All lookup/field/continuation facts are hypotheses; cancel OutsideCritical unchanged.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r1/groups/group_04__returns/proof_reuse.md`.

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
      "InitDataqueue-vc-proving-r1",
      "--group",
      "returns"
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
      "InitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "returns"
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
      "InitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "returns"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/_coq_builds/InitDataqueue-vc-proving-r1/group_04/src/.coq_debug/group_04_returns.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r1/groups/group_04__returns/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r1/groups/group_04__returns/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
