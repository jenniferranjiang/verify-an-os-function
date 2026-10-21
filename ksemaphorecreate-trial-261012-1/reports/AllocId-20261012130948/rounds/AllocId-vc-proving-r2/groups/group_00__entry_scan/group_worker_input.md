# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `entry_scan`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r2/groups/group_00__entry_scan/AllocId_proof_manual.v`.
- Editable proof spans: `proof_of_AllocId_entail_wit_5`, `proof_of_AllocId_entail_wit_5_split_goal_1`, `proof_of_AllocId_entail_wit_6`, `proof_of_AllocId_entail_wit_6_split_goal_1`, `proof_of_AllocId_safety_wit_22`, `proof_of_AllocId_safety_wit_22_split_goal_1`, `proof_of_AllocId_safety_wit_22_split_goal_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of_AllocId_entail_wit_5` — `aggressive_pre_process`

- Split `proof_of_AllocId_entail_wit_5_split_goal_1`: Pure goal. Choose offset = 0 in allocid_entry_scan_inv, normalize index*8-index*8 and shiftr by zero. Obtain the byte range from id_map_bytes_ok_Znth_range using index bounds and end equality. The scanned-bit prefix is empty; all conjuncts follow.
### `proof_of_AllocId_entail_wit_6` — `aggressive_pre_process`

- Split `proof_of_AllocId_entail_wit_6_split_goal_1`: Pure scan transition. Unfold allocid_entry_scan_inv and retain its offset witness. From byte range and the prefix of true low bits, offset = 8 would imply byte = 255 by byte_eq_255_of_low_bits, contradicting the guard; hence offset < 8. Choose offset+1. Z.land entry 1 <> 0 establishes testbit entry 0 = true; shiftr testbit transfers this to the original byte at offset. Preserve earlier bits and compose shiftr by offset then by 1. entry in [0,255] makes shiftr entry 1 lie in [0,127], so unsigned_last_nbits at 8 is unchanged. Discharge new id and offset bounds arithmetically. No spatial resources or semantic-state change.
### `proof_of_AllocId_safety_wit_22` — `aggressive_pre_process`

- Split `proof_of_AllocId_safety_wit_22_split_goal_1`: Destruct id_map_bytes_ok for 0 <= idmax <= 65535. Rewrite quot to div using nonnegative idmax+7, and use division bounds to get 0 <= end <= 8192; index < end and 0 <= index give index <= 8191. Unfold entry-scan invariant for id <= index*8+8, hence id+1 <= 65537 < INT_MAX. Antecedent resources remain context; conclude only the requested pure upper bound.

- Split `proof_of_AllocId_safety_wit_22_split_goal_2`: Unfold entry-scan invariant for index*8 <= id; index >= 0 implies id+1 >= 1 >= INT_MIN. Heap resources are context; no witnesses.

## Helpers

- None planned.

## Historical references

- Previous proving round: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/AllocId-vc-proving-r1`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_00__entry_scan/proof_reuse.md`.

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
      "AllocId-vc-proving-r2",
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
      "AllocId-vc-proving-r2",
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
      "AllocId-vc-proving-r2",
      "--target-kind",
      "group-check",
      "--group",
      "entry_scan"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/AllocId-20261012130948/_coq_builds/AllocId-vc-proving-r2/group_00/src/.coq_debug/group_00_entry_scan.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_00__entry_scan/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-proving-r2/groups/group_00__entry_scan/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
