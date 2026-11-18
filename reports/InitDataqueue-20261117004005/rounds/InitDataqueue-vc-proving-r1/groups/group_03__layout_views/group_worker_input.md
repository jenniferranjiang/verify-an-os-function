# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `layout_views`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/InitDataqueue-vc-proving-r1/groups/group_03__layout_views/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_which_implies_wit_1`, `proof_of_InitDataqueue_which_implies_wit_1_split_goal_1`, `proof_of_InitDataqueue_which_implies_wit_1_split_goal_2`, `proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial`, `proof_of_InitDataqueue_which_implies_wit_2`, `proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of_InitDataqueue_which_implies_wit_1_split_goal_1`: Unfold DataqueueStorage, extract nonzero/alignment pure conjunct for numeric split or cancel CharArray.undef_full after sizeof(DataQueue)=20 for spatial split; preserve exact byte ownership.

- Split `proof_of_InitDataqueue_which_implies_wit_1_split_goal_2`: Unfold DataqueueStorage, extract nonzero/alignment pure conjunct for numeric split or cancel CharArray.undef_full after sizeof(DataQueue)=20 for spatial split; preserve exact byte ownership.

- Split `proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial`: Unfold DataqueueStorage, extract nonzero/alignment pure conjunct for numeric split or cancel CharArray.undef_full after sizeof(DataQueue)=20 for spatial split; preserve exact byte ownership.
### `proof_of_InitDataqueue_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial`: Use actual ABI field offsets and sizeof(DataQueue)=20; split zero-filled CharArray into [0,2),[2,4),[4,6),padding[6,8),[8,12),[12,16),[16,20). Convert little-endian zero bytes to UShort/Ptr/Int zero cells, forget only the two padding bytes to undef_full, then reassemble separation in target order. All layout equalities must be proved from existing ABI interface; do not assume dataqueue_zero_obligation.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_03__layout_views/proof_reuse.md`.

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
      "layout_views"
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
      "layout_views"
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
      "layout_views"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117004005/_coq_builds/InitDataqueue-vc-proving-r1/group_03/src/.coq_debug/group_03_layout_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_03__layout_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-proving-r1/groups/group_03__layout_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
