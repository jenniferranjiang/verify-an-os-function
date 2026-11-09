# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `loop_step`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_01__loop_step/MutexResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_entail_wit_4_1`, `proof_of_LinklistResumeAll_entail_wit_4_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_01__loop_step/MutexResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexResumeAll_lib.v`
- Every new/adapted helper uses suffix `__loop_step`. Preserve the seed.

### `proof_of_LinklistResumeAll_entail_wit_4_1` — `LLM_pre_process`

Select the full spatial disjunct. after=marked gives os_inv marked. Task ID manager uniqueness identifies task=target from the two get_task_with_idnode_success facts. Rewrite marked.task_desc_map(target) to Some(set_task_desc_exstatus desc (-1)); it preserves SUSPEND, contradicting the returned non-SUSPEND branch. Discharge the whole entailment by this contradiction; no fictitious wakeup transition is needed.
### `proof_of_LinklistResumeAll_entail_wit_4_2` — `LLM_pre_process`

Select the full spatial disjunct and instantiate current=after and remaining=rest. Frame InsideCritical and weaken task/node local cells. Use unchanged task ID manager in ktask_wakeup_step plus os_inv after to identify the returned task with target and returned desc with set_task_desc_exstatus desc (-1). Build mutex_resume_one from old pending/task-map facts. Prepend this step to any future tail steps to discharge mutex_resume_remaining_effect. Forall2 Mutex removal preserves object address/id; infer the exact target tail by remove_found_prop and post-invariant READY-versus-SUSPEND exclusion (duplicate surviving target waiters are impossible), yielding live and pending(rest). Do not assume old os_inv is still owned after the call.

## Helpers

- `wakeup_known_mutex_head__loop_step` (local): Establish the exact facts required after a general wakeup: two successful same-ID lookups in marked, current target map/desc, marked=exstatus update, old pending target::rest, and os_inv after plus the normal ktask_wakeup_step imply task=target, desc2=set_task_desc_exstatus desc(-1), preserved mutex identity and pending rest. Derive lookup uniqueness using the unchanged ID manager and the actual post invariant; derive exact source removal using Forall2/remove_found and post READY/SUSPEND exclusion. Preserve all old logical relations, but do not require old heap ownership which is absent here. Prove pure helpers for Forall2 identity/pending and step-prepending as needed under this group suffix.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_01__loop_step/proof_reuse.md`.

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
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "MutexResumeAll-20261103170225",
      "--round",
      "MutexResumeAll-vc-proving-r1",
      "--group",
      "loop_step"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-check",
      "--run",
      "MutexResumeAll-20261103170225",
      "--round",
      "MutexResumeAll-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "loop_step"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-check",
      "--run",
      "MutexResumeAll-20261103170225",
      "--round",
      "MutexResumeAll-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "loop_step"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/_coq_builds/MutexResumeAll-vc-proving-r1/group_01/src/.coq_debug/group_01_loop_step.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_01__loop_step/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_01__loop_step/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
