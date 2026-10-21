# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `manager_open`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/InsertObj-vc-proving-r1/groups/group_01__manager_open/InsertObj_proof_manual.v`.
- Editable proof spans: `proof_of_InsertObj_entail_wit_1`, `proof_of_InsertObj_entail_wit_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_InsertObj_entail_wit_1` — `LLM_pre_process`

For mixed OSHeap/root-heap assertions use crtos_heap_lift_sep and crtos_heap_lift_entails plus unfolding of OSHeap, crtos_heap_state and primitive stores to transport the same concrete heap; OSHeap_ushort_eq is public. Do not assume the Local OSHeap_* lemmas are exported. Any additional carrier equality must be an inline assertion in this witness body, since no case lib exists. Choose the left whole-goal disjunct. Unfold allocated_unlinked and store_sem_id_detached. Expose min_free_id, idbuckets_ok and the four manager fields, updated bitmap, id value and two detached link cells. Derive 0<=id<=65535 from id UShort validity (or min-free-id and idmax field range); positive hoffset from idbuckets_ok and upper bound from its UShort cell. Forget previous/next contents to undef with their actual values as witnesses, frame all other resources, and reassemble the conjunction. No existential state change.
### `proof_of_InsertObj_entail_wit_2` — `LLM_pre_process`

For mixed OSHeap/root-heap assertions use crtos_heap_lift_sep and crtos_heap_lift_entails plus unfolding of OSHeap, crtos_heap_state and primitive stores to transport the same concrete heap; OSHeap_ushort_eq is public. Do not assume the Local OSHeap_* lemmas are exported. Any additional carrier equality must be an inline assertion in this witness body, since no case lib exists. Set k=id mod hoffset sm and bucket=Znth k (idbuckets before) nil. From 0<hoffset and the length component of idbuckets_ok obtain 0<=k<Zlength buckets. Lift store_idbuckets_split, retain the except frame, and use store_idbucket_cases. For the uninitialized alternative choose the left disjunct with empty bucket and zero head fields; prove head<>0 from validity of head.node_prev at offset zero. For initialized DLL choose the right disjunct with its actual hn,hp and nonzero facts. Frame manager, bitmap, id and undef links unchanged. All other pure conjuncts are original premises or the reflexive computed-head equation.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r1/groups/group_01__manager_open/proof_reuse.md`.

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
      "manager_open"
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
      "manager_open"
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
      "manager_open"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/_coq_builds/InsertObj-vc-proving-r1/group_01/src/.coq_debug/group_01_manager_open.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r1/groups/group_01__manager_open/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r1/groups/group_01__manager_open/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
