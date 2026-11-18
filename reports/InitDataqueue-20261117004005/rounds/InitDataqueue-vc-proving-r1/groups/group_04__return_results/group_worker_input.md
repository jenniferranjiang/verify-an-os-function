# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `return_results`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/InitDataqueue-vc-proving-r1/groups/group_04__return_results/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_return_wit_1`, `proof_of_InitDataqueue_return_wit_2`, `proof_of_InitDataqueue_return_wit_3`, `proof_of_InitDataqueue_return_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_return_wit_1` — `LLM_pre_process`

Pattern R-failure 1: instantiate returned object with dataqueue_retired(q_3), state after_4; unfold dataqueue_retired projections, preserve addr/max_len/front/rear and base=0. Branch 1 has respectively sem IDs (nonnegative,-5),(-5,-1),(-1,-1); use Z.leb of nonnegative/negative to get (-1,-5),(-5,-1),(-1,-1). Apply the forall-final continuation bridge to PreH1 to obtain safeExec(ret -1) X. Select the matching output disjunct; cancel owned retired object and OutsideCritical.
### `proof_of_InitDataqueue_return_wit_2` — `LLM_pre_process`

Pattern R-failure 2: instantiate returned object with dataqueue_retired(q_3), state after_4; unfold dataqueue_retired projections, preserve addr/max_len/front/rear and base=0. Branch 2 has respectively sem IDs (nonnegative,-5),(-5,-1),(-1,-1); use Z.leb of nonnegative/negative to get (-1,-5),(-5,-1),(-1,-1). Apply the forall-final continuation bridge to PreH1 to obtain safeExec(ret -1) X. Select the matching output disjunct; cancel owned retired object and OutsideCritical.
### `proof_of_InitDataqueue_return_wit_3` — `LLM_pre_process`

Pattern R-failure 3: instantiate returned object with dataqueue_retired(q_3), state after_4; unfold dataqueue_retired projections, preserve addr/max_len/front/rear and base=0. Branch 3 has respectively sem IDs (nonnegative,-5),(-5,-1),(-1,-1); use Z.leb of nonnegative/negative to get (-1,-5),(-5,-1),(-1,-1). Apply the forall-final continuation bridge to PreH1 to obtain safeExec(ret -1) X. Select the matching output disjunct; cancel owned retired object and OutsideCritical.
### `proof_of_InitDataqueue_return_wit_4` — `LLM_pre_process`

Pattern R-success: choose the left whole-goal alternative, instantiate q=q_3 and after=after_3; all scalar, membership and safeExec facts are premises. Cancel OutsideCritical. No entry/exit state equality is claimed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_04__return_results/proof_reuse.md`.

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
      "return_results"
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
      "return_results"
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
      "return_results"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/_coq_builds/InitDataqueue-vc-proving-r1/group_04/src/.coq_debug/group_04_return_results.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_04__return_results/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_04__return_results/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
