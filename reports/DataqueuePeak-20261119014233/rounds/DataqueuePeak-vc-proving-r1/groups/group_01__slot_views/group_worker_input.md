# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `slot_views`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/DataqueuePeak-20261119014233/DataqueuePeak-vc-proving-r1/groups/group_01__slot_views/DataqueuePeak_proof_manual.v`.
- Editable proof spans: `proof_of_DataqueuePeak_which_implies_wit_2`, `proof_of_DataqueuePeak_which_implies_wit_3`, `proof_of_DataqueuePeak_which_implies_wit_3_split_goal_spatial`, `proof_of_DataqueuePeak_which_implies_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_DataqueuePeak_which_implies_wit_2` — `LLM_pre_process`

Choose either identical disjunct and start LLM_pre_process. Unpack dataqueue_ready: max_len>0, front/rear in [0,max_len), base<>0, slot length=max_len, and every entry in dataqueue_contents is Some. Prove dataqueue_count>0 from front<>rear and the two bounds: rear-front+max_len lies strictly between 0 and 2*max_len and is not max_len, so its modulo is nonzero. Thus seq 0 (Z.to_nat count) has a head; Forall on contents yields a Some e at its first entry. Normalize (front+0) mod max_len to front and choose that e, obtaining dataqueue_peak q=Some e. Unfold the nonzero-base branch of dataqueue_buffer. Split store_array at front using its bounds and length, identify the extracted nth entry with Some e, retain the missing-index array and the buffer pure conditions. Introduce the wand and merge the unchanged slot back at the same index to reconstruct dataqueue_buffer. All arithmetic and borrowing facts are to be proved inline; the similarly named nonempty/front and slot-view obligation definitions are not lemmas.
### `proof_of_DataqueuePeak_which_implies_wit_3` — `aggressive_pre_process`

- Split `proof_of_DataqueuePeak_which_implies_wit_3_split_goal_spatial`: Start LLM_pre_process; unfold dataqueue_slot for Some e. Use the existing authorized dataqueue_layout_abi projection sizeof(DataElem)=8 to rewrite pointer_offset arithmetic (unfold the sizeof wrapper if necessary). Both sides then contain exactly the data Ptr cell and length UInt cell with unchanged values; cancel them. No range or initialized-memory assumption is added.
### `proof_of_DataqueuePeak_which_implies_wit_4` — `LLM_pre_process`

Select the first disjunct (unknown destination cells), start LLM_pre_process and destruct old_data/old_length. Unfold peak_data_slot/peak_length_slot. None cases already own unknown Ptr/UInt cells; Some cases forget the existing values with the library store-to-undef entailments. Frame the other output cell and cancel. The second disjunct need not be proved; it would require inventing known values for unknown slots.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/DataqueuePeak-20261119014233/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/DataqueuePeak-20261119014233/rounds/DataqueuePeak-vc-proving-r1/groups/group_01__slot_views/proof_reuse.md`.

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
      "DataqueuePeak-20261119014233",
      "--round",
      "DataqueuePeak-vc-proving-r1",
      "--group",
      "slot_views"
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
      "DataqueuePeak-20261119014233",
      "--round",
      "DataqueuePeak-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "slot_views"
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
      "DataqueuePeak-20261119014233",
      "--round",
      "DataqueuePeak-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "slot_views"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/DataqueuePeak-20261119014233/_coq_builds/DataqueuePeak-vc-proving-r1/group_01/src/.coq_debug/group_01_slot_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/DataqueuePeak-20261119014233/rounds/DataqueuePeak-vc-proving-r1/groups/group_01__slot_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/DataqueuePeak-20261119014233/rounds/DataqueuePeak-vc-proving-r1/groups/group_01__slot_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
