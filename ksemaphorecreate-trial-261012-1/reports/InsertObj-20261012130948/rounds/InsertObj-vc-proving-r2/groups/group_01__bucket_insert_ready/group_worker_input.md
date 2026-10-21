# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `bucket_insert_ready`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/InsertObj-vc-proving-r2/groups/group_01__bucket_insert_ready/InsertObj_proof_manual.v`.
- Editable proof spans: `proof_of_InsertObj_entail_wit_3_1`, `proof_of_InsertObj_entail_wit_3_1_split_goal_1`, `proof_of_InsertObj_entail_wit_3_1_split_goal_spatial`, `proof_of_InsertObj_entail_wit_3_2`, `proof_of_InsertObj_entail_wit_3_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_InsertObj_entail_wit_3_1` — `aggressive_pre_process`

- Split `proof_of_InsertObj_entail_wit_3_1_split_goal_1`: Pattern E. P has only OSHeap bitmap and bucket-except resources; Q is idnodes_nonzero bucket_2. Substitute PreH13 bucket_2=nil, unfold idnodes_nonzero/idnodes_to_dll/dll_nodes_nonzero, prove Forall nil. Pure consequence needs no existential or resource transformation.

- Split `proof_of_InsertObj_entail_wit_3_1_split_goal_spatial`: Pattern E/H. Rewrite target Znth bucket with PreH3 and then PreH13=nil. Frame/cancel OSHeap bitmap and bucket-except. The new OSHeap dllseg_shift_rev store_idnode head head [] is emp with reflexive head=head; insert that empty spatial unit via the heap lift. No witness, bound or transition beyond the unchanged empty bucket.
### `proof_of_InsertObj_entail_wit_3_2` — `aggressive_pre_process`

- Split `proof_of_InsertObj_entail_wit_3_2_split_goal_spatial`: Pattern B/H. Rewrite target selected bucket using PreH4. Frame OSHeap bitmap and bucket-except. Convert native head.prev|->hp into the Task heap representation within the combined OSHeap; apply DLL.dllseg_to_dllseg_shift_rev with x=hn,px=head,y=head,py=hp,l=idnodes_to_dll bucket_2 after unfolding idnodes_dllseg. This consumes the old head.prev cell and ordinary dllseg, producing hn.prev|->head and shifted reverse segment. Transport the pointer cell back to the current OS carrier. Works also for an initialized empty bucket. Nonzero and abstract bucket metadata remain assumptions; no new witness/helper.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/InsertObj-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r2/groups/group_01__bucket_insert_ready/proof_reuse.md`.

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
      "InsertObj-vc-proving-r2",
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
      "InsertObj-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "bucket_insert_ready"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/_coq_builds/InsertObj-vc-proving-r2/group_01/src/.coq_debug/group_01_bucket_insert_ready.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r2/groups/group_01__bucket_insert_ready/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r2/groups/group_01__bucket_insert_ready/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
