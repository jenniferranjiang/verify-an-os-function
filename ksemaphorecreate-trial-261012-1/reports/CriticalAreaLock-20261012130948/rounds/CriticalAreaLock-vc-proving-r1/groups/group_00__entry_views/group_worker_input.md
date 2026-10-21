# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `entry_views`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/CriticalAreaLock-20261012130948/CriticalAreaLock-vc-proving-r1/groups/group_00__entry_views/CriticalAreaLock_proof_manual.v`.
- Editable proof spans: `proof_of_CriticalAreaLock_entail_wit_1`, `proof_of_CriticalAreaLock_entail_wit_1_split_goal_1`, `proof_of_CriticalAreaLock_entail_wit_1_split_goal_spatial`, `proof_of_CriticalAreaLock_partial_solve_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_CriticalAreaLock_entail_wit_1` — `aggressive_pre_process`

- Split `proof_of_CriticalAreaLock_entail_wit_1_split_goal_1`: Unfold the split definition and introduce before, hs, sg, retval, current and PreH1..3. P owns InsideCritical ** OSInvariant and Q is only pure CrtosOSValid current. Obtain this pure fact directly from the second conjunct of PreH2 : SemaphoreRely hs before current (unfold SemaphoreRely in a copy of PreH2), then pure introduction/entailer. Alternatively extract it using SemaphoreOSInvariant_valid. No existential, address conversion or protocol transition is required; do not unfold or duplicate the inside token.

- Split `proof_of_CriticalAreaLock_entail_wit_1_split_goal_spatial`: Unfold the split definition and introduce quantified inputs. Frame the unchanged SemaphoreInsideCritical sg hs retval current and apply accepted SemaphoreOSInvariant_split_nest sg current to the single owned invariant. It exposes the identical global KTaskOsAssignLockNest UShort cell with current.scheduler_lock_nest plus SemaphoreCriticalFrame sg current. Drop the extra pure valid conjunct and reassociate separation with entailer. No existential or state update is needed; retain the same inside token and the exact heap frame.
### `proof_of_CriticalAreaLock_partial_solve_wit_1` — `LLM_pre_process`

Unfold the whole goal, introduce before, hs, sg and PreH1. P and Q have exactly the same SemaphoreOutsideCritical sg hs before resource; introduce the pure conjunction using the already supplied PreH1 : before.scheduler_lock_nest < 65535 and reflexive resource entailment/entailer. No allocation, existential, helper, protocol step or alteration of the domain is needed. Prove this witness independently to Qed; do not reuse the raw auto module admitted witness.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/CriticalAreaLock-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaLock-20261012130948/rounds/CriticalAreaLock-vc-proving-r1/groups/group_00__entry_views/proof_reuse.md`.

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
      "CriticalAreaLock-20261012130948",
      "--round",
      "CriticalAreaLock-vc-proving-r1",
      "--group",
      "entry_views"
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
      "CriticalAreaLock-20261012130948",
      "--round",
      "CriticalAreaLock-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "entry_views"
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
      "CriticalAreaLock-20261012130948",
      "--round",
      "CriticalAreaLock-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "entry_views"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/CriticalAreaLock-20261012130948/_coq_builds/CriticalAreaLock-vc-proving-r1/group_00/src/.coq_debug/group_00_entry_views.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaLock-20261012130948/rounds/CriticalAreaLock-vc-proving-r1/groups/group_00__entry_views/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaLock-20261012130948/rounds/CriticalAreaLock-vc-proving-r1/groups/group_00__entry_views/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
