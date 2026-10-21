# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `outer_scan`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r2/groups/group_03__outer_scan/AllocId_proof_manual.v`.
- Editable proof spans: `proof_of_AllocId_entail_wit_2`, `proof_of_AllocId_entail_wit_3`, `proof_of_AllocId_entail_wit_3_split_goal_1`, `proof_of_AllocId_entail_wit_3_split_goal_2`, `proof_of_AllocId_entail_wit_4`, `proof_of_AllocId_entail_wit_4_split_goal_1`, `proof_of_AllocId_safety_wit_9`, `proof_of_AllocId_safety_wit_9_split_goal_1`, `proof_of_AllocId_safety_wit_9_split_goal_2`, `proof_of_AllocId_safety_wit_14`, `proof_of_AllocId_safety_wit_19`, `proof_of_AllocId_safety_wit_19_split_goal_1`, `proof_of_AllocId_safety_wit_19_split_goal_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_AllocId_entail_wit_2` — `LLM_pre_process`

Choose the first identical disjunct. Unfold store_idmanager, store_id_map, store_uchar_array and OSHeap. Decompose heap lift over separating conjunction/existential/pure assertions using crtos_heap_lift_sep and the definitions. Reuse its byte existential; extract id_map_bytes_ok and idbuckets_ok; rewrite the array length div to quot from idmax >= 0. Reassemble the exact four manager fields, full array and OSHeap bucket frame; pure manager/local equalities are explicit premises. No footprint or abstract state changes.
### `proof_of_AllocId_entail_wit_3` — `aggressive_pre_process`

- Split `proof_of_AllocId_entail_wit_3_split_goal_1`: Unfold allocid_index_scan_inv. At index 0 nonnegativity is trivial and its universally quantified earlier-index range is empty. Pure goal, no heap or existential.

- Split `proof_of_AllocId_entail_wit_3_split_goal_2`: From id_map_bytes_ok obtain idmax >= 0. Then (idmax+7) quot 8 >= 0 by nonnegative quotient. Pure goal, no resource or witness.
### `proof_of_AllocId_entail_wit_4` — `aggressive_pre_process`

- Split `proof_of_AllocId_entail_wit_4_split_goal_1`: Unfold the index-scan invariant. For 0 <= i < index+1, split i<index or i=index; use the old prefix or the Znth index bytes 0=255 guard. Nonnegativity follows from index>=0. Pure goal, no resource transition.
### `proof_of_AllocId_safety_wit_9` — `aggressive_pre_process`

- Split `proof_of_AllocId_safety_wit_9_split_goal_1`: Extract idmax<=65535 from id_map_bytes_ok. Then idmax+7<=65542<INT_MAX. Heap is context; pure conclusion only.

- Split `proof_of_AllocId_safety_wit_9_split_goal_2`: Extract idmax>=0 from id_map_bytes_ok, hence INT_MIN<=idmax+7. Heap is context; pure conclusion only.
### `proof_of_AllocId_safety_wit_14` — `LLM_pre_process`

Destruct id_map_bytes_ok for 0 <= idmax <= 65535. Rewrite quot to div using nonnegative idmax+7, and use division bounds to get 0 <= end <= 8192; index < end and 0 <= index give index <= 8191. Therefore index+1 is between 1 and 8192; prove both INT bounds. Array and manager resources are context; no existential.
### `proof_of_AllocId_safety_wit_19` — `aggressive_pre_process`

- Split `proof_of_AllocId_safety_wit_19_split_goal_1`: Destruct id_map_bytes_ok for 0 <= idmax <= 65535. Rewrite quot to div using nonnegative idmax+7, and use division bounds to get 0 <= end <= 8192; index < end and 0 <= index give index <= 8191. Therefore index*8 <= 65528 < INT_MAX. Conclude the pure upper bound, with unchanged heap context.

- Split `proof_of_AllocId_safety_wit_19_split_goal_2`: index>=0 implies 0<=index*8, hence INT_MIN<=index*8. Pure lower bound; heap context needs no transformation.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_03__outer_scan/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-debug",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-proving-r2",
      "--group",
      "outer_scan"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-check",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "outer_scan"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-check",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "outer_scan"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/_coq_builds/AllocId-vc-proving-r2/group_03/src/.coq_debug/group_03_outer_scan.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_03__outer_scan/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_03__outer_scan/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
