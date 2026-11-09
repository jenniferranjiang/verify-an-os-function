# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "KEventDelete-vc-checking-r1",
  "round": "KEventDelete-vc-checking-r1",
  "main_root": "/home/xinra/crtos/keventdelete-trial-261103-1",
  "target_files": {
    "c_file": "annotated_C/src/KEventDelete.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/KEventDelete_lib.v",
    "goal_file": "VC/KEventDelete_goal.v",
    "proof_auto_file": "VC/KEventDelete_proof_auto.v",
    "proof_manual_file": "VC/KEventDelete_proof_manual.v",
    "goal_check_file": "VC/KEventDelete_goal_check.v",
    "case_name": "KEventDelete",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/KEventDelete-20261103211513/rounds/KEventDelete-vc-checking-r1/KEventDelete_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_KEventDelete_safety_wit_1": {
        "name": "proof_of_KEventDelete_safety_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_safety_wit_1 : KEventDelete_safety_wit_1.\n"
      },
      "proof_of_KEventDelete_safety_wit_2": {
        "name": "proof_of_KEventDelete_safety_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_safety_wit_2 : KEventDelete_safety_wit_2.\n"
      },
      "proof_of_KEventDelete_safety_wit_3": {
        "name": "proof_of_KEventDelete_safety_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_safety_wit_3 : KEventDelete_safety_wit_3.\n"
      },
      "proof_of_KEventDelete_safety_wit_4": {
        "name": "proof_of_KEventDelete_safety_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_safety_wit_4 : KEventDelete_safety_wit_4.\n"
      },
      "proof_of_KEventDelete_return_wit_2": {
        "name": "proof_of_KEventDelete_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_return_wit_2 : KEventDelete_return_wit_2.\n"
      },
      "proof_of_KEventDelete_partial_solve_wit_1_pure": {
        "name": "proof_of_KEventDelete_partial_solve_wit_1_pure",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_partial_solve_wit_1_pure : KEventDelete_partial_solve_wit_1_pure.\n"
      },
      "proof_of_KEventDelete_partial_solve_wit_1": {
        "name": "proof_of_KEventDelete_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_partial_solve_wit_1 : KEventDelete_partial_solve_wit_1.\n"
      },
      "proof_of_KEventDelete_partial_solve_wit_2_pure": {
        "name": "proof_of_KEventDelete_partial_solve_wit_2_pure",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_partial_solve_wit_2_pure : KEventDelete_partial_solve_wit_2_pure.\n"
      },
      "proof_of_KEventDelete_partial_solve_wit_2": {
        "name": "proof_of_KEventDelete_partial_solve_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_partial_solve_wit_2 : KEventDelete_partial_solve_wit_2.\n"
      },
      "proof_of_KEventDelete_partial_solve_wit_3_pure": {
        "name": "proof_of_KEventDelete_partial_solve_wit_3_pure",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_partial_solve_wit_3_pure : KEventDelete_partial_solve_wit_3_pure.\n"
      },
      "proof_of_KEventDelete_partial_solve_wit_3": {
        "name": "proof_of_KEventDelete_partial_solve_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_partial_solve_wit_3 : KEventDelete_partial_solve_wit_3.\n"
      },
      "proof_of_KEventDelete_partial_solve_wit_4_pure": {
        "name": "proof_of_KEventDelete_partial_solve_wit_4_pure",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_partial_solve_wit_4_pure : KEventDelete_partial_solve_wit_4_pure.\n"
      },
      "proof_of_KEventDelete_partial_solve_wit_4": {
        "name": "proof_of_KEventDelete_partial_solve_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_partial_solve_wit_4 : KEventDelete_partial_solve_wit_4.\n"
      },
      "proof_of_KEventDelete_return_wit_1_split_goal_1": {
        "name": "proof_of_KEventDelete_return_wit_1_split_goal_1",
        "parent": "proof_of_KEventDelete_return_wit_1",
        "statement": "Lemma proof_of_KEventDelete_return_wit_1_split_goal_1 : KEventDelete_return_wit_1_split_goal_1.\n"
      },
      "proof_of_KEventDelete_return_wit_1": {
        "name": "proof_of_KEventDelete_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_return_wit_1 : KEventDelete_return_wit_1.\n"
      },
      "proof_of_KEventDelete_which_implies_wit_1_split_goal_1": {
        "name": "proof_of_KEventDelete_which_implies_wit_1_split_goal_1",
        "parent": "proof_of_KEventDelete_which_implies_wit_1",
        "statement": "Lemma proof_of_KEventDelete_which_implies_wit_1_split_goal_1 : KEventDelete_which_implies_wit_1_split_goal_1.\n"
      },
      "proof_of_KEventDelete_which_implies_wit_1": {
        "name": "proof_of_KEventDelete_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_which_implies_wit_1 : KEventDelete_which_implies_wit_1.\n"
      },
      "proof_of_KEventDelete_which_implies_wit_2_split_goal_1": {
        "name": "proof_of_KEventDelete_which_implies_wit_2_split_goal_1",
        "parent": "proof_of_KEventDelete_which_implies_wit_2",
        "statement": "Lemma proof_of_KEventDelete_which_implies_wit_2_split_goal_1 : KEventDelete_which_implies_wit_2_split_goal_1.\n"
      },
      "proof_of_KEventDelete_which_implies_wit_2": {
        "name": "proof_of_KEventDelete_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_KEventDelete_which_implies_wit_2 : KEventDelete_which_implies_wit_2.\n"
      }
    },
    "top_level": [
      "proof_of_KEventDelete_safety_wit_1",
      "proof_of_KEventDelete_safety_wit_2",
      "proof_of_KEventDelete_safety_wit_3",
      "proof_of_KEventDelete_safety_wit_4",
      "proof_of_KEventDelete_return_wit_2",
      "proof_of_KEventDelete_partial_solve_wit_1_pure",
      "proof_of_KEventDelete_partial_solve_wit_1",
      "proof_of_KEventDelete_partial_solve_wit_2_pure",
      "proof_of_KEventDelete_partial_solve_wit_2",
      "proof_of_KEventDelete_partial_solve_wit_3_pure",
      "proof_of_KEventDelete_partial_solve_wit_3",
      "proof_of_KEventDelete_partial_solve_wit_4_pure",
      "proof_of_KEventDelete_partial_solve_wit_4",
      "proof_of_KEventDelete_return_wit_1",
      "proof_of_KEventDelete_which_implies_wit_1",
      "proof_of_KEventDelete_which_implies_wit_2"
    ],
    "split_goals": {
      "proof_of_KEventDelete_safety_wit_1": [],
      "proof_of_KEventDelete_safety_wit_2": [],
      "proof_of_KEventDelete_safety_wit_3": [],
      "proof_of_KEventDelete_safety_wit_4": [],
      "proof_of_KEventDelete_return_wit_2": [],
      "proof_of_KEventDelete_partial_solve_wit_1_pure": [],
      "proof_of_KEventDelete_partial_solve_wit_1": [],
      "proof_of_KEventDelete_partial_solve_wit_2_pure": [],
      "proof_of_KEventDelete_partial_solve_wit_2": [],
      "proof_of_KEventDelete_partial_solve_wit_3_pure": [],
      "proof_of_KEventDelete_partial_solve_wit_3": [],
      "proof_of_KEventDelete_partial_solve_wit_4_pure": [],
      "proof_of_KEventDelete_partial_solve_wit_4": [],
      "proof_of_KEventDelete_return_wit_1": [
        "proof_of_KEventDelete_return_wit_1_split_goal_1"
      ],
      "proof_of_KEventDelete_which_implies_wit_1": [
        "proof_of_KEventDelete_which_implies_wit_1_split_goal_1"
      ],
      "proof_of_KEventDelete_which_implies_wit_2": [
        "proof_of_KEventDelete_which_implies_wit_2_split_goal_1"
      ]
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
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "KEventDelete-20261103211513",
      "--round",
      "KEventDelete-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
