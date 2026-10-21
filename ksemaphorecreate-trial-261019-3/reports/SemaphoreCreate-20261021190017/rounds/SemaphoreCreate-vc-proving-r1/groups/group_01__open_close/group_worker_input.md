# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `open_close`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_01__open_close/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_2`, `proof_of__SemaphoreCreate_entail_wit_2_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_2_split_goal_2`, `proof_of__SemaphoreCreate_entail_wit_2_split_goal_3`, `proof_of__SemaphoreCreate_entail_wit_2_split_goal_4`, `proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial`, `proof_of__SemaphoreCreate_entail_wit_3`, `proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_01__open_close/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__open_close`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_2_split_goal_1`: Use semaphore_zero_fresh__open_close on os_inv sg locked ** SemaphoreZero retval, framing InsideCritical. Assuming an existing semaphore has address retval would give overlapping value-field ownership; extract that payload from the management DLL and contradict separation. Return the pure freshness fact, not a fresh-address axiom.

- Split `proof_of__SemaphoreCreate_entail_wit_2_split_goal_2`: Unfold os_inv then semaphore_inv; extract semaphore_context from the latter pure conjunction under the whole heap, keeping all frame resources available.

- Split `proof_of__SemaphoreCreate_entail_wit_2_split_goal_3`: Unfold os_inv and extract its os_world_wf pure conjunct; no relation between before and locked beyond explicit assumptions is required.

- Split `proof_of__SemaphoreCreate_entail_wit_2_split_goal_4`: Unfold SemaphoreZero and extract addr_aligned retval 4 from its existing pure conjunct.

- Split `proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial`: Unfold os_inv, semaphore_inv, SemaphoreZero. Use semaphore_context to rewrite semaphore manager/list global addresses to k_sem_id_manager and k_sem_list. Cancel InsideCritical and every component; payload decomposition is exactly ZeroIdNode, value zero, two NodeZero assertions and padding. No existential new address is introduced.
### `proof_of__SemaphoreCreate_entail_wit_3` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial`: Reverse the invariant decomposition: fold SemaphoreZero sem from ZeroIdNode, value zero, two NodeZero predicates, padding, and explicit nonzero/alignment. Fold semaphore_inv from unchanged manager and full DLL using explicit semaphore_context. Fold os_inv with explicit os_world_wf, and frame InsideCritical. retval=-1/full are failure-branch facts; the shared state remains locked.

## Helpers

- `semaphore_zero_fresh__open_close` (local): Prove forall sg st p, os_inv sg st ** SemaphoreZero p |-- pure (~ In p (map semaphore_addr (os_semaphores st))). Unfold os_inv/semaphore_inv and extract a management DLL member under an assumed map membership, by induction on the semaphore list or a DLL member-extraction lemma. store_semaphore for that member owns its value UShort field; SemaphoreZero p owns the identical field. Separation excludes duplicate ownership, giving contradiction. The argument must handle empty and nonempty circular DLL cases and arbitrary surrounding frame; no external allocation-freshness premise is available or necessary.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_01__open_close/proof_reuse.md`.

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
      "open_close"
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
      "open_close"
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
      "open_close"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/_coq_builds/SemaphoreCreate-vc-proving-r1/group_01/src/.coq_debug/group_01_open_close.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_01__open_close/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_01__open_close/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
