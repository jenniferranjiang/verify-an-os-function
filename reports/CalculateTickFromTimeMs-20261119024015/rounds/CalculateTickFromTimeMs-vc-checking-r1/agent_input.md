# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "CalculateTickFromTimeMs-vc-checking-r1",
  "round": "CalculateTickFromTimeMs-vc-checking-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/common/CalculateTickFromTimeMs.c",
    "formal_directory": "VC/common",
    "formal_case_lib": "VC/common/CalculateTickFromTimeMs_lib.v",
    "goal_file": "VC/common/CalculateTickFromTimeMs_goal.v",
    "proof_auto_file": "VC/common/CalculateTickFromTimeMs_proof_auto.v",
    "proof_manual_file": "VC/common/CalculateTickFromTimeMs_proof_manual.v",
    "goal_check_file": "VC/common/CalculateTickFromTimeMs_goal_check.v",
    "case_name": "CalculateTickFromTimeMs",
    "active_case_theory": "CRTOS_Verify.VC.common"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/rounds/CalculateTickFromTimeMs-vc-checking-r1/CalculateTickFromTimeMs_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_CalculateTickFromTimeMs_return_wit_1_split_goal_1": {
        "name": "proof_of_CalculateTickFromTimeMs_return_wit_1_split_goal_1",
        "parent": "proof_of_CalculateTickFromTimeMs_return_wit_1",
        "statement": "Lemma proof_of_CalculateTickFromTimeMs_return_wit_1_split_goal_1 : CalculateTickFromTimeMs_return_wit_1_split_goal_1.\n"
      },
      "proof_of_CalculateTickFromTimeMs_return_wit_1": {
        "name": "proof_of_CalculateTickFromTimeMs_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_CalculateTickFromTimeMs_return_wit_1 : CalculateTickFromTimeMs_return_wit_1.\n"
      },
      "proof_of_CalculateTickFromTimeMs_return_wit_2_split_goal_1": {
        "name": "proof_of_CalculateTickFromTimeMs_return_wit_2_split_goal_1",
        "parent": "proof_of_CalculateTickFromTimeMs_return_wit_2",
        "statement": "Lemma proof_of_CalculateTickFromTimeMs_return_wit_2_split_goal_1 : CalculateTickFromTimeMs_return_wit_2_split_goal_1.\n"
      },
      "proof_of_CalculateTickFromTimeMs_return_wit_2": {
        "name": "proof_of_CalculateTickFromTimeMs_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_CalculateTickFromTimeMs_return_wit_2 : CalculateTickFromTimeMs_return_wit_2.\n"
      },
      "proof_of_CalculateTickFromTimeMs_return_wit_3_split_goal_1": {
        "name": "proof_of_CalculateTickFromTimeMs_return_wit_3_split_goal_1",
        "parent": "proof_of_CalculateTickFromTimeMs_return_wit_3",
        "statement": "Lemma proof_of_CalculateTickFromTimeMs_return_wit_3_split_goal_1 : CalculateTickFromTimeMs_return_wit_3_split_goal_1.\n"
      },
      "proof_of_CalculateTickFromTimeMs_return_wit_3": {
        "name": "proof_of_CalculateTickFromTimeMs_return_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_CalculateTickFromTimeMs_return_wit_3 : CalculateTickFromTimeMs_return_wit_3.\n"
      },
      "proof_of_CalculateTickFromTimeMs_return_wit_4_split_goal_1": {
        "name": "proof_of_CalculateTickFromTimeMs_return_wit_4_split_goal_1",
        "parent": "proof_of_CalculateTickFromTimeMs_return_wit_4",
        "statement": "Lemma proof_of_CalculateTickFromTimeMs_return_wit_4_split_goal_1 : CalculateTickFromTimeMs_return_wit_4_split_goal_1.\n"
      },
      "proof_of_CalculateTickFromTimeMs_return_wit_4": {
        "name": "proof_of_CalculateTickFromTimeMs_return_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_CalculateTickFromTimeMs_return_wit_4 : CalculateTickFromTimeMs_return_wit_4.\n"
      },
      "proof_of_CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial": {
        "name": "proof_of_CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial",
        "parent": "proof_of_CalculateTickFromTimeMs_which_implies_wit_1",
        "statement": "Lemma proof_of_CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial : CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial.\n"
      },
      "proof_of_CalculateTickFromTimeMs_which_implies_wit_1": {
        "name": "proof_of_CalculateTickFromTimeMs_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_CalculateTickFromTimeMs_which_implies_wit_1 : CalculateTickFromTimeMs_which_implies_wit_1.\n"
      },
      "proof_of_CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial": {
        "name": "proof_of_CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial",
        "parent": "proof_of_CalculateTickFromTimeMs_which_implies_wit_2",
        "statement": "Lemma proof_of_CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial : CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial.\n"
      },
      "proof_of_CalculateTickFromTimeMs_which_implies_wit_2": {
        "name": "proof_of_CalculateTickFromTimeMs_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_CalculateTickFromTimeMs_which_implies_wit_2 : CalculateTickFromTimeMs_which_implies_wit_2.\n"
      }
    },
    "top_level": [
      "proof_of_CalculateTickFromTimeMs_return_wit_1",
      "proof_of_CalculateTickFromTimeMs_return_wit_2",
      "proof_of_CalculateTickFromTimeMs_return_wit_3",
      "proof_of_CalculateTickFromTimeMs_return_wit_4",
      "proof_of_CalculateTickFromTimeMs_which_implies_wit_1",
      "proof_of_CalculateTickFromTimeMs_which_implies_wit_2"
    ],
    "split_goals": {
      "proof_of_CalculateTickFromTimeMs_return_wit_1": [
        "proof_of_CalculateTickFromTimeMs_return_wit_1_split_goal_1"
      ],
      "proof_of_CalculateTickFromTimeMs_return_wit_2": [
        "proof_of_CalculateTickFromTimeMs_return_wit_2_split_goal_1"
      ],
      "proof_of_CalculateTickFromTimeMs_return_wit_3": [
        "proof_of_CalculateTickFromTimeMs_return_wit_3_split_goal_1"
      ],
      "proof_of_CalculateTickFromTimeMs_return_wit_4": [
        "proof_of_CalculateTickFromTimeMs_return_wit_4_split_goal_1"
      ],
      "proof_of_CalculateTickFromTimeMs_which_implies_wit_1": [
        "proof_of_CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial"
      ],
      "proof_of_CalculateTickFromTimeMs_which_implies_wit_2": [
        "proof_of_CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial"
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
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-debug",
      "--run",
      "CalculateTickFromTimeMs-20261119024015",
      "--round",
      "CalculateTickFromTimeMs-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
