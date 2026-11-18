# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `storage_views`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r1/groups/group_03__storage_views/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_which_implies_wit_1`, `proof_of_InitDataqueue_which_implies_wit_1_split_goal_1`, `proof_of_InitDataqueue_which_implies_wit_1_split_goal_2`, `proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial`, `proof_of_InitDataqueue_which_implies_wit_2`, `proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of_InitDataqueue_which_implies_wit_1_split_goal_1`: Unfold DataqueueStorage; project addr_aligned p 4 from its pure conjunction.

- Split `proof_of_InitDataqueue_which_implies_wit_1_split_goal_2`: Unfold DataqueueStorage; project p<>0 from its pure conjunction.

- Split `proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial`: Unfold DataqueueStorage and rewrite sizeof DataQueue=20 using dataqueue_layout_abi, then cancel the unchanged CharArray.undef_full.
### `proof_of_InitDataqueue_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial`: Use authorized dataqueue_layout_abi to rewrite size20 and eight field offsets; split 20 zero bytes into lengths 2,2,2,2(padding),4,4,4. Convert zero bytes to the three UShort, pointer and two Int zero stores using actual memory encoding lemmas, weaken padding bytes to undef, normalize sizeof CHAR=1, and reassemble. No zero-obligation Prop may be assumed. The statement quantifies all p; prove with the actual byte/typed-store model without silently inserting an alignment hypothesis.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r1/groups/group_03__storage_views/proof_reuse.md`.

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
      "storage_views"
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
      "storage_views"
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
      "storage_views"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/_coq_builds/InitDataqueue-vc-proving-r1/group_03/src/.coq_debug/group_03_storage_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r1/groups/group_03__storage_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r1/groups/group_03__storage_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
