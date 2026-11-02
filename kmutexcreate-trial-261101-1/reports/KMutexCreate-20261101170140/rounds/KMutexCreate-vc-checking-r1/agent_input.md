# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "KMutexCreate-vc-checking-r1",
  "round": "KMutexCreate-vc-checking-r1",
  "main_root": "/home/xinra/crtos/kmutexcreate-trial-261101-1",
  "target_files": {
    "c_file": "annotated_C/src/KMutexCreate.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/KMutexCreate_lib.v",
    "goal_file": "VC/KMutexCreate_goal.v",
    "proof_auto_file": "VC/KMutexCreate_proof_auto.v",
    "proof_manual_file": "VC/KMutexCreate_proof_manual.v",
    "goal_check_file": "VC/KMutexCreate_goal_check.v",
    "case_name": "KMutexCreate",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/KMutexCreate-20261101170140/rounds/KMutexCreate-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/KMutexCreate-20261101170140/rounds/KMutexCreate-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/KMutexCreate-20261101170140/rounds/KMutexCreate-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/KMutexCreate-20261101170140/rounds/KMutexCreate-vc-checking-r1/KMutexCreate_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_KMutexCreate_return_wit_1": {
        "name": "proof_of_KMutexCreate_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_KMutexCreate_return_wit_1 : KMutexCreate_return_wit_1.\n"
      },
      "proof_of_KMutexCreate_return_wit_2": {
        "name": "proof_of_KMutexCreate_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_KMutexCreate_return_wit_2 : KMutexCreate_return_wit_2.\n"
      },
      "proof_of_KMutexCreate_partial_solve_wit_1_pure": {
        "name": "proof_of_KMutexCreate_partial_solve_wit_1_pure",
        "parent": null,
        "statement": "Lemma proof_of_KMutexCreate_partial_solve_wit_1_pure : KMutexCreate_partial_solve_wit_1_pure.\n"
      },
      "proof_of_KMutexCreate_partial_solve_wit_1": {
        "name": "proof_of_KMutexCreate_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_KMutexCreate_partial_solve_wit_1 : KMutexCreate_partial_solve_wit_1.\n"
      }
    },
    "top_level": [
      "proof_of_KMutexCreate_return_wit_1",
      "proof_of_KMutexCreate_return_wit_2",
      "proof_of_KMutexCreate_partial_solve_wit_1_pure",
      "proof_of_KMutexCreate_partial_solve_wit_1"
    ],
    "split_goals": {
      "proof_of_KMutexCreate_return_wit_1": [],
      "proof_of_KMutexCreate_return_wit_2": [],
      "proof_of_KMutexCreate_partial_solve_wit_1_pure": [],
      "proof_of_KMutexCreate_partial_solve_wit_1": []
    }
  },
  "max_witnesses_per_group": 12,
  "annotation_comparisons": []
}
```

Use exact argv and cwd. A shell-only tool must quote arguments for its actual shell. Keep the terminal session until exit; checks need exit code 0 and JSON passed.

```json
[
  {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-debug",
      "--run",
      "KMutexCreate-20261101170140",
      "--round",
      "KMutexCreate-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
