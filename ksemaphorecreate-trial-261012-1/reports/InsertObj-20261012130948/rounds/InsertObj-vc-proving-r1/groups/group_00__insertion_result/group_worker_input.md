# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `insertion_result`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/InsertObj-vc-proving-r1/groups/group_00__insertion_result/InsertObj_proof_manual.v`.
- Editable proof spans: `proof_of_InsertObj_return_wit_1`, `proof_of_InsertObj_return_wit_1_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_InsertObj_return_wit_1` — `aggressive_pre_process`

- Split `proof_of_InsertObj_return_wit_1_split_goal_spatial`: For mixed OSHeap/root-heap assertions use crtos_heap_lift_sep and crtos_heap_lift_entails plus unfolding of OSHeap, crtos_heap_state and primitive stores to transport the same concrete heap; OSHeap_ushort_eq is public. Do not assume the Local OSHeap_* lemmas are exported. Any additional carrier equality must be an inline assertion in this witness body, since no case lib exists. Let k=id mod hoffset sm, n=Build_IdNodeAbs id idnode_pre and new_bucket=n::bucket. Fold the id UShort and idnode_pre<>0 into store_idnode at link=idnode_pre+4. Use DLL.dllseg_shift_rev_contact_a to prefix n to the existing reverse-shifted segment, using the two updated next/prev cells. Combine its new first-prev=head cell with DLL.dllseg_shift_rev_to_dllseg, obtaining the tail pointer and head-prev resource; retain head-next=link and fold store_dll/store_idnodes. Derive tail nonzero by induction/list-last cases on the reconstructed nonempty dllseg and idnodes_nonzero of the new list (a pointer value cell alone does not imply nonzero); head and new-link nonzero are explicit. Apply store_idbuckets_replace to the unchanged except frame with k>=0 from positive hoffset. Prove idbuckets_ok for replace_Znth k new_bucket old_buckets as inline pure assertions: length unchanged; id is in range and absent from old ids by min_free_id/query=false; old permutation implies absence in every old bucket; extend idlist_ok and the selected idnodes_ok using idnode_pre<>0; preserve other buckets and bucket-index equations, adding id mod hoffset=k; prove concat/map permutation equals id::old_ids by the prefix/selected/suffix decomposition (commute the new singleton past prefix). Fold idmanager_link(idmanager_add before id), store_idmanager, and cancel the unchanged manager fields and already updated bitmap. No protocol-state transition is involved; only the abstract manager changes from allocated-unlinked to linked.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r1/groups/group_00__insertion_result/proof_reuse.md`.

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
      "InsertObj-20261012130948",
      "--round",
      "InsertObj-vc-proving-r1",
      "--group",
      "insertion_result"
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
      "InsertObj-20261012130948",
      "--round",
      "InsertObj-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "insertion_result"
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
      "InsertObj-20261012130948",
      "--round",
      "InsertObj-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "insertion_result"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/_coq_builds/InsertObj-vc-proving-r1/group_00/src/.coq_debug/group_00_insertion_result.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r1/groups/group_00__insertion_result/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r1/groups/group_00__insertion_result/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
