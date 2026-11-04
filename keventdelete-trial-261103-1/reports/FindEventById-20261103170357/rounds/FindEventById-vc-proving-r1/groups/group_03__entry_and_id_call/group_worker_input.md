# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `entry_and_id_call`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/FindEventById-vc-proving-r1/groups/group_03__entry_and_id_call/FindEventById_proof_manual.v`.
- Editable proof spans: `proof_of_FindEventById_partial_solve_wit_1`, `proof_of_FindEventById_partial_solve_wit_2`, `proof_of_FindEventById_partial_solve_wit_3_pure`, `proof_of_FindEventById_partial_solve_wit_3`, `proof_of_FindEventById_partial_solve_wit_4_pure`, `proof_of_FindEventById_partial_solve_wit_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
- Group library: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/FindEventById-vc-proving-r1/groups/group_03__entry_and_id_call/FindEventById_lib.v`
- Read-only canonical library: `/home/xinra/crtos/keventdelete-trial-261103-1/VC/FindEventById_lib.v`
- Every new/adapted helper uses suffix `__entry_and_id_call`. Preserve the seed.

### `proof_of_FindEventById_partial_solve_wit_1` — `LLM_pre_process`

P and Q both own OutsideCritical(sg,before). Introduce binders, copy id bounds/nonnegative and safeExec hypotheses into Q and cancel OutsideCritical unchanged. There is no state update or existential.
### `proof_of_FindEventById_partial_solve_wit_2` — `LLM_pre_process`

P has InsideCritical(sg,st_lock) ** os_inv(sg,st_lock); Q has the same pair in reverse order, plus hypotheses RTrans, ID bounds and safeExec. Reorder/cancel spatial resources and copy pure facts; do not unfold protocol ownership.
### `proof_of_FindEventById_partial_solve_wit_3_pure` — `LLM_pre_process`

Introduce the VC binders. Its pure target (0<=id_pre and id_pre<65536) is explicitly present in the hypotheses, apart from the indicated retval=found rewriting. Split pure conjunctions and discharge by assumption/congruence; spatial locals, manager/frame or os_inv/InsideCritical are not consumed to invent facts. No existential witness or new helper is needed.
### `proof_of_FindEventById_partial_solve_wit_3` — `LLM_pre_process`

Unfold partial_solve_wit_3 to the implication from the pure obligation to its aux obligation, then introduce that premise and all aux binders. The aux P and Q contain the same manager/frame/InsideCritical or os_inv/InsideCritical resources, possibly reordered; cancel them using the separation frame rule. Each pure clause in Q is an explicit aux hypothesis; in case 9 rewrite retval=found for lookup_result. The pure-obligation implication premise need not supply any missing state/resource. No helper or allocation witness is needed.
### `proof_of_FindEventById_partial_solve_wit_4_pure` — `LLM_pre_process`

Introduce the VC binders. Its pure target (idmanager_query(event_manager(os_events st_lock),id_pre)=false) is explicitly present in the hypotheses, apart from the indicated retval=found rewriting. Split pure conjunctions and discharge by assumption/congruence; spatial locals, manager/frame or os_inv/InsideCritical are not consumed to invent facts. No existential witness or new helper is needed.
### `proof_of_FindEventById_partial_solve_wit_4` — `LLM_pre_process`

Unfold partial_solve_wit_4 to the implication from the pure obligation to its aux obligation, then introduce that premise and all aux binders. The aux P and Q contain the same manager/frame/InsideCritical or os_inv/InsideCritical resources, possibly reordered; cancel them using the separation frame rule. Each pure clause in Q is an explicit aux hypothesis; in case 9 rewrite retval=found for lookup_result. The pure-obligation implication premise need not supply any missing state/resource. No helper or allocation witness is needed.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_03__entry_and_id_call/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "FindEventById-20261103170357",
      "--round",
      "FindEventById-vc-proving-r1",
      "--group",
      "entry_and_id_call"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "development": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "FindEventById-20261103170357",
      "--round",
      "FindEventById-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "entry_and_id_call"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  "check": {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "FindEventById-20261103170357",
      "--round",
      "FindEventById-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "entry_and_id_call"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
}
```

Debug script: `/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/FindEventById-20261103170357/_coq_builds/FindEventById-vc-proving-r1/group_03/src/.coq_debug/group_03_entry_and_id_call.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_03__entry_and_id_call/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-proving-r1/groups/group_03__entry_and_id_call/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
