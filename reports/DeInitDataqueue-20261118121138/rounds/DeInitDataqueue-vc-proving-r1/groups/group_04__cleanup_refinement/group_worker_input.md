# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `cleanup_refinement`; difficulty hint: 5/5.
- Copied manual: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/DeInitDataqueue-vc-proving-r1/groups/group_04__cleanup_refinement/DeInitDataqueue_proof_manual.v`.
- Editable proof spans: `proof_of_DeInitDataqueue_entail_wit_5_1`, `proof_of_DeInitDataqueue_entail_wit_5_2`, `proof_of_DeInitDataqueue_entail_wit_5_3`, `proof_of_DeInitDataqueue_entail_wit_5_4`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

### `proof_of_DeInitDataqueue_entail_wit_5_1` — `LLM_pre_process`

Choose whole-goal LEFT alternative. Branch 1: instantiate final=after when data ID is nonnegative (1/2), otherwise final=middle (3/4). First ID uses saved delete effect in 1/3, middle=observed in 2/4. These two branch choices construct dataqueue_cleanup_effect q observed final exactly, with no additional semaphore existence premise. Use safeExec of assertS followed by os_atomic_cmd, observed membership from RTrans, and high-step/atomic refinement to derive safeExec(LastSeen final,ret tt,X) and GTrans observed final. Reassemble store_dataqueue p (dataqueue_retired q): base=0/slots=nil eliminates buffer, keep front/rear/max_len, blank already retired, and data=-1 or preserved negative according to branch guard. Nonzero/alignment and padding are in the antecedent. Frame InsideCritical sg observed and current os_inv sg final. No resource is inferred merely from the pure effect.
### `proof_of_DeInitDataqueue_entail_wit_5_2` — `LLM_pre_process`

Choose whole-goal LEFT alternative. Branch 2: instantiate final=after when data ID is nonnegative (1/2), otherwise final=middle (3/4). First ID uses saved delete effect in 1/3, middle=observed in 2/4. These two branch choices construct dataqueue_cleanup_effect q observed final exactly, with no additional semaphore existence premise. Use safeExec of assertS followed by os_atomic_cmd, observed membership from RTrans, and high-step/atomic refinement to derive safeExec(LastSeen final,ret tt,X) and GTrans observed final. Reassemble store_dataqueue p (dataqueue_retired q): base=0/slots=nil eliminates buffer, keep front/rear/max_len, blank already retired, and data=-1 or preserved negative according to branch guard. Nonzero/alignment and padding are in the antecedent. Frame InsideCritical sg observed and current os_inv sg final. No resource is inferred merely from the pure effect.
### `proof_of_DeInitDataqueue_entail_wit_5_3` — `LLM_pre_process`

Choose whole-goal LEFT alternative. Branch 3: instantiate final=after when data ID is nonnegative (1/2), otherwise final=middle (3/4). First ID uses saved delete effect in 1/3, middle=observed in 2/4. These two branch choices construct dataqueue_cleanup_effect q observed final exactly, with no additional semaphore existence premise. Use safeExec of assertS followed by os_atomic_cmd, observed membership from RTrans, and high-step/atomic refinement to derive safeExec(LastSeen final,ret tt,X) and GTrans observed final. Reassemble store_dataqueue p (dataqueue_retired q): base=0/slots=nil eliminates buffer, keep front/rear/max_len, blank already retired, and data=-1 or preserved negative according to branch guard. Nonzero/alignment and padding are in the antecedent. Frame InsideCritical sg observed and current os_inv sg final. No resource is inferred merely from the pure effect.
### `proof_of_DeInitDataqueue_entail_wit_5_4` — `LLM_pre_process`

Choose whole-goal LEFT alternative. Branch 4: instantiate final=after when data ID is nonnegative (1/2), otherwise final=middle (3/4). First ID uses saved delete effect in 1/3, middle=observed in 2/4. These two branch choices construct dataqueue_cleanup_effect q observed final exactly, with no additional semaphore existence premise. Use safeExec of assertS followed by os_atomic_cmd, observed membership from RTrans, and high-step/atomic refinement to derive safeExec(LastSeen final,ret tt,X) and GTrans observed final. Reassemble store_dataqueue p (dataqueue_retired q): base=0/slots=nil eliminates buffer, keep front/rear/max_len, blank already retired, and data=-1 or preserved negative according to branch guard. Nonzero/alignment and padding are in the antecedent. Frame InsideCritical sg observed and current os_inv sg final. No resource is inferred merely from the pure effect.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_04__cleanup_refinement/proof_reuse.md`.

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
      "cleanup_refinement"
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
      "cleanup_refinement"
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
      "cleanup_refinement"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
}
```

Debug script: `/home/xinra/crtos-verify/verification_runs/DeInitDataqueue-20261118121138/_coq_builds/DeInitDataqueue-vc-proving-r1/group_04/src/.coq_debug/group_04_cleanup_refinement.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_04__cleanup_refinement/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-proving-r1/groups/group_04__cleanup_refinement/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
