# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `cleanup_create`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/InitDataqueue-vc-proving-r1/groups/group_02__cleanup_create/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_entail_wit_2_3`, `proof_of_InitDataqueue_entail_wit_2_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_entail_wit_2_3` — `LLM_pre_process`

Pattern T-cleanup (high risk): first create failed; base=retval_2, IDs -5,-1, after=after_2. Instantiate held=observed, actual after from the current invariant, q=dataqueue_constructed with exactly the stored fields; choose correct failure disjunct (third for malloc, second for first-create failure, first for second-create failure). Fold fields plus padding into dataqueue_owned; if base nonzero prove n>0 and byte-to-None-slot array conversion from UShort bounds/allocation length. Reconstruct dataqueue_init_phase_effect including actual create effects and refs (None for negative IDs; saved allocated blank pointer for successful first create). Use safeExec bind decomposition at actual observed init phase to obtain continuation Y for abs_deinit_dataqueue and forall final bridge to ret(-1) X. This transfers the existing checked cleanup entry condition from original safeExec, rather than assuming arbitrary lifecycle facts. GTrans is the existing protocol relation; frame os_inv and InsideCritical unchanged.
### `proof_of_InitDataqueue_entail_wit_2_4` — `LLM_pre_process`

Pattern T-cleanup (high risk): second create failed; base=retval_2, IDs retval_3,-5, after=after_3. Instantiate held=observed, actual after from the current invariant, q=dataqueue_constructed with exactly the stored fields; choose correct failure disjunct (third for malloc, second for first-create failure, first for second-create failure). Fold fields plus padding into dataqueue_owned; if base nonzero prove n>0 and byte-to-None-slot array conversion from UShort bounds/allocation length. Reconstruct dataqueue_init_phase_effect including actual create effects and refs (None for negative IDs; saved allocated blank pointer for successful first create). Use safeExec bind decomposition at actual observed init phase to obtain continuation Y for abs_deinit_dataqueue and forall final bridge to ret(-1) X. This transfers the existing checked cleanup entry condition from original safeExec, rather than assuming arbitrary lifecycle facts. GTrans is the existing protocol relation; frame os_inv and InsideCritical unchanged.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_02__cleanup_create/proof_reuse.md`.

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
      "cleanup_create"
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
      "cleanup_create"
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
      "cleanup_create"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/_coq_builds/InitDataqueue-vc-proving-r1/group_02/src/.coq_debug/group_02_cleanup_create.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_02__cleanup_create/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_02__cleanup_create/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
