# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `return_increment`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/CriticalAreaLock-20261012130948/CriticalAreaLock-vc-proving-r1/groups/group_01__return_increment/CriticalAreaLock_proof_manual.v`.
- Editable proof spans: `proof_of_CriticalAreaLock_return_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_CriticalAreaLock_return_wit_1` — `LLM_pre_process`

Unfold the whole definition; its two disjuncts are identical, so select one and introduce before, hs, sg, current_2, lock and PreH1..4. Preserve PreH2 intact and derive current_2.scheduler_lock_nest < 65535 using SemaphoreRely_preserves_create_domain with PreH2 and PreH3; derive the lower bound 0 <= current_2.scheduler_lock_nest from PreH4 (CrtosOSValid). Thus 0 <= n+1 < 65536, including n=65534. Normalize unsigned_last_nbits (n+1) 16 to n+1 via its exact modulo definition and Z.mod_small/int_auto. Instantiate the result existential with current_2, not the incremented state; the inside token and Rely are indexed by the pre-increment protected observation. Reintroduce the pure CrtosOSValid current_2 and use accepted SemaphoreOSInvariant_merge_increment sg current_2 under the unchanged SemaphoreInsideCritical frame. Its premise is exactly the physical UShort cell n+1 ** SemaphoreCriticalFrame sg current_2, and its conclusion is OSInvariant sg (semaphore_nest_increment current_2). Supply handler_ok/Rely from PreH1/PreH2 and finish by separation reassociation/cancellation. No new STS step occurs here: the C write changes only physical nest and the protected token remains at current_2. No new helper is allowed because formal_case_lib is absent.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/CriticalAreaLock-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaLock-20261012130948/rounds/CriticalAreaLock-vc-proving-r1/groups/group_01__return_increment/proof_reuse.md`.

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
      "return_increment"
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
      "return_increment"
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
      "return_increment"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/CriticalAreaLock-20261012130948/_coq_builds/CriticalAreaLock-vc-proving-r1/group_01/src/.coq_debug/group_01_return_increment.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaLock-20261012130948/rounds/CriticalAreaLock-vc-proving-r1/groups/group_01__return_increment/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaLock-20261012130948/rounds/CriticalAreaLock-vc-proving-r1/groups/group_01__return_increment/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
