# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `retire_object`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreDeleteIC-20261118235913/SemaphoreDeleteIC-vc-proving-r1/groups/group_00__retire_object/SemaphoreDeleteIC_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_entail_wit_3_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreDelete_entail_wit_3_2` — `LLM_pre_process`

Use LLM_pre_process on the whole goal; choose after = replace_semaphores (prefix ++ suffix) before. Preserve the entire non-semaphore frame, including dataqueue_inv. From idmanager_contains in the original derived 16-bucket manager and NoDup(map semaphore_id old), identify idnode_2 with the embedded IdNode of original. From the removed payload plus remaining management DLL, derive that no remaining semaphore has the removed base address: a same-base object would duplicate its UShort value ownership. Hence semaphore_unpublish base old = prefix ++ suffix. Prove idmanager_remove stable (semaphore_manager old) original.id = semaphore_manager (prefix ++ suffix), using old = prefix ++ original :: suffix, NoDup IDs and the fixed hoffset=16; reason pointwise about filtered buckets/replace_Znth. Empty pending removes no scheduler owners, so os_world_wf is preserved. Unfold dataqueue_inv and use quiescent for every map lookup: referenced semaphore IDs differ from the removed ID, so their existing witnesses remain; preserve the complete store_map. For the freed object combine removed self-linked management node, empty pending list, value/padding payload, returned ID=65535 and self-linked ID node. Derive alignment from store_semaphore; apply existing trusted field-layout facts, forget typed values and assemble all 32 bytes, including both padding intervals. Package the public delete effect using original as witness and normalized query ID. Keep helper facts local inside the assigned proof (case lib absent); do not assume any unpublish/manager/resource obligation.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreDeleteIC-20261118235913/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/rounds/SemaphoreDeleteIC-vc-proving-r1/groups/group_00__retire_object/proof_reuse.md`.

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
      "SemaphoreDeleteIC-20261118235913",
      "--round",
      "SemaphoreDeleteIC-vc-proving-r1",
      "--group",
      "retire_object"
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
      "SemaphoreDeleteIC-20261118235913",
      "--round",
      "SemaphoreDeleteIC-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "retire_object"
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
      "SemaphoreDeleteIC-20261118235913",
      "--round",
      "SemaphoreDeleteIC-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "retire_object"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreDeleteIC-20261118235913/_coq_builds/SemaphoreDeleteIC-vc-proving-r1/group_00/src/.coq_debug/group_00_retire_object.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/rounds/SemaphoreDeleteIC-vc-proving-r1/groups/group_00__retire_object/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/rounds/SemaphoreDeleteIC-vc-proving-r1/groups/group_00__retire_object/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
