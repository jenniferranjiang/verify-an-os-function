# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `returns`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/PopDataqueue-20261119021132/PopDataqueue-vc-proving-r1/groups/group_03__returns/PopDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_PopDataqueue_entail_wit_3`, `proof_of_PopDataqueue_entail_wit_3_split_goal_1`, `proof_of_PopDataqueue_return_wit_1`, `proof_of_PopDataqueue_return_wit_2`, `proof_of_PopDataqueue_return_wit_3`, `proof_of_PopDataqueue_return_wit_3_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_PopDataqueue_entail_wit_3` — `aggressive_pre_process`

- Split `proof_of_PopDataqueue_entail_wit_3_split_goal_1`: Use retval=0 and instantiate PreH5 at after and retval; its antecedent is the existing safeExec ret retval Y. Substitute the equality to obtain after_obtain sg p_queue_pre 0 X. All spatial frame is handled by the top-level split route.
### `proof_of_PopDataqueue_return_wit_1` — `LLM_pre_process`

Use LLM_pre_process. Instantiate the universal Y_finish return bridge with after_4 and retval to obtain safeExec ret result X. Substitute result=DqPopItem item and new_data/new_length equalities. Choose the right public result disjunct with after_3=after_4 and e=item, cancel OutsideCritical and both Some output slots. The old optional outputs need not be reconstructible and are not chosen.
### `proof_of_PopDataqueue_return_wit_2` — `LLM_pre_process`

Use LLM_pre_process. Apply the universal Y_finish bridge at after_4/retval, substitute result=DqPopEmpty and old output equalities. Choose the left result disjunct with after_2=after_4 and cancel OutsideCritical and original output slots. No assumption about Abandon status is needed.
### `proof_of_PopDataqueue_return_wit_3` — `aggressive_pre_process`

- Split `proof_of_PopDataqueue_return_wit_3_split_goal_1`: Apply the continuation bridge PreH5 at after_4/retval using PreH2. Unfold dataqueue_pop_after_obtain and use 0<>retval to select the failure branch, yielding safeExec ret DqPopFailed X. No ring or Abandon transition is performed on this path.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/PopDataqueue-20261119021132/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-proving-r1/groups/group_03__returns/proof_reuse.md`.

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
      "PopDataqueue-20261119021132",
      "--round",
      "PopDataqueue-vc-proving-r1",
      "--group",
      "returns"
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
      "PopDataqueue-20261119021132",
      "--round",
      "PopDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "returns"
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
      "PopDataqueue-20261119021132",
      "--round",
      "PopDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "returns"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/PopDataqueue-20261119021132/_coq_builds/PopDataqueue-vc-proving-r1/group_03/src/.coq_debug/group_03_returns.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-proving-r1/groups/group_03__returns/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-proving-r1/groups/group_03__returns/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
