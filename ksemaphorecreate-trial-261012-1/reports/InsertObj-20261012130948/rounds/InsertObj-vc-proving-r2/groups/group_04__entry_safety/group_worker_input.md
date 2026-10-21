# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `entry_safety`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/InsertObj-vc-proving-r2/groups/group_04__entry_safety/InsertObj_proof_manual.v`.
- Editable proof spans: `proof_of_InsertObj_safety_wit_1`, `proof_of_InsertObj_safety_wit_2`, `proof_of_InsertObj_safety_wit_3`, `proof_of_InsertObj_safety_wit_4`, `proof_of_InsertObj_safety_wit_5`, `proof_of_InsertObj_safety_wit_6`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_InsertObj_safety_wit_1` — `LLM_pre_process`

Pattern S. P has local manager/idnode pointers and two OSHeap representations. Q is INT_MIN<=0<=INT_MAX, a closed Arch32 integer fact; introduce variables and discharge by integer bounds, without changing resources.
### `proof_of_InsertObj_safety_wit_2` — `LLM_pre_process`

Pattern S. PreH1 manager_pre=0 contradicts PreH2 manager_pre<>0. Eliminate the inconsistent pure context to prove the False entailment; no resource inference.
### `proof_of_InsertObj_safety_wit_3` — `LLM_pre_process`

Pattern S. Same unchanged entry heap as safety_1; Q is the same closed INT_MIN<=0<=INT_MAX fact, prove directly.
### `proof_of_InsertObj_safety_wit_4` — `LLM_pre_process`

Pattern S. Same entry heap and closed integer-constant bounds as safety_1, prove directly.
### `proof_of_InsertObj_safety_wit_5` — `LLM_pre_process`

Pattern S. PreH1 idnode_pre=0 contradicts PreH4 idnode_pre<>0; eliminate contradiction to prove False.
### `proof_of_InsertObj_safety_wit_6` — `LLM_pre_process`

Pattern S. Same entry heap and closed integer-constant bounds as safety_1; no predicate unfolding required.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/InsertObj-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r2/groups/group_04__entry_safety/proof_reuse.md`.

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
      "InsertObj-20261012130948",
      "--round",
      "InsertObj-vc-proving-r2",
      "--group",
      "entry_safety"
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
      "InsertObj-20261012130948",
      "--round",
      "InsertObj-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "entry_safety"
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
      "InsertObj-20261012130948",
      "--round",
      "InsertObj-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "entry_safety"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/_coq_builds/InsertObj-vc-proving-r2/group_04/src/.coq_debug/group_04_entry_safety.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r2/groups/group_04__entry_safety/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r2/groups/group_04__entry_safety/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
