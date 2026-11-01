# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `loop_step`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r1/groups/group_04__loop_step/LinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_entail_wit_2`, `proof_of_LinklistResumeAll_partial_solve_wit_13_pure`, `proof_of_LinklistResumeAll_partial_solve_wit_13`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r1/groups/group_04__loop_step/LinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC/LinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__loop_step`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of_LinklistResumeAll_entail_wit_2` — `LLM_pre_process`

Choose left whole disjunct; instantiate current=next_state and remaining=rest. Forget task/node values with retval/next witnesses and cancel os_inv next_state. For resume_remaining_effect, take arbitrary final with tail steps, apply PreH36 after remaining_2=target::rest, and prepend semaphore_resume_one from current_2 to next_state. PreH8 yields the semaphore object and exact task::rest pending list via injectivity of sched_link_node/map. Use desc from PreH14 and SUSPEND PreH24. Rewrite marked using PreH9 and its map update: PreH3 forces woke_desc=set_task_desc_exstatus desc (-1); now PreH5 is the required wakeup step. PreH6 is next pending nodes; PreH27/28 give head equality/nonzero. This composes the existing continuation and needs no steps-to-effect theorem.
### `proof_of_LinklistResumeAll_partial_solve_wit_13_pure` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. PreH5,6,7 give task_id bound, marked ID lookup and marked pending relation. resume_task_id local cell is context.
### `proof_of_LinklistResumeAll_partial_solve_wit_13` — `LLM_pre_process`

Pattern P: unfold the whole VC and its _aux when present, introduce parameters and PreH, establish every pure conjunct from the explicit premises, and cancel the identical spatial resources. For pure-only conclusions use pure introduction on the arbitrary heap; do not require emp. For a pure -> aux VC, introduce the premise; aux facts follow from its own PreH. Aux repeats PreH1..30 and cancels os_inv marked before Wakeup. Nonnegative task_id is already PreH4.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r1/groups/group_04__loop_step/proof_reuse.md`.

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
      "loop_step"
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
      "loop_step"
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
      "loop_step"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/LinklistResumeAll-20261030234941/_coq_builds/LinklistResumeAll-vc-proving-r1/group_04/src/.coq_debug/group_04_loop_step.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r1/groups/group_04__loop_step/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-proving-r1/groups/group_04__loop_step/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
