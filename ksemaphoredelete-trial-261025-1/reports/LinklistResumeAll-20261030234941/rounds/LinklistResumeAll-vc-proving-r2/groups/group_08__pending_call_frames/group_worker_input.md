# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `pending_call_frames`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r2/groups/group_08__pending_call_frames/LinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_partial_solve_wit_3`, `proof_of_LinklistResumeAll_partial_solve_wit_4`, `proof_of_LinklistResumeAll_partial_solve_wit_5_pure`, `proof_of_LinklistResumeAll_partial_solve_wit_5`, `proof_of_LinklistResumeAll_partial_solve_wit_6_pure`, `proof_of_LinklistResumeAll_partial_solve_wit_6`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r2/groups/group_08__pending_call_frames/LinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/LinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__pending_call_frames`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of_LinklistResumeAll_partial_solve_wit_3` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Preserve the same next field and resume_next_restore at current; nonempty-branch facts are PreH1..10.
### `proof_of_LinklistResumeAll_partial_solve_wit_4` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Preserve the same next field/wand in the nil branch; facts are PreH1..9.
### `proof_of_LinklistResumeAll_partial_solve_wit_5_pure` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. PreH5,6,4 give remaining=target::rest, next=sched_link_of target and pending nodes.
### `proof_of_LinklistResumeAll_partial_solve_wit_5` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Aux repeats PreH1..11 and retains os_inv current.
### `proof_of_LinklistResumeAll_partial_solve_wit_6_pure` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Alignment is PreH3 and next=sched_link_of target is PreH2, already supplied by descriptor extraction.
### `proof_of_LinklistResumeAll_partial_solve_wit_6` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Aux repeats PreH1..17 and retains os_inv current.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r2/groups/group_08__pending_call_frames/proof_reuse.md`.

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
      "LinklistResumeAll-vc-proving-r2",
      "--group",
      "pending_call_frames"
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
      "LinklistResumeAll-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "pending_call_frames"
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
      "LinklistResumeAll-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "pending_call_frames"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/_coq_builds/LinklistResumeAll-vc-proving-r2/group_08/src/.coq_debug/group_08_pending_call_frames.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r2/groups/group_08__pending_call_frames/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r2/groups/group_08__pending_call_frames/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
