# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `list_prepare`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_04__list_prepare/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_5`, `proof_of__SemaphoreCreate_entail_wit_6`, `proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial`, `proof_of__SemaphoreCreate_partial_solve_wit_7`, `proof_of__SemaphoreCreate_partial_solve_wit_8_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1`, `proof_of__SemaphoreCreate_partial_solve_wit_8`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_04__list_prepare/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__list_prepare`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_5` — `LLM_pre_process`

Choose the whole left disjunct. Derive retval<128 from min-free and semaphore_context/idmax=128; retval>=0 is explicit. Unfold NodeZero at pend_list, normalize nested field addresses with addr_of_arrow_field/eval_addr, weaken both zero pointer values to unknown stores, and retain NodeZero(link), padding, value=val_pre, manager and all frames. Alternatively right branch uses existential next/prev=0. No extra field offset premise is invented.
### `proof_of__SemaphoreCreate_entail_wit_6` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial`: P contains store_node_self_linked pend_list, value=val_pre, padding, NodeZero(link), manager and full DLL. Q combines empty pending queue/value/padding into store_semaphore at link for semaphore_created sem id val_pre, and weakens management-link zero pointers into occupy_dll_node. Instantiate payload owner sem and created fields; fold empty DLL using explicit pend-list nonzero. ID is owned by manager, so do not duplicate it into payload. Cancel all other resources, retaining explicit link nonzero.
### `proof_of__SemaphoreCreate_partial_solve_wit_7` — `LLM_pre_process`

Introduce all pure premises; preserve each spatial resource with cancellation/reassociation. Re-establish the displayed pure conjunction from the same antecedent premises; there is no state change or fresh existential. Select exactly the two unknown nested pend_list pointer stores for InitDoubleLinkList, retaining value/padding/management NodeZero and manager/full DLL. Normalize nested addresses only as needed.
### `proof_of__SemaphoreCreate_partial_solve_wit_8_pure` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1`: P includes full semaphore DLL and the new payload plus occupy_dll_node. Q is dll_insert_anchor head old_nodes head; establish the head alternative in the anchor definition, with global head nonzero from the known global-address fact if required. No membership in old_nodes is needed for the sentinel head.
### `proof_of__SemaphoreCreate_partial_solve_wit_8` — `LLM_pre_process`

Introduce all pure premises; preserve each spatial resource with cancellation/reassociation. Re-establish the displayed pure conjunction from the same antecedent premises; there is no state change or fresh existential. Prove anchor at the global head directly and use explicit link<>0; move full DLL, payload and occupy_dll_node to the front for insertion. Avoid invoking the pure VC in a way that would require reconstructing eliminated C-local stores.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_04__list_prepare/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-debug",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--group",
      "list_prepare"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "list_prepare"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "list_prepare"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/_coq_builds/SemaphoreCreate-vc-proving-r1/group_04/src/.coq_debug/group_04_list_prepare.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_04__list_prepare/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_04__list_prepare/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
