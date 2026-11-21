# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `arithmetic_returns`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/CalculateTickFromTimeMs-20261119024015/CalculateTickFromTimeMs-vc-proving-r1/groups/group_00__arithmetic_returns/CalculateTickFromTimeMs_proof_manual.v`.
- Editable proof spans: `proof_of_CalculateTickFromTimeMs_return_wit_1`, `proof_of_CalculateTickFromTimeMs_return_wit_1_split_goal_1`, `proof_of_CalculateTickFromTimeMs_return_wit_2`, `proof_of_CalculateTickFromTimeMs_return_wit_2_split_goal_1`, `proof_of_CalculateTickFromTimeMs_return_wit_3`, `proof_of_CalculateTickFromTimeMs_return_wit_3_split_goal_1`, `proof_of_CalculateTickFromTimeMs_return_wit_4`, `proof_of_CalculateTickFromTimeMs_return_wit_4_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_CalculateTickFromTimeMs_return_wit_1` — `aggressive_pre_process`

- Split `proof_of_CalculateTickFromTimeMs_return_wit_1_split_goal_1`: All resources are emp; ms_pre is the sole scalar witness and already has 0 <= ms_pre <= UINT_MAX. Normalize C nonnegative quotient/remainder to Z.div/Z.mod using positivity of 1000. Derive q=(ms_pre*100)/1000 in [0,429496729] and r=(ms_pre*100) mod 1000 in [0,999]; therefore unsigned_last_nbits q 32=q, unsigned_last_nbits r 32=r, and unsigned_last_nbits (q+1) 32=q+1. Unfold tick_from_time_ms and use the normalized C guard to select the same mathematical branch. Use local assertions inside the assigned proof for these facts, no helper declaration/case lib. This branch has truncated quotient zero, hence q=0; the specification reduces to 1. No existential or memory transformation remains.
### `proof_of_CalculateTickFromTimeMs_return_wit_2` — `aggressive_pre_process`

- Split `proof_of_CalculateTickFromTimeMs_return_wit_2_split_goal_1`: All resources are emp; ms_pre is the sole scalar witness and already has 0 <= ms_pre <= UINT_MAX. Normalize C nonnegative quotient/remainder to Z.div/Z.mod using positivity of 1000. Derive q=(ms_pre*100)/1000 in [0,429496729] and r=(ms_pre*100) mod 1000 in [0,999]; therefore unsigned_last_nbits q 32=q, unsigned_last_nbits r 32=r, and unsigned_last_nbits (q+1) 32=q+1. Unfold tick_from_time_ms and use the normalized C guard to select the same mathematical branch. Use local assertions inside the assigned proof for these facts, no helper declaration/case lib. This branch has q<>0 and 5<=r<=9. Reduce Z.eq_dec and both Z.leb tests, then match q+1 after removing the final 32-bit truncation. It is unnecessary to assert reachability or to introduce a new modulo-100 assumption; even this guarded branch is handled by the exact specification.
### `proof_of_CalculateTickFromTimeMs_return_wit_3` — `aggressive_pre_process`

- Split `proof_of_CalculateTickFromTimeMs_return_wit_3_split_goal_1`: All resources are emp; ms_pre is the sole scalar witness and already has 0 <= ms_pre <= UINT_MAX. Normalize C nonnegative quotient/remainder to Z.div/Z.mod using positivity of 1000. Derive q=(ms_pre*100)/1000 in [0,429496729] and r=(ms_pre*100) mod 1000 in [0,999]; therefore unsigned_last_nbits q 32=q, unsigned_last_nbits r 32=r, and unsigned_last_nbits (q+1) 32=q+1. Unfold tick_from_time_ms and use the normalized C guard to select the same mathematical branch. Use local assertions inside the assigned proof for these facts, no helper declaration/case lib. This branch has q<>0 and r<5. Z.leb 5 r is false so the andb rounding guard is false, and the result is q. No additional lower-bound premise is needed beyond the explicit UInt range.
### `proof_of_CalculateTickFromTimeMs_return_wit_4` — `aggressive_pre_process`

- Split `proof_of_CalculateTickFromTimeMs_return_wit_4_split_goal_1`: All resources are emp; ms_pre is the sole scalar witness and already has 0 <= ms_pre <= UINT_MAX. Normalize C nonnegative quotient/remainder to Z.div/Z.mod using positivity of 1000. Derive q=(ms_pre*100)/1000 in [0,429496729] and r=(ms_pre*100) mod 1000 in [0,999]; therefore unsigned_last_nbits q 32=q, unsigned_last_nbits r 32=r, and unsigned_last_nbits (q+1) 32=q+1. Unfold tick_from_time_ms and use the normalized C guard to select the same mathematical branch. Use local assertions inside the assigned proof for these facts, no helper declaration/case lib. This branch has q<>0 and r>9 (also r>=5). Z.leb r 9 is false, so the rounding conjunction is false and the result is q.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/CalculateTickFromTimeMs-20261119024015/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-proving-r1/groups/group_00__arithmetic_returns/proof_reuse.md`.

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
      "/home/xinra/crtos-verify",
      "coq-debug",
      "--run",
      "CalculateTickFromTimeMs-20261119024015",
      "--round",
      "CalculateTickFromTimeMs-vc-proving-r1",
      "--group",
      "arithmetic_returns"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "CalculateTickFromTimeMs-20261119024015",
      "--round",
      "CalculateTickFromTimeMs-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "arithmetic_returns"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "CalculateTickFromTimeMs-20261119024015",
      "--round",
      "CalculateTickFromTimeMs-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "arithmetic_returns"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/CalculateTickFromTimeMs-20261119024015/_coq_builds/CalculateTickFromTimeMs-vc-proving-r1/group_00/src/.coq_debug/group_00_arithmetic_returns.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-proving-r1/groups/group_00__arithmetic_returns/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-proving-r1/groups/group_00__arithmetic_returns/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
