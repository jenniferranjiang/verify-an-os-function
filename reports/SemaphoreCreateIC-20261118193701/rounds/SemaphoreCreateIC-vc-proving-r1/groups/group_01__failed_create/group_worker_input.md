# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `failed_create`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreCreateIC-20261118193701/SemaphoreCreateIC-vc-proving-r1/groups/group_01__failed_create/SemaphoreCreateIC_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_2_1`, `proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial`, `proof_of__SemaphoreCreate_entail_wit_2_2`, `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial`, `proof_of__SemaphoreCreate_return_wit_2`, `proof_of__SemaphoreCreate_return_wit_2_split_goal_1`, `proof_of__SemaphoreCreate_return_wit_3`, `proof_of__SemaphoreCreate_return_wit_3_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreCreate_entail_wit_2_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial`: Group the private ID-ready, zero value, two zero nodes and padding resources. Use semaphore_insert_failure_raw with retained base/alignment and embedded-node nonzero facts. Convert all typed unknown cells to unknown bytes using number-as-bytes equivalences and the approved concrete layout, combine contiguous intervals into CharArray.undef_full sem 32 (including [2,4) and [14,16) padding). Independently fold the unchanged manager, old DLL and all frame resources back into os_inv using given os_world_wf and semaphore_context. No value or allocation provenance assumption is added; derive byte bounds from owned typed cells. Any intermediate conversion must be proved inline inside this assigned span.
### `proof_of__SemaphoreCreate_entail_wit_2_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1`: Unfold IDNode.idmanager_min_free_id in the premise: it contains 0 <= retval, contradicting retval < 0. Ex falso proves the pure result.

- Split `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial`: The same min-free nonnegativity contradicts the negative branch guard; eliminate the inconsistent pure premises before spatial work.
### `proof_of__SemaphoreCreate_return_wit_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_return_wit_2_split_goal_1`: Unfold semaphore_create_ic_effect; select its failure disjunct and prove -5=-5 and before=before. It requires no ID-full fact and no val range.
### `proof_of__SemaphoreCreate_return_wit_3` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_return_wit_3_split_goal_1`: The malloc failure uses the identical unchanged-state failure disjunct of semaphore_create_ic_effect. Reflexivity closes both conjuncts.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreCreateIC-20261118193701/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/rounds/SemaphoreCreateIC-vc-proving-r1/groups/group_01__failed_create/proof_reuse.md`.

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
      "SemaphoreCreateIC-20261118193701",
      "--round",
      "SemaphoreCreateIC-vc-proving-r1",
      "--group",
      "failed_create"
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
      "SemaphoreCreateIC-20261118193701",
      "--round",
      "SemaphoreCreateIC-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "failed_create"
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
      "SemaphoreCreateIC-20261118193701",
      "--round",
      "SemaphoreCreateIC-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "failed_create"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreCreateIC-20261118193701/_coq_builds/SemaphoreCreateIC-vc-proving-r1/group_01/src/.coq_debug/group_01_failed_create.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/rounds/SemaphoreCreateIC-vc-proving-r1/groups/group_01__failed_create/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/rounds/SemaphoreCreateIC-vc-proving-r1/groups/group_01__failed_create/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
