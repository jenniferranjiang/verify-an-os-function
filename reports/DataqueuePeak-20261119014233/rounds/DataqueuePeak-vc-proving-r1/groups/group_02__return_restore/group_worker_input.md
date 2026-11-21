# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `return_restore`; difficulty hint: 3/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/DataqueuePeak-20261119014233/DataqueuePeak-vc-proving-r1/groups/group_02__return_restore/DataqueuePeak_proof_manual.v`.
- Editable proof spans: `proof_of_DataqueuePeak_entail_wit_2`, `proof_of_DataqueuePeak_entail_wit_2_split_goal_1`, `proof_of_DataqueuePeak_entail_wit_2_split_goal_2`, `proof_of_DataqueuePeak_entail_wit_2_split_goal_spatial`, `proof_of_DataqueuePeak_entail_wit_3`, `proof_of_DataqueuePeak_entail_wit_3_split_goal_1`, `proof_of_DataqueuePeak_entail_wit_3_split_goal_2`, `proof_of_DataqueuePeak_entail_wit_3_split_goal_spatial`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_DataqueuePeak_entail_wit_2` — `aggressive_pre_process`

- Split `proof_of_DataqueuePeak_entail_wit_2_split_goal_1`: Start LLM_pre_process and prove Crtos_GTrans observed observed from the reflexive guarantee transition (or unfold current True transition). This is a pure reflexive step; spatial resources are merely framed.

- Split `proof_of_DataqueuePeak_entail_wit_2_split_goal_2`: Start LLM_pre_process. Consume the existing safeExec of abs_dataqueue_peak at LastSeen(before). After the assertS step, select the atomic observation observed using Crtos_RTrans before observed. Exhibit the locked normal step with after=observed, map witness q, nonempty guard from front/rear field equalities, and result Some e from dataqueue_peak q=Some e. The atomic output state-set is Crtos_RTrans observed, exactly LastSeen(observed). Apply the native safeExec/high-step return derivation, or unfold its wp characterization, to obtain safeExec LastSeen(observed) (ret (Some e)) X. Do not assume any Prop obligation or strengthen X.

- Split `proof_of_DataqueuePeak_entail_wit_2_split_goal_spatial`: Start LLM_pre_process; substitute the six field equalities. Fold the two DataElem cells into dataqueue_slot(base,front,Some e), using the authorized sizeof(DataElem)=8 equation. Eliminate the slot-to-buffer wand. Fold DataQueue fields plus padding into store_dataqueue using the existing nonzero/alignment premises, then eliminate its wand to recover os_inv(sg,observed). Fold the two freshly written output cells into peak_data_slot/peak_length_slot Some values and frame InsideCritical. All resources are unchanged except caller output values.
### `proof_of_DataqueuePeak_entail_wit_3` — `aggressive_pre_process`

- Split `proof_of_DataqueuePeak_entail_wit_3_split_goal_1`: Start LLM_pre_process and establish the reflexive Crtos_GTrans observed observed exactly as for the nonempty branch.

- Split `proof_of_DataqueuePeak_entail_wit_3_split_goal_2`: Start LLM_pre_process. Use the same assertS/atomic refinement as entail_wit_2, but exhibit the empty locked branch: the field equalities and p_queue_front=p_queue_rear give dq_front q=dq_rear q; choose q with the existing map lookup, result None and after=observed. Derive safeExec LastSeen(observed) (ret None) X from the original safeExec and observed rely step.

- Split `proof_of_DataqueuePeak_entail_wit_3_split_goal_spatial`: Start LLM_pre_process; rewrite the six field equalities, normalize the CHAR padding address, fold dataqueue_fields and store_dataqueue using nonzero/alignment, then apply its wand to recover the same os_inv. Keep dataqueue_buffer and both optional output predicates unchanged, with InsideCritical framed. No array slot is consumed on this branch.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/DataqueuePeak-20261119014233/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/DataqueuePeak-20261119014233/rounds/DataqueuePeak-vc-proving-r1/groups/group_02__return_restore/proof_reuse.md`.

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
      "return_restore"
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
      "return_restore"
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
      "return_restore"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/DataqueuePeak-20261119014233/_coq_builds/DataqueuePeak-vc-proving-r1/group_02/src/.coq_debug/group_02_return_restore.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/DataqueuePeak-20261119014233/rounds/DataqueuePeak-vc-proving-r1/groups/group_02__return_restore/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/DataqueuePeak-20261119014233/rounds/DataqueuePeak-vc-proving-r1/groups/group_02__return_restore/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
