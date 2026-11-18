# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `native_manual_restore`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261118165045/InitDataqueue-vc-proving-r1/groups/group_00__native_manual_restore/InitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_InitDataqueue_safety_wit_12`, `proof_of_InitDataqueue_safety_wit_12_split_goal_1`, `proof_of_InitDataqueue_safety_wit_12_split_goal_2`, `proof_of_InitDataqueue_entail_wit_1`, `proof_of_InitDataqueue_entail_wit_2_1`, `proof_of_InitDataqueue_entail_wit_2_2`, `proof_of_InitDataqueue_entail_wit_2_3`, `proof_of_InitDataqueue_entail_wit_2_4`, `proof_of_InitDataqueue_return_wit_1`, `proof_of_InitDataqueue_return_wit_2`, `proof_of_InitDataqueue_return_wit_3`, `proof_of_InitDataqueue_return_wit_4`, `proof_of_InitDataqueue_which_implies_wit_1`, `proof_of_InitDataqueue_which_implies_wit_1_split_goal_1`, `proof_of_InitDataqueue_which_implies_wit_1_split_goal_2`, `proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial`, `proof_of_InitDataqueue_which_implies_wit_2`, `proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_InitDataqueue_safety_wit_12` — `aggressive_pre_process`

- Split `proof_of_InitDataqueue_safety_wit_12_split_goal_1`: Use max_len or NodeNumber UShort store to derive 0<=NodeNumber_pre<=65535; frame all memory and prove NodeNumber_pre-1<=INT_MAX by arithmetic.

- Split `proof_of_InitDataqueue_safety_wit_12_split_goal_2`: Use same UShort range to prove INT_MIN<=NodeNumber_pre-1; frame remaining memory.
### `proof_of_InitDataqueue_entail_wit_1` — `LLM_pre_process`

Select LEFT whole-goal alternative (right fallback incorrectly requires the pre-publication map already contains q). Derive 0<=n<=65535 from max_len UShort; use ABI DataElem size8 and malloc bounds to eliminate 32-bit multiplication truncation, establish n>0. Build q=dataqueue_constructed n base blank data, convert bytes to repeat None slots, fold store_dataqueue. Derive map p=None by store_map_split plus exclusive duplicate private/shared front store. Two create effects yield distinct fresh IDs and exact semaphore refs. Choose after=replace_dataqueues(dataqueue_publish p q after_3.os_dataqueues) after_3, insert cell with MapLib, preserve task/other global records explicitly where indexed by full state. Show ready and sem association. Construct init-phase high step from observed; apply safeExec/highstepbind_derive to return0 and GTrans. Preserve InsideCritical. Extra alignment premise is available, not a new requirement.
### `proof_of_InitDataqueue_entail_wit_2_1` — `LLM_pre_process`

Use q=dataqueue_constructed n 0 (-1) (-1), refs=(None,None), held=after=observed. Cancel six fields and padding into store_dataqueue with empty buffer (no malloc bytes). Choose third disjunct. Instantiate actual malloc-failure phase, derive safeExec cleanup;;ret(-1) via high-step bind; choose Y=fun _=>X(-1) and establish universal final-return bridge via wp_bind/wp_ret. Retain os_inv and InsideCritical. Does not assume cleanup guard separately. This malloc-failure path has positive requested length.
### `proof_of_InitDataqueue_entail_wit_2_2` — `LLM_pre_process`

Use q=dataqueue_constructed n 0 (-1) (-1), refs=(None,None), held=after=observed. Cancel six fields and padding into store_dataqueue with empty buffer (no malloc bytes). Choose third disjunct. Instantiate actual malloc-failure phase, derive safeExec cleanup;;ret(-1) via high-step bind; choose Y=fun _=>X(-1) and establish universal final-return bridge via wp_bind/wp_ret. Retain os_inv and InsideCritical. Does not assume cleanup guard separately. This malloc-failure path has zero requested length; do not require n>0.
### `proof_of_InitDataqueue_entail_wit_2_3` — `LLM_pre_process`

Choose second disjunct and q=dataqueue_constructed n base (-5) (-1), refs=(None,None), held=observed, after=after_2. Get n range from UShort; normalize byte length with ABI and convert allocated bytes into slots, fold six fields/padding. Use failed first create effect and malloc success to build exact init phase and derive cleanup continuation Y and final-return bridge. Preserve current os_inv/InsideCritical; do not discard allocation.
### `proof_of_InitDataqueue_entail_wit_2_4` — `LLM_pre_process`

