# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `publish_transition`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_SemaphoreCreate-vc-proving-r1/groups/group_01__publish_transition/_SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_5`, `proof_of__SemaphoreCreate_entail_wit_5_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_5_split_goal_2`, `proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of__SemaphoreCreate_entail_wit_5` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_5_split_goal_1`: P contains the updated manager, actual post-insertion registry boundary/link cells and old shifted-reverse segment, new value=val_pre, empty self-linked pending head and padding, plus task/scheduler and IRQ frames. First expose StableContext (idmax=128, hoffset=16), CrtosOSValid current from Rely, and uint16 bounds of val_pre from the owned value cell. Prove sem is absent from map semaphore_addr old objects: recurse through the actual old shifted segment, exposing each store_semaphore_body value cell; equal base sem would duplicate the owned new value cell, contradicting separation. Use map getData nodes = old objects to transport the absence. This is a spatial argument, not a malloc-freshness assumption. From min_free_id/query=false derive ID absence and 0<=id<128. With empty pending list, prove semaphore_valid after head insertion (NoDup addresses/IDs/pending and Forall ranges); all task-world, ready, pending-SUSPEND and scheduler clauses of CrtosOSValid stay unchanged. Thus establish SemaphoreGuarantee current (publish sem id val_pre current) by validity and definitional task/scheduler preservation. Transport the entry nest bound through Rely, use validity for the lower bound, and note publish preserves the whole scheduler. Apply semaphore_nesting_roundtrip_bounded to the published state, rewriting the target guarantee to the publication guarantee just established. No resource is fabricated and no existential is required. All supporting claims must be proved inline because formal_case_lib is absent.

- Split `proof_of__SemaphoreCreate_entail_wit_5_split_goal_2`: P contains the updated manager, actual post-insertion registry boundary/link cells and old shifted-reverse segment, new value=val_pre, empty self-linked pending head and padding, plus task/scheduler and IRQ frames. First expose StableContext (idmax=128, hoffset=16), CrtosOSValid current from Rely, and uint16 bounds of val_pre from the owned value cell. Prove sem is absent from map semaphore_addr old objects: recurse through the actual old shifted segment, exposing each store_semaphore_body value cell; equal base sem would duplicate the owned new value cell, contradicting separation. Use map getData nodes = old objects to transport the absence. This is a spatial argument, not a malloc-freshness assumption. From min_free_id/query=false derive ID absence and 0<=id<128. With empty pending list, prove semaphore_valid after head insertion (NoDup addresses/IDs/pending and Forall ranges); all task-world, ready, pending-SUSPEND and scheduler clauses of CrtosOSValid stay unchanged. Thus establish SemaphoreGuarantee current (publish sem id val_pre current) by validity and definitional task/scheduler preservation. Conclude the publication guarantee directly; no IRQ token update occurs inside this entailment. Prove any induction/disjointness claims inline, using current premises only; formal_case_lib is absent.

- Split `proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial`: P contains the updated manager, actual post-insertion registry boundary/link cells and old shifted-reverse segment, new value=val_pre, empty self-linked pending head and padding, plus task/scheduler and IRQ frames. First expose StableContext (idmax=128, hoffset=16), CrtosOSValid current from Rely, and uint16 bounds of val_pre from the owned value cell. Prove sem is absent from map semaphore_addr old objects: recurse through the actual old shifted segment, exposing each store_semaphore_body value cell; equal base sem would duplicate the owned new value cell, contradicting separation. Use map getData nodes = old objects to transport the absence. This is a spatial argument, not a malloc-freshness assumption. From min_free_id/query=false derive ID absence and 0<=id<128. With empty pending list, prove semaphore_valid after head insertion (NoDup addresses/IDs/pending and Forall ranges); all task-world, ready, pending-SUSPEND and scheduler clauses of CrtosOSValid stay unchanged. Thus establish SemaphoreGuarantee current (publish sem id val_pre current) by validity and definitional task/scheduler preservation. For the spatial Q, fold the new value, padding and self-linked empty pending head into store_semaphore_body (Build_SemaphoreObject sem id val_pre []). Add Build_DL_Node new_object sem.link to nodes; use the four updated boundary/link cells and shifted-reverse segment to fold the registry. Derive that old nodes equal the registry map of old objects by extensionality/induction from map getData and the per-node getPtr equation, retaining nonzero head/nodes and deriving the tail nonzero in empty/nonempty cases. Prove inline semaphore_manager_state stable (new_object::old) = idmanager_link manager_abs (idmanager_add old_manager id) id sem.id: unfold map/filter over seq, split on k=id mod 16, and show its bucket list equals the replace_Znth result by length and indexed extensionality; 0<=id mod 16<16 supplies the index bound. Rewrite the actual manager resource by this equality. Fold store_semaphore and OSInvariant at nest_increment(publish...), using CrtosOSValid_with_nest and the bounded increment to establish its validity. Task and scheduler heap projections are unchanged; keep exactly the original InsideCritical token at current. Use heap-lift equivalences only on heap pieces. No helper declarations are permitted; any mathematical and transport claims are inline local proof assertions.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_01__publish_transition/proof_reuse.md`.

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
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-proving-r1",
      "--group",
      "publish_transition"
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
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "publish_transition"
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
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "publish_transition"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_coq_builds/_SemaphoreCreate-vc-proving-r1/group_01/src/.coq_debug/group_01_publish_transition.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_01__publish_transition/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_01__publish_transition/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
