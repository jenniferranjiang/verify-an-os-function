# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `bucket_insert_ready`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/InsertObj-vc-proving-r1/groups/group_02__bucket_insert_ready/InsertObj_proof_manual.v`.
- Editable proof spans: `proof_of_InsertObj_entail_wit_3_1`, `proof_of_InsertObj_entail_wit_3_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): `proof_of_InsertObj_entail_wit_3_1_split_goal_1`, `proof_of_InsertObj_entail_wit_3_1_split_goal_2`, `proof_of_InsertObj_entail_wit_3_1_split_goal_spatial`, `proof_of_InsertObj_entail_wit_3_2_split_goal_1`, `proof_of_InsertObj_entail_wit_3_2_split_goal_spatial`.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_InsertObj_entail_wit_3_1` — `LLM_pre_process`

For mixed OSHeap/root-heap assertions use crtos_heap_lift_sep and crtos_heap_lift_entails plus unfolding of OSHeap, crtos_heap_state and primitive stores to transport the same concrete heap; OSHeap_ushort_eq is public. Do not assume the Local OSHeap_* lemmas are exported. Any additional carrier equality must be an inline assertion in this witness body, since no case lib exists. Choose the first whole-goal disjunct, keeping idnode fields. Instantiate bucket=bucket_2=nil and successor=head. Obtain link=idnode_pre+4<>0 from the retained idnode UShort valid-address lower bound, which was lost by splitting. Use head<>0 and trivial idnodes_nonzero nil. The empty DLL.dllseg_shift_rev head head [] is pure equality plus emp; add it and cancel/reorder every existing resource, including the initialized self-loop head fields. Bucket observation comes from PreH3.
### `proof_of_InsertObj_entail_wit_3_2` — `LLM_pre_process`

For mixed OSHeap/root-heap assertions use crtos_heap_lift_sep and crtos_heap_lift_entails plus unfolding of OSHeap, crtos_heap_state and primitive stores to transport the same concrete heap; OSHeap_ushort_eq is public. Do not assume the Local OSHeap_* lemmas are exported. Any additional carrier equality must be an inline assertion in this witness body, since no case lib exists. Choose the first whole-goal disjunct and witnesses bucket=bucket_2, successor=hn. Retain idnode fields to derive idnode_pre+4<>0 from UShort address validity. Lift DLL.dllseg_to_dllseg_shift_rev using existing idnodes_dllseg hn head head hp bucket_2 and head.prev=hp; it yields hn.prev=head plus reverse-shifted segment. Cancel head.next=hn and unchanged manager, bitmap, id and except resources. All nonzero and bucket observation facts are explicit premises.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r1/groups/group_02__bucket_insert_ready/proof_reuse.md`.

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
      "bucket_insert_ready"
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
      "bucket_insert_ready"
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
      "bucket_insert_ready"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/_coq_builds/InsertObj-vc-proving-r1/group_02/src/.coq_debug/group_02_bucket_insert_ready.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r1/groups/group_02__bucket_insert_ready/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r1/groups/group_02__bucket_insert_ready/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
