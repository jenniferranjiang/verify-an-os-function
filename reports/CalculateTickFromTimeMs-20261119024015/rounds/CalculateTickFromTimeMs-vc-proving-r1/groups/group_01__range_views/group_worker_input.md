# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `range_views`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/CalculateTickFromTimeMs-20261119024015/CalculateTickFromTimeMs-vc-proving-r1/groups/group_01__range_views/CalculateTickFromTimeMs_proof_manual.v`.
- Editable proof spans: `proof_of_CalculateTickFromTimeMs_which_implies_wit_1`, `proof_of_CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial`, `proof_of_CalculateTickFromTimeMs_which_implies_wit_2`, `proof_of_CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_CalculateTickFromTimeMs_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of_CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial`: The antecedent is the actual UInt cell at the local ms address storing ms_pre; explicit UInt range hypotheses are available in this split. The consequent is the same existing store_uinteger (Z.to_nat 4) 4 cell. Normalize the UInt/store_uint notation and Z.to_nat 4 to their definitionally identical store_uinteger instance, then close by entailment reflexivity/cancellation. Preserve the cell; no existential, allocation, or new range assumption is needed. The parent unconditional resource view genuinely contains the typed cell that entails the range, rather than emp.
### `proof_of_CalculateTickFromTimeMs_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of_CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial`: The antecedent is store_uinteger (Z.to_nat 4) 4 at the local ms address with the same ms_pre; consequent is the UInt cell at exactly that address/value. Normalize the existing UInt/store_uint definition and close the identity entailment. There is no range strengthening or resource loss.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/CalculateTickFromTimeMs-20261119024015/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-proving-r1/groups/group_01__range_views/proof_reuse.md`.

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
      "range_views"
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
      "range_views"
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
      "range_views"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/CalculateTickFromTimeMs-20261119024015/_coq_builds/CalculateTickFromTimeMs-vc-proving-r1/group_01/src/.coq_debug/group_01_range_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-proving-r1/groups/group_01__range_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-proving-r1/groups/group_01__range_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
