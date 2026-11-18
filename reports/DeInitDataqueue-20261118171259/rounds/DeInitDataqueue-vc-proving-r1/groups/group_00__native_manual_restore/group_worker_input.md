# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `native_manual_restore`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118171259/DeInitDataqueue-vc-proving-r1/groups/group_00__native_manual_restore/DeInitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_DeInitDataqueue_entail_wit_1`, `proof_of_DeInitDataqueue_entail_wit_4_1`, `proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_1`, `proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_2`, `proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_3`, `proof_of_DeInitDataqueue_entail_wit_4_2`, `proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_1`, `proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_2`, `proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_3`, `proof_of_DeInitDataqueue_entail_wit_4_3`, `proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_1`, `proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_2`, `proof_of_DeInitDataqueue_entail_wit_4_4`, `proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_1`, `proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_2`, `proof_of_DeInitDataqueue_entail_wit_5_1`, `proof_of_DeInitDataqueue_entail_wit_5_2`, `proof_of_DeInitDataqueue_entail_wit_5_3`, `proof_of_DeInitDataqueue_entail_wit_5_4`, `proof_of_DeInitDataqueue_which_implies_wit_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): `proof_of_DeInitDataqueue_entail_wit_1_split_goal_1`, `proof_of_DeInitDataqueue_entail_wit_1_split_goal_2`.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_DeInitDataqueue_entail_wit_1` — `LLM_pre_process`

Select the whole-goal LEFT alternative, keeping os_inv sg observed in the antecedent. Unfold abs_deinit_dataqueue; use safeExec of assertS to obtain dataqueue_cleanup_entry for the initial LastSeen set. Crtos_RTrans before observed establishes membership in that observation set. Instantiate entry at observed to get os_inv |-- cleanup_guard, then project both quiescence facts while preserving os_inv by pure extraction/frame. Cancel InsideCritical/private store_dataqueue unchanged. Do not select the pure emp fallback: its generated split drops the os_inv needed by cleanup_entry. Whitelist001 permits this checked observation model, not assuming the resulting facts without this argument.
### `proof_of_DeInitDataqueue_entail_wit_4_1` — `aggressive_pre_process`

- Split `proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_1`: Substitute the field-to-q ID equalities. Unfold semaphore_delete_ic_effect on the first ID. Invalid-ID and lookup-miss cases have after=observed, so reuse old quiescence. In the hit case after=replace_semaphores(filter-out-address) observed: every surviving semaphore was an old member, pending fields are unchanged, and dataqueue_map is unchanged. Apply old semaphore_delete_quiescent for the second ID to those old members and identical map lookups. This holds even if IDs coincide; removal cannot create waiters/references. No os_inv or freshness assumption is required for this pure monotonicity.

- Split `proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_2`: Use the saved equality between the C blank field and dq_sem_blank q and its branch sign. Unfold dataqueue_retired and project dq_sem_blank; rewrite Z.leb 0 blank to true for the nonnegative branch or false for the negative branch. The desired equality is then reflexivity after substitution. Duplicate split equations are each proved, not skipped.

- Split `proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_3`: Use the saved equality between the C blank field and dq_sem_blank q and its branch sign. Unfold dataqueue_retired and project dq_sem_blank; rewrite Z.leb 0 blank to true for the nonnegative branch or false for the negative branch. The desired equality is then reflexivity after substitution. Duplicate split equations are each proved, not skipped.
### `proof_of_DeInitDataqueue_entail_wit_4_2` — `aggressive_pre_process`

- Split `proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_1`: Substitute the field-to-q ID equalities. Unfold semaphore_delete_ic_effect on the first ID. Invalid-ID and lookup-miss cases have after=observed, so reuse old quiescence. In the hit case after=replace_semaphores(filter-out-address) observed: every surviving semaphore was an old member, pending fields are unchanged, and dataqueue_map is unchanged. Apply old semaphore_delete_quiescent for the second ID to those old members and identical map lookups. This holds even if IDs coincide; removal cannot create waiters/references. No os_inv or freshness assumption is required for this pure monotonicity.

