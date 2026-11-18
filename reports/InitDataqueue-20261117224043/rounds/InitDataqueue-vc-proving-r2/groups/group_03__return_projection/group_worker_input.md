# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `return_projection`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r2/groups/group_03__return_projection/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_return_wit_1`, `proof_of_InitDataqueue_return_wit_2`, `proof_of_InitDataqueue_return_wit_3`, `proof_of_InitDataqueue_return_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_return_wit_1` — `LLM_pre_process`

Choose q=dataqueue_retired q_3, after=after_4; select the disjunct matching (-1,-5), (-5,-1), or (-1,-1) respectively for return1,2,3. Unfold retired only for fields, preserve store_dataqueue/OutsideCritical, apply given forall-final bridge to safeExec return tt Y.
### `proof_of_InitDataqueue_return_wit_2` — `LLM_pre_process`

Choose q=dataqueue_retired q_3, after=after_4; select the disjunct matching (-1,-5), (-5,-1), or (-1,-1) respectively for return1,2,3. Unfold retired only for fields, preserve store_dataqueue/OutsideCritical, apply given forall-final bridge to safeExec return tt Y.
### `proof_of_InitDataqueue_return_wit_3` — `LLM_pre_process`

Choose q=dataqueue_retired q_3, after=after_4; select the disjunct matching (-1,-5), (-5,-1), or (-1,-1) respectively for return1,2,3. Unfold retired only for fields, preserve store_dataqueue/OutsideCritical, apply given forall-final bridge to safeExec return tt Y.
### `proof_of_InitDataqueue_return_wit_4` — `LLM_pre_process`

Choose current q_3 and after_3 in the left whole-goal alternative; lookup, empty indices, two distinct nonnegative IDs and safeExec return0 are all explicit premises. Preserve OutsideCritical unchanged.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_03__return_projection/proof_reuse.md`.

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
      "return_projection"
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
      "return_projection"
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
      "return_projection"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/_coq_builds/InitDataqueue-vc-proving-r2/group_03/src/.coq_debug/group_03_return_projection.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_03__return_projection/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_03__return_projection/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
