# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `call_frames_6_8`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/DeInitDataqueue-vc-proving-r1/groups/group_09__call_frames_6_8/DeInitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_DeInitDataqueue_partial_solve_wit_6_pure`, `proof_of_DeInitDataqueue_partial_solve_wit_6`, `proof_of_DeInitDataqueue_partial_solve_wit_7_pure`, `proof_of_DeInitDataqueue_partial_solve_wit_7`, `proof_of_DeInitDataqueue_partial_solve_wit_8_pure`, `proof_of_DeInitDataqueue_partial_solve_wit_8`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_DeInitDataqueue_partial_solve_wit_6_pure` — `LLM_pre_process`

Rewrite C ID using saved field equality; requested quiescent is the saved fact at observed (4/5) or middle (6/7).
### `proof_of_DeInitDataqueue_partial_solve_wit_6` — `LLM_pre_process`

Introduce the separately quantified pure-obligation premise and unfold this partial-solve auxiliary goal. Instantiate that premise on exactly the current state, values and spatial resources; preserve all accompanying facts, commute the requested callee resource first, and cancel untouched fields/padding/critical/object frames. For free use base=dq_base q to identify the byte allocation; for Delete use the matching os_inv; for Enable use InsideCritical and os_inv with saved GTrans. The pure premise is an implication argument in the generated target, not an added assumption.
### `proof_of_DeInitDataqueue_partial_solve_wit_7_pure` — `LLM_pre_process`

Rewrite C ID using saved field equality; requested quiescent is the saved fact at observed (4/5) or middle (6/7).
### `proof_of_DeInitDataqueue_partial_solve_wit_7` — `LLM_pre_process`

Introduce the separately quantified pure-obligation premise and unfold this partial-solve auxiliary goal. Instantiate that premise on exactly the current state, values and spatial resources; preserve all accompanying facts, commute the requested callee resource first, and cancel untouched fields/padding/critical/object frames. For free use base=dq_base q to identify the byte allocation; for Delete use the matching os_inv; for Enable use InsideCritical and os_inv with saved GTrans. The pure premise is an implication argument in the generated target, not an added assumption.
### `proof_of_DeInitDataqueue_partial_solve_wit_8_pure` — `LLM_pre_process`

Requested GTrans observed final is already a saved premise.
### `proof_of_DeInitDataqueue_partial_solve_wit_8` — `LLM_pre_process`

Introduce the separately quantified pure-obligation premise and unfold this partial-solve auxiliary goal. Instantiate that premise on exactly the current state, values and spatial resources; preserve all accompanying facts, commute the requested callee resource first, and cancel untouched fields/padding/critical/object frames. For free use base=dq_base q to identify the byte allocation; for Delete use the matching os_inv; for Enable use InsideCritical and os_inv with saved GTrans. The pure premise is an implication argument in the generated target, not an added assumption.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_09__call_frames_6_8/proof_reuse.md`.

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
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--group",
      "call_frames_6_8"
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
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "call_frames_6_8"
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
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "call_frames_6_8"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/_coq_builds/DeInitDataqueue-vc-proving-r1/group_09/src/.coq_debug/group_09_call_frames_6_8.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_09__call_frames_6_8/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_09__call_frames_6_8/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