- Split `proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_2`: Use the saved equality between the C blank field and dq_sem_blank q and its branch sign. Unfold dataqueue_retired and project dq_sem_blank; rewrite Z.leb 0 blank to true for the nonnegative branch or false for the negative branch. The desired equality is then reflexivity after substitution. Duplicate split equations are each proved, not skipped.

- Split `proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_3`: Use the saved equality between the C blank field and dq_sem_blank q and its branch sign. Unfold dataqueue_retired and project dq_sem_blank; rewrite Z.leb 0 blank to true for the nonnegative branch or false for the negative branch. The desired equality is then reflexivity after substitution. Duplicate split equations are each proved, not skipped.
### `proof_of_DeInitDataqueue_entail_wit_4_3` — `aggressive_pre_process`

- Split `proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_1`: Use the saved equality between the C blank field and dq_sem_blank q and its branch sign. Unfold dataqueue_retired and project dq_sem_blank; rewrite Z.leb 0 blank to true for the nonnegative branch or false for the negative branch. The desired equality is then reflexivity after substitution. Duplicate split equations are each proved, not skipped.

- Split `proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_2`: Use the saved equality between the C blank field and dq_sem_blank q and its branch sign. Unfold dataqueue_retired and project dq_sem_blank; rewrite Z.leb 0 blank to true for the nonnegative branch or false for the negative branch. The desired equality is then reflexivity after substitution. Duplicate split equations are each proved, not skipped.
### `proof_of_DeInitDataqueue_entail_wit_4_4` — `aggressive_pre_process`

- Split `proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_1`: Use the saved equality between the C blank field and dq_sem_blank q and its branch sign. Unfold dataqueue_retired and project dq_sem_blank; rewrite Z.leb 0 blank to true for the nonnegative branch or false for the negative branch. The desired equality is then reflexivity after substitution. Duplicate split equations are each proved, not skipped.

- Split `proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_2`: Use the saved equality between the C blank field and dq_sem_blank q and its branch sign. Unfold dataqueue_retired and project dq_sem_blank; rewrite Z.leb 0 blank to true for the nonnegative branch or false for the negative branch. The desired equality is then reflexivity after substitution. Duplicate split equations are each proved, not skipped.
### `proof_of_DeInitDataqueue_entail_wit_5_1` — `LLM_pre_process`

Choose whole-goal LEFT alternative. Branch 1: instantiate final=after when data ID is nonnegative (1/2), otherwise final=middle (3/4). First ID uses saved delete effect in 1/3, middle=observed in 2/4. These two branch choices construct dataqueue_cleanup_effect q observed final exactly, with no additional semaphore existence premise. Use safeExec of assertS followed by os_atomic_cmd, observed membership from RTrans, and high-step/atomic refinement to derive safeExec(LastSeen final,ret tt,X) and GTrans observed final. Reassemble store_dataqueue p (dataqueue_retired q): base=0/slots=nil eliminates buffer, keep front/rear/max_len, blank already retired, and data=-1 or preserved negative according to branch guard. Nonzero/alignment and padding are in the antecedent. Frame InsideCritical sg observed and current os_inv sg final. No resource is inferred merely from the pure effect.
### `proof_of_DeInitDataqueue_entail_wit_5_2` — `LLM_pre_process`

