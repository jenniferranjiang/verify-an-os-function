# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `raw_open`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r2/groups/group_00__raw_open/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_2`, `proof_of__SemaphoreCreate_entail_wit_3`, `proof_of__SemaphoreCreate_entail_wit_3_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_3_split_goal_2`, `proof_of__SemaphoreCreate_entail_wit_3_split_goal_3`, `proof_of__SemaphoreCreate_entail_wit_3_split_goal_4`, `proof_of__SemaphoreCreate_entail_wit_3_split_goal_5`, `proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): `proof_of__SemaphoreCreate_entail_wit_2_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_2_split_goal_2`.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r2/groups/group_00__raw_open/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__raw_open`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_2` — `LLM_pre_process`

Choose the full-resource disjunct. Open SemaphoreRaw only enough to expose the two NodeStorage nonzero conjuncts at pend_list and link; derive both inequalities from those spatial predicates, then refold exactly the same SemaphoreRaw. Preserve OutsideCritical sg before and all bounds/safeExec facts; commute the frame. The pure split goals lack the raw storage and are not selected.
### `proof_of__SemaphoreCreate_entail_wit_3` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_3_split_goal_1`: From os_inv sg locked isolate the semaphore store_dll; from SemaphoreZero sem isolate its value cell. Prove freshness using fresh_semaphore__raw_open: if sem occurs in map semaphore_addr of the old list, expose that old store_semaphore value cell by list induction and contradict separating ownership at the same value address. Frame InsideCritical and remaining invariants; retain original resources.

- Split `proof_of__SemaphoreCreate_entail_wit_3_split_goal_2`: Open os_inv and its semaphore invariant to obtain store_dll at k_sem_list. Extract dll_nodes_nonzero from that store_dll, using list induction if necessary, under the unchanged InsideCritical and SemaphoreZero frame. No pointer arithmetic axiom is needed.

- Split `proof_of__SemaphoreCreate_entail_wit_3_split_goal_3`: Open os_inv and semaphore_inv only to extract semaphore_context (os_semaphore_stable sg). Frame all spatial resources; no existential target.

- Split `proof_of__SemaphoreCreate_entail_wit_3_split_goal_4`: Extract os_world_wf sg locked from os_inv. The state is exactly locked throughout; do not substitute before for locked.

- Split `proof_of__SemaphoreCreate_entail_wit_3_split_goal_5`: Open SemaphoreZero and its aligned storage constituents to obtain addr_aligned sem 4. Keep os_inv and InsideCritical as frames.

- Split `proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial`: Unfold os_inv, semaphore_inv and SemaphoreZero. Instantiate their existing witnesses, expose the listed task/tick/delay/assign/scheduling/object invariants, store_idmanager, store_dll, ZeroIdNode, value 0, two NodeZero predicates and padding. Cancel/reorder these exact resources; no new state or ownership is introduced.

## Helpers

- `fresh_semaphore__raw_open` (local): Statement shape: for old semaphore list ss and task projection f, store_dll (store_semaphore f) head (map semaphore_link_node ss) ** SemaphoreZero sem entails the pure fact ~ In sem (map semaphore_addr ss). Use only these separated resources, plus any list well-formedness supplied by the enclosing os_inv if required. Induct over ss/dllseg; membership exposes an old semaphore value cell at the same address as the new zero value cell, contradicting disjoint ownership. Frame arbitrary unrelated resources. Used in entail_wit_3 split 1.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_00__raw_open/proof_reuse.md`.

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
      "SemaphoreCreate-vc-proving-r2",
      "--group",
      "raw_open"
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
      "SemaphoreCreate-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "raw_open"
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
      "SemaphoreCreate-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "raw_open"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/_coq_builds/SemaphoreCreate-vc-proving-r2/group_00/src/.coq_debug/group_00_raw_open.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_00__raw_open/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r2/groups/group_00__raw_open/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
