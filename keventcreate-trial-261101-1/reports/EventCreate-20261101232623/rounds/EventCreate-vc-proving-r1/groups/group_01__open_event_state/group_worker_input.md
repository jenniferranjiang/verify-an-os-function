# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `open_event_state`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/EventCreate-vc-proving-r1/groups/group_01__open_event_state/EventCreate_proof_manual.v`.
- Editable proof spans: `proof_of__EventCreate_which_implies_wit_2`, `proof_of__EventCreate_which_implies_wit_2_split_goal_1`, `proof_of__EventCreate_which_implies_wit_2_split_goal_2`, `proof_of__EventCreate_which_implies_wit_2_split_goal_3`, `proof_of__EventCreate_which_implies_wit_2_split_goal_4`, `proof_of__EventCreate_which_implies_wit_2_split_goal_spatial`, `proof_of__EventCreate_entail_wit_2_1`, `proof_of__EventCreate_entail_wit_2_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/EventCreate-vc-proving-r1/groups/group_01__open_event_state/EventCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventcreate-trial-261101-1/VC/EventCreate_lib.v`
- Every new/adapted helper uses suffix `__open_event_state`. Preserve the seed.

### `proof_of__EventCreate_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of__EventCreate_which_implies_wit_2_split_goal_1`: Prove event_fresh__open_event_state from disjoint os_inv and EventZero. If p occurs in map event_addr, extract its store_event payload from the manager DLL; both it and EventZero own the options UInt cell at the same address. Separation exclusion yields contradiction. This uses spatial ownership, not a malloc freshness axiom.

- Split `proof_of__EventCreate_which_implies_wit_2_split_goal_2`: Unfold os_inv and event_inv (or os_world_wf.os_wf_context followed by os_global_context) to extract event_context; frame the owned resources.

- Split `proof_of__EventCreate_which_implies_wit_2_split_goal_3`: Unfold EventZero and extract its pure addr_aligned p 4 conjunct under the separating frame.

- Split `proof_of__EventCreate_which_implies_wit_2_split_goal_4`: Unfold EventZero and extract p<>0 under the separating frame.

- Split `proof_of__EventCreate_which_implies_wit_2_split_goal_spatial`: Unfold os_inv and event_create_frame, isolate event_inv and rewrite event_context pointer/head equalities to the C global symbols. Unfold EventZero, convert ZeroIdNode to insert-ready unknown scalar/node storage, keep EventPadding and both NodeZero resources, and cancel/reassociate all other OS resources. Do not duplicate any ID/link or scheduler ownership.
### `proof_of__EventCreate_entail_wit_2_1` — `LLM_pre_process`

Choose the left separation disjunct, keeping retval_4=-1 and every resource. Derive lock signed bounds from its Int store. Derive the conditional minimum-ID bound from idmanager_min_free_id and event_context idmax=128 (independent of whether the antecedent minimum-ID condition holds). All other pure facts are copied; reorder the id local cell.
### `proof_of__EventCreate_entail_wit_2_2` — `LLM_pre_process`

Choose the right disjunct and retain successful retval_5. Minimum-free-ID plus event_context gives 0<=retval_5<128; the lock Int store yields lock bounds. Reassociate/cancel all unchanged manager, object, frame and local resources.

## Helpers

- `event_fresh__open_event_state` (public): Prove forall sg st p, os_inv sg st ** EventZero p |-- !!(~ In p (map event_addr (os_events st))). Unfold the event DLL and use membership to expose the corresponding store_event. Its options UInt cell and the separately held zero object options cell coincide if event_addr=p; apply disjoint store conflict. Preserve arbitrary DLL prefix/suffix in the induction.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_01__open_event_state/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-debug",
      "--run",
      "EventCreate-20261101232623",
      "--round",
      "EventCreate-vc-proving-r1",
      "--group",
      "open_event_state"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-check",
      "--run",
      "EventCreate-20261101232623",
      "--round",
      "EventCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "open_event_state"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-check",
      "--run",
      "EventCreate-20261101232623",
      "--round",
      "EventCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "open_event_state"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/_coq_builds/EventCreate-vc-proving-r1/group_01/src/.coq_debug/group_01_open_event_state.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_01__open_event_state/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_01__open_event_state/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
