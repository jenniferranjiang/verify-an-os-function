# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `observation_focus`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/DataqueuePeak-20261119014233/DataqueuePeak-vc-proving-r1/groups/group_00__observation_focus/DataqueuePeak_proof_manual.v`.
- Editable proof spans: `proof_of_DataqueuePeak_entail_wit_1`, `proof_of_DataqueuePeak_which_implies_wit_1`, `proof_of_DataqueuePeak_which_implies_wit_1_split_goal_1`, `proof_of_DataqueuePeak_which_implies_wit_1_split_goal_2`, `proof_of_DataqueuePeak_which_implies_wit_1_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_DataqueuePeak_entail_wit_1` — `LLM_pre_process`

Choose either identical disjunct and start LLM_pre_process. From safeExec for assertS(dataqueue_peak_entry);;os_atomic_cmd, extract the initial state-set witness and the assertS property using the existing wp/bind/assertS rules. LastSeen identifies that set with Crtos_RTrans before; PreH1 therefore makes observed a member. Apply the resulting os_inv-to-exists-lookup entailment with spatial-preserving pure extraction, not by discarding os_inv. Choose its q, unfold only os_inv/dataqueue_inv, obtain dataqueue_ready q from the map wellformedness clause, and use store_map_split at p_queue_pre. Frame all non-queue resources, InsideCritical and both caller output slots. Introduce the wand with the extracted store_dataqueue as its antecedent and restore the same map via store_map_merge; re-establish the unchanged global invariant and pure facts. Prove the focus transformation inline: dataqueue_peak_focus_obligation is only a Prop definition, not an available lemma. No additional state/lookup premise may be assumed.
### `proof_of_DataqueuePeak_which_implies_wit_1` — `aggressive_pre_process`

- Split `proof_of_DataqueuePeak_which_implies_wit_1_split_goal_1`: Start LLM_pre_process; unfold store_dataqueue. Extract the existing conjunction p_queue<>0 /\ addr_aligned p_queue 4 and project alignment; no field or ABI inference is needed.

- Split `proof_of_DataqueuePeak_which_implies_wit_1_split_goal_2`: Start LLM_pre_process; unfold store_dataqueue and project p_queue<>0 from its pure conjunct.

- Split `proof_of_DataqueuePeak_which_implies_wit_1_split_goal_spatial`: Start LLM_pre_process; unfold store_dataqueue and dataqueue_fields, retain dataqueue_buffer unchanged, normalize sizeof(CHAR)=1, and cancel the six typed fields and explicit two-byte padding after reassociation. No payload or semaphore ownership is introduced.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/DataqueuePeak-20261119014233/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/DataqueuePeak-20261119014233/rounds/DataqueuePeak-vc-proving-r1/groups/group_00__observation_focus/proof_reuse.md`.

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
      "DataqueuePeak-20261119014233",
      "--round",
      "DataqueuePeak-vc-proving-r1",
      "--group",
      "observation_focus"
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
      "DataqueuePeak-20261119014233",
      "--round",
      "DataqueuePeak-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "observation_focus"
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
      "DataqueuePeak-20261119014233",
      "--round",
      "DataqueuePeak-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "observation_focus"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/DataqueuePeak-20261119014233/_coq_builds/DataqueuePeak-vc-proving-r1/group_00/src/.coq_debug/group_00_observation_focus.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/DataqueuePeak-20261119014233/rounds/DataqueuePeak-vc-proving-r1/groups/group_00__observation_focus/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/DataqueuePeak-20261119014233/rounds/DataqueuePeak-vc-proving-r1/groups/group_00__observation_focus/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
