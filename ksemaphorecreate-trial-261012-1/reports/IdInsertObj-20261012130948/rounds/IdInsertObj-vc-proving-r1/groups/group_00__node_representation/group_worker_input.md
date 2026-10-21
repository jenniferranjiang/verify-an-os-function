# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `node_representation`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/IdInsertObj-20261012130948/IdInsertObj-vc-proving-r1/groups/group_00__node_representation/IdInsertObj_proof_manual.v`.
- Editable proof spans: `proof_of_IdInsertObj_entail_wit_3`, `proof_of_IdInsertObj_entail_wit_3_split_goal_1`, `proof_of_IdInsertObj_entail_wit_3_split_goal_2`, `proof_of_IdInsertObj_entail_wit_3_split_goal_spatial`, `proof_of_IdInsertObj_entail_wit_4`, `proof_of_IdInsertObj_entail_wit_4_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_IdInsertObj_entail_wit_3` — `aggressive_pre_process`

- Split `proof_of_IdInsertObj_entail_wit_3_split_goal_1`: P has OSHeap allocated-unlinked manager and detached node; Q is only retval <= 65535. Unfold idmanager_min_free_id to obtain 0 <= retval < idmax sm. In the manager heap unfold store_idmanager_allocated_unlinked and OSHeap/crtos_heap_lift far enough to expose the id_max UShort cell; its value range gives idmax sm <= 65535, so lia closes the pure conclusion. Use crtos_heap_lift_sep to expose cells if useful and the existing public OSHeap_ushort_eq; other manager and node resources only frame the pure projection. No existential output, abstract transition, or new helper.

- Split `proof_of_IdInsertObj_entail_wit_3_split_goal_2`: P has allocated-unlinked manager plus OSHeap(store_sem_id_detached idnode_pre old_id previous next); Q asks embedded link address nonzero. Unfold store_sem_id_detached and OSHeap/crtos_heap_lift to extract exactly the stored conjunction idnode_pre <> 0 /\ link_address <> 0. Project its second conjunct through the separating frame; do not infer link address nonzero from pointer arithmetic or field validity. No existential output or state transition; preserve the original source parameters.

- Split `proof_of_IdInsertObj_entail_wit_3_split_goal_spatial`: P has the allocated-unlinked manager and lifted detached node; Q has the identical manager and the id UShort, previous Ptr and next Ptr cells at the identical field expressions. Frame/cancel the manager. Unfold detached and drop only its pure metadata, transport its separating conjunction with crtos_heap_lift_sep, and show scalar heap-cell transport inline by unfolding OSHeap/crtos_heap_lift and scalar byte stores (public OSHeap_ushort_eq handles UShort). Pointer byte witnesses and memory joins are reused unchanged; tokens remain empty and STS sets full. This is representation exposure only, before the write; no list update, abstract transition, or new helper.
### `proof_of_IdInsertObj_entail_wit_4` — `aggressive_pre_process`

- Split `proof_of_IdInsertObj_entail_wit_4_split_goal_spatial`: P has allocated-unlinked manager and three explicit node cells with new id; Q folds those same cells into OSHeap(store_sem_id_detached idnode_pre id previous next). Frame/cancel manager. Rebuild the detached metadata from PreH2 idnode_pre <> 0 and PreH3 link address <> 0, then fold the exact UShort id and Ptr previous/next cells through crtos_heap_lift_sep and inline scalar heap-cell transport; public OSHeap_ushort_eq handles UShort. Reuse byte witnesses and joins unchanged. The prior C store changes only old_id to id; no bucket/list mutation occurs in this VC. No new helper.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/IdInsertObj-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/IdInsertObj-20261012130948/rounds/IdInsertObj-vc-proving-r1/groups/group_00__node_representation/proof_reuse.md`.

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
      "IdInsertObj-20261012130948",
      "--round",
      "IdInsertObj-vc-proving-r1",
      "--group",
      "node_representation"
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
      "IdInsertObj-20261012130948",
      "--round",
      "IdInsertObj-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "node_representation"
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
      "IdInsertObj-20261012130948",
      "--round",
      "IdInsertObj-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "node_representation"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/IdInsertObj-20261012130948/_coq_builds/IdInsertObj-vc-proving-r1/group_00/src/.coq_debug/group_00_node_representation.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/IdInsertObj-20261012130948/rounds/IdInsertObj-vc-proving-r1/groups/group_00__node_representation/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/IdInsertObj-20261012130948/rounds/IdInsertObj-vc-proving-r1/groups/group_00__node_representation/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
