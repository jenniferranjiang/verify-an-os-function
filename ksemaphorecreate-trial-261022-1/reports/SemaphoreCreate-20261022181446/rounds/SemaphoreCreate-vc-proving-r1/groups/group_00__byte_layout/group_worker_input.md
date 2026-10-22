# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `byte_layout`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_00__byte_layout/SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_2`, `proof_of__SemaphoreCreate_entail_wit_2_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_2_split_goal_2`, `proof_of__SemaphoreCreate_entail_wit_2_split_goal_3`, `proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/SemaphoreCreate-vc-proving-r1/groups/group_00__byte_layout/SemaphoreCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/VC/SemaphoreCreate_lib.v`
- Every new/adapted helper uses suffix `__byte_layout`. Preserve the seed.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/checks/implement-frozen-inputs.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Historical proofs are references only; check contract and dependency compatibility before reuse.

### `proof_of__SemaphoreCreate_entail_wit_2` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_2_split_goal_1`: P contains CharArray.full retval 32 (repeat_Z 0 32) and OutsideCritical; Q is the pure nonzero management-link address. Use malloc positivity, upper bound and ALIGN_SIZE alignment with the frozen SemaphoreByteLayout bridge/layout premise to express the link as retval+24, then arithmetic. Do not infer a node base nonzero merely from pointer-cell ownership.

- Split `proof_of__SemaphoreCreate_entail_wit_2_split_goal_2`: Same byte-array P and unchanged critical frame; use the verified layout bridge to rewrite pend_list to retval+16 and derive nonzero from retval>0. The premise establishing allocation bounds is explicit.

- Split `proof_of__SemaphoreCreate_entail_wit_2_split_goal_3`: Pure alignment projection: the malloc alignment premise is addr_aligned retval ALIGN_SIZE. Reduce the current ALIGN_SIZE to the 4-byte alignment required by the cut; frame the array and critical resource.

- Split `proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial`: Convert precisely 32 repeated-zero bytes into SemaphoreZero retval using the frozen imported SemaphoreByteLayout lemmas, supplied malloc positivity/bound/alignment and explicit layout premise. Preserve the OutsideCritical frame; include ID/value, both nodes and padding, without changing the memset contract or treating the conversion itself as an axiom.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_00__byte_layout/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-debug",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--group",
      "byte_layout"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "byte_layout"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "byte_layout"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/verification_runs/SemaphoreCreate-20261022181446/_coq_builds/SemaphoreCreate-vc-proving-r1/group_00/src/.coq_debug/group_00_byte_layout.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_00__byte_layout/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-proving-r1/groups/group_00__byte_layout/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
