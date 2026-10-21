# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `critical_decomposition`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_SemaphoreCreate-vc-proving-r1/groups/group_03__critical_decomposition/_SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_1`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_2`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_3`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial`, `proof_of__SemaphoreCreate_partial_solve_wit_4_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of__SemaphoreCreate_entail_wit_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_1_split_goal_1`: P owns InsideCritical, OSInvariant(nest_increment current), and zeroed private sem. Unfold SemaphoreOSInvariant or use SemaphoreOSInvariant_valid to expose CrtosOSValid(nest_increment current), then project it as Q. No witnesses or transition; the heap/protocol domain is retained while proving a pure fact.

- Split `proof_of__SemaphoreCreate_entail_wit_1_split_goal_2`: From the zeroed-private OSHeap resource expose semaphore_object_addresses retval and project its sem.id nonzero conjunct. Lift its pure-and through OSHeap by its definition. The premise retval <> 0 alone does not imply nonzero field addresses. IRQ and OSInvariant are frames; no existential or transition.

- Split `proof_of__SemaphoreCreate_entail_wit_1_split_goal_3`: Q is the address of the named global k_sem_id_manager being nonzero. Apply the existing framework CNotation.addr_of_LE_var_not_zero to the LE_var notation (qualified according to the imported CNotation namespace). Do not derive a base-address fact from manager field ownership. P needs no transformation; no existential or transition.

- Split `proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial`: Unfold OSInvariant, store_semaphore, store_sem_manager and store_sem_zeroed_private. InsideCritical supplies SemaphoreStableContext: rewrite semaphore_manager_addr to the named global. Lift heap separating conjunction through crtos_heap_lift_sep; preserve the same token in InsideCritical. Project tasks/semaphores of nest_increment current to current, retaining the incremented scheduler view. Split zeroed private into the existing zero detached ID node and store_sem_registered_private; its metadata feeds both folded pieces. Reassociate and cancel all six heap pieces and the IRQ frame. No new addresses or state witnesses are introduced; metadata and validity already reside in P.
### `proof_of__SemaphoreCreate_partial_solve_wit_4_pure` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. Pure projection/reflexivity pattern: prove manager-global and sem.id addresses are nonzero by PreH3 and PreH4. P also has C locals and the manager and detached zero ID node, registered private remainder, registry, task/scheduler views and SemaphoreInsideCritical at current; Q has only the stated pure conjunction. Extract explicit premises and split the conjunction; do not consume or reconstruct resources. No existential witnesses or new refinement transition.
### `proof_of__SemaphoreCreate_partial_solve_wit_4` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. This definition is pure-VC -> auxiliary-VC. Introduce that implication premise, unfold the auxiliary, and establish its pure conjuncts directly: manager-global and sem.id addresses are nonzero by PreH3 and PreH4. P and Q contain exactly the manager and detached zero ID node, registered private remainder, registry, task/scheduler views and SemaphoreInsideCritical at current; cancel these resources modulo separating associativity/commutativity. Retain all other named pure premises. Move detached ID/manager resources to the call footprint.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_03__critical_decomposition/proof_reuse.md`.

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
      "critical_decomposition"
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
      "critical_decomposition"
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
      "critical_decomposition"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_coq_builds/_SemaphoreCreate-vc-proving-r1/group_03/src/.coq_debug/group_03_critical_decomposition.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_03__critical_decomposition/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_03__critical_decomposition/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
