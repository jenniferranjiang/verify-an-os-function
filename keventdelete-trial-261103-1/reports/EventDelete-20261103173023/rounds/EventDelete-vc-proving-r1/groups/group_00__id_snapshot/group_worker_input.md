# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `id_snapshot`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_00__id_snapshot/EventDelete_proof_manual.v`.
- Editable proof spans: `proof_of__EventDelete_which_implies_wit_6`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/EventDelete-vc-proving-r1/groups/group_00__id_snapshot/EventDelete_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/EventDelete_lib.v`
- Every new/adapted helper uses suffix `__id_snapshot`. Preserve the seed.

### `proof_of__EventDelete_which_implies_wit_6` — `LLM_pre_process`

P: os_inv(sg,locked) and event_delete_gap(id,p,true,ready,locked). Unfold gap/guard to choose original with address p, ID id and empty pending; use In->prefix/original/suffix decomposition for the existential witnesses. From the still-owned manager/DLL derive actual ID bounds, ID/address NoDup, query=true and manager-remove=derived-unpublish-manager. Borrow the original IdNode.id UShort cell and build the explicit event_delete_id_restore wand from its exact unchanged remainder. Return all pure facts plus this cell/wand. The facts are conclusions to prove, never extra assumptions or design-obligation axioms.

## Helpers

- `event_sequence_facts__id_snapshot` (local): Statement: for sg/st, os_inv sg st entails address/ID NoDup, and for each member e its ID is in [0,128), query is true and event_manager(event_unpublish e.addr st.events)=idmanager_remove sg.event_manager_stable (event_manager st.events) e.id. Prove from event_context, store_idmanager/idbuckets_ok and the actual management DLL payload. Address uniqueness follows disjoint owned payload fields; ID uniqueness follows manager invariant. Then prove filter/remove correspondence for the one known unique member. All premises come from P, not a strengthened caller Require.
- `event_id_focus__id_snapshot` (local): Statement: In e st.events -> os_inv sg st |-- field(e.addr,Event.id.id) # UShort |-> e.id ** (that cell -* os_inv sg st). Recover the member IdNode in the derived event_manager bucket, split its scalar from manager ownership, and package all unchanged manager/DLL/world resources into the wand. Use existing field nesting equalities; retain padding and ID links in the remainder.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_00__id_snapshot/proof_reuse.md`.

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
      "id_snapshot"
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
      "id_snapshot"
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
      "id_snapshot"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventDelete-20261103173023/_coq_builds/EventDelete-vc-proving-r1/group_00/src/.coq_debug/group_00_id_snapshot.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_00__id_snapshot/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-proving-r1/groups/group_00__id_snapshot/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
