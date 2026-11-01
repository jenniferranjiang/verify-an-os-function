# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `id_focus`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r2/groups/group_03__id_focus/LinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_which_implies_wit_6`, `proof_of_LinklistResumeAll_which_implies_wit_7`, `proof_of_LinklistResumeAll_which_implies_wit_7_split_goal_spatial`, `proof_of_LinklistResumeAll_partial_solve_wit_10_pure`, `proof_of_LinklistResumeAll_partial_solve_wit_10`, `proof_of_LinklistResumeAll_partial_solve_wit_11`, `proof_of_LinklistResumeAll_partial_solve_wit_12`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r2/groups/group_03__id_focus/LinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/LinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__id_focus`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of_LinklistResumeAll_which_implies_wit_6` — `LLM_pre_process`

Pattern I: choose either identical whole disjunct. PreH3 and replace_task_desc_map preserve os_semaphores, so PreH2 gives pending_nodes at marked directly. No current.task_desc_map target=Some desc premise is needed. Derive registration/target membership from os_inv marked and the selected semaphore pending list. task_world_wf gives membership in task_ptr_list and the task_wf_id_nodes permutation. Use the actual ID-manager bucket/node to select the IdNodeAbs at &(target->id). Its bounds, bitmap query and bucket membership establish get_task_with_idnode_success; UShort ownership gives 0<=task_id<65536. Instantiate task_id from that node and borrow exactly id.id. Preserve ID links, buckets and all remaining heap in resume_id_restore by wand introduction/reassembly of the same marked os_inv. Retain PreH1..3. Both resource states are marked, never current.
### `proof_of_LinklistResumeAll_which_implies_wit_7` — `aggressive_pre_process`

- Split `proof_of_LinklistResumeAll_which_implies_wit_7_split_goal_spatial`: Pattern W: unfold resume_*_restore, commute the field/wand if necessary and apply separating implication elimination. The field is owned once; the complementary wand yields exactly the indicated os_inv. No existential or state transition is needed. Use resume_id_restore at marked,target,task_id.
### `proof_of_LinklistResumeAll_partial_solve_wit_10_pure` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. PreH6,11,2 give remaining equality, current pending nodes and marked update. Heap has os_inv marked.
### `proof_of_LinklistResumeAll_partial_solve_wit_10` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Aux repeats PreH1..22 and retains os_inv marked.
### `proof_of_LinklistResumeAll_partial_solve_wit_11` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Rewrite retval=target using PreH10; preserve the UShort task_id cell and marked-state restore wand. Bounds/lookup/pending facts are PreH4..7.
### `proof_of_LinklistResumeAll_partial_solve_wit_12` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Rewrite retval=target using PreH10 in the source field. Preserve task_id and the restore wand; conjunction repeats PreH1..29.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r2/groups/group_03__id_focus/proof_reuse.md`.

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
      "id_focus"
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
      "id_focus"
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
      "id_focus"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/_coq_builds/LinklistResumeAll-vc-proving-r2/group_03/src/.coq_debug/group_03_id_focus.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r2/groups/group_03__id_focus/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r2/groups/group_03__id_focus/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
