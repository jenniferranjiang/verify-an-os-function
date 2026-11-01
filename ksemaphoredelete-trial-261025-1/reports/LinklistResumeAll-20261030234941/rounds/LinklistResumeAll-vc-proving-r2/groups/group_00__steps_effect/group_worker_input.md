# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `steps_effect`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r2/groups/group_00__steps_effect/LinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_entail_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r2/groups/group_00__steps_effect/LinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/LinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__steps_effect`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of_LinklistResumeAll_entail_wit_1` — `LLM_pre_process`

Choose the left whole disjunct, since the pure-only alternative discards the legal heap needed by steps-to-effect. Instantiate current=before_semaphore_waiters and remaining=waiting_semaphore_waiters. Apply steps_to_effect__steps_effect with PreH3 and os_inv before to establish resume_remaining_effect. Preserve the same os_inv, forget task/node/lock values using witnesses 0 and cancel all three cells. The transition is arbitrary full-list steps from before to final, producing the exact batch effect. The Definition semaphore_resume_all_effect_steps_obligation is a proposition, not a proved lemma.

## Helpers

- `steps_to_effect__steps_effect` (public): Prove forall sg p waiting before, semaphore_pending_nodes p before (map sched_link_node waiting) -> os_inv sg before |-- “ (forall final, semaphore_resume_all_steps p waiting before final -> semaphore_resume_all_effect p waiting before final) ”. Both premises are present in entail_wit_1. Extract semaphore membership, NoDup waiting, suspended registered descriptors and legal delay/scheduler shapes from the heap. Induct over waiting and steps with a prefix/suffix invariant. Show later distinct task lookups equal original-map lookups; per-step updates change only stat/exstatus. Compose ready insertions into resume_all_ready by proving their insensitivity to earlier stat/exstatus map updates. Show repeated delay cancellation equals the batch selected-delay filter/find, using initial active-node uniqueness and active/inactive disjointness, including zero, inactive and repeated delay pointer cases. Compose semaphore_set_pending and every preserved global component, then extensionality gives the batch state. Nil is final=before. Prove required algebraic facts within this helper family without assuming the obligation Definition or importing sibling output.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r2/groups/group_00__steps_effect/proof_reuse.md`.

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
      "steps_effect"
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
      "steps_effect"
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
      "steps_effect"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/_coq_builds/LinklistResumeAll-vc-proving-r2/group_00/src/.coq_debug/group_00_steps_effect.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r2/groups/group_00__steps_effect/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r2/groups/group_00__steps_effect/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
