# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `zero_bytes`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_00__zero_bytes/MutexCreate_proof_manual.v`.
- Editable proof spans: `proof_of__MutexCreate_which_implies_wit_1`, `proof_of__MutexCreate_which_implies_wit_1_split_goal_1`, `proof_of__MutexCreate_which_implies_wit_1_split_goal_2`, `proof_of__MutexCreate_which_implies_wit_1_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/MutexCreate-vc-proving-r1/groups/group_00__zero_bytes/MutexCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexcreate-trial-261101-1/VC/MutexCreate_lib.v`
- Every new/adapted helper uses suffix `__zero_bytes`. Preserve the seed.

### `proof_of__MutexCreate_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of__MutexCreate_which_implies_wit_1_split_goal_1`: P owns the 36 zero bytes at mutex, with 0<mutex, mutex<=UINT_MAX-sizeof(Mutex), and 4-byte alignment. Rewrite the existing Mutex size/field-offset facts; the management link is mutex+28, hence nonzero by lia. Discard no needed spatial facts; pure entailment is a projection over this heap.

- Split `proof_of__MutexCreate_which_implies_wit_1_split_goal_2`: Same zero-byte P and allocation bounds. Existing pend_list offset is 20, so mutex+20<>0. No existential or state transition.

- Split `proof_of__MutexCreate_which_implies_wit_1_split_goal_spatial`: Use mutex_zero_bytes__zero_bytes. Rewrite sizeof(Mutex)=36 and existing field offsets. Split the zero CharArray into ID ushort [0,2), padding [2,4), ID links [4,12), val [12,14), recursion [14,15), priority [15,16), holder [16,20), pend links [20,28), management links [28,36). Convert each zero byte segment to the corresponding typed zero using the imported Arch32 LittleEndian memory representation, then fold ZeroIdNode/NodeZero/MutexPadding/MutexZero. Alignment and range are exactly the three preconditions; padding is owned exactly once.

## Helpers

- `mutex_zero_bytes__zero_bytes` (public): Prove forall p, 0<p -> p<=UINT_MAX-sizeof(Mutex) -> addr_aligned p 4 -> CharArray.full p sizeof(Mutex) (repeat_Z 0 sizeof(Mutex)) |-- MutexZero p. Use only existing layout axioms, split at the 36-byte layout boundaries, prove zero-byte encoding of ushort/uchar/32-bit pointers, and reconstruct the separating conjunction. No fresh axiom and no use of the Prop-only mutex_zero_bytes_obligation as a lemma.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_00__zero_bytes/proof_reuse.md`.

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
      "zero_bytes"
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
      "zero_bytes"
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
      "zero_bytes"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexcreate-trial-261101-1/verification_runs/MutexCreate-20261101164709/_coq_builds/MutexCreate-vc-proving-r1/group_00/src/.coq_debug/group_00_zero_bytes.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_00__zero_bytes/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-proving-r1/groups/group_00__zero_bytes/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
