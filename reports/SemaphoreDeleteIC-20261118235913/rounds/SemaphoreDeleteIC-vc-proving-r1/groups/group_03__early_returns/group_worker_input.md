# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `early_returns`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/SemaphoreDeleteIC-20261118235913/SemaphoreDeleteIC-vc-proving-r1/groups/group_03__early_returns/SemaphoreDeleteIC_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreDelete_entail_wit_3_1`, `proof_of__SemaphoreDelete_return_wit_1`, `proof_of__SemaphoreDelete_return_wit_2`, `proof_of__SemaphoreDelete_return_wit_3`, `proof_of__SemaphoreDelete_return_wit_3_split_goal_1`, `proof_of__SemaphoreDelete_return_wit_4`, `proof_of__SemaphoreDelete_return_wit_4_split_goal_1`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of__SemaphoreDelete_entail_wit_3_1` — `LLM_pre_process`

Use LLM_pre_process. The antecedent simultaneously states query(old,delete_sem_id)=false and query(old,original.id)=true, with delete_sem_id=original.id. Substitute and discriminate; the purported absent-ID branch is impossible. No after witness or memory conversion is needed on this contradictory branch.
### `proof_of__SemaphoreDelete_return_wit_1` — `LLM_pre_process`

Use LLM_pre_process. This is the imported IdGet null-manager branch: k_sem_id_manager=0 contradicts the existing QCP CNotation addr_of_LE_var_not_zero fact for the named global address. Derive False; do not claim a lookup-miss effect without query=false or introduce a new address axiom.
### `proof_of__SemaphoreDelete_return_wit_2` — `LLM_pre_process`

Use LLM_pre_process. Choose after=before and reconstruct os_inv from its opened manager/DLL/global frame. Normalize query ID by the retained 0<=id<=65535 bounds. query(semaphore_manager old,id)=false means no member of map semaphore_id old equals id, hence every old semaphore has a different queried ID. Establish the valid-ID no-match branch of semaphore_delete_ic_effect; the full dataqueue and all other resources remain unchanged.
### `proof_of__SemaphoreDelete_return_wit_3` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_return_wit_3_split_goal_1`: Unfold semaphore_delete_ic_effect and choose its invalid-ID/state-unchanged disjunct. Use id<0 and reflexive before=before; quiescent is not needed to force valid range.
### `proof_of__SemaphoreDelete_return_wit_4` — `aggressive_pre_process`

- Split `proof_of__SemaphoreDelete_return_wit_4_split_goal_1`: Unfold semaphore_delete_ic_effect and choose invalid-ID/state-unchanged. The guard id>65535 directly proves the high-ID alternative and state equality is reflexive.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/SemaphoreDeleteIC-20261118235913/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/rounds/SemaphoreDeleteIC-vc-proving-r1/groups/group_03__early_returns/proof_reuse.md`.

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
      "early_returns"
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
      "early_returns"
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
      "early_returns"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/SemaphoreDeleteIC-20261118235913/_coq_builds/SemaphoreDeleteIC-vc-proving-r1/group_03/src/.coq_debug/group_03_early_returns.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/rounds/SemaphoreDeleteIC-vc-proving-r1/groups/group_03__early_returns/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/rounds/SemaphoreDeleteIC-vc-proving-r1/groups/group_03__early_returns/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
