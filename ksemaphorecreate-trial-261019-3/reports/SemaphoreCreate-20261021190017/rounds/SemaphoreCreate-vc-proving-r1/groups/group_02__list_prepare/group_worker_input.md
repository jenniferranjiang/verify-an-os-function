# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `list_prepare`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_02__list_prepare/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_4`, `proof_of__SemaphoreCreate_entail_wit_4_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial`, `proof_of__SemaphoreCreate_partial_solve_wit_7`, `proof_of__SemaphoreCreate_partial_solve_wit_8`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_02__list_prepare/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__list_prepare`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_4` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_4_split_goal_1`: Unfold explicit semaphore_context to obtain idmax=128, rewrite the allocator postcondition retval<idmax, and conclude retval<128. Spatial resources can be framed while proving this pure inequality.

- Split `proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial`: Frame manager and non-semaphore OS resources. Split store_dll at its first edge into dllseg_shift_rev and the head.next/first.prev cut, with next=semaphore_first_link. Handle empty list by next=head (distinct fields, not distinct nodes), and nonempty list by its first node. Combine cut with NodeZero of sem.link into DllInsertAfterCut head next sem.link 0 0; weaken NodeZero sem.pend_list to NodeStorage. Derive required nonzero node addresses from typed field ownership/layout, and head/next nonzero from DLL ownership. Preserve padding; frame resources removed by the generated split stay outside the target.
### `proof_of__SemaphoreCreate_partial_solve_wit_7` — `LLM_pre_process`

Introduce quantified values and hypotheses, unfold the named whole VC (and auxiliary definition if present), introduce its pure-witness implication without importing any admitted theorem. Establish the consequent pure conjuncts from the explicit PreH hypotheses; use sep_apply/entailer and cancellation to reorder the identical spatial resources. No existential or abstract state change is needed. Move NodeStorage sem.pend_list to the call-front position, preserving the linked manager, DLL cut/tail, value, padding, and OS frame.
### `proof_of__SemaphoreCreate_partial_solve_wit_8` — `LLM_pre_process`

Introduce quantified values and hypotheses, unfold the named whole VC (and auxiliary definition if present), introduce its pure-witness implication without importing any admitted theorem. Establish the consequent pure conjuncts from the explicit PreH hypotheses; use sep_apply/entailer and cancellation to reorder the identical spatial resources. No existential or abstract state change is needed. Move DllInsertAfterCut to the call-front position; retain store_node_self_linked sem.pend_list and every remaining resource.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_02__list_prepare/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-debug",
      "--run",
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--group",
      "list_prepare"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "list_prepare"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "list_prepare"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/_coq_builds/SemaphoreCreate-vc-proving-r1/group_02/src/.coq_debug/group_02_list_prepare.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_02__list_prepare/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_02__list_prepare/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
