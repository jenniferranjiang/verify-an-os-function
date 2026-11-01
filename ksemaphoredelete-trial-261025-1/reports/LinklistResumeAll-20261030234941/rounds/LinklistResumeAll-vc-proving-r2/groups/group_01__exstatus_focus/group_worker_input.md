# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `exstatus_focus`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r2/groups/group_01__exstatus_focus/LinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_which_implies_wit_4`, `proof_of_LinklistResumeAll_which_implies_wit_4_split_goal_spatial`, `proof_of_LinklistResumeAll_which_implies_wit_5`, `proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial`, `proof_of_LinklistResumeAll_partial_solve_wit_7_pure`, `proof_of_LinklistResumeAll_partial_solve_wit_7`, `proof_of_LinklistResumeAll_partial_solve_wit_8`, `proof_of_LinklistResumeAll_partial_solve_wit_9`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r2/groups/group_01__exstatus_focus/LinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/LinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__exstatus_focus`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of_LinklistResumeAll_which_implies_wit_4` — `aggressive_pre_process`

- Split `proof_of_LinklistResumeAll_which_implies_wit_4_split_goal_spatial`: Apply exstatus_focus__exstatus_focus using PreH1 current.task_desc_map target=Some desc. Borrow the old Int exstatus cell and retain a wand accepting -1 and rebuilding os_inv at the explicit updated map state. No extra descriptor premise is permitted.
### `proof_of_LinklistResumeAll_which_implies_wit_5` — `aggressive_pre_process`

- Split `proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial`: Pattern W: unfold resume_*_restore, commute the field/wand if necessary and apply separating implication elimination. The field is owned once; the complementary wand yields exactly the indicated os_inv. No existential or state transition is needed. Use resume_exstatus_restore at marked,target,-1; range facts are already given.
### `proof_of_LinklistResumeAll_partial_solve_wit_7_pure` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Required map lookup is PreH7; os_inv current and local cells are context.
### `proof_of_LinklistResumeAll_partial_solve_wit_7` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Aux conjunction repeats PreH1..20, with os_inv current unchanged.
### `proof_of_LinklistResumeAll_partial_solve_wit_8` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Rewrite retval=target from PreH3; instantiate the undefined RHS exstatus field with desc.tdExstatus. Keep resume_exstatus_restore unchanged.
### `proof_of_LinklistResumeAll_partial_solve_wit_9` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Rewrite retval=target from PreH3; cancel the same -1 exstatus field and marked-state wand.

## Helpers

- `exstatus_focus__exstatus_focus` (public): Prove forall sg st target desc, st.(os_tasks).(task_desc_map) target=Some desc -> os_inv sg st |-- (target->exstatus |-> desc.(tdExstatus)) ** resume_exstatus_restore sg (replace_task_desc_map (update_task_desc_map target (set_task_desc_exstatus desc (-1)) st.(os_tasks).(task_desc_map)) st) target (-1), using the exact typed Int field notation. Extract target from store_map, unfold store_published_task/store_task_descriptor and isolate exstatus. Introduce the wand, consume its -1 cell, and reassemble the updated descriptor/map. Reindex task_world_wf, os_world_wf, delay invariants, ready/wait/zombie payloads and other map-indexed predicates using the fact only tdExstatus changed. Split target/other lookup cases; stack, ID, all non-exstatus fields and global resources are framed. The lookup premise is exactly which_implies_wit_4 PreH1.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r2/groups/group_01__exstatus_focus/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-debug",
      "--run",
      "LinklistResumeAll-20261030234941",
      "--round",
      "LinklistResumeAll-vc-proving-r2",
      "--group",
      "exstatus_focus"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "LinklistResumeAll-20261030234941",
      "--round",
      "LinklistResumeAll-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "exstatus_focus"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "LinklistResumeAll-20261030234941",
      "--round",
      "LinklistResumeAll-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "exstatus_focus"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/_coq_builds/LinklistResumeAll-vc-proving-r2/group_01/src/.coq_debug/group_01_exstatus_focus.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r2/groups/group_01__exstatus_focus/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r2/groups/group_01__exstatus_focus/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
