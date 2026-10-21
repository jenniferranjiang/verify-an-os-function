# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `index_scan`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r1/groups/group_04__index_scan/AllocId_proof_manual.v`.
- Editable proof spans: `proof_of_AllocId_entail_wit_3`, `proof_of_AllocId_entail_wit_3_split_goal_1`, `proof_of_AllocId_entail_wit_3_split_goal_2`, `proof_of_AllocId_entail_wit_4`, `proof_of_AllocId_entail_wit_4_split_goal_1`, `proof_of_AllocId_safety_wit_9`, `proof_of_AllocId_safety_wit_9_split_goal_1`, `proof_of_AllocId_safety_wit_9_split_goal_2`, `proof_of_AllocId_safety_wit_14`, `proof_of_AllocId_safety_wit_19`, `proof_of_AllocId_safety_wit_19_split_goal_1`, `proof_of_AllocId_safety_wit_19_split_goal_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_AllocId_entail_wit_3` — `aggressive_pre_process`

- Split `proof_of_AllocId_entail_wit_3_split_goal_1`: Pattern INDEX_SCAN: this target is pure; unfold allocid_index_scan_inv at index=0. Nonnegativity is immediate and no integer i satisfies 0<=i<0. No spatial transformation.

- Split `proof_of_AllocId_entail_wit_3_split_goal_2`: Pattern BOUNDS: this target is pure; id_map_bytes_ok supplies idmax>=0. Positive-divisor/nonnegative-numerator facts prove 0<=(idmax+7) quot 8; no heap required.
### `proof_of_AllocId_entail_wit_4` — `aggressive_pre_process`

- Split `proof_of_AllocId_entail_wit_4_split_goal_1`: Pattern INDEX_SCAN: unfold allocid_index_scan_inv. index>=0 gives nonnegative index+1; any 0<=i<index+1 is either i<index, using old invariant, or i=index, using Znth index bytes 0=255. Pure target only.
### `proof_of_AllocId_safety_wit_9` — `aggressive_pre_process`

- Split `proof_of_AllocId_safety_wit_9_split_goal_1`: Pattern BOUNDS: expose the pure upper bound, extract idmax<=65535 from id_map_bytes_ok, normalize INT_MAX and use lia; local/manager/bitmap/bucket resources are frame.

- Split `proof_of_AllocId_safety_wit_9_split_goal_2`: Pattern BOUNDS: extract 0<=idmax from id_map_bytes_ok and prove INT_MIN<=idmax+7 by lia; no resource conversion or existential.
### `proof_of_AllocId_safety_wit_14` — `LLM_pre_process`

Pattern BOUNDS: extract 0 <= idmax <= 65535 from id_map_bytes_ok. Convert (idmax+7) quot 8 to div using nonnegativity, derive end <= 8192. Together with 0 <= index < end, prove both INT bounds of index+1. Spatial locals/fields/bitmap/buckets carry no needed additional premise.
### `proof_of_AllocId_safety_wit_19` — `aggressive_pre_process`

- Split `proof_of_AllocId_safety_wit_19_split_goal_1`: Pattern BOUNDS: from id_map_bytes_ok obtain 0<=idmax<=65535, normalize quot/div and bound end<=8192. With index<end derive index*8<=65528<=INT_MAX. All spatial resources are frame.

- Split `proof_of_AllocId_safety_wit_19_split_goal_2`: Pattern BOUNDS: index>=0 gives index*8>=0>=INT_MIN; retain the spatial frame.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r1/groups/group_04__index_scan/proof_reuse.md`.

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
      "index_scan"
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
      "index_scan"
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
      "index_scan"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/_coq_builds/AllocId-vc-proving-r1/group_04/src/.coq_debug/group_04_index_scan.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r1/groups/group_04__index_scan/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r1/groups/group_04__index_scan/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
