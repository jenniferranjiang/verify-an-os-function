# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `cleanup_transitions`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r2/groups/group_02__cleanup_transitions/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_entail_wit_2_1`, `proof_of_InitDataqueue_entail_wit_2_2`, `proof_of_InitDataqueue_entail_wit_2_3`, `proof_of_InitDataqueue_entail_wit_2_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_entail_wit_2_1` — `LLM_pre_process`

Use q=dataqueue_constructed n 0 (-1) (-1), refs=(None,None), held=after=observed. Cancel six fields and padding into store_dataqueue with empty buffer (no malloc bytes). Choose third disjunct. Instantiate actual malloc-failure phase, derive safeExec cleanup;;ret(-1) via high-step bind; choose Y=fun _=>X(-1) and establish universal final-return bridge via wp_bind/wp_ret. Retain os_inv and InsideCritical. Does not assume cleanup guard separately. This malloc-failure path has positive requested length.
### `proof_of_InitDataqueue_entail_wit_2_2` — `LLM_pre_process`

Use q=dataqueue_constructed n 0 (-1) (-1), refs=(None,None), held=after=observed. Cancel six fields and padding into store_dataqueue with empty buffer (no malloc bytes). Choose third disjunct. Instantiate actual malloc-failure phase, derive safeExec cleanup;;ret(-1) via high-step bind; choose Y=fun _=>X(-1) and establish universal final-return bridge via wp_bind/wp_ret. Retain os_inv and InsideCritical. Does not assume cleanup guard separately. This malloc-failure path has zero requested length; do not require n>0.
### `proof_of_InitDataqueue_entail_wit_2_3` — `LLM_pre_process`

Choose second disjunct and q=dataqueue_constructed n base (-5) (-1), refs=(None,None), held=observed, after=after_2. Get n range from UShort; normalize byte length with ABI and convert allocated bytes into slots, fold six fields/padding. Use failed first create effect and malloc success to build exact init phase and derive cleanup continuation Y and final-return bridge. Preserve current os_inv/InsideCritical; do not discard allocation.
### `proof_of_InitDataqueue_entail_wit_2_4` — `LLM_pre_process`

Choose first disjunct and q=dataqueue_constructed n base blank (-5), refs=(Some blank_ptr,None), held=observed, after=after_3. First successful create supplies blank_ptr/ref and fresh ID; second failed create retains it. Normalize byte length and fold object/array. Construct both effects in exact init phase and derive cleanup continuation Y plus return(-1) bridge. Do not assume deletion or discharge cleanup contract body here.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_02__cleanup_transitions/proof_reuse.md`.

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
      "/home/xinra/crtos-verify",
      "coq-debug",
      "--run",
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-vc-proving-r2",
      "--group",
      "cleanup_transitions"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  "development": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-vc-proving-r2",
      "--target-kind",
      "group-development",
      "--group",
      "cleanup_transitions"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  "check": {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "cleanup_transitions"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/_coq_builds/InitDataqueue-vc-proving-r2/group_02/src/.coq_debug/group_02_cleanup_transitions.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_02__cleanup_transitions/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r2/groups/group_02__cleanup_transitions/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
