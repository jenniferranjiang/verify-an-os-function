# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "LinklistResumeAll-vc-checking-r1",
  "round": "LinklistResumeAll-vc-checking-r1",
  "main_root": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
  "target_files": {
    "c_file": "annotated_C/src/LinklistResumeAll.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/LinklistResumeAll_lib.v",
    "goal_file": "VC/LinklistResumeAll_goal.v",
    "proof_auto_file": "VC/LinklistResumeAll_proof_auto.v",
    "proof_manual_file": "VC/LinklistResumeAll_proof_manual.v",
    "goal_check_file": "VC/LinklistResumeAll_goal_check.v",
    "case_name": "LinklistResumeAll",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "present",
  "report": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/LinklistResumeAll-20261030234941/rounds/LinklistResumeAll-vc-checking-r1/LinklistResumeAll_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_LinklistResumeAll_entail_wit_1": {
        "name": "proof_of_LinklistResumeAll_entail_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_entail_wit_1 : LinklistResumeAll_entail_wit_1.\n"
      },
      "proof_of_LinklistResumeAll_entail_wit_2": {
        "name": "proof_of_LinklistResumeAll_entail_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_entail_wit_2 : LinklistResumeAll_entail_wit_2.\n"
      },
      "proof_of_LinklistResumeAll_return_wit_1_split_goal_1": {
        "name": "proof_of_LinklistResumeAll_return_wit_1_split_goal_1",
        "parent": "proof_of_LinklistResumeAll_return_wit_1",
        "statement": "Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_1 : LinklistResumeAll_return_wit_1_split_goal_1.\n"
      },
      "proof_of_LinklistResumeAll_return_wit_1_split_goal_2": {
        "name": "proof_of_LinklistResumeAll_return_wit_1_split_goal_2",
        "parent": "proof_of_LinklistResumeAll_return_wit_1",
        "statement": "Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_2 : LinklistResumeAll_return_wit_1_split_goal_2.\n"
      },
      "proof_of_LinklistResumeAll_return_wit_1_split_goal_3": {
        "name": "proof_of_LinklistResumeAll_return_wit_1_split_goal_3",
        "parent": "proof_of_LinklistResumeAll_return_wit_1",
        "statement": "Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_3 : LinklistResumeAll_return_wit_1_split_goal_3.\n"
      },
      "proof_of_LinklistResumeAll_return_wit_1": {
        "name": "proof_of_LinklistResumeAll_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_return_wit_1 : LinklistResumeAll_return_wit_1.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_1": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_1 : LinklistResumeAll_which_implies_wit_1.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_2_split_goal_spatial": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_2_split_goal_spatial",
        "parent": "proof_of_LinklistResumeAll_which_implies_wit_2",
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_2_split_goal_spatial : LinklistResumeAll_which_implies_wit_2_split_goal_spatial.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_2": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_2 : LinklistResumeAll_which_implies_wit_2.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_3": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_3 : LinklistResumeAll_which_implies_wit_3.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_4_split_goal_spatial": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_4_split_goal_spatial",
        "parent": "proof_of_LinklistResumeAll_which_implies_wit_4",
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_4_split_goal_spatial : LinklistResumeAll_which_implies_wit_4_split_goal_spatial.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_4": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_4 : LinklistResumeAll_which_implies_wit_4.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial",
        "parent": "proof_of_LinklistResumeAll_which_implies_wit_5",
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial : LinklistResumeAll_which_implies_wit_5_split_goal_spatial.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_5": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_5 : LinklistResumeAll_which_implies_wit_5.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_6": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_6 : LinklistResumeAll_which_implies_wit_6.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_7_split_goal_spatial": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_7_split_goal_spatial",
        "parent": "proof_of_LinklistResumeAll_which_implies_wit_7",
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_7_split_goal_spatial : LinklistResumeAll_which_implies_wit_7_split_goal_spatial.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_7": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_7 : LinklistResumeAll_which_implies_wit_7.\n"
      },
      "proof_of_LinklistResumeAll_safety_wit_1": {
        "name": "proof_of_LinklistResumeAll_safety_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_safety_wit_1 : LinklistResumeAll_safety_wit_1.\n"
      },
      "proof_of_LinklistResumeAll_safety_wit_2": {
        "name": "proof_of_LinklistResumeAll_safety_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_safety_wit_2 : LinklistResumeAll_safety_wit_2.\n"
      },
      "proof_of_LinklistResumeAll_safety_wit_3": {
        "name": "proof_of_LinklistResumeAll_safety_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_safety_wit_3 : LinklistResumeAll_safety_wit_3.\n"
      },
      "proof_of_LinklistResumeAll_safety_wit_4": {
        "name": "proof_of_LinklistResumeAll_safety_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_safety_wit_4 : LinklistResumeAll_safety_wit_4.\n"
      },
      "proof_of_LinklistResumeAll_safety_wit_5": {
        "name": "proof_of_LinklistResumeAll_safety_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_safety_wit_5 : LinklistResumeAll_safety_wit_5.\n"
      },
      "proof_of_LinklistResumeAll_safety_wit_6": {
        "name": "proof_of_LinklistResumeAll_safety_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_safety_wit_6 : LinklistResumeAll_safety_wit_6.\n"
      },
      "proof_of_LinklistResumeAll_safety_wit_7": {
        "name": "proof_of_LinklistResumeAll_safety_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_safety_wit_7 : LinklistResumeAll_safety_wit_7.\n"
      },
      "proof_of_LinklistResumeAll_safety_wit_8": {
        "name": "proof_of_LinklistResumeAll_safety_wit_8",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_safety_wit_8 : LinklistResumeAll_safety_wit_8.\n"
      },
      "proof_of_LinklistResumeAll_safety_wit_9": {
        "name": "proof_of_LinklistResumeAll_safety_wit_9",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_safety_wit_9 : LinklistResumeAll_safety_wit_9.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_1": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_1 : LinklistResumeAll_partial_solve_wit_1.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_2_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_2_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_2_pure : LinklistResumeAll_partial_solve_wit_2_pure.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_2": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_2 : LinklistResumeAll_partial_solve_wit_2.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_3": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_3 : LinklistResumeAll_partial_solve_wit_3.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_4": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_4 : LinklistResumeAll_partial_solve_wit_4.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_5_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_5_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_5_pure : LinklistResumeAll_partial_solve_wit_5_pure.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_5": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_5 : LinklistResumeAll_partial_solve_wit_5.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_6_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_6_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_6_pure : LinklistResumeAll_partial_solve_wit_6_pure.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_6": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_6 : LinklistResumeAll_partial_solve_wit_6.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_7_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_7_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_7_pure : LinklistResumeAll_partial_solve_wit_7_pure.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_7": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_7 : LinklistResumeAll_partial_solve_wit_7.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_8": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_8",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_8 : LinklistResumeAll_partial_solve_wit_8.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_9": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_9",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_9 : LinklistResumeAll_partial_solve_wit_9.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_10_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_10_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_10_pure : LinklistResumeAll_partial_solve_wit_10_pure.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_10": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_10",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_10 : LinklistResumeAll_partial_solve_wit_10.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_11": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_11",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_11 : LinklistResumeAll_partial_solve_wit_11.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_12": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_12",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_12 : LinklistResumeAll_partial_solve_wit_12.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_13_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_13_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_13_pure : LinklistResumeAll_partial_solve_wit_13_pure.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_13": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_13",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.\n"
      }
    },
    "top_level": [
      "proof_of_LinklistResumeAll_entail_wit_1",
      "proof_of_LinklistResumeAll_entail_wit_2",
      "proof_of_LinklistResumeAll_return_wit_1",
      "proof_of_LinklistResumeAll_which_implies_wit_1",
      "proof_of_LinklistResumeAll_which_implies_wit_2",
      "proof_of_LinklistResumeAll_which_implies_wit_3",
      "proof_of_LinklistResumeAll_which_implies_wit_4",
      "proof_of_LinklistResumeAll_which_implies_wit_5",
      "proof_of_LinklistResumeAll_which_implies_wit_6",
      "proof_of_LinklistResumeAll_which_implies_wit_7",
      "proof_of_LinklistResumeAll_safety_wit_1",
      "proof_of_LinklistResumeAll_safety_wit_2",
      "proof_of_LinklistResumeAll_safety_wit_3",
      "proof_of_LinklistResumeAll_safety_wit_4",
      "proof_of_LinklistResumeAll_safety_wit_5",
      "proof_of_LinklistResumeAll_safety_wit_6",
      "proof_of_LinklistResumeAll_safety_wit_7",
      "proof_of_LinklistResumeAll_safety_wit_8",
      "proof_of_LinklistResumeAll_safety_wit_9",
      "proof_of_LinklistResumeAll_partial_solve_wit_1",
      "proof_of_LinklistResumeAll_partial_solve_wit_2_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_2",
      "proof_of_LinklistResumeAll_partial_solve_wit_3",
      "proof_of_LinklistResumeAll_partial_solve_wit_4",
      "proof_of_LinklistResumeAll_partial_solve_wit_5_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_5",
      "proof_of_LinklistResumeAll_partial_solve_wit_6_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_6",
      "proof_of_LinklistResumeAll_partial_solve_wit_7_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_7",
      "proof_of_LinklistResumeAll_partial_solve_wit_8",
      "proof_of_LinklistResumeAll_partial_solve_wit_9",
      "proof_of_LinklistResumeAll_partial_solve_wit_10_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_10",
      "proof_of_LinklistResumeAll_partial_solve_wit_11",
      "proof_of_LinklistResumeAll_partial_solve_wit_12",
      "proof_of_LinklistResumeAll_partial_solve_wit_13_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_13"
    ],
    "split_goals": {
      "proof_of_LinklistResumeAll_entail_wit_1": [],
      "proof_of_LinklistResumeAll_entail_wit_2": [],
      "proof_of_LinklistResumeAll_return_wit_1": [
        "proof_of_LinklistResumeAll_return_wit_1_split_goal_1",
        "proof_of_LinklistResumeAll_return_wit_1_split_goal_2",
        "proof_of_LinklistResumeAll_return_wit_1_split_goal_3"
      ],
      "proof_of_LinklistResumeAll_which_implies_wit_1": [],
      "proof_of_LinklistResumeAll_which_implies_wit_2": [
        "proof_of_LinklistResumeAll_which_implies_wit_2_split_goal_spatial"
      ],
      "proof_of_LinklistResumeAll_which_implies_wit_3": [],
      "proof_of_LinklistResumeAll_which_implies_wit_4": [
        "proof_of_LinklistResumeAll_which_implies_wit_4_split_goal_spatial"
      ],
      "proof_of_LinklistResumeAll_which_implies_wit_5": [
        "proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial"
      ],
      "proof_of_LinklistResumeAll_which_implies_wit_6": [],
      "proof_of_LinklistResumeAll_which_implies_wit_7": [
        "proof_of_LinklistResumeAll_which_implies_wit_7_split_goal_spatial"
      ],
      "proof_of_LinklistResumeAll_safety_wit_1": [],
      "proof_of_LinklistResumeAll_safety_wit_2": [],
      "proof_of_LinklistResumeAll_safety_wit_3": [],
      "proof_of_LinklistResumeAll_safety_wit_4": [],
      "proof_of_LinklistResumeAll_safety_wit_5": [],
      "proof_of_LinklistResumeAll_safety_wit_6": [],
      "proof_of_LinklistResumeAll_safety_wit_7": [],
      "proof_of_LinklistResumeAll_safety_wit_8": [],
      "proof_of_LinklistResumeAll_safety_wit_9": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_1": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_2_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_2": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_3": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_4": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_5_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_5": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_6_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_6": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_7_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_7": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_8": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_9": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_10_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_10": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_11": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_12": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_13_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_13": []
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
      "LinklistResumeAll-20261030234941",
      "--round",
      "LinklistResumeAll-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
