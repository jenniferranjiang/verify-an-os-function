# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `first_delete_transition`; difficulty hint: 4/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/DeInitDataqueue-vc-proving-r1/groups/group_03__first_delete_transition/DeInitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_DeInitDataqueue_entail_wit_4_1`, `proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_1`, `proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_2`, `proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_3`, `proof_of_DeInitDataqueue_entail_wit_4_2`, `proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_1`, `proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_2`, `proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_3`, `proof_of_DeInitDataqueue_entail_wit_4_3`, `proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_1`, `proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_2`, `proof_of_DeInitDataqueue_entail_wit_4_4`, `proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_1`, `proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_2`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

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

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_03__first_delete_transition/proof_reuse.md`.

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
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--group",
      "first_delete_transition"
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
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "first_delete_transition"
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
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "first_delete_transition"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/_coq_builds/DeInitDataqueue-vc-proving-r1/group_03/src/.coq_debug/group_03_first_delete_transition.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_03__first_delete_transition/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_03__first_delete_transition/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
