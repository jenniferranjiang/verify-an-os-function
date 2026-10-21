# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `return_refinement`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_03__return_refinement/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_return_wit_1`, `proof_of__SemaphoreCreate_return_wit_1_split_goal_1`, `proof_of__SemaphoreCreate_return_wit_2`, `proof_of__SemaphoreCreate_return_wit_2_split_goal_1`, `proof_of__SemaphoreCreate_return_wit_3`, `proof_of__SemaphoreCreate_return_wit_3_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_03__return_refinement/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__return_refinement`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_return_wit_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_return_wit_1_split_goal_1`: Pure refinement only: start with safeExec (LastSeen before) (abs_semaphore_create sg val_pre) X. Use the atomic branch of choice, instantiate its observed prestate with locked via Crtos_RTrans before locked, and its poststate with replace_semaphores (semaphore_publish sem id val_pre (os_semaphores locked)) locked. Establish the success nrm alternative of abs_semaphore_create_locked using witness sem and the explicit nonzero, alignment, freshness, min-free-ID facts. The target LastSeen is precisely the rely closure of that poststate; use safeExec normal-transition/return rule. X is unchanged and no OS ownership is needed by this split.
### `proof_of__SemaphoreCreate_return_wit_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_return_wit_2_split_goal_1`: Pure refinement of the full-ID failure: use safeExec choice atomic branch and instantiate observed state locked using Crtos_RTrans before locked. Establish abs_semaphore_create_locked nrm locked (-5) locked with explicit idmanager_full; state is unchanged. Conclude safeExec (LastSeen locked) (ret (-5)) X via the normal transition rule. id=-1 is implementation bookkeeping, not the abstract result.
### `proof_of__SemaphoreCreate_return_wit_3` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_return_wit_3_split_goal_1`: Pure refinement of malloc failure: project safeExec for abs_semaphore_create to its immediate ret (-5) choice branch. LastSeen before is unchanged; use the choice/normal-transition rules. No lock observation or hypothetical ID-full premise is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_03__return_refinement/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-debug",
      "--run",
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--group",
      "return_refinement"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "return_refinement"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "return_refinement"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/_coq_builds/SemaphoreCreate-vc-proving-r1/group_03/src/.coq_debug/group_03_return_refinement.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_03__return_refinement/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_03__return_refinement/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
