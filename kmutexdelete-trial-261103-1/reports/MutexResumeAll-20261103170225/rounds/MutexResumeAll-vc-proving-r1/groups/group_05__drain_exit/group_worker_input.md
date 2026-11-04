# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `drain_exit`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_05__drain_exit/MutexResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_which_implies_wit_9`, `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1`, `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2`, `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3`, `proof_of_LinklistResumeAll_return_wit_1`, `proof_of_LinklistResumeAll_return_wit_1_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/MutexResumeAll-vc-proving-r1/groups/group_05__drain_exit/MutexResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/kmutexdelete-trial-261103-1/VC/MutexResumeAll_lib.v`
- Every new/adapted helper uses suffix `__drain_exit`. Preserve the seed.

### `proof_of_LinklistResumeAll_which_implies_wit_9` — `aggressive_pre_process`

- Split `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1`: Unfold mutex_resume_remaining_effect, use remaining=nil and reflexive nil steps to obtain the actual aggregate effect from st_lock to current. original membership/address/id and the live guard at st_lock witness a normal abs_mutex_resume_all_locked execution. With Crtos_RTrans before st_lock, lift it through mutex_delete_scoped_atomic and specialize the entry safeExec to establish safeExec(LastSeen current, ret tt, X). Preserve the original continuation; do not assume the Prop obligation as a lemma.

- Split `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2`: Unfold the existing Crtos_GTrans/Crtos_CS relation, which is True; discharge directly. No state equality or extra environment freezing is required.

- Split `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3`: Use remaining_effect at nil to obtain aggregate effect. Case split original.pending: empty gives current=st_lock and choose original; nonempty gives current Mutex sequence=mutex_delete_set_pending p nil st_lock.os_mutexes, so choose the mapped original retaining its ID and address. Combine p<>0/id range from live current or live st_lock. This avoids relying on a potentially different object witnessing pending_nodes in pure malformed states.
### `proof_of_LinklistResumeAll_return_wit_1` — `aggressive_pre_process`

- Split `proof_of_LinklistResumeAll_return_wit_1_split_goal_1`: The generated split target is only 0=KOK. Unfold KOK (0) and use reflexivity. Parent regeneration supplies the current after witness and preserves OutsideCritical from the stated post-lock facts.

## Helpers

- `resume_effect_keeps_drained_identity__drain_exit` (public): Pure lemma: original in before.os_mutexes, address p, ID id, live p id before, and mutex_resume_all_effect p original.pending before after imply mutex_delete_drained p id after. Prove by nil/nonempty pending and membership of mapped original; it does not require a new uniqueness premise.
- `scoped_resume_safe_continuation__drain_exit` (public): Prove safeExec continuation transfer for the concrete normal scoped execution witnessed by st_lock, original and current, with RTrans before st_lock, live guard and aggregate effect. Unfold safeExec/LastSeen/scoped atomic or use their actual normal-execution rules; quantify X unchanged and construct exactly the next observation set Crtos_RTrans current.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_05__drain_exit/proof_reuse.md`.

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
      "drain_exit"
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
      "drain_exit"
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
      "drain_exit"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/kmutexdelete-trial-261103-1/verification_runs/MutexResumeAll-20261103170225/_coq_builds/MutexResumeAll-vc-proving-r1/group_05/src/.coq_debug/group_05_drain_exit.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_05__drain_exit/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexResumeAll-20261103170225/rounds/MutexResumeAll-vc-proving-r1/groups/group_05__drain_exit/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
