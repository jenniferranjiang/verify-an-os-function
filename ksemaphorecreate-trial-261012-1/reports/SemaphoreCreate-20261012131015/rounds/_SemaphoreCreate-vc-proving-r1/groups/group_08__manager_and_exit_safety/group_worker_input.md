# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `manager_and_exit_safety`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_SemaphoreCreate-vc-proving-r1/groups/group_08__manager_and_exit_safety/_SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_safety_wit_11`, `proof_of__SemaphoreCreate_safety_wit_13`, `proof_of__SemaphoreCreate_safety_wit_14`, `proof_of__SemaphoreCreate_safety_wit_15`, `proof_of__SemaphoreCreate_safety_wit_16`, `proof_of__SemaphoreCreate_safety_wit_17`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of__SemaphoreCreate_safety_wit_11` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. The two conclusions are INT_MIN <= 0 and 0 <= INT_MAX. Reduce the imported signed 32-bit limits and discharge both closed inequalities. The antecedent locals and protocol/heap resources are unchanged and are used only as the domain of a pure assertion; no existential, list transformation, or transition is needed.
### `proof_of__SemaphoreCreate_safety_wit_13` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. The two conclusions are INT_MIN <= 0 and 0 <= INT_MAX. Reduce the imported signed 32-bit limits and discharge both closed inequalities. The antecedent locals and protocol/heap resources are unchanged and are used only as the domain of a pure assertion; no existential, list transformation, or transition is needed.
### `proof_of__SemaphoreCreate_safety_wit_14` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. The two conclusions are INT_MIN <= 0 and 0 <= INT_MAX. Reduce the imported signed 32-bit limits and discharge both closed inequalities. The antecedent locals and protocol/heap resources are unchanged and are used only as the domain of a pure assertion; no existential, list transformation, or transition is needed.
### `proof_of__SemaphoreCreate_safety_wit_15` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. The guard retval >= 0 contradicts retval = -1. Derive False arithmetically; manager, detached node, registry, task/scheduler and IRQ resources need no conversion.
### `proof_of__SemaphoreCreate_safety_wit_16` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. The conclusion is the closed arithmetic fact 5 <> INT_MIN. Reduce the imported signed 32-bit limit and discharge arithmetically. Antecedent resources are irrelevant to this pure assertion; there are no existential witnesses or transitions.
### `proof_of__SemaphoreCreate_safety_wit_17` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. The two conclusions are INT_MIN <= 5 and 5 <= INT_MAX. Reduce the imported signed 32-bit limits and discharge both closed inequalities. The antecedent locals and protocol/heap resources are unchanged and are used only as the domain of a pure assertion; no existential, list transformation, or transition is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_08__manager_and_exit_safety/proof_reuse.md`.

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
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-proving-r1",
      "--group",
      "manager_and_exit_safety"
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
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "manager_and_exit_safety"
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
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "manager_and_exit_safety"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_coq_builds/_SemaphoreCreate-vc-proving-r1/group_08/src/.coq_debug/group_08_manager_and_exit_safety.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_08__manager_and_exit_safety/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_08__manager_and_exit_safety/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
