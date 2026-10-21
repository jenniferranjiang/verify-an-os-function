# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `manager_failure`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_SemaphoreCreate-vc-proving-r1/groups/group_04__manager_failure/_SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_2_1`, `proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial`, `proof_of__SemaphoreCreate_entail_wit_2_2`, `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_2`, `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_3`, `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial`, `proof_of__SemaphoreCreate_partial_solve_wit_5`, `proof_of__SemaphoreCreate_partial_solve_wit_6_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_6`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of__SemaphoreCreate_entail_wit_2_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_1`: Use SemaphoreRely to obtain CrtosOSValid current and equality of before/current scheduler nest. Transport before.nest < 65535, combine with current validity for 0 <= current.nest, and apply semaphore_nesting_roundtrip_bounded. Rewrite the target to SemaphoreGuarantee current current and unfold it; validity and unchanged task/scheduler are immediate. P includes the manager/private/registry/task/scheduler and IRQ resources, but Q is pure; no spatial creation or existential.

- Split `proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial`: P has the unchanged manager, detached ID zero node, registered private remainder, registry, borrowed task/scheduler views, and InsideCritical. Recombine detached ID plus private remainder into store_sem_zeroed_private. Recombine manager and registry into store_semaphore with semaphore_valid obtained from PreH11 (CrtosOSValid of nest_increment current), then into OSInvariant of that same state. StableContext from InsideCritical supplies manager/global equality. Use the heap lift sep equivalence in reverse; preserve the IRQ token and exact incremented scheduler view. No transition or new existential is needed.
### `proof_of__SemaphoreCreate_entail_wit_2_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1`: The negative-result guard PreH1 is retval < 0, while PreH2 = idmanager_min_free_id includes 0 <= retval. Unfold that pure definition and derive False by lia. Thus the entire antecedent is impossible and this split conclusion (including the spatial one) follows by ex falso; do not invent full-manager, retval=-1, private-object, or guarantee facts on a reachable branch. No witnesses or resource transformations are required.

- Split `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_2`: The negative-result guard PreH1 is retval < 0, while PreH2 = idmanager_min_free_id includes 0 <= retval. Unfold that pure definition and derive False by lia. Thus the entire antecedent is impossible and this split conclusion (including the spatial one) follows by ex falso; do not invent full-manager, retval=-1, private-object, or guarantee facts on a reachable branch. No witnesses or resource transformations are required.

- Split `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_3`: The negative-result guard PreH1 is retval < 0, while PreH2 = idmanager_min_free_id includes 0 <= retval. Unfold that pure definition and derive False by lia. Thus the entire antecedent is impossible and this split conclusion (including the spatial one) follows by ex falso; do not invent full-manager, retval=-1, private-object, or guarantee facts on a reachable branch. No witnesses or resource transformations are required.

- Split `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial`: The negative-result guard PreH1 is retval < 0, while PreH2 = idmanager_min_free_id includes 0 <= retval. Unfold that pure definition and derive False by lia. Thus the entire antecedent is impossible and this split conclusion (including the spatial one) follows by ex falso; do not invent full-manager, retval=-1, private-object, or guarantee facts on a reachable branch. No witnesses or resource transformations are required.
### `proof_of__SemaphoreCreate_partial_solve_wit_5` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. Reordering pattern: P owns InsideCritical, OSInvariant(nest_increment current), and the zeroed private object. Q adds only the existing id=-1, sem nonzero, IRQ, Rely, full-manager and restoration-guarantee premises and moves the same private object to the front. Introduce pure conjuncts and cancel the three spatial factors. There is no allocation, existential, or transition in this VC.
### `proof_of__SemaphoreCreate_partial_solve_wit_6_pure` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. Pure projection/reflexivity pattern: prove IRQ handler validity and the failed-branch restoration guarantee are PreH3 and PreH6. P also has C locals and SemaphoreInsideCritical at current and SemaphoreOSInvariant at nest_increment current; Q has only the stated pure conjunction. Extract explicit premises and split the conjunction; do not consume or reconstruct resources. No existential witnesses or new refinement transition.
### `proof_of__SemaphoreCreate_partial_solve_wit_6` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. This definition is pure-VC -> auxiliary-VC. Introduce that implication premise, unfold the auxiliary, and establish its pure conjuncts directly: IRQ handler validity and the failed-branch restoration guarantee are PreH3 and PreH6. P and Q contain exactly SemaphoreInsideCritical at current and SemaphoreOSInvariant at nest_increment current; cancel these resources modulo separating associativity/commutativity. Retain all other named pure premises. No change of abstract state or existential instantiation is required.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_04__manager_failure/proof_reuse.md`.

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
      "manager_failure"
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
      "manager_failure"
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
      "manager_failure"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_coq_builds/_SemaphoreCreate-vc-proving-r1/group_04/src/.coq_debug/group_04_manager_failure.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_04__manager_failure/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_04__manager_failure/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
