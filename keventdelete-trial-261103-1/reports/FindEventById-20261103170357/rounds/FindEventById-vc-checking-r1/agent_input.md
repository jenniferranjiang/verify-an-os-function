# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "FindEventById-vc-checking-r1",
  "round": "FindEventById-vc-checking-r1",
  "main_root": "/home/xinra/crtos/keventdelete-trial-261103-1",
  "target_files": {
    "c_file": "annotated_C/src/FindEventById.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/FindEventById_lib.v",
    "goal_file": "VC/FindEventById_goal.v",
    "proof_auto_file": "VC/FindEventById_proof_auto.v",
    "proof_manual_file": "VC/FindEventById_proof_manual.v",
    "goal_check_file": "VC/FindEventById_goal_check.v",
    "case_name": "FindEventById",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/FindEventById-20261103170357/rounds/FindEventById-vc-checking-r1/FindEventById_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_FindEventById_safety_wit_1": {
        "name": "proof_of_FindEventById_safety_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_safety_wit_1 : FindEventById_safety_wit_1.\n"
      },
      "proof_of_FindEventById_safety_wit_2": {
        "name": "proof_of_FindEventById_safety_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_safety_wit_2 : FindEventById_safety_wit_2.\n"
      },
      "proof_of_FindEventById_safety_wit_3": {
        "name": "proof_of_FindEventById_safety_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_safety_wit_3 : FindEventById_safety_wit_3.\n"
      },
      "proof_of_FindEventById_safety_wit_4": {
        "name": "proof_of_FindEventById_safety_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_safety_wit_4 : FindEventById_safety_wit_4.\n"
      },
      "proof_of_FindEventById_safety_wit_5": {
        "name": "proof_of_FindEventById_safety_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_safety_wit_5 : FindEventById_safety_wit_5.\n"
      },
      "proof_of_FindEventById_safety_wit_6": {
        "name": "proof_of_FindEventById_safety_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_safety_wit_6 : FindEventById_safety_wit_6.\n"
      },
      "proof_of_FindEventById_safety_wit_7": {
        "name": "proof_of_FindEventById_safety_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_safety_wit_7 : FindEventById_safety_wit_7.\n"
      },
      "proof_of_FindEventById_safety_wit_8": {
        "name": "proof_of_FindEventById_safety_wit_8",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_safety_wit_8 : FindEventById_safety_wit_8.\n"
      },
      "proof_of_FindEventById_safety_wit_9": {
        "name": "proof_of_FindEventById_safety_wit_9",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_safety_wit_9 : FindEventById_safety_wit_9.\n"
      },
      "proof_of_FindEventById_safety_wit_10": {
        "name": "proof_of_FindEventById_safety_wit_10",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_safety_wit_10 : FindEventById_safety_wit_10.\n"
      },
      "proof_of_FindEventById_safety_wit_11": {
        "name": "proof_of_FindEventById_safety_wit_11",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_safety_wit_11 : FindEventById_safety_wit_11.\n"
      },
      "proof_of_FindEventById_return_wit_1": {
        "name": "proof_of_FindEventById_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_return_wit_1 : FindEventById_return_wit_1.\n"
      },
      "proof_of_FindEventById_return_wit_2": {
        "name": "proof_of_FindEventById_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_return_wit_2 : FindEventById_return_wit_2.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_1": {
        "name": "proof_of_FindEventById_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_1 : FindEventById_partial_solve_wit_1.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_2": {
        "name": "proof_of_FindEventById_partial_solve_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_2 : FindEventById_partial_solve_wit_2.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_3_pure": {
        "name": "proof_of_FindEventById_partial_solve_wit_3_pure",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_3_pure : FindEventById_partial_solve_wit_3_pure.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_3": {
        "name": "proof_of_FindEventById_partial_solve_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_3 : FindEventById_partial_solve_wit_3.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_4_pure": {
        "name": "proof_of_FindEventById_partial_solve_wit_4_pure",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_4_pure : FindEventById_partial_solve_wit_4_pure.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_4": {
        "name": "proof_of_FindEventById_partial_solve_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_4 : FindEventById_partial_solve_wit_4.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_5_pure": {
        "name": "proof_of_FindEventById_partial_solve_wit_5_pure",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_5_pure : FindEventById_partial_solve_wit_5_pure.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_5": {
        "name": "proof_of_FindEventById_partial_solve_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_5 : FindEventById_partial_solve_wit_5.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_6_pure": {
        "name": "proof_of_FindEventById_partial_solve_wit_6_pure",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_6_pure : FindEventById_partial_solve_wit_6_pure.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_6": {
        "name": "proof_of_FindEventById_partial_solve_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_6 : FindEventById_partial_solve_wit_6.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_7_pure": {
        "name": "proof_of_FindEventById_partial_solve_wit_7_pure",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_7_pure : FindEventById_partial_solve_wit_7_pure.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_7": {
        "name": "proof_of_FindEventById_partial_solve_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_7 : FindEventById_partial_solve_wit_7.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_8_pure": {
        "name": "proof_of_FindEventById_partial_solve_wit_8_pure",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_8_pure : FindEventById_partial_solve_wit_8_pure.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_8": {
        "name": "proof_of_FindEventById_partial_solve_wit_8",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_8 : FindEventById_partial_solve_wit_8.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_9_pure": {
        "name": "proof_of_FindEventById_partial_solve_wit_9_pure",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_9_pure : FindEventById_partial_solve_wit_9_pure.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_9": {
        "name": "proof_of_FindEventById_partial_solve_wit_9",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_9 : FindEventById_partial_solve_wit_9.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_10_pure": {
        "name": "proof_of_FindEventById_partial_solve_wit_10_pure",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_10_pure : FindEventById_partial_solve_wit_10_pure.\n"
      },
      "proof_of_FindEventById_partial_solve_wit_10": {
        "name": "proof_of_FindEventById_partial_solve_wit_10",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_partial_solve_wit_10 : FindEventById_partial_solve_wit_10.\n"
      },
      "proof_of_FindEventById_which_implies_wit_1_split_goal_1": {
        "name": "proof_of_FindEventById_which_implies_wit_1_split_goal_1",
        "parent": "proof_of_FindEventById_which_implies_wit_1",
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_1_split_goal_1 : FindEventById_which_implies_wit_1_split_goal_1.\n"
      },
      "proof_of_FindEventById_which_implies_wit_1_split_goal_spatial": {
        "name": "proof_of_FindEventById_which_implies_wit_1_split_goal_spatial",
        "parent": "proof_of_FindEventById_which_implies_wit_1",
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_1_split_goal_spatial : FindEventById_which_implies_wit_1_split_goal_spatial.\n"
      },
      "proof_of_FindEventById_which_implies_wit_1": {
        "name": "proof_of_FindEventById_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_1 : FindEventById_which_implies_wit_1.\n"
      },
      "proof_of_FindEventById_which_implies_wit_2_split_goal_1": {
        "name": "proof_of_FindEventById_which_implies_wit_2_split_goal_1",
        "parent": "proof_of_FindEventById_which_implies_wit_2",
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_2_split_goal_1 : FindEventById_which_implies_wit_2_split_goal_1.\n"
      },
      "proof_of_FindEventById_which_implies_wit_2_split_goal_spatial": {
        "name": "proof_of_FindEventById_which_implies_wit_2_split_goal_spatial",
        "parent": "proof_of_FindEventById_which_implies_wit_2",
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_2_split_goal_spatial : FindEventById_which_implies_wit_2_split_goal_spatial.\n"
      },
      "proof_of_FindEventById_which_implies_wit_2": {
        "name": "proof_of_FindEventById_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_2 : FindEventById_which_implies_wit_2.\n"
      },
      "proof_of_FindEventById_which_implies_wit_3_split_goal_1": {
        "name": "proof_of_FindEventById_which_implies_wit_3_split_goal_1",
        "parent": "proof_of_FindEventById_which_implies_wit_3",
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_3_split_goal_1 : FindEventById_which_implies_wit_3_split_goal_1.\n"
      },
      "proof_of_FindEventById_which_implies_wit_3_split_goal_2": {
        "name": "proof_of_FindEventById_which_implies_wit_3_split_goal_2",
        "parent": "proof_of_FindEventById_which_implies_wit_3",
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_3_split_goal_2 : FindEventById_which_implies_wit_3_split_goal_2.\n"
      },
      "proof_of_FindEventById_which_implies_wit_3": {
        "name": "proof_of_FindEventById_which_implies_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_3 : FindEventById_which_implies_wit_3.\n"
      },
      "proof_of_FindEventById_which_implies_wit_4": {
        "name": "proof_of_FindEventById_which_implies_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_4 : FindEventById_which_implies_wit_4.\n"
      },
      "proof_of_FindEventById_which_implies_wit_5_split_goal_1": {
        "name": "proof_of_FindEventById_which_implies_wit_5_split_goal_1",
        "parent": "proof_of_FindEventById_which_implies_wit_5",
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_5_split_goal_1 : FindEventById_which_implies_wit_5_split_goal_1.\n"
      },
      "proof_of_FindEventById_which_implies_wit_5_split_goal_2": {
        "name": "proof_of_FindEventById_which_implies_wit_5_split_goal_2",
        "parent": "proof_of_FindEventById_which_implies_wit_5",
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_5_split_goal_2 : FindEventById_which_implies_wit_5_split_goal_2.\n"
      },
      "proof_of_FindEventById_which_implies_wit_5": {
        "name": "proof_of_FindEventById_which_implies_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_FindEventById_which_implies_wit_5 : FindEventById_which_implies_wit_5.\n"
      }
    },
    "top_level": [
      "proof_of_FindEventById_safety_wit_1",
      "proof_of_FindEventById_safety_wit_2",
      "proof_of_FindEventById_safety_wit_3",
      "proof_of_FindEventById_safety_wit_4",
      "proof_of_FindEventById_safety_wit_5",
      "proof_of_FindEventById_safety_wit_6",
      "proof_of_FindEventById_safety_wit_7",
      "proof_of_FindEventById_safety_wit_8",
      "proof_of_FindEventById_safety_wit_9",
      "proof_of_FindEventById_safety_wit_10",
      "proof_of_FindEventById_safety_wit_11",
      "proof_of_FindEventById_return_wit_1",
      "proof_of_FindEventById_return_wit_2",
      "proof_of_FindEventById_partial_solve_wit_1",
      "proof_of_FindEventById_partial_solve_wit_2",
      "proof_of_FindEventById_partial_solve_wit_3_pure",
      "proof_of_FindEventById_partial_solve_wit_3",
      "proof_of_FindEventById_partial_solve_wit_4_pure",
      "proof_of_FindEventById_partial_solve_wit_4",
      "proof_of_FindEventById_partial_solve_wit_5_pure",
      "proof_of_FindEventById_partial_solve_wit_5",
      "proof_of_FindEventById_partial_solve_wit_6_pure",
      "proof_of_FindEventById_partial_solve_wit_6",
      "proof_of_FindEventById_partial_solve_wit_7_pure",
      "proof_of_FindEventById_partial_solve_wit_7",
      "proof_of_FindEventById_partial_solve_wit_8_pure",
      "proof_of_FindEventById_partial_solve_wit_8",
      "proof_of_FindEventById_partial_solve_wit_9_pure",
      "proof_of_FindEventById_partial_solve_wit_9",
      "proof_of_FindEventById_partial_solve_wit_10_pure",
      "proof_of_FindEventById_partial_solve_wit_10",
      "proof_of_FindEventById_which_implies_wit_1",
      "proof_of_FindEventById_which_implies_wit_2",
      "proof_of_FindEventById_which_implies_wit_3",
      "proof_of_FindEventById_which_implies_wit_4",
      "proof_of_FindEventById_which_implies_wit_5"
    ],
    "split_goals": {
      "proof_of_FindEventById_safety_wit_1": [],
      "proof_of_FindEventById_safety_wit_2": [],
      "proof_of_FindEventById_safety_wit_3": [],
      "proof_of_FindEventById_safety_wit_4": [],
      "proof_of_FindEventById_safety_wit_5": [],
      "proof_of_FindEventById_safety_wit_6": [],
      "proof_of_FindEventById_safety_wit_7": [],
      "proof_of_FindEventById_safety_wit_8": [],
      "proof_of_FindEventById_safety_wit_9": [],
      "proof_of_FindEventById_safety_wit_10": [],
      "proof_of_FindEventById_safety_wit_11": [],
      "proof_of_FindEventById_return_wit_1": [],
      "proof_of_FindEventById_return_wit_2": [],
      "proof_of_FindEventById_partial_solve_wit_1": [],
      "proof_of_FindEventById_partial_solve_wit_2": [],
      "proof_of_FindEventById_partial_solve_wit_3_pure": [],
      "proof_of_FindEventById_partial_solve_wit_3": [],
      "proof_of_FindEventById_partial_solve_wit_4_pure": [],
      "proof_of_FindEventById_partial_solve_wit_4": [],
      "proof_of_FindEventById_partial_solve_wit_5_pure": [],
      "proof_of_FindEventById_partial_solve_wit_5": [],
      "proof_of_FindEventById_partial_solve_wit_6_pure": [],
      "proof_of_FindEventById_partial_solve_wit_6": [],
      "proof_of_FindEventById_partial_solve_wit_7_pure": [],
      "proof_of_FindEventById_partial_solve_wit_7": [],
      "proof_of_FindEventById_partial_solve_wit_8_pure": [],
      "proof_of_FindEventById_partial_solve_wit_8": [],
      "proof_of_FindEventById_partial_solve_wit_9_pure": [],
      "proof_of_FindEventById_partial_solve_wit_9": [],
      "proof_of_FindEventById_partial_solve_wit_10_pure": [],
      "proof_of_FindEventById_partial_solve_wit_10": [],
      "proof_of_FindEventById_which_implies_wit_1": [
        "proof_of_FindEventById_which_implies_wit_1_split_goal_1",
        "proof_of_FindEventById_which_implies_wit_1_split_goal_spatial"
      ],
      "proof_of_FindEventById_which_implies_wit_2": [
        "proof_of_FindEventById_which_implies_wit_2_split_goal_1",
        "proof_of_FindEventById_which_implies_wit_2_split_goal_spatial"
      ],
      "proof_of_FindEventById_which_implies_wit_3": [
        "proof_of_FindEventById_which_implies_wit_3_split_goal_1",
        "proof_of_FindEventById_which_implies_wit_3_split_goal_2"
      ],
      "proof_of_FindEventById_which_implies_wit_4": [],
      "proof_of_FindEventById_which_implies_wit_5": [
        "proof_of_FindEventById_which_implies_wit_5_split_goal_1",
        "proof_of_FindEventById_which_implies_wit_5_split_goal_2"
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
      "FindEventById-20261103170357",
      "--round",
      "FindEventById-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
