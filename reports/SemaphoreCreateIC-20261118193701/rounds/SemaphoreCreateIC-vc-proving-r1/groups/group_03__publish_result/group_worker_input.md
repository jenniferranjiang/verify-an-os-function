# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `publish_result`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreCreateIC-20261118193701/SemaphoreCreateIC-vc-proving-r1/groups/group_03__publish_result/SemaphoreCreateIC_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_return_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreCreate_return_wit_1` — `LLM_pre_process`

Choose after = replace_semaphores (semaphore_publish sem id val_pre (os_semaphores before)) before. Prove semaphore_create_ic_effect by its success branch with witness sem and the explicit freshness/alignment/min-free facts. Rewrite dll_insert_after_dispatch_at_head so the physical management list equals map semaphore_link_node of the cons-published state. Prove the ID manager state equality: semaphore_manager of this cons equals idmanager_link sidm (idmanager_add old id) id embedded_id; unfold the bucket construction, use hoffset=16 and 0<=id<128, and reason pointwise on the finite bucket list/filter and updated bucket. This is a real inline list equality, not an assumed obligation. Rebuild os_world_wf: new semaphore has empty pending list, so os_sched_owners is unchanged; service-slot and task-map projections are unchanged. Rebuild task/tick/delay/assign/exstatus invariants through the unchanged projections of replace_semaphores. For dataqueue_inv keep the same store_map and ready facts; lift both existential semaphore membership witnesses from the old list to its cons tail. Fold semaphore_inv and os_inv and cancel every frame resource. No fresh queue state, wait nodes, extra public guarantee, or new assumption is introduced.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreCreateIC-20261118193701/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/rounds/SemaphoreCreateIC-vc-proving-r1/groups/group_03__publish_result/proof_reuse.md`.

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
      "SemaphoreCreateIC-20261118193701",
      "--round",
      "SemaphoreCreateIC-vc-proving-r1",
      "--group",
      "publish_result"
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
      "SemaphoreCreateIC-20261118193701",
      "--round",
      "SemaphoreCreateIC-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "publish_result"
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
      "SemaphoreCreateIC-20261118193701",
      "--round",
      "SemaphoreCreateIC-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "publish_result"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreCreateIC-20261118193701/_coq_builds/SemaphoreCreateIC-vc-proving-r1/group_03/src/.coq_debug/group_03_publish_result.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/rounds/SemaphoreCreateIC-vc-proving-r1/groups/group_03__publish_result/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/rounds/SemaphoreCreateIC-vc-proving-r1/groups/group_03__publish_result/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
