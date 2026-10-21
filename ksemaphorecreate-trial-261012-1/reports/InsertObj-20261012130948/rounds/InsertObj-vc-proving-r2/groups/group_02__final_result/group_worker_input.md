# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `final_result`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/InsertObj-vc-proving-r2/groups/group_02__final_result/InsertObj_proof_manual.v`.
- Editable proof spans: `proof_of_InsertObj_return_wit_1`, `proof_of_InsertObj_return_wit_1_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_InsertObj_return_wit_1` — `aggressive_pre_process`

- Split `proof_of_InsertObj_return_wit_1_split_goal_spatial`: Patterns H/R. Let idx=id mod hoffset(sm), node=Build_IdNodeAbs id idnode_pre, new_bucket=node::bucket. Fold store_idnode for node from its exact UShort id cell, idnode_pre<>0 and reflexive link equality; normalize nested field addresses. Combine the four insertion-result pointer cells with shifted reverse old bucket by DLL.dllseg_shift_rev_contact_a, then DLL.dllseg_shift_rev_to_dllseg (x=new link,px=head,y=head) to obtain the circular segment and final head.prev cell. Its tail address is nonzero: prove the endpoint fact inside this proof by induction on the represented list, using head<>0 at nil and Forall link-nonzero at cons; new node nonzero is PreH4 and old nodes are PreH6. Fold store_idnodes head new_bucket. Apply lifted store_idbuckets_replace at idx with PreH5 and modulo nonnegativity, preserving all untouched buckets and bitmap. For the target store_idmanager pure invariant prove locally idbuckets_ok idmax hoffset (id::old_ids) (replace_Znth idx new_bucket old_buckets). Obtain in-range idx from old length and positive hoffset; min-free gives 0<=id<idmax and fresh id via id_in_ids_false_iff. Old global permutation makes id absent from every old bucket. Decompose old_buckets as prefix++bucket::suffix using bucket-except (Zlength prefix=idx); replacement becomes prefix++new_bucket::suffix. Preserve total length, all untouched Forall facts and recursive bucket indices; extend selected bucket range/NoDup/address-nonzero using freshness and idnode_pre<>0. Its hash index follows idx=id mod hoffset. Map/concat over the decomposition and move the newly prepended id across the prefix using Permutation_app/Permutation_middle, then compose old permutation to id::old_ids. Fold target idmanager_link(sm,idmanager_add(before,id),id,idnode_pre); manager fields and already allocated bitmap cancel exactly. This is the only abstract transition, with old buckets becoming their selected-bucket prepend. No helper declarations: all needed induction/transition facts must be assertions inside the assigned proof because formal_case_lib is absent.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/InsertObj-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r2/groups/group_02__final_result/proof_reuse.md`.

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
      "InsertObj-vc-proving-r2",
      "--group",
      "final_result"
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
      "InsertObj-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "final_result"
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
      "InsertObj-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "final_result"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/_coq_builds/InsertObj-vc-proving-r2/group_02/src/.coq_debug/group_02_final_result.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r2/groups/group_02__final_result/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r2/groups/group_02__final_result/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
