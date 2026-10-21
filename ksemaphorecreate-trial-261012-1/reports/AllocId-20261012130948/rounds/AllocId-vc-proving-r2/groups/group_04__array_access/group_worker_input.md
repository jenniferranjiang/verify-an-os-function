# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `array_access`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r2/groups/group_04__array_access/AllocId_proof_manual.v`.
- Editable proof spans: `proof_of_AllocId_partial_solve_wit_1`, `proof_of_AllocId_partial_solve_wit_2`, `proof_of_AllocId_partial_solve_wit_3`, `proof_of_AllocId_partial_solve_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_AllocId_partial_solve_wit_1` — `LLM_pre_process`

The precondition owns the manager fields, full UCharArray and OSHeap bucket frame. Preserve all pure premises and frame all manager/bucket resources. Use index >= 0, index < end and end = (idmax+7) quot 8 to split the full array at index, producing the Znth byte and missing_i; no existential state transition is needed. Keep the known byte value unchanged.
### `proof_of_AllocId_partial_solve_wit_2` — `LLM_pre_process`

The precondition owns the manager fields, full UCharArray and OSHeap bucket frame. Preserve all pure premises and frame all manager/bucket resources. Use index >= 0, index < end and end = (idmax+7) quot 8 to split the full array at index, producing the Znth byte and missing_i; no existential state transition is needed. Keep the known byte value unchanged.
### `proof_of_AllocId_partial_solve_wit_3` — `LLM_pre_process`

The precondition owns the manager fields, full UCharArray and OSHeap bucket frame. Preserve all pure premises and frame all manager/bucket resources. Use index >= 0, index < end and end = (idmax+7) quot 8 to split the full array at index, producing the Znth byte and missing_i; no existential state transition is needed. Keep the known byte value unchanged.
### `proof_of_AllocId_partial_solve_wit_4` — `LLM_pre_process`

The precondition owns the manager fields, full UCharArray and OSHeap bucket frame. Preserve all pure premises and frame all manager/bucket resources. Use index >= 0, index < end and end = (idmax+7) quot 8 to split the full array at index, producing the Znth byte and missing_i; no existential state transition is needed. Weaken the known byte cell to its undef form after splitting.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_04__array_access/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-debug",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-proving-r2",
      "--group",
      "array_access"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-check",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "array_access"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-check",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "array_access"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/_coq_builds/AllocId-vc-proving-r2/group_04/src/.coq_debug/group_04_array_access.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_04__array_access/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_04__array_access/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
