# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `retire_success`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_01__retire_success/EventDelete_proof_manual.v`.
- Editable proof spans: `proof_of__EventDelete_entail_wit_4_2`, `proof_of__EventDelete_entail_wit_4_2_split_goal_1`, `proof_of__EventDelete_entail_wit_4_2_split_goal_2`, `proof_of__EventDelete_entail_wit_4_2_split_goal_spatial`, `proof_of__EventDelete_entail_wit_4_4`, `proof_of__EventDelete_entail_wit_4_4_split_goal_1`, `proof_of__EventDelete_entail_wit_4_4_split_goal_2`, `proof_of__EventDelete_entail_wit_4_4_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_01__retire_success/EventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventDelete_lib.v`
- Every new/adapted helper uses suffix `__retire_success`. Preserve the seed.

### `proof_of__EventDelete_entail_wit_4_2` — `aggressive_pre_process`

- Split `proof_of__EventDelete_entail_wit_4_2_split_goal_1`: P retains InsideCritical/frame and the pure old snapshot. Q is Crtos_GTrans locked (replace_events (event_unpublish p locked.events) locked); unfold the existing permissive global transition (True). No heap mutation or extra invariant assumption is needed.

- Split `proof_of__EventDelete_entail_wit_4_2_split_goal_2`: P has safeExec(LastSeen ready)(event_delete_finish id p resched)X, event_delete_gap id p true ready locked, and original is the empty-pending member with this p/id. Use the guarded unpublish nrm step locked -> replace_events(unpublish p) locked to consume the first bind. Preserve the same X; Q is safeExec at the after LastSeen of abs_ktask_assign for 4_2 (resched=1), or ret tt for 4_4 (resched=0). This is an abstract refinement proof; do not assume the unproved design Prop.

- Split `proof_of__EventDelete_entail_wit_4_2_split_goal_spatial`: P owns removed manager, target ID scalar=65535 and self-linked ID pointers at idnode, detached management link, old store_event payload, remaining DLL and exact event_create_frame/InsideCritical. First use idmanager_contains and old ID NoDup/original membership to prove idnode=&p->id. Combine these fields with empty pending, unchanged options/events/padding into EventRetired p original.options original.events. By old address NoDup, unpublish p removes exactly original, so remaining DLL is map event_link_node(prefix++suffix). Rewrite the retained manager projection equality; empty-pending removal preserves sched-owner/world facts. Rebuild os_inv at replace_events(unpublish...) and frame the unchanged InsideCritical and separate EventRetired. Do not silently assume old os_inv after its resources have been split.
### `proof_of__EventDelete_entail_wit_4_4` — `aggressive_pre_process`

- Split `proof_of__EventDelete_entail_wit_4_4_split_goal_1`: P retains InsideCritical/frame and the pure old snapshot. Q is Crtos_GTrans locked (replace_events (event_unpublish p locked.events) locked); unfold the existing permissive global transition (True). No heap mutation or extra invariant assumption is needed.

- Split `proof_of__EventDelete_entail_wit_4_4_split_goal_2`: P has safeExec(LastSeen ready)(event_delete_finish id p resched)X, event_delete_gap id p true ready locked, and original is the empty-pending member with this p/id. Use the guarded unpublish nrm step locked -> replace_events(unpublish p) locked to consume the first bind. Preserve the same X; Q is safeExec at the after LastSeen of abs_ktask_assign for 4_2 (resched=1), or ret tt for 4_4 (resched=0). This is an abstract refinement proof; do not assume the unproved design Prop.

- Split `proof_of__EventDelete_entail_wit_4_4_split_goal_spatial`: P owns removed manager, target ID scalar=65535 and self-linked ID pointers at idnode, detached management link, old store_event payload, remaining DLL and exact event_create_frame/InsideCritical. First use idmanager_contains and old ID NoDup/original membership to prove idnode=&p->id. Combine these fields with empty pending, unchanged options/events/padding into EventRetired p original.options original.events. By old address NoDup, unpublish p removes exactly original, so remaining DLL is map event_link_node(prefix++suffix). Rewrite the retained manager projection equality; empty-pending removal preserves sched-owner/world facts. Rebuild os_inv at replace_events(unpublish...) and frame the unchanged InsideCritical and separate EventRetired. Do not silently assume old os_inv after its resources have been split.

## Helpers

- `event_contains_unique_target__retire_success` (local): Statement: NoDup(map event_id events), In e events, event_id e=id, and idmanager_contains sm (event_manager events) id node imply node=&e.addr->id. Expand Znth/map/filter bucket membership, recover an event with that ID, then use mapped-ID uniqueness. The actual VC provides exactly those pure premises; no old heap is required.
- `event_detached_rebuild__retire_success` (local): Statement shape: event_pending_at id p [] before, address NoDup, manager-removal projection equality, exact event_create_frame + removed manager + surviving management DLL + detached target payload/ID/link cells entail os_inv(replace_events(unpublish p) before) ** EventRetired p options events. Prove the target field packing and os_world preservation from empty-pending removal, then cancellation. Derive context/validity from the still-owned frame and payload. Do not apply event_delete_restore_obligation as if it were a proof.
- `event_finish_commit__retire_success` (local): For bool r, known guarded empty-pending acquisition ready->locked, and after=replace_events(unpublish p locked.events) locked, safeExec(LastSeen ready)(event_delete_finish id p r)X entails safeExec(LastSeen after)(if r then abs_ktask_assign else ret tt)X. Use MonadErr bind/WLP and actual nrm of event_delete_atomic_cmd/abs_event_unpublish_locked; the source guard and empty-member facts are existing VC premises.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_01__retire_success/proof_reuse.md`.

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
      "EventDelete-20261103173023",
      "--round",
      "EventDelete-vc-proving-r1",
      "--group",
      "retire_success"
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
      "EventDelete-20261103173023",
      "--round",
      "EventDelete-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "retire_success"
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
      "EventDelete-20261103173023",
      "--round",
      "EventDelete-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "retire_success"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/_coq_builds/EventDelete-vc-proving-r1/group_01/src/.coq_debug/group_01_retire_success.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_01__retire_success/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_01__retire_success/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
