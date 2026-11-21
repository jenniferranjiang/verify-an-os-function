# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `resource_views`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/PopDataqueue-20261119021132/PopDataqueue-vc-proving-r1/groups/group_02__resource_views/PopDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_PopDataqueue_which_implies_wit_1`, `proof_of_PopDataqueue_which_implies_wit_1_split_goal_1`, `proof_of_PopDataqueue_which_implies_wit_1_split_goal_2`, `proof_of_PopDataqueue_which_implies_wit_1_split_goal_spatial`, `proof_of_PopDataqueue_which_implies_wit_2`, `proof_of_PopDataqueue_which_implies_wit_2_split_goal_1`, `proof_of_PopDataqueue_which_implies_wit_2_split_goal_2`, `proof_of_PopDataqueue_which_implies_wit_2_split_goal_spatial`, `proof_of_PopDataqueue_which_implies_wit_3`, `proof_of_PopDataqueue_which_implies_wit_4`, `proof_of_PopDataqueue_which_implies_wit_4_split_goal_spatial`, `proof_of_PopDataqueue_which_implies_wit_5`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_PopDataqueue_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of_PopDataqueue_which_implies_wit_1_split_goal_1`: Unfold store_dataqueue; its pure conjunction directly gives addr_aligned p_queue 4, with no need to consume fields.

- Split `proof_of_PopDataqueue_which_implies_wit_1_split_goal_2`: Unfold store_dataqueue and project p_queue<>0 from its pure conjunction.

- Split `proof_of_PopDataqueue_which_implies_wit_1_split_goal_spatial`: Unfold store_dataqueue and dataqueue_fields, retain dataqueue_buffer opaque, extract nonzero/alignment pure conjunction, normalize sizeof CHAR=1, and cancel the six named typed fields plus the explicit two-byte padding and buffer in the required order. No field or buffer ownership is dropped.
### `proof_of_PopDataqueue_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of_PopDataqueue_which_implies_wit_2_split_goal_1`: Unfold store_dataqueue for the second observed q; project address alignment from its existing pure conjunct.

- Split `proof_of_PopDataqueue_which_implies_wit_2_split_goal_2`: Unfold store_dataqueue and project the existing nonzero address fact for this q.

- Split `proof_of_PopDataqueue_which_implies_wit_2_split_goal_spatial`: Unfold store_dataqueue and dataqueue_fields, retain dataqueue_buffer opaque, extract nonzero/alignment pure conjunction, normalize sizeof CHAR=1, and cancel the six named typed fields plus the explicit two-byte padding and buffer in the required order. No field or buffer ownership is dropped.
### `proof_of_PopDataqueue_which_implies_wit_3` — `LLM_pre_process`

Use LLM_pre_process choosing the first whole disjunct. From ready and front<>rear prove 0<dataqueue_count q by considering rear>=front vs wrap and the known 0<=front,rear<max_len. Therefore seq0(to_nat count) has a first entry; Forall initialized of dataqueue_contents yields nth(to_nat front) slots None=Some e after front mod max_len reduction. Choose that e and retain ready. From buffer, base<>0 and slots length, split store_array at front with bounds; obtain exactly dataqueue_slot base front (Some e) and a missing-index array. Introduce the wand by merging that same slot back with missing-index resources, restoring buffer including length/alignment pure facts. Prove actual arithmetic/list facts locally, not via the unproved nonempty-front or slot-view Prop definitions.
### `proof_of_PopDataqueue_which_implies_wit_4` — `aggressive_pre_process`

- Split `proof_of_PopDataqueue_which_implies_wit_4_split_goal_spatial`: Unfold dataqueue_slot with Some e and use the existing DataElem sizeof=8 ABI fact to identify base+front*8 with the generated pointer offset. Cancel exactly the pointer and UInt fields; no payload memory is owned or accessed.
### `proof_of_PopDataqueue_which_implies_wit_5` — `LLM_pre_process`

Use LLM_pre_process choosing the first disjunct, whose target owns unknown output cells. Destruct each old option, unfold peak_data_slot/peak_length_slot, keep None cells unchanged and forget the known Some contents using existing typed-store-to-undef entailments. Cancel the two disjoint cells; never replace None by emp.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/PopDataqueue-20261119021132/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-proving-r1/groups/group_02__resource_views/proof_reuse.md`.

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
      "PopDataqueue-20261119021132",
      "--round",
      "PopDataqueue-vc-proving-r1",
      "--group",
      "resource_views"
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
      "PopDataqueue-20261119021132",
      "--round",
      "PopDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "resource_views"
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
      "PopDataqueue-20261119021132",
      "--round",
      "PopDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "resource_views"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/PopDataqueue-20261119021132/_coq_builds/PopDataqueue-vc-proving-r1/group_02/src/.coq_debug/group_02_resource_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-proving-r1/groups/group_02__resource_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-proving-r1/groups/group_02__resource_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