Choose first disjunct and q=dataqueue_constructed n base blank (-5), refs=(Some blank_ptr,None), held=observed, after=after_3. First successful create supplies blank_ptr/ref and fresh ID; second failed create retains it. Normalize byte length and fold object/array. Construct both effects in exact init phase and derive cleanup continuation Y plus return(-1) bridge. Do not assume deletion or discharge cleanup contract body here.
### `proof_of_InitDataqueue_return_wit_1` — `LLM_pre_process`

Choose q=dataqueue_retired q_3, after=after_4; select the disjunct matching (-1,-5), (-5,-1), or (-1,-1) respectively for return1,2,3. Unfold retired only for fields, preserve store_dataqueue/OutsideCritical, apply given forall-final bridge to safeExec return tt Y.
### `proof_of_InitDataqueue_return_wit_2` — `LLM_pre_process`

Choose q=dataqueue_retired q_3, after=after_4; select the disjunct matching (-1,-5), (-5,-1), or (-1,-1) respectively for return1,2,3. Unfold retired only for fields, preserve store_dataqueue/OutsideCritical, apply given forall-final bridge to safeExec return tt Y.
### `proof_of_InitDataqueue_return_wit_3` — `LLM_pre_process`

Choose q=dataqueue_retired q_3, after=after_4; select the disjunct matching (-1,-5), (-5,-1), or (-1,-1) respectively for return1,2,3. Unfold retired only for fields, preserve store_dataqueue/OutsideCritical, apply given forall-final bridge to safeExec return tt Y.
### `proof_of_InitDataqueue_return_wit_4` — `LLM_pre_process`

Choose current q_3 and after_3 in the left whole-goal alternative; lookup, empty indices, two distinct nonnegative IDs and safeExec return0 are all explicit premises. Preserve OutsideCritical unchanged.
### `proof_of_InitDataqueue_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of_InitDataqueue_which_implies_wit_1_split_goal_1`: Unfold DataqueueStorage; retain the owned 20 bytes. Project alignment/nonzero pure conjuncts and use authorized dataqueue_layout_abi size(DataQueue)=20 to rewrite the spatial length. No new address premise.

- Split `proof_of_InitDataqueue_which_implies_wit_1_split_goal_2`: Unfold DataqueueStorage; retain the owned 20 bytes. Project alignment/nonzero pure conjuncts and use authorized dataqueue_layout_abi size(DataQueue)=20 to rewrite the spatial length. No new address premise.

- Split `proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial`: Unfold DataqueueStorage; retain the owned 20 bytes. Project alignment/nonzero pure conjuncts and use authorized dataqueue_layout_abi size(DataQueue)=20 to rewrite the spatial length. No new address premise.
### `proof_of_InitDataqueue_which_implies_wit_2` — `aggressive_pre_process`

- Split `proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial`: Use explicit PreH1 addr_aligned p_queue 4 and authorized dataqueue_layout_abi size/offset facts. Expand or split the 20 known-zero bytes at offsets 0,2,4,6,8,12,16,20. Construct zero UShort stores at p,p+2,p+4, zero Ptr at p+8, zero Int at p+12,p+16; forget values only in padding [p+6,p+8). Derive typed valid_object range from byte ranges and alignment2/4 from PreH1. Cancel each byte exactly once. No spatial resource is introduced by the ABI fact.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261118165045/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/InitDataqueue-20261118165045/rounds/InitDataqueue-vc-proving-r1/groups/group_00__native_manual_restore/proof_reuse.md`.

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
      "InitDataqueue-20261118165045",
      "--round",
      "InitDataqueue-vc-proving-r1",
      "--group",
      "native_manual_restore"
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
      "InitDataqueue-20261118165045",
      "--round",
      "InitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "native_manual_restore"
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
      "InitDataqueue-20261118165045",
      "--round",
      "InitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "native_manual_restore"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261118165045/_coq_builds/InitDataqueue-vc-proving-r1/group_00/src/.coq_debug/group_00_native_manual_restore.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/InitDataqueue-20261118165045/rounds/InitDataqueue-vc-proving-r1/groups/group_00__native_manual_restore/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/InitDataqueue-20261118165045/rounds/InitDataqueue-vc-proving-r1/groups/group_00__native_manual_restore/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
