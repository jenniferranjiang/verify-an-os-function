# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `payload_initialization`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_03__payload_initialization/MutexCreate_proof_manual.v`.
- Editable proof spans: `proof_of__MutexCreate_which_implies_wit_4`, `proof_of__MutexCreate_which_implies_wit_5`, `proof_of__MutexCreate_which_implies_wit_5_split_goal_spatial`, `proof_of__MutexCreate_partial_solve_wit_10`, `proof_of__MutexCreate_partial_solve_wit_11`, `proof_of__MutexCreate_partial_solve_wit_12_pure`, `proof_of__MutexCreate_partial_solve_wit_12`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_03__payload_initialization/MutexCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/VC/MutexCreate_lib.v`
- Every new/adapted helper uses suffix `__payload_initialization`. Preserve the seed.

### `proof_of__MutexCreate_which_implies_wit_4` — `LLM_pre_process`

Choose the original left disjunct. Unfold NodeZero into its next/prev pointer cells initialized to zero; weaken each to the existential undef pointer predicate, witnesses 0 and 0; reconcile nested field addresses by existing layout notation facts, reorder and cancel.
### `proof_of__MutexCreate_which_implies_wit_5` — `aggressive_pre_process`

- Split `proof_of__MutexCreate_which_implies_wit_5_split_goal_spatial`: Q store_mutex wait link (mutex_created p id) ** occupy_dll_node link. Unfold the created record and store_mutex. The pure payload address facts are supplied by p<>0, alignment, and definitional link equality. Convert self-linked pend node to store_dll wait pend nil, including its nonzero head from the self-linked predicate. Forget management NodeZero values to occupy_dll_node with zero witnesses. Retain exact padding, val=1, count=0, priority=255, holder=0. ID min-free is carried through but store_mutex owns no ID bytes.
### `proof_of__MutexCreate_partial_solve_wit_10` — `LLM_pre_process`

Reorder NodeZero pend to the call footprint, leaving updated manager, frame, existing DLL, zero payload and link/padding resources unchanged. Q pure conditions are all PreH projections.
### `proof_of__MutexCreate_partial_solve_wit_11` — `LLM_pre_process`

Two undef pointer cells at pend.prev/next and the remaining frame appear unchanged on both sides. Add only already supplied branch/min-free/context/range/address/continuation facts and cancel.
### `proof_of__MutexCreate_partial_solve_wit_12_pure` — `LLM_pre_process`

After field assignments and pend initialization, Q needs p nonzero/aligned, management link nonzero and original min-free id. Each is an explicit retained PreH. No payload unfolding needed.
### `proof_of__MutexCreate_partial_solve_wit_12` — `LLM_pre_process`

Unfold auxiliary conclusion; reorder initialized fields, self-linked pend, management NodeZero and padding to the conversion footprint, retaining updated manager, system frame, old DLL and InsideCritical. All pure facts are explicit PreH; ignore the implication premise if redundant.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_03__payload_initialization/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-debug",
      "--run",
      "MutexCreate-20261101164709",
      "--round",
      "MutexCreate-vc-proving-r1",
      "--group",
      "payload_initialization"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-check",
      "--run",
      "MutexCreate-20261101164709",
      "--round",
      "MutexCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "payload_initialization"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-check",
      "--run",
      "MutexCreate-20261101164709",
      "--round",
      "MutexCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "payload_initialization"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/_coq_builds/MutexCreate-vc-proving-r1/group_03/src/.coq_debug/group_03_payload_initialization.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_03__payload_initialization/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_03__payload_initialization/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
