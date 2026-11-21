# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `zero_object`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreCreateIC-20261118193701/SemaphoreCreateIC-vc-proving-r1/groups/group_00__zero_object/SemaphoreCreateIC_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_entail_wit_1`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_1`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_2`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_3`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_4`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_5`, `proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreCreate_entail_wit_1` — `aggressive_pre_process`

- Split `proof_of__SemaphoreCreate_entail_wit_1_split_goal_1`: From CharArray.full p 32 ** os_inv show p is absent from map semaphore_addr. Open os_inv/semaphore_inv and the management DLL; if a mapped semaphore has address p, isolate its store_semaphore value field at p+12. Split the private zero bytes at that field using semaphore_zero_bytes_fields and the approved semaphore_field_offsets_trusted layout; duplicate owned UShort cells contradict separation. Derive the pure absence fact without discarding the original frame; use an inline induction over the DLL if required. No new library helper is available.

- Split `proof_of__SemaphoreCreate_entail_wit_1_split_goal_2`: Open os_inv and semaphore_inv, extract the pure semaphore_context fact, discard the spatial frame only for this pure conclusion.

- Split `proof_of__SemaphoreCreate_entail_wit_1_split_goal_3`: Open os_inv and project its os_world_wf pure conjunct; no state change.

- Split `proof_of__SemaphoreCreate_entail_wit_1_split_goal_4`: Use semaphore_field_offsets_trusted with the explicit malloc alignment to rewrite link to p+24; p>0 entails nonzero.

- Split `proof_of__SemaphoreCreate_entail_wit_1_split_goal_5`: Use the same approved layout to rewrite pend_list to p+16; p>0 entails nonzero.

- Split `proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial`: Apply semaphore_zero_bytes_object using the explicit malloc positive, upper-bound and alignment facts plus the existing approved layout axiom, then semaphore_zero_insert_ready. Open os_inv/semaphore_inv, rewrite manager/list addresses by semaphore_context, and cancel the entire unchanged frame including dataqueue_inv. Preserve all padding bytes and pending/link zero cells; no new ownership premise.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreCreateIC-20261118193701/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/rounds/SemaphoreCreateIC-vc-proving-r1/groups/group_00__zero_object/proof_reuse.md`.

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
      "zero_object"
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
      "zero_object"
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
      "zero_object"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreCreateIC-20261118193701/_coq_builds/SemaphoreCreateIC-vc-proving-r1/group_00/src/.coq_debug/group_00_zero_object.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/rounds/SemaphoreCreateIC-vc-proving-r1/groups/group_00__zero_object/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/rounds/SemaphoreCreateIC-vc-proving-r1/groups/group_00__zero_object/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
