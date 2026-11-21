# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `call_transitions`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/PopDataqueue-20261119021132/PopDataqueue-vc-proving-r1/groups/group_01__call_transitions/PopDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_PopDataqueue_entail_wit_2`, `proof_of_PopDataqueue_entail_wit_5_1`, `proof_of_PopDataqueue_entail_wit_5_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_PopDataqueue_entail_wit_2` — `LLM_pre_process`

Use LLM_pre_process on one whole disjunct. Substitute the six field equalities; fold current fields, explicit padding (sizeof CHAR=1), and dataqueue_buffer into store_dataqueue p_queue_pre q_id, then eliminate its restoration wand to recover os_inv sg seen_id. Use before->seen_id RTrans and lookup to construct the atomic abs_dataqueue_pop_id execution with result dq_sem_data q_id and unchanged state; GTrans is reflexive. Advance safeExec through assertS and this atomic step to dataqueue_pop_after_id. Decompose its bind into an Obtain precondition and continuation, taking Y to be the appropriate wp/continuation predicate for dataqueue_pop_after_obtain. Prove the universal st/status bridge from safeExec ret status Y by bind/return rules; it must work at the callee-return state, not only seen_id. Keep InsideCritical and both optional output cells as frame.
### `proof_of_PopDataqueue_entail_wit_5_1` — `LLM_pre_process`

Use LLM_pre_process. Choose the left result disjunct, item=e, result=DqPopItem e, new_data=Some(dq_data e), new_length=Some(dq_length e), and after_ring=replace_dataqueues(dataqueue_publish p_queue_pre (dataqueue_pop q) (os_dataqueues seen_ring)) seen_ring. Reassemble the read element fields into dataqueue_slot using DataElem ABI and eliminate the slot wand to restore the unchanged buffer. Normalize front unsigned_last_nbits using 0<max_len<=65535 and modular bounds; the written value is precisely the new front. Reassemble store_dataqueue for dataqueue_pop q (same base/slots/IDs), eliminate its update wand to obtain the chosen after os_inv. Outputs are the already-written cells. Construct abs_dataqueue_pop_ring normal step using q, lookup, nonempty and peak=Some e. Prove Crtos_GTrans by unchanged scheduler/task components and queue-only update. Advance safeExec through second assertS/atomic ring to after_ring continuation; unfold dataqueue_pop_after_ring and split its Abandon bind, obtaining Y_finish and the universal return-status bridge to ret(DqPopItem e). Ignore Abandon status as specified, not by dropping its call.
### `proof_of_PopDataqueue_entail_wit_5_2` — `LLM_pre_process`

Use LLM_pre_process. Choose the right result disjunct, after_ring=seen_ring, result=DqPopEmpty and unchanged old_data/old_length. Substitute field equalities and front=rear, fold store_dataqueue q including padding/buffer, and eliminate the same-value restoration wand. Prove reflexive GTrans. Construct the empty abs_dataqueue_pop_ring normal step yielding (dq_sem_blank q,None) without modifying state or outputs. From safeExec after_obtain0 and after_get->seen_ring RTrans advance through the assert/atomic step, then split dataqueue_pop_after_ring Abandon bind to a Y_finish whose every returned status continues to ret DqPopEmpty. Preserve InsideCritical and both original option slots.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/PopDataqueue-20261119021132/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-proving-r1/groups/group_01__call_transitions/proof_reuse.md`.

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
      "PopDataqueue-20261119021132",
      "--round",
      "PopDataqueue-vc-proving-r1",
      "--group",
      "call_transitions"
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
      "PopDataqueue-20261119021132",
      "--round",
      "PopDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "call_transitions"
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
      "PopDataqueue-20261119021132",
      "--round",
      "PopDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "call_transitions"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/PopDataqueue-20261119021132/_coq_builds/PopDataqueue-vc-proving-r1/group_01/src/.coq_debug/group_01_call_transitions.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-proving-r1/groups/group_01__call_transitions/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-proving-r1/groups/group_01__call_transitions/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
