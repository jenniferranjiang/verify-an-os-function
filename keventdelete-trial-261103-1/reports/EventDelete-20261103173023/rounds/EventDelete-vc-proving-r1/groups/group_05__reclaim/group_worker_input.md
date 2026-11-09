# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `reclaim`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_05__reclaim/EventDelete_proof_manual.v`.
- Editable proof spans: `proof_of__EventDelete_which_implies_wit_9`, `proof_of__EventDelete_which_implies_wit_9_split_goal_spatial`, `proof_of__EventDelete_partial_solve_wit_28`, `proof_of__EventDelete_partial_solve_wit_29`, `proof_of__EventDelete_partial_solve_wit_30`, `proof_of__EventDelete_partial_solve_wit_31`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_05__reclaim/EventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventDelete_lib.v`
- Every new/adapted helper uses suffix `__reclaim`. Preserve the seed.

### `proof_of__EventDelete_which_implies_wit_9` — `aggressive_pre_process`

- Split `proof_of__EventDelete_which_implies_wit_9_split_goal_spatial`: Unfold EventRetired and EventRaw; forget ID/options/events field values, turn each self-linked DLL pair into NodeStorage/insert-ready unknown fields, and forget the zero padding to undef bytes. Keep nonzero/alignment facts. Prove the claimed typed resource entailment directly; event_retired_raw_obligation is only a Prop definition, not a usable theorem.
### `proof_of__EventDelete_partial_solve_wit_28` — `LLM_pre_process`

P contains EventRetired/EventRaw and OutsideCritical at exactly after, plus pure result/continuation facts. Q merely swaps/framed resources and repeats those same pure facts; cancel spatial atoms without unfolding OutsideCritical. For each wit preserve its concrete resched=0/ret or resched=1/assign branch; never mix them.
### `proof_of__EventDelete_partial_solve_wit_29` — `LLM_pre_process`

P contains EventRetired/EventRaw and OutsideCritical at exactly after, plus pure result/continuation facts. Q merely swaps/framed resources and repeats those same pure facts; cancel spatial atoms without unfolding OutsideCritical. For each wit preserve its concrete resched=0/ret or resched=1/assign branch; never mix them.
### `proof_of__EventDelete_partial_solve_wit_30` — `LLM_pre_process`

P contains EventRetired/EventRaw and OutsideCritical at exactly after, plus pure result/continuation facts. Q merely swaps/framed resources and repeats those same pure facts; cancel spatial atoms without unfolding OutsideCritical. For each wit preserve its concrete resched=0/ret or resched=1/assign branch; never mix them.
### `proof_of__EventDelete_partial_solve_wit_31` — `LLM_pre_process`

P contains EventRetired/EventRaw and OutsideCritical at exactly after, plus pure result/continuation facts. Q merely swaps/framed resources and repeats those same pure facts; cancel spatial atoms without unfolding OutsideCritical. For each wit preserve its concrete resched=0/ret or resched=1/assign branch; never mix them.

## Helpers

- `event_retired_forget__reclaim` (local): forall p options events, EventRetired p options events |-- EventRaw p. Use typed-store forget and node-self-linked -> unknown-node lemmas, with exact Event/IdNode nested field equalities and unchanged 2-byte padding. No allocation provenance or extra bytes may be invented.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_05__reclaim/proof_reuse.md`.

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
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "EventDelete-20261103173023",
      "--round",
      "EventDelete-vc-proving-r1",
      "--group",
      "reclaim"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "EventDelete-20261103173023",
      "--round",
      "EventDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "reclaim"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "EventDelete-20261103173023",
      "--round",
      "EventDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "reclaim"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/_coq_builds/EventDelete-vc-proving-r1/group_05/src/.coq_debug/group_05_reclaim.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_05__reclaim/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_05__reclaim/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
