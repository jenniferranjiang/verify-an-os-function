# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `call_preconditions`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/InsertObj-vc-proving-r2/groups/group_03__call_preconditions/InsertObj_proof_manual.v`.
- Editable proof spans: `proof_of_InsertObj_partial_solve_wit_1_pure`, `proof_of_InsertObj_partial_solve_wit_1`, `proof_of_InsertObj_partial_solve_wit_2_pure`, `proof_of_InsertObj_partial_solve_wit_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_InsertObj_partial_solve_wit_1_pure` — `LLM_pre_process`

Pattern P. For InitDoubleLinkList, P includes local pointer cells and complete empty-bucket frame; Q is head=head and head<>0. Reflexivity and PreH2 discharge the pure goal. No spatial rewrite, witness or transition.
### `proof_of_InsertObj_partial_solve_wit_1` — `LLM_pre_process`

Pattern P. Introduce the pure-premise implication then unfold the aux obligation; do not rely on another assigned proof. Retain all listed pure facts from PreH1..13, add head=head and head<>0, and weaken the two exact head prev/next zero stores to typed undef stores. Reorder/cancel every manager, bitmap, node and bucket-except resource. No extra resource or existential is required.
### `proof_of_InsertObj_partial_solve_wit_2_pure` — `LLM_pre_process`

Pattern P. For insertion call, its three required nonzero facts are precisely PreH2 (head), PreH4 (new embedded link) and PreH3 (successor). P includes unchanged local cells and insertion-ready heap; derive the pure conjunction directly, with no address-layout inference.
### `proof_of_InsertObj_partial_solve_wit_2` — `LLM_pre_process`

Pattern P. Introduce the pure-premise implication and prove the aux obligation directly from PreH1..14. Target has precisely the same head.next, successor.prev, detached link undef cells, manager fields, bitmap, node id, bucket-except and shifted-reverse resources; reorder and cancel. Preserve all pure facts including link<>0 and idnodes_nonzero, without using sibling proofs.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/InsertObj-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r2/groups/group_03__call_preconditions/proof_reuse.md`.

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
      "InsertObj-20261012130948",
      "--round",
      "InsertObj-vc-proving-r2",
      "--group",
      "call_preconditions"
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
      "InsertObj-20261012130948",
      "--round",
      "InsertObj-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "call_preconditions"
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
      "InsertObj-20261012130948",
      "--round",
      "InsertObj-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "call_preconditions"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InsertObj-20261012130948/_coq_builds/InsertObj-vc-proving-r2/group_03/src/.coq_debug/group_03_call_preconditions.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r2/groups/group_03__call_preconditions/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-proving-r2/groups/group_03__call_preconditions/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
