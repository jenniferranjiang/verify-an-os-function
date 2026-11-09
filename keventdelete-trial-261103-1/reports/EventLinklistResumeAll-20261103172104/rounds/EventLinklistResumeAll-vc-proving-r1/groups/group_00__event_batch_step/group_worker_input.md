# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `event_batch_step`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_00__event_batch_step/EventLinklistResumeAll_proof_manual.v`.
- Editable proof spans: `proof_of_LinklistResumeAll_entail_wit_4_2`, `proof_of_LinklistResumeAll_which_implies_wit_4`, `proof_of_LinklistResumeAll_which_implies_wit_7`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/EventLinklistResumeAll-vc-proving-r1/groups/group_00__event_batch_step/EventLinklistResumeAll_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventLinklistResumeAll_lib.v`
- Every new/adapted helper uses suffix `__event_batch_step`. Preserve the seed.

### `proof_of_LinklistResumeAll_entail_wit_4_2` — `LLM_pre_process`

Select the spatial first disjunct. Use the post os_inv(after), preserved old os_world_wf/task_world_wf(current_2 and marked), both marked-state ID lookups, and unchanged task ID-manager in ktask_wakeup_step to identify returned task with target and desc_2 with set_task_desc_exstatus desc (-1). Apply event_batch_after_head__event_batch_step with remaining_2=target::rest. It gives pending_at id p rest after and the one-head/batch composition implication. Instantiate consequent remaining=rest,current=after. Unfold event_resume_remaining_effect and compose this implication with PreH40. Forget task/node local values to undef and cancel os_inv(after) and InsideCritical(locked). Do not assume old os_inv: it is absent from this VC.
### `proof_of_LinklistResumeAll_which_implies_wit_4` — `LLM_pre_process`

Select the spatial first disjunct. From event_pending_at and os_inv(current), use event_pending_task_info__event_batch_step to obtain the registered SUSPEND descriptor, target alignment, os_world_wf and task_world_wf; instantiate desc with this descriptor. Reassert existing remaining/next/pending equalities and return the unchanged os_inv. This is a source VC for the historical pure premises used by the corrected backedge.
### `proof_of_LinklistResumeAll_which_implies_wit_7` — `LLM_pre_process`

Use marked=replace_task_desc_map(exstatus update,current) to carry event_pending_at to marked, since this update leaves os_events unchanged. Obtain the head task ID/registration and both marked-state world facts from event_pending_task_info__event_batch_step over os_inv(marked); no pre-state heap is assumed. Apply task_id_borrow__event_batch_step to split the ushort ID cell with event_resume_id_restore wand. Instantiate task_id with that concrete ID, preserve all pure input facts, and retain the precise field resource. This establishes the second source of old world facts across Wakeup.

## Helpers

- `event_pending_task_info__event_batch_step` (local): Prove a generic pure-extraction entailment: event_pending_at id p (t::rest) st -> os_inv sg st |-- pure(exists desc tid, task_desc_map(os_tasks st)t=Some desc /\ stat(desc)=TSK_SUSPEND /\ addr_aligned t ALIGN_SIZE /\ 0<=tid<65536 /\ get_task_with_idnode_success sg st tid t /\ os_world_wf sg st /\ task_world_wf st) && os_inv sg st. Open the selected Event pending DLL, its pure_suspend_sched_link payload and Task registration/ID manager, extract the ID-node membership and typed ushort range, then reassemble all resources. Source premises are the actual os_inv and nonempty pending relation in the two assigned which-implies VCs.
- `task_id_borrow__event_batch_step` (local): From get_task_with_idnode_success sg st tid t and os_inv sg st, derive the TaskDescriptor.id.id ushort cell at tid separated from its event_resume_id_restore sg st t tid wand. Locate the task ID payload in the manager bucket using its membership relation, borrow only its scalar field, and introduce the wand by reassembly of the same manager/os_inv. Relate nested field addresses with existing ABI/address lemmas, without new layout axioms.
- `event_batch_after_head__event_batch_step` (public): Prove the spatial-to-pure one-head composition used by entail_wit_4_2, with exactly its premises: event_pending_at id p (t::rest) current; map current t=Some desc with SUSPEND; marked equals the exstatus=-1 map update; os_world_wf/task_world_wf for current and marked; two get_task_with_idnode_success marked tid lookups (t and the generic returned task); generic ktask_wakeup_step returned_task returned_desc marked after; and owned os_inv sg after. Conclude event_pending_at id p rest after and forall final, event_resume_all_effect p rest after final -> event_resume_all_effect p (t::rest) current final. First derive old ID lookup uniqueness from the unchanged ID manager represented by post os_inv, and identify descriptors. Use old sched-owner NoDup to exclude t from every other queue/self-list and remove exactly the Event head. Recover object/ID representation uniqueness and delay shape restrictions needed for equality from preserved components of post os_inv and the explicit step frame; never add old os_inv as a premise. Prove task-map update composition by extensionality, ready-fold composition preserving all insertion-observed descriptor fields, and selected-delay filtering/map-update composition for NULL/inactive/active cases. This is the high-risk mathematical work; if a required premise cannot be obtained, report the exact counterexample rather than assume it.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_00__event_batch_step/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-vc-proving-r1",
      "--group",
      "event_batch_step"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "event_batch_step"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "event_batch_step"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/_coq_builds/EventLinklistResumeAll-vc-proving-r1/group_00/src/.coq_debug/group_00_event_batch_step.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_00__event_batch_step/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-proving-r1/groups/group_00__event_batch_step/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
