# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `nest_resources`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/CriticalAreaUnLock-20261012130948/CriticalAreaUnLock-vc-proving-r1/groups/group_00__nest_resources/CriticalAreaUnLock_proof_manual.v`.
- Editable proof spans: `proof_of_CriticalAreaUnLock_entail_wit_1`, `proof_of_CriticalAreaUnLock_entail_wit_1_split_goal_1`, `proof_of_CriticalAreaUnLock_entail_wit_1_split_goal_spatial`, `proof_of_CriticalAreaUnLock_entail_wit_2_1`, `proof_of_CriticalAreaUnLock_entail_wit_2_1_split_goal_spatial`, `proof_of_CriticalAreaUnLock_entail_wit_2_2`, `proof_of_CriticalAreaUnLock_entail_wit_2_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_CriticalAreaUnLock_entail_wit_1` — `aggressive_pre_process`

- Split `proof_of_CriticalAreaUnLock_entail_wit_1_split_goal_1`: Introduce the quantified parameters and retained IRQ/guarantee hypotheses. Apply SemaphoreOSInvariant_split_nest to the invariant while framing SemaphoreInsideCritical. Its pure CrtosOSValid after component implies the pure conclusion; no fresh state or token is required.

- Split `proof_of_CriticalAreaUnLock_entail_wit_1_split_goal_spatial`: Introduce parameters; apply SemaphoreOSInvariant_split_nest to SemaphoreOSInvariant sg after, frame the unchanged SemaphoreInsideCritical sg hs lock_pre before, and discharge the resulting pure validity by projection. The precise UShort cell is at the same KTaskOsAssignLockNest address and the remaining resource is exactly SemaphoreCriticalFrame sg after. Reassociate/cancel these three resources.
### `proof_of_CriticalAreaUnLock_entail_wit_2_1` — `aggressive_pre_process`

- Split `proof_of_CriticalAreaUnLock_entail_wit_2_1_split_goal_spatial`: Let n = scheduler_lock_nest (os_scheduler after). Extract 0 <= n <= 65535 from the given CrtosOSValid after; the branch guard gives n >= 1. Thus 0 <= n-1 < 65536. Unfold unsigned_last_nbits and normalize its 16-bit modulus with Z.mod_small, then rewrite Z.max 0 (n-1) = n-1. Use SemaphoreOSInvariant_merge_decrement with the explicit validity hypothesis, the updated UShort cell, and SemaphoreCriticalFrame sg after. Frame and cancel the unchanged SemaphoreInsideCritical. This proves the exact decrement target; no guarantee or IRQ transition is synthesized.
### `proof_of_CriticalAreaUnLock_entail_wit_2_2` — `aggressive_pre_process`

- Split `proof_of_CriticalAreaUnLock_entail_wit_2_2_split_goal_spatial`: Let n = scheduler_lock_nest (os_scheduler after). CrtosOSValid after gives 0 <= n and the false-guard branch gives n < 1, hence n = 0. Rewrite the unchanged UShort value as Z.max 0 (n-1), which is also zero. Apply SemaphoreOSInvariant_merge_decrement with the given validity and SemaphoreCriticalFrame sg after, framing SemaphoreInsideCritical. This covers the source no-write branch without assuming positive nesting.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/CriticalAreaUnLock-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaUnLock-20261012130948/rounds/CriticalAreaUnLock-vc-proving-r1/groups/group_00__nest_resources/proof_reuse.md`.

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
      "CriticalAreaUnLock-20261012130948",
      "--round",
      "CriticalAreaUnLock-vc-proving-r1",
      "--group",
      "nest_resources"
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
      "CriticalAreaUnLock-20261012130948",
      "--round",
      "CriticalAreaUnLock-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "nest_resources"
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
      "CriticalAreaUnLock-20261012130948",
      "--round",
      "CriticalAreaUnLock-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "nest_resources"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/CriticalAreaUnLock-20261012130948/_coq_builds/CriticalAreaUnLock-vc-proving-r1/group_00/src/.coq_debug/group_00_nest_resources.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaUnLock-20261012130948/rounds/CriticalAreaUnLock-vc-proving-r1/groups/group_00__nest_resources/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaUnLock-20261012130948/rounds/CriticalAreaUnLock-vc-proving-r1/groups/group_00__nest_resources/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
