# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `pending_head`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r1/groups/group_02__pending_head/LinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_which_implies_wit_1`, `proof_of_LinklistResumeAll_which_implies_wit_2`, `proof_of_LinklistResumeAll_which_implies_wit_2_split_goal_spatial`, `proof_of_LinklistResumeAll_which_implies_wit_3`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r1/groups/group_02__pending_head/LinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/LinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__pending_head`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of_LinklistResumeAll_which_implies_wit_1` — `LLM_pre_process`

Pattern H: extract the selected semaphore object from semaphore_pending_nodes and its owned DLL from os_inv. Rewrite its pending-node list to map sched_link_node remaining. Case remaining=nil or first::tail. Nil chooses the left disjunct with next=list_pre; cons chooses right with next=sched_link_of first and the actual first/tail. PreH1 rewrites the sentinel address. Borrow its node_next cell by opening the head of store_dll. Obtain first link<>head from valid separated DLL ownership, not nonempty syntax alone. Package all residual heap into resume_next_restore using wand introduction; returning the same next cell reconstructs the same os_inv current. Keep PreH1..3 and the case equality.
### `proof_of_LinklistResumeAll_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of_LinklistResumeAll_which_implies_wit_2_split_goal_spatial`: Pattern W: unfold resume_*_restore, commute the field/wand if necessary and apply separating implication elimination. The field is owned once; the complementary wand yields exactly the indicated os_inv. No existential or state transition is needed. Use resume_next_restore at current,list_pre,next.
### `proof_of_LinklistResumeAll_which_implies_wit_3` — `LLM_pre_process`

Choose left whole disjunct, since pure-only pending_nodes does not supply descriptor existence/SUSPEND/alignment. Rewrite remaining=target::rest and map_cons. Extract the first pure_suspend_sched_link payload from the matching semaphore DLL inside os_inv, obtaining registered desc and SUSPEND. task_world_wf gives alignment and concrete task ownership/layout gives target<>0. Instantiate desc with that lookup descriptor. Rebuild the same os_inv, retaining every resource; pending-node pure equality follows by rewriting. No state transition occurs.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r1/groups/group_02__pending_head/proof_reuse.md`.

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
      "LinklistResumeAll-vc-proving-r1",
      "--group",
      "pending_head"
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
      "LinklistResumeAll-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "pending_head"
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
      "LinklistResumeAll-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "pending_head"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/_coq_builds/LinklistResumeAll-vc-proving-r1/group_02/src/.coq_debug/group_02_pending_head.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r1/groups/group_02__pending_head/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r1/groups/group_02__pending_head/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
