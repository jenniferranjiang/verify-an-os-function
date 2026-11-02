# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `payload_init`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/EventCreate-vc-proving-r1/groups/group_04__payload_init/EventCreate_proof_manual.v`.
- Editable proof spans: `proof_of__EventCreate_which_implies_wit_4`, `proof_of__EventCreate_which_implies_wit_5`, `proof_of__EventCreate_which_implies_wit_5_split_goal_spatial`, `proof_of__EventCreate_partial_solve_wit_10`, `proof_of__EventCreate_partial_solve_wit_11`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/EventCreate-vc-proving-r1/groups/group_04__payload_init/EventCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventcreate-trial-261101-1/VC/EventCreate_lib.v`
- Every new/adapted helper uses suffix `__payload_init`. Preserve the seed.

### `proof_of__EventCreate_which_implies_wit_4` — `LLM_pre_process`

Choose the first disjunct. Unfold NodeZero at the pending sentinel, use the nested-field address identity for SysDoubleLinklistNode fields, forget the zero values to Ptr undef and commute next/prev. Alternatively the second disjunct witnesses are both 0. No new event alignment assumption is required; this is field-resource unfolding.
### `proof_of__EventCreate_which_implies_wit_5` — `aggressive_pre_process`

- Split `proof_of__EventCreate_which_implies_wit_5_split_goal_spatial`: Normalize Z.land options_pre 7 = options_pre mod 8 (7=2^3-1), valid for every integer. Fold event_created/store_event with pending_addrs=[]; turn store_node_self_linked into the empty store_dll using the sentinel nonzero/resource fact. Keep EventPadding and options/events stores exactly; bounds are 0<=options mod8<8 and 0<=0<536870912. Convert the separate management NodeZero to occupy_dll_node. The ID manager is not owned by store_event.
### `proof_of__EventCreate_partial_solve_wit_10` — `LLM_pre_process`

All pure facts are copied from PreH; move pending NodeZero to the front and cancel the exact remaining manager, frame, DLL, fields, padding and InsideCritical resources.
### `proof_of__EventCreate_partial_solve_wit_11` — `LLM_pre_process`

The consequent has the same two pending pointer undef cells and remaining resources as the antecedent. Introduce existing pure facts and cancel; no reinitialization or loss of pointer permission is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_04__payload_init/proof_reuse.md`.

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
      "payload_init"
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
      "payload_init"
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
      "payload_init"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/_coq_builds/EventCreate-vc-proving-r1/group_04/src/.coq_debug/group_04_payload_init.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_04__payload_init/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_04__payload_init/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
