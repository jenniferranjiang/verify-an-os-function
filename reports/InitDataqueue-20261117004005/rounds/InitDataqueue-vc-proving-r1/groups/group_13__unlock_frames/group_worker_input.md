# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `unlock_frames`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/InitDataqueue-vc-proving-r1/groups/group_13__unlock_frames/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_partial_solve_wit_8_pure`, `proof_of_InitDataqueue_partial_solve_wit_8`, `proof_of_InitDataqueue_partial_solve_wit_9_pure`, `proof_of_InitDataqueue_partial_solve_wit_9`, `proof_of_InitDataqueue_partial_solve_wit_10_pure`, `proof_of_InitDataqueue_partial_solve_wit_10`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_partial_solve_wit_8_pure` — `LLM_pre_process`

Pattern P: unfold this witness (and its _pure/_aux definitions when implication-valued), introduce the supplied pure-witness argument if present, introduce quantified parameters and pure hypotheses. Re-establish each pure conjunct from the identical context (for return bridge retain full forall final), cancel/reorder unchanged stores, os_inv, dataqueue_owned and critical token. There are no fresh state witnesses or abstract transitions; call arguments q/refs/Y and saved lock are unchanged.
### `proof_of_InitDataqueue_partial_solve_wit_8` — `LLM_pre_process`

Pattern P: unfold this witness (and its _pure/_aux definitions when implication-valued), introduce the supplied pure-witness argument if present, introduce quantified parameters and pure hypotheses. Re-establish each pure conjunct from the identical context (for return bridge retain full forall final), cancel/reorder unchanged stores, os_inv, dataqueue_owned and critical token. There are no fresh state witnesses or abstract transitions; call arguments q/refs/Y and saved lock are unchanged.
### `proof_of_InitDataqueue_partial_solve_wit_9_pure` — `LLM_pre_process`

Pattern P: unfold this witness (and its _pure/_aux definitions when implication-valued), introduce the supplied pure-witness argument if present, introduce quantified parameters and pure hypotheses. Re-establish each pure conjunct from the identical context (for return bridge retain full forall final), cancel/reorder unchanged stores, os_inv, dataqueue_owned and critical token. There are no fresh state witnesses or abstract transitions; call arguments q/refs/Y and saved lock are unchanged.
### `proof_of_InitDataqueue_partial_solve_wit_9` — `LLM_pre_process`

Pattern P: unfold this witness (and its _pure/_aux definitions when implication-valued), introduce the supplied pure-witness argument if present, introduce quantified parameters and pure hypotheses. Re-establish each pure conjunct from the identical context (for return bridge retain full forall final), cancel/reorder unchanged stores, os_inv, dataqueue_owned and critical token. There are no fresh state witnesses or abstract transitions; call arguments q/refs/Y and saved lock are unchanged.
### `proof_of_InitDataqueue_partial_solve_wit_10_pure` — `LLM_pre_process`

Pattern P: unfold this witness (and its _pure/_aux definitions when implication-valued), introduce the supplied pure-witness argument if present, introduce quantified parameters and pure hypotheses. Re-establish each pure conjunct from the identical context (for return bridge retain full forall final), cancel/reorder unchanged stores, os_inv, dataqueue_owned and critical token. There are no fresh state witnesses or abstract transitions; call arguments q/refs/Y and saved lock are unchanged.
### `proof_of_InitDataqueue_partial_solve_wit_10` — `LLM_pre_process`

Pattern P: unfold this witness (and its _pure/_aux definitions when implication-valued), introduce the supplied pure-witness argument if present, introduce quantified parameters and pure hypotheses. Re-establish each pure conjunct from the identical context (for return bridge retain full forall final), cancel/reorder unchanged stores, os_inv, dataqueue_owned and critical token. There are no fresh state witnesses or abstract transitions; call arguments q/refs/Y and saved lock are unchanged.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_13__unlock_frames/proof_reuse.md`.

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
      "InitDataqueue-20261117004005",
      "--round",
      "InitDataqueue-vc-proving-r1",
      "--group",
      "unlock_frames"
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
      "InitDataqueue-20261117004005",
      "--round",
      "InitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "unlock_frames"
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
      "InitDataqueue-20261117004005",
      "--round",
      "InitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "unlock_frames"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/_coq_builds/InitDataqueue-vc-proving-r1/group_13/src/.coq_debug/group_13_unlock_frames.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_13__unlock_frames/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_13__unlock_frames/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
