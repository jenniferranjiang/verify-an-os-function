# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `arithmetic_returns`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/CalculateTickFromTimeMs-20261119024015/CalculateTickFromTimeMs-vc-proving-r2/groups/group_00__arithmetic_returns/CalculateTickFromTimeMs_proof_manual.v`.
- Editable proof spans: `proof_of_CalculateTickFromTimeMs_return_wit_1`, `proof_of_CalculateTickFromTimeMs_return_wit_1_split_goal_1`, `proof_of_CalculateTickFromTimeMs_return_wit_2`, `proof_of_CalculateTickFromTimeMs_return_wit_2_split_goal_1`, `proof_of_CalculateTickFromTimeMs_return_wit_3`, `proof_of_CalculateTickFromTimeMs_return_wit_3_split_goal_1`, `proof_of_CalculateTickFromTimeMs_return_wit_4`, `proof_of_CalculateTickFromTimeMs_return_wit_4_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_CalculateTickFromTimeMs_return_wit_1` — `aggressive_pre_process`

- Split `proof_of_CalculateTickFromTimeMs_return_wit_1_split_goal_1`: Pure equality, no spatial resources or existential. From 0<=ms<=UINT_MAX derive n=ms*100>=0 and q=n/1000 within unsigned32. Rewrite C quot as Z.div using nonnegative numerator and positive divisor, then unsigned_last_nbits(q,32)=q. The path guard gives q=0; unfold tick_from_time_ms, select its zero branch and conclude 1=1.
### `proof_of_CalculateTickFromTimeMs_return_wit_2` — `aggressive_pre_process`

- Split `proof_of_CalculateTickFromTimeMs_return_wit_2_split_goal_1`: Pure equality, no spatial resources or existential. From the UInt bound derive n>=0, 0<=q=n/1000<=429496730 and 0<=r=n mod 1000<1000. Convert C quot/rem to Z.div/mod and eliminate all unsigned32 truncations, including q+1. Guards give q<>0 and 5<=r<=9; unfold tick_from_time_ms and select the nonzero and true conjunction branches, yielding q+1. It is unnecessary to assume this arithmetic guard is reachable or add any premise.
### `proof_of_CalculateTickFromTimeMs_return_wit_3` — `aggressive_pre_process`

- Split `proof_of_CalculateTickFromTimeMs_return_wit_3_split_goal_1`: Pure equality, no spatial resources or existential. Use the UInt bound to prove nonnegative n, unsigned32 bounds for q=n/1000 and r=n mod 1000; convert quot/rem and eliminate truncations. The guards imply q<>0 and r<5. Unfold tick_from_time_ms, select its nonzero branch and show Z.leb 5 r=false, so the result is q.
### `proof_of_CalculateTickFromTimeMs_return_wit_4` — `aggressive_pre_process`

- Split `proof_of_CalculateTickFromTimeMs_return_wit_4_split_goal_1`: Pure equality, no spatial resources or existential. Use the UInt bound to prove nonnegative n, unsigned32 bounds for q=n/1000 and r=n mod 1000; convert quot/rem and eliminate truncations. The guards imply q<>0, r>=5 and r>9. Unfold tick_from_time_ms; show the upper-bound test false, hence the conjunction false and result q.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/CalculateTickFromTimeMs-20261119024015/CalculateTickFromTimeMs-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/CalculateTickFromTimeMs-20261119024015/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-proving-r2/groups/group_00__arithmetic_returns/proof_reuse.md`.

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
      "CalculateTickFromTimeMs-vc-proving-r2",
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
      "CalculateTickFromTimeMs-vc-proving-r2",
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
      "CalculateTickFromTimeMs-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "arithmetic_returns"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/CalculateTickFromTimeMs-20261119024015/_coq_builds/CalculateTickFromTimeMs-vc-proving-r2/group_00/src/.coq_debug/group_00_arithmetic_returns.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-proving-r2/groups/group_00__arithmetic_returns/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-proving-r2/groups/group_00__arithmetic_returns/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
