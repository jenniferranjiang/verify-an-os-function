# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `publish_world`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/EventCreate-vc-proving-r1/groups/group_02__publish_world/EventCreate_proof_manual.v`.
- Editable proof spans: `proof_of__EventCreate_which_implies_wit_6`, `proof_of__EventCreate_which_implies_wit_6_split_goal_1`, `proof_of__EventCreate_which_implies_wit_6_split_goal_2`, `proof_of__EventCreate_which_implies_wit_6_split_goal_3`, `proof_of__EventCreate_which_implies_wit_6_split_goal_4`, `proof_of__EventCreate_which_implies_wit_6_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/EventCreate-vc-proving-r1/groups/group_02__publish_world/EventCreate_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventcreate-trial-261101-1/VC/EventCreate_lib.v`
- Every new/adapted helper uses suffix `__publish_world`. Preserve the seed.

### `proof_of__EventCreate_which_implies_wit_6` — `aggressive_pre_process`

- Split `proof_of__EventCreate_which_implies_wit_6_split_goal_1`: Crtos_GTrans uses the existing permissive CriticalSTS transition; unfold the wrapper and establish its reflexive/transitive True transition for st_lock to replace_events(new::old) st_lock. No heap resource changes are needed for this pure fact.

- Split `proof_of__EventCreate_which_implies_wit_6_split_goal_2`: Consume safeExec abs_event_create by selecting the task_atomic_cmd branch. LastSeen before admits st_lock via the explicit Crtos_RTrans. For abs_event_create_locked choose the success alternative with witness event and exact after=replace_events(event_publish event id options old) st_lock; use nonnull, alignment, freshness and minimum-ID premises. The atomic output set is LastSeen after; derive safeExec(ret id) X at that set. Keep the actual existential initial-state witness carried by safeExec.

- Split `proof_of__EventCreate_which_implies_wit_6_split_goal_3`: Unfold minimum-free-ID and event_context: idmax=128 supplies id<128.

- Split `proof_of__EventCreate_which_implies_wit_6_split_goal_4`: Unfold minimum-free-ID: extract 0<=id.

- Split `proof_of__EventCreate_which_implies_wit_6_split_goal_spatial`: Use event_publish_manager__publish_world to rewrite the inserted ID manager as event_manager(new::old); use event_context to rewrite manager/head globals. Reduce dll_insert_after_dispatch at the head to cons and identify Build_DL_Node with event_link_node(event_created...). Establish os_world_wf of replace_events by event_publish_world__publish_world: new event has no waiters and every other state component is unchanged. Rebuild event_inv and os_inv from the exact frame, manager and extended management DLL. Do not recover old event_inv by discarding the new node.

## Helpers

- `event_publish_manager__publish_world` (public): Prove event_publish_manager_obligation under event_context and idmanager_min_free_id. Unfold event_manager/event_publish and idmanager_link/add; show IDs cons agrees with add and each of the 16 filtered buckets agrees with insertion at id mod 16. Use 0<=id<128 and hoffset=16; prove seq/map bucket update equality by nth/extensionality and split equality of the bucket index. Statement must retain every premise required by idmanager operations; current VC supplies them.
- `event_publish_world__publish_world` (public): Prove event_publish_world_obligation. Unfold os_world_wf, replace_events and event_publish; event_waiters of the new singleton prefix is []; os_sched_owners is unchanged. All service slots, task descriptions, global stable context, NoDup and domain equivalence transport by definitional equality. No freshness or valid-options restriction is needed for this pure world fact.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_02__publish_world/proof_reuse.md`.

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
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-debug",
      "--run",
      "EventCreate-20261101232623",
      "--round",
      "EventCreate-vc-proving-r1",
      "--group",
      "publish_world"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-check",
      "--run",
      "EventCreate-20261101232623",
      "--round",
      "EventCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "publish_world"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-check",
      "--run",
      "EventCreate-20261101232623",
      "--round",
      "EventCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "publish_world"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventcreate-trial-261101-1/verification_runs/EventCreate-20261101232623/_coq_builds/EventCreate-vc-proving-r1/group_02/src/.coq_debug/group_02_publish_world.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_02__publish_world/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventcreate-trial-261101-1/reports/EventCreate-20261101232623/rounds/EventCreate-vc-proving-r1/groups/group_02__publish_world/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