Choose whole-goal LEFT alternative. Branch 2: instantiate final=after when data ID is nonnegative (1/2), otherwise final=middle (3/4). First ID uses saved delete effect in 1/3, middle=observed in 2/4. These two branch choices construct dataqueue_cleanup_effect q observed final exactly, with no additional semaphore existence premise. Use safeExec of assertS followed by os_atomic_cmd, observed membership from RTrans, and high-step/atomic refinement to derive safeExec(LastSeen final,ret tt,X) and GTrans observed final. Reassemble store_dataqueue p (dataqueue_retired q): base=0/slots=nil eliminates buffer, keep front/rear/max_len, blank already retired, and data=-1 or preserved negative according to branch guard. Nonzero/alignment and padding are in the antecedent. Frame InsideCritical sg observed and current os_inv sg final. No resource is inferred merely from the pure effect.
### `proof_of_DeInitDataqueue_entail_wit_5_3` — `LLM_pre_process`

Choose whole-goal LEFT alternative. Branch 3: instantiate final=after when data ID is nonnegative (1/2), otherwise final=middle (3/4). First ID uses saved delete effect in 1/3, middle=observed in 2/4. These two branch choices construct dataqueue_cleanup_effect q observed final exactly, with no additional semaphore existence premise. Use safeExec of assertS followed by os_atomic_cmd, observed membership from RTrans, and high-step/atomic refinement to derive safeExec(LastSeen final,ret tt,X) and GTrans observed final. Reassemble store_dataqueue p (dataqueue_retired q): base=0/slots=nil eliminates buffer, keep front/rear/max_len, blank already retired, and data=-1 or preserved negative according to branch guard. Nonzero/alignment and padding are in the antecedent. Frame InsideCritical sg observed and current os_inv sg final. No resource is inferred merely from the pure effect.
### `proof_of_DeInitDataqueue_entail_wit_5_4` — `LLM_pre_process`

Choose whole-goal LEFT alternative. Branch 4: instantiate final=after when data ID is nonnegative (1/2), otherwise final=middle (3/4). First ID uses saved delete effect in 1/3, middle=observed in 2/4. These two branch choices construct dataqueue_cleanup_effect q observed final exactly, with no additional semaphore existence premise. Use safeExec of assertS followed by os_atomic_cmd, observed membership from RTrans, and high-step/atomic refinement to derive safeExec(LastSeen final,ret tt,X) and GTrans observed final. Reassemble store_dataqueue p (dataqueue_retired q): base=0/slots=nil eliminates buffer, keep front/rear/max_len, blank already retired, and data=-1 or preserved negative according to branch guard. Nonzero/alignment and padding are in the antecedent. Frame InsideCritical sg observed and current os_inv sg final. No resource is inferred merely from the pure effect.
### `proof_of_DeInitDataqueue_which_implies_wit_1` — `LLM_pre_process`

Unfold store_dataqueue into nonzero/aligned structure fields, padding and dataqueue_buffer. Choose each existential field value from q. Split on dq_base q=0. Null branch buffer is emp and slots=nil; choose left alternative and cancel all fields/padding. Nonnull branch has positive max_len and complete store_array dataqueue_slot; prove its conversion into CharArray.undef_full base (max_len*8) by induction on slots/array representation. For None slots forget no values; for Some slots forget data/length values using typed-store-to-undef facts. Authorized dataqueue_layout_abi converts offsets and 8-byte strides; concatenate each slot two four-byte blocks, retaining the structure/padding frame. Array length originates in store_array and scalar range in field stores, not a new assumption. dataqueue_buffer_free_obligation is only a Prop and must not be used as a theorem.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118171259/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118171259/rounds/DeInitDataqueue-vc-proving-r1/groups/group_00__native_manual_restore/proof_reuse.md`.

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
      "DeInitDataqueue-20261118171259",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--group",
      "native_manual_restore"
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
      "DeInitDataqueue-20261118171259",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "native_manual_restore"
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
      "DeInitDataqueue-20261118171259",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "native_manual_restore"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118171259/_coq_builds/DeInitDataqueue-vc-proving-r1/group_00/src/.coq_debug/group_00_native_manual_restore.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118171259/rounds/DeInitDataqueue-vc-proving-r1/groups/group_00__native_manual_restore/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118171259/rounds/DeInitDataqueue-vc-proving-r1/groups/group_00__native_manual_restore/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
