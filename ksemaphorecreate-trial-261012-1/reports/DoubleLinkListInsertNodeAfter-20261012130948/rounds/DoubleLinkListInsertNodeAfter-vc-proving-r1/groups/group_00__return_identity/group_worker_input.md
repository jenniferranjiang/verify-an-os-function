# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `return_identity`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/DoubleLinkListInsertNodeAfter-20261012130948/DoubleLinkListInsertNodeAfter-vc-proving-r1/groups/group_00__return_identity/DoubleLinkListInsertNodeAfter_proof_manual.v`.
- Editable proof spans: `proof_of_DoubleLinkListInsertNodeAfter_return_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_DoubleLinkListInsertNodeAfter_return_wit_1` — `LLM_pre_process`

Unfold DoubleLinkListInsertNodeAfter_return_wit_1 and introduce linklist_node_pre, linklist_pre, successor and their three nonzero premises. The antecedent and consequent are syntactically identical separating conjunctions of four Ptr cells: linklist.node_next maps to linklist_node, successor.node_prev maps to linklist_node, linklist_node.node_next maps to successor, and linklist_node.node_prev maps to linklist. Close by entailment reflexivity (or cancel all four cells). There are no existential witnesses, array/list transformations, arithmetic bounds, abstract-state refinements or extra premises. No helper is needed. Use only the whole top-level obligation under LLM_pre_process.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/DoubleLinkListInsertNodeAfter-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/DoubleLinkListInsertNodeAfter-20261012130948/rounds/DoubleLinkListInsertNodeAfter-vc-proving-r1/groups/group_00__return_identity/proof_reuse.md`.

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
      "DoubleLinkListInsertNodeAfter-20261012130948",
      "--round",
      "DoubleLinkListInsertNodeAfter-vc-proving-r1",
      "--group",
      "return_identity"
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
      "DoubleLinkListInsertNodeAfter-20261012130948",
      "--round",
      "DoubleLinkListInsertNodeAfter-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "return_identity"
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
      "DoubleLinkListInsertNodeAfter-20261012130948",
      "--round",
      "DoubleLinkListInsertNodeAfter-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "return_identity"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/DoubleLinkListInsertNodeAfter-20261012130948/_coq_builds/DoubleLinkListInsertNodeAfter-vc-proving-r1/group_00/src/.coq_debug/group_00_return_identity.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/DoubleLinkListInsertNodeAfter-20261012130948/rounds/DoubleLinkListInsertNodeAfter-vc-proving-r1/groups/group_00__return_identity/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/DoubleLinkListInsertNodeAfter-20261012130948/rounds/DoubleLinkListInsertNodeAfter-vc-proving-r1/groups/group_00__return_identity/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
