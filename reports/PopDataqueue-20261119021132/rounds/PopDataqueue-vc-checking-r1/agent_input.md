# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "PopDataqueue-vc-checking-r1",
  "round": "PopDataqueue-vc-checking-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/dataqueue/PopDataqueue.c",
    "formal_directory": "VC/dataqueue",
    "formal_case_lib": "VC/dataqueue/PopDataqueue_lib.v",
    "goal_file": "VC/dataqueue/PopDataqueue_goal.v",
    "proof_auto_file": "VC/dataqueue/PopDataqueue_proof_auto.v",
    "proof_manual_file": "VC/dataqueue/PopDataqueue_proof_manual.v",
    "goal_check_file": "VC/dataqueue/PopDataqueue_goal_check.v",
    "case_name": "PopDataqueue",
    "active_case_theory": "CRTOS_Verify.VC.dataqueue"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/rounds/PopDataqueue-vc-checking-r1/PopDataqueue_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_PopDataqueue_entail_wit_1": {
        "name": "proof_of_PopDataqueue_entail_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_entail_wit_1 : PopDataqueue_entail_wit_1.\n"
      },
      "proof_of_PopDataqueue_entail_wit_2": {
        "name": "proof_of_PopDataqueue_entail_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_entail_wit_2 : PopDataqueue_entail_wit_2.\n"
      },
      "proof_of_PopDataqueue_entail_wit_3_split_goal_1": {
        "name": "proof_of_PopDataqueue_entail_wit_3_split_goal_1",
        "parent": "proof_of_PopDataqueue_entail_wit_3",
        "statement": "Lemma proof_of_PopDataqueue_entail_wit_3_split_goal_1 : PopDataqueue_entail_wit_3_split_goal_1.\n"
      },
      "proof_of_PopDataqueue_entail_wit_3": {
        "name": "proof_of_PopDataqueue_entail_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_entail_wit_3 : PopDataqueue_entail_wit_3.\n"
      },
      "proof_of_PopDataqueue_entail_wit_4": {
        "name": "proof_of_PopDataqueue_entail_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_entail_wit_4 : PopDataqueue_entail_wit_4.\n"
      },
      "proof_of_PopDataqueue_entail_wit_5_1": {
        "name": "proof_of_PopDataqueue_entail_wit_5_1",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_entail_wit_5_1 : PopDataqueue_entail_wit_5_1.\n"
      },
      "proof_of_PopDataqueue_entail_wit_5_2": {
        "name": "proof_of_PopDataqueue_entail_wit_5_2",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_entail_wit_5_2 : PopDataqueue_entail_wit_5_2.\n"
      },
      "proof_of_PopDataqueue_return_wit_1": {
        "name": "proof_of_PopDataqueue_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_return_wit_1 : PopDataqueue_return_wit_1.\n"
      },
      "proof_of_PopDataqueue_return_wit_2": {
        "name": "proof_of_PopDataqueue_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_return_wit_2 : PopDataqueue_return_wit_2.\n"
      },
      "proof_of_PopDataqueue_return_wit_3_split_goal_1": {
        "name": "proof_of_PopDataqueue_return_wit_3_split_goal_1",
        "parent": "proof_of_PopDataqueue_return_wit_3",
        "statement": "Lemma proof_of_PopDataqueue_return_wit_3_split_goal_1 : PopDataqueue_return_wit_3_split_goal_1.\n"
      },
      "proof_of_PopDataqueue_return_wit_3": {
        "name": "proof_of_PopDataqueue_return_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_return_wit_3 : PopDataqueue_return_wit_3.\n"
      },
      "proof_of_PopDataqueue_which_implies_wit_1_split_goal_1": {
        "name": "proof_of_PopDataqueue_which_implies_wit_1_split_goal_1",
        "parent": "proof_of_PopDataqueue_which_implies_wit_1",
        "statement": "Lemma proof_of_PopDataqueue_which_implies_wit_1_split_goal_1 : PopDataqueue_which_implies_wit_1_split_goal_1.\n"
      },
      "proof_of_PopDataqueue_which_implies_wit_1_split_goal_2": {
        "name": "proof_of_PopDataqueue_which_implies_wit_1_split_goal_2",
        "parent": "proof_of_PopDataqueue_which_implies_wit_1",
        "statement": "Lemma proof_of_PopDataqueue_which_implies_wit_1_split_goal_2 : PopDataqueue_which_implies_wit_1_split_goal_2.\n"
      },
      "proof_of_PopDataqueue_which_implies_wit_1_split_goal_spatial": {
        "name": "proof_of_PopDataqueue_which_implies_wit_1_split_goal_spatial",
        "parent": "proof_of_PopDataqueue_which_implies_wit_1",
        "statement": "Lemma proof_of_PopDataqueue_which_implies_wit_1_split_goal_spatial : PopDataqueue_which_implies_wit_1_split_goal_spatial.\n"
      },
      "proof_of_PopDataqueue_which_implies_wit_1": {
        "name": "proof_of_PopDataqueue_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_which_implies_wit_1 : PopDataqueue_which_implies_wit_1.\n"
      },
      "proof_of_PopDataqueue_which_implies_wit_2_split_goal_1": {
        "name": "proof_of_PopDataqueue_which_implies_wit_2_split_goal_1",
        "parent": "proof_of_PopDataqueue_which_implies_wit_2",
        "statement": "Lemma proof_of_PopDataqueue_which_implies_wit_2_split_goal_1 : PopDataqueue_which_implies_wit_2_split_goal_1.\n"
      },
      "proof_of_PopDataqueue_which_implies_wit_2_split_goal_2": {
        "name": "proof_of_PopDataqueue_which_implies_wit_2_split_goal_2",
        "parent": "proof_of_PopDataqueue_which_implies_wit_2",
        "statement": "Lemma proof_of_PopDataqueue_which_implies_wit_2_split_goal_2 : PopDataqueue_which_implies_wit_2_split_goal_2.\n"
      },
      "proof_of_PopDataqueue_which_implies_wit_2_split_goal_spatial": {
        "name": "proof_of_PopDataqueue_which_implies_wit_2_split_goal_spatial",
        "parent": "proof_of_PopDataqueue_which_implies_wit_2",
        "statement": "Lemma proof_of_PopDataqueue_which_implies_wit_2_split_goal_spatial : PopDataqueue_which_implies_wit_2_split_goal_spatial.\n"
      },
      "proof_of_PopDataqueue_which_implies_wit_2": {
        "name": "proof_of_PopDataqueue_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_which_implies_wit_2 : PopDataqueue_which_implies_wit_2.\n"
      },
      "proof_of_PopDataqueue_which_implies_wit_3": {
        "name": "proof_of_PopDataqueue_which_implies_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_which_implies_wit_3 : PopDataqueue_which_implies_wit_3.\n"
      },
      "proof_of_PopDataqueue_which_implies_wit_4_split_goal_spatial": {
        "name": "proof_of_PopDataqueue_which_implies_wit_4_split_goal_spatial",
        "parent": "proof_of_PopDataqueue_which_implies_wit_4",
        "statement": "Lemma proof_of_PopDataqueue_which_implies_wit_4_split_goal_spatial : PopDataqueue_which_implies_wit_4_split_goal_spatial.\n"
      },
      "proof_of_PopDataqueue_which_implies_wit_4": {
        "name": "proof_of_PopDataqueue_which_implies_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_which_implies_wit_4 : PopDataqueue_which_implies_wit_4.\n"
      },
      "proof_of_PopDataqueue_which_implies_wit_5": {
        "name": "proof_of_PopDataqueue_which_implies_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_PopDataqueue_which_implies_wit_5 : PopDataqueue_which_implies_wit_5.\n"
      }
    },
    "top_level": [
      "proof_of_PopDataqueue_entail_wit_1",
      "proof_of_PopDataqueue_entail_wit_2",
      "proof_of_PopDataqueue_entail_wit_3",
      "proof_of_PopDataqueue_entail_wit_4",
      "proof_of_PopDataqueue_entail_wit_5_1",
      "proof_of_PopDataqueue_entail_wit_5_2",
      "proof_of_PopDataqueue_return_wit_1",
      "proof_of_PopDataqueue_return_wit_2",
      "proof_of_PopDataqueue_return_wit_3",
      "proof_of_PopDataqueue_which_implies_wit_1",
      "proof_of_PopDataqueue_which_implies_wit_2",
      "proof_of_PopDataqueue_which_implies_wit_3",
      "proof_of_PopDataqueue_which_implies_wit_4",
      "proof_of_PopDataqueue_which_implies_wit_5"
    ],
    "split_goals": {
      "proof_of_PopDataqueue_entail_wit_1": [],
      "proof_of_PopDataqueue_entail_wit_2": [],
      "proof_of_PopDataqueue_entail_wit_3": [
        "proof_of_PopDataqueue_entail_wit_3_split_goal_1"
      ],
      "proof_of_PopDataqueue_entail_wit_4": [],
      "proof_of_PopDataqueue_entail_wit_5_1": [],
      "proof_of_PopDataqueue_entail_wit_5_2": [],
      "proof_of_PopDataqueue_return_wit_1": [],
      "proof_of_PopDataqueue_return_wit_2": [],
      "proof_of_PopDataqueue_return_wit_3": [
        "proof_of_PopDataqueue_return_wit_3_split_goal_1"
      ],
      "proof_of_PopDataqueue_which_implies_wit_1": [
        "proof_of_PopDataqueue_which_implies_wit_1_split_goal_1",
        "proof_of_PopDataqueue_which_implies_wit_1_split_goal_2",
        "proof_of_PopDataqueue_which_implies_wit_1_split_goal_spatial"
      ],
      "proof_of_PopDataqueue_which_implies_wit_2": [
        "proof_of_PopDataqueue_which_implies_wit_2_split_goal_1",
        "proof_of_PopDataqueue_which_implies_wit_2_split_goal_2",
        "proof_of_PopDataqueue_which_implies_wit_2_split_goal_spatial"
      ],
      "proof_of_PopDataqueue_which_implies_wit_3": [],
      "proof_of_PopDataqueue_which_implies_wit_4": [
        "proof_of_PopDataqueue_which_implies_wit_4_split_goal_spatial"
      ],
      "proof_of_PopDataqueue_which_implies_wit_5": []
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
      "PopDataqueue-20261119021132",
      "--round",
      "PopDataqueue-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
