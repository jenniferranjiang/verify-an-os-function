# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `zero_layout`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/EventCreate-vc-proving-r1/groups/group_00__zero_layout/EventCreate_proof_manual.v`.
- Editable proof spans: `proof_of__EventCreate_which_implies_wit_1`, `proof_of__EventCreate_which_implies_wit_1_split_goal_1`, `proof_of__EventCreate_which_implies_wit_1_split_goal_2`, `proof_of__EventCreate_which_implies_wit_1_split_goal_spatial`, `proof_of__EventCreate_partial_solve_wit_1_pure`, `proof_of__EventCreate_partial_solve_wit_2_pure`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/EventCreate-vc-proving-r1/groups/group_00__zero_layout/EventCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventcreate-trial-261101-1/VC/EventCreate_lib.v`
- Every new/adapted helper uses suffix `__zero_layout`. Preserve the seed.

### `proof_of__EventCreate_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of__EventCreate_which_implies_wit_1_split_goal_1`: Use the Event top-level ABI offset link=p+28 under the explicit addr_aligned p 4 premise. Since p>0, link is nonzero; retain no spatial target.

- Split `proof_of__EventCreate_which_implies_wit_1_split_goal_2`: Use the Event top-level ABI offset pend_list=p+20 under explicit alignment. Since p>0, the sentinel is nonzero.

- Split `proof_of__EventCreate_which_implies_wit_1_split_goal_spatial`: Apply event_zero_bytes__zero_layout to the exact 36-byte zero array after rewriting sizeof(Event)=36. Explicit premises supply positivity, upper address bound and alignment. Split bytes into ID scalar [0,2), padding [2,4), ID links [4,12), options [12,16), events [16,20), pending links [20,28), management links [28,36). Use typed byte-store conversion and fold ZeroIdNode/NodeZero/EventPadding/EventZero; retain all 36 bytes exactly.
### `proof_of__EventCreate_partial_solve_wit_1_pure` — `LLM_pre_process`

Unfold the witness; introduce all quantified values and pure premises. Use EventLayoutABI.event_size_axiom and EVENT_MEM_SIZE=36, then integer bounds (UINT_MAX=4294967295). The spatial frame is irrelevant to this pure conclusion; no input range restriction is added.
### `proof_of__EventCreate_partial_solve_wit_2_pure` — `LLM_pre_process`

Unfold the witness; introduce all quantified values and pure premises. Use EventLayoutABI.event_size_axiom and EVENT_MEM_SIZE=36, then integer bounds (UINT_MAX=4294967295). The spatial frame is irrelevant to this pure conclusion; no input range restriction is added. The extra memset zero-byte range goals are 0<=0 and 0<=127.

## Helpers

- `event_byte_layout__zero_layout` (public): Prove forall p, addr_aligned p 4 -> event_byte_layout p. Combine the reviewed EventLayoutABI.event_top_level_field_offset_axiom with the existing StructFieldOffsetAxiom.mutex_field_offset_axiom for IdNode and DLL offsets at p+4,p+20,p+28; normalize ALIGN_SIZE=4. This is a derived layout lemma, not a new trusted assumption.
- `event_zero_bytes__zero_layout` (public): Prove forall p, 0<p -> p<=UINT_MAX-36 -> addr_aligned p 4 -> CharArray.full p 36 (repeat_Z 0 36) |-- EventZero p. Derive layout from the preceding current-group lemma, split the byte array at offsets 2,4,12,16,20,28,36 and use typed store conversion. Scalar widths/alignment and address validity follow from the supplied bounds; pure nonnull/alignment fold directly. No EventZero or whole VC assumption may be introduced.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_00__zero_layout/proof_reuse.md`.

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
      "zero_layout"
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
      "zero_layout"
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
      "zero_layout"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/_coq_builds/EventCreate-vc-proving-r1/group_00/src/.coq_debug/group_00_zero_layout.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_00__zero_layout/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_00__zero_layout/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
