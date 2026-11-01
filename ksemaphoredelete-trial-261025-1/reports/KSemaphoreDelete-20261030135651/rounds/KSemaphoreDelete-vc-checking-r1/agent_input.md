# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "KSemaphoreDelete-vc-checking-r1",
  "round": "KSemaphoreDelete-vc-checking-r1",
  "main_root": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
  "target_files": {
    "c_file": "annotated_C/src/KSemaphoreDelete.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/KSemaphoreDelete_lib.v",
    "goal_file": "VC/KSemaphoreDelete_goal.v",
    "proof_auto_file": "VC/KSemaphoreDelete_proof_auto.v",
    "proof_manual_file": "VC/KSemaphoreDelete_proof_manual.v",
    "goal_check_file": "VC/KSemaphoreDelete_goal_check.v",
    "case_name": "KSemaphoreDelete",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/KSemaphoreDelete-20261030135651/rounds/KSemaphoreDelete-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/KSemaphoreDelete-20261030135651/rounds/KSemaphoreDelete-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/KSemaphoreDelete-20261030135651/rounds/KSemaphoreDelete-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/KSemaphoreDelete-20261030135651/rounds/KSemaphoreDelete-vc-checking-r1/KSemaphoreDelete_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_KSemaphoreDelete_return_wit_1": {
        "name": "proof_of_KSemaphoreDelete_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_KSemaphoreDelete_return_wit_1 : KSemaphoreDelete_return_wit_1.\n"
      },
      "proof_of_KSemaphoreDelete_partial_solve_wit_1_pure": {
        "name": "proof_of_KSemaphoreDelete_partial_solve_wit_1_pure",
        "parent": null,
        "statement": "Lemma proof_of_KSemaphoreDelete_partial_solve_wit_1_pure : KSemaphoreDelete_partial_solve_wit_1_pure.\n"
      },
      "proof_of_KSemaphoreDelete_partial_solve_wit_1": {
        "name": "proof_of_KSemaphoreDelete_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_KSemaphoreDelete_partial_solve_wit_1 : KSemaphoreDelete_partial_solve_wit_1.\n"
      }
    },
    "top_level": [
      "proof_of_KSemaphoreDelete_return_wit_1",
      "proof_of_KSemaphoreDelete_partial_solve_wit_1_pure",
      "proof_of_KSemaphoreDelete_partial_solve_wit_1"
    ],
    "split_goals": {
      "proof_of_KSemaphoreDelete_return_wit_1": [],
      "proof_of_KSemaphoreDelete_partial_solve_wit_1_pure": [],
      "proof_of_KSemaphoreDelete_partial_solve_wit_1": []
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
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-debug",
      "--run",
      "KSemaphoreDelete-20261030135651",
      "--round",
      "KSemaphoreDelete-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
