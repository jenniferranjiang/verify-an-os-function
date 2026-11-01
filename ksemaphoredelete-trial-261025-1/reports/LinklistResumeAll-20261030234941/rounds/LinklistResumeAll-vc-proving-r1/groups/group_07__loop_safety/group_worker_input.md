# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `loop_safety`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r1/groups/group_07__loop_safety/LinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_safety_wit_4`, `proof_of_LinklistResumeAll_safety_wit_5`, `proof_of_LinklistResumeAll_safety_wit_6`, `proof_of_LinklistResumeAll_safety_wit_7`, `proof_of_LinklistResumeAll_safety_wit_8`, `proof_of_LinklistResumeAll_safety_wit_9`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r1/groups/group_07__loop_safety/LinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/LinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__loop_safety`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of_LinklistResumeAll_safety_wit_4` — `LLM_pre_process`

Pattern A: unfold the whole VC and introduce all parameters; unfold INT_MIN/INT_MAX and use computation/lia to establish bounds for 1 on the arbitrary source heap. No witness, helper or state transition.
### `proof_of_LinklistResumeAll_safety_wit_5` — `LLM_pre_process`

Pattern C: unfold the whole VC and derive False from PreH1 next<>list_pre and PreH6 next=list_pre. The explicit branch contradiction holds on any heap; no resource transformation.
### `proof_of_LinklistResumeAll_safety_wit_6` — `LLM_pre_process`

Pattern C: unfold the whole VC and derive False from PreH1 next=list_pre and PreH7 next<>list_pre. The explicit branch contradiction holds on any heap; no resource transformation.
### `proof_of_LinklistResumeAll_safety_wit_7` — `LLM_pre_process`

Pattern A: unfold the whole VC and introduce all parameters; unfold INT_MIN/INT_MAX and use computation/lia to establish 1<>INT_MIN on the arbitrary source heap. No witness, helper or state transition.
### `proof_of_LinklistResumeAll_safety_wit_8` — `LLM_pre_process`

Pattern A: unfold the whole VC and introduce all parameters; unfold INT_MIN/INT_MAX and use computation/lia to establish bounds for 1 on the arbitrary source heap. No witness, helper or state transition.
### `proof_of_LinklistResumeAll_safety_wit_9` — `LLM_pre_process`

Pattern A: unfold the whole VC and introduce all parameters; unfold INT_MIN/INT_MAX and use computation/lia to establish bounds for 0 on the arbitrary source heap. No witness, helper or state transition.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r1/groups/group_07__loop_safety/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-debug",
      "--run",
      "LinklistResumeAll-20261030234941",
      "--round",
      "LinklistResumeAll-vc-proving-r1",
      "--group",
      "loop_safety"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "LinklistResumeAll-20261030234941",
      "--round",
      "LinklistResumeAll-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "loop_safety"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "LinklistResumeAll-20261030234941",
      "--round",
      "LinklistResumeAll-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "loop_safety"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/_coq_builds/LinklistResumeAll-vc-proving-r1/group_07/src/.coq_debug/group_07_loop_safety.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r1/groups/group_07__loop_safety/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r1/groups/group_07__loop_safety/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
