# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `entry_scan`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r1/groups/group_01__entry_scan/AllocId_proof_manual.v`.
- Editable proof spans: `proof_of_AllocId_entail_wit_5`, `proof_of_AllocId_entail_wit_5_split_goal_1`, `proof_of_AllocId_entail_wit_6`, `proof_of_AllocId_entail_wit_6_split_goal_1`, `proof_of_AllocId_safety_wit_22`, `proof_of_AllocId_safety_wit_22_split_goal_1`, `proof_of_AllocId_safety_wit_22_split_goal_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_AllocId_entail_wit_5` — `aggressive_pre_process`

- Split `proof_of_AllocId_entail_wit_5_split_goal_1`: Pattern ENTRY_SCAN: use id_map_bytes_ok_Znth_range with the loop index bounds for 0<=b<=255. Unfold allocid_entry_scan_inv; instantiate offset=0 and id=index*8. shiftr b 0=b, bounds are linear, and the quantified lower-bit range is empty. Pure target, no resource updates.
### `proof_of_AllocId_entail_wit_6` — `aggressive_pre_process`

- Split `proof_of_AllocId_entail_wit_6_split_goal_1`: Pattern ENTRY_SCAN (high risk): destruct old invariant and instantiate offset+1. The old byte range plus lower-bit clause and b<>255 exclude offset=8 via byte_eq_255_of_low_bits, so offset+1<=8. From entry=shiftr b offset and land entry 1<>0 derive testbit b offset=true; append this bit to the old lower-bit prefix. Use shiftr composition to identify shiftr entry 1=shiftr b (offset+1), prove this is in 0..255, and remove unsigned_last_nbits at width 8. Prove updated id range by lia. Only a pure target; establish needed facts as proof-local assertions, no new helper.
### `proof_of_AllocId_safety_wit_22` — `aggressive_pre_process`

- Split `proof_of_AllocId_safety_wit_22_split_goal_1`: Pattern BOUNDS: unfold entry-scan invariant for id<=index*8+8; byte validity bounds idmax<=65535 and end<=8192. With index<end derive id+1<=65537<INT_MAX. No additional loop premise or heap fact needed.

- Split `proof_of_AllocId_safety_wit_22_split_goal_2`: Pattern BOUNDS: entry-scan invariant gives index*8<=id; index>=0 yields id+1>=1>=INT_MIN. Heap is frame.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r1/groups/group_01__entry_scan/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-debug",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-proving-r1",
      "--group",
      "entry_scan"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-check",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "entry_scan"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-check",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "entry_scan"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/_coq_builds/AllocId-vc-proving-r1/group_01/src/.coq_debug/group_01_entry_scan.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r1/groups/group_01__entry_scan/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r1/groups/group_01__entry_scan/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
