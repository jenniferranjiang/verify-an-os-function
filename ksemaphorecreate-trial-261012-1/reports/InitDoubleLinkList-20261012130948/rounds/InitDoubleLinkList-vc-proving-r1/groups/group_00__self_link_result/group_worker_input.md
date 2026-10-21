# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `self_link_result`; difficulty hint: 1/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InitDoubleLinkList-20261012130948/InitDoubleLinkList-vc-proving-r1/groups/group_00__self_link_result/InitDoubleLinkList_proof_manual.v`.
- Editable proof spans: `proof_of_InitDoubleLinkList_return_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_InitDoubleLinkList_return_wit_1` — `LLM_pre_process`

Unfold InitDoubleLinkList_return_wit_1 and introduce linklist_head_pre, head, PreH1 and PreH2. The antecedent owns node_next and node_prev at the linklist_head_pre structure, each storing linklist_head_pre; the consequent owns exactly those same fields, each storing head. Rewrite or substitute with PreH1 : linklist_head_pre = head, then close the identical separating conjunction entailment by reflexivity (or ordinary separation cancellation). There are no existential witnesses, list transformations, arithmetic obligations, frame changes or refinement transitions. PreH2 : head <> 0 is available but unnecessary. No helper is needed or permitted under the absent formal_case_lib policy.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InitDoubleLinkList-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InitDoubleLinkList-20261012130948/rounds/InitDoubleLinkList-vc-proving-r1/groups/group_00__self_link_result/proof_reuse.md`.

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
      "InitDoubleLinkList-20261012130948",
      "--round",
      "InitDoubleLinkList-vc-proving-r1",
      "--group",
      "self_link_result"
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
      "InitDoubleLinkList-20261012130948",
      "--round",
      "InitDoubleLinkList-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "self_link_result"
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
      "InitDoubleLinkList-20261012130948",
      "--round",
      "InitDoubleLinkList-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "self_link_result"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/InitDoubleLinkList-20261012130948/_coq_builds/InitDoubleLinkList-vc-proving-r1/group_00/src/.coq_debug/group_00_self_link_result.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InitDoubleLinkList-20261012130948/rounds/InitDoubleLinkList-vc-proving-r1/groups/group_00__self_link_result/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InitDoubleLinkList-20261012130948/rounds/InitDoubleLinkList-vc-proving-r1/groups/group_00__self_link_result/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
