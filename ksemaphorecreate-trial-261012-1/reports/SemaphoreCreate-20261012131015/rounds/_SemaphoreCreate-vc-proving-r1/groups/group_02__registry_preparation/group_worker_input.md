# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `registry_preparation`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_SemaphoreCreate-vc-proving-r1/groups/group_02__registry_preparation/_SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_3`, `proof_of__SemaphoreCreate_entail_wit_4`, `proof_of__SemaphoreCreate_partial_solve_wit_7_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_7`, `proof_of__SemaphoreCreate_partial_solve_wit_8_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_8`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of__SemaphoreCreate_entail_wit_3` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. Choose the first whole-goal disjunct. P owns the updated ID manager and the registered private remainder, with registry, task/scheduler and IRQ frames. Unfold only store_sem_registered_private and its detached link predicates under OSHeap: obtain semaphore_object_addresses sem, value=0, both zero pending slots, both zero link slots and padding. Project nonzero pending/link metadata; preserve all existing pure premises and frames. Use crtos_heap_lift_sep and the established ushort bridge; derive the analogous pointer/undef transport inline from the heap lift and byte definitions if needed. Normalize chained field addressing using addr_of_arrow_field/csimpl and weaken each known-zero pointer cell to undef. The first disjunct needs no existential; if using the equivalent second branch its four slot witnesses are all zero. No OS transition occurs.
### `proof_of__SemaphoreCreate_entail_wit_4` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. Choose the second whole-goal disjunct, which exposes only the necessary registry footprint. Let nodes be map (fun obj => Build_DL_Node obj (&(semaphore_addr obj # "Semaphore" ->s "link"))) (os_semaphores current), exactly as in store_sem_registry. Unfold registry and store_dll under OSHeap, obtain its actual head-next successor and tail predecessor, retain head/tail/node nonzero metadata, and use dllseg_to_dllseg_shift_rev to expose head.next, successor.prev, and shifted-reverse segment. StableContext from InsideCritical rewrites the registry address to k_sem_list. Prove map getData nodes = old objects by map_map/induction, and the per-node getPtr equation by in_map_iff; carry dll_nodes_nonzero from store_dll. The existential successor is the observed head-next, including the empty-list case successor=head; it is not invented. Lift pointer cells to the OS carrier, normalize address notation and cancel all manager/task/scheduler/IRQ/padding frames. No publication or state change is asserted here.
### `proof_of__SemaphoreCreate_partial_solve_wit_7_pure` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. Pure projection/reflexivity pattern: prove pend_list address reflexivity and its nonzero premise PreH3. P also has C locals and manager, registry, task/scheduler and IRQ frames, value=val_pre, undefined pend/link slots, and padding; Q has only the stated pure conjunction. Extract explicit premises and split the conjunction; do not consume or reconstruct resources. No existential witnesses or new refinement transition.
### `proof_of__SemaphoreCreate_partial_solve_wit_7` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. This definition is pure-VC -> auxiliary-VC. Introduce that implication premise, unfold the auxiliary, and establish its pure conjuncts directly: pend_list address reflexivity and its nonzero premise PreH3. P and Q contain exactly manager, registry, task/scheduler and IRQ frames, value=val_pre, undefined pend/link slots, and padding; cancel these resources modulo separating associativity/commutativity. Retain all other named pure premises. Move the two undefined pending slots to the call footprint; preserve value and all link slots.
### `proof_of__SemaphoreCreate_partial_solve_wit_8_pure` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. Pure projection/reflexivity pattern: prove k_sem_list, sem.link, successor are nonzero by PreH4, PreH9, PreH5. P also has C locals and manager, task/scheduler and IRQ frames, registry boundary slots plus shifted-reverse segment, initialized pending head, value, undefined link slots and padding; Q has only the stated pure conjunction. Extract explicit premises and split the conjunction; do not consume or reconstruct resources. No existential witnesses or new refinement transition.
### `proof_of__SemaphoreCreate_partial_solve_wit_8` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. This definition is pure-VC -> auxiliary-VC. Introduce that implication premise, unfold the auxiliary, and establish its pure conjuncts directly: k_sem_list, sem.link, successor are nonzero by PreH4, PreH9, PreH5. P and Q contain exactly manager, task/scheduler and IRQ frames, registry boundary slots plus shifted-reverse segment, initialized pending head, value, undefined link slots and padding; cancel these resources modulo separating associativity/commutativity. Retain all other named pure premises. Move the two registry boundary cells and two undefined new link slots to the call footprint; leave the shifted segment and pending/value/padding frame intact.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_02__registry_preparation/proof_reuse.md`.

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
      "registry_preparation"
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
      "registry_preparation"
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
      "registry_preparation"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_coq_builds/_SemaphoreCreate-vc-proving-r1/group_02/src/.coq_debug/group_02_registry_preparation.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_02__registry_preparation/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_02__registry_preparation/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
