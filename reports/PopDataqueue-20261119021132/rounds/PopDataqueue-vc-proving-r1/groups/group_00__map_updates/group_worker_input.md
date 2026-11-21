# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `map_updates`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/PopDataqueue-20261119021132/PopDataqueue-vc-proving-r1/groups/group_00__map_updates/PopDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_PopDataqueue_entail_wit_1`, `proof_of_PopDataqueue_entail_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_PopDataqueue_entail_wit_1` — `LLM_pre_process`

Use LLM_pre_process. Extract the first assertS/dataqueue_peak_entry fact from safeExec by unfolding the current named program and wp bind/assert rules. Instantiate its observed state using Crtos_RTrans and LastSeen. Apply the resulting os_inv entailment with pure-resource preservation, obtaining q with map lookup. Unfold only the queue component of os_inv; dataqueue_inv lookup gives ready and semaphore associations. Split store_map at p_queue_pre, instantiate seen_id=observed and this q, and introduce the restoration wand using merge with the unchanged value. Return InsideCritical and both optional output slots unchanged; keep all other OS resources in the wand. The map lookup is not itself ownership and the Prop focus obligation is not a proved lemma.
### `proof_of_PopDataqueue_entail_wit_4` — `LLM_pre_process`

Use LLM_pre_process. Unfold dataqueue_pop_after_obtain at status0 and extract the second assertS observation using Crtos_RTrans after_get observed. Obtain q, ready and map ownership from os_inv, taking seen_ring=observed. Split on dq_front q = dq_rear q. Empty branch chooses the right disjunct and constructs the same-value map restoration wand. Nonempty branch chooses the left disjunct and must prove dataqueue_ready(dataqueue_pop q) before constructing the update wand. Derive max_len/front/rear bounds and slots length from ready. Prove count(pop q)=count q-1 and that each FIFO slot of pop q is the old FIFO slot at successor index (modular front wrap included); transport Forall initialized along that tail/subsequence using seq/map indices. All other ready fields and both semaphore IDs are unchanged. Split store_map once; within wand introduction merge the supplied new store_dataqueue at p into dataqueue_publish, retaining all other keys. Prove new map pure invariant by key=p vs key<>p; the latter uses old invariant, former uses pop-ready and unchanged semaphore association. Rebuild os_inv using replace_dataqueues projections; nonqueue frame and world conditions are unchanged. Keep InsideCritical and output slots untouched. No duplicate frame ownership and no assumed ready-obligation.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/PopDataqueue-20261119021132/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-proving-r1/groups/group_00__map_updates/proof_reuse.md`.

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
      "map_updates"
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
      "map_updates"
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
      "map_updates"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/PopDataqueue-20261119021132/_coq_builds/PopDataqueue-vc-proving-r1/group_00/src/.coq_debug/group_00_map_updates.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-proving-r1/groups/group_00__map_updates/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-proving-r1/groups/group_00__map_updates/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
