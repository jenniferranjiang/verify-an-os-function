# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "DeInitDataqueue-vc-checking-r1",
  "round": "DeInitDataqueue-vc-checking-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/dataqueue/DeInitDataqueue.c",
    "formal_directory": "VC/dataqueue",
    "formal_case_lib": "VC/dataqueue/DeInitDataqueue_lib.v",
    "goal_file": "VC/dataqueue/DeInitDataqueue_goal.v",
    "proof_auto_file": "VC/dataqueue/DeInitDataqueue_proof_auto.v",
    "proof_manual_file": "VC/dataqueue/DeInitDataqueue_proof_manual.v",
    "goal_check_file": "VC/dataqueue/DeInitDataqueue_goal_check.v",
    "case_name": "DeInitDataqueue",
    "active_case_theory": "CRTOS_Verify.VC.dataqueue"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118171259/rounds/DeInitDataqueue-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118171259/rounds/DeInitDataqueue-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118171259/rounds/DeInitDataqueue-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118171259/rounds/DeInitDataqueue-vc-checking-r1/DeInitDataqueue_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_DeInitDataqueue_entail_wit_1_split_goal_1": {
        "name": "proof_of_DeInitDataqueue_entail_wit_1_split_goal_1",
        "parent": "proof_of_DeInitDataqueue_entail_wit_1",
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_1_split_goal_1 : DeInitDataqueue_entail_wit_1_split_goal_1.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_1_split_goal_2": {
        "name": "proof_of_DeInitDataqueue_entail_wit_1_split_goal_2",
        "parent": "proof_of_DeInitDataqueue_entail_wit_1",
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_1_split_goal_2 : DeInitDataqueue_entail_wit_1_split_goal_2.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_1": {
        "name": "proof_of_DeInitDataqueue_entail_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_1 : DeInitDataqueue_entail_wit_1.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_1": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_1",
        "parent": "proof_of_DeInitDataqueue_entail_wit_4_1",
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_1 : DeInitDataqueue_entail_wit_4_1_split_goal_1.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_2": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_2",
        "parent": "proof_of_DeInitDataqueue_entail_wit_4_1",
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_2 : DeInitDataqueue_entail_wit_4_1_split_goal_2.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_3": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_3",
        "parent": "proof_of_DeInitDataqueue_entail_wit_4_1",
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_3 : DeInitDataqueue_entail_wit_4_1_split_goal_3.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_1": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_1",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_1 : DeInitDataqueue_entail_wit_4_1.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_1": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_1",
        "parent": "proof_of_DeInitDataqueue_entail_wit_4_2",
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_1 : DeInitDataqueue_entail_wit_4_2_split_goal_1.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_2": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_2",
        "parent": "proof_of_DeInitDataqueue_entail_wit_4_2",
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_2 : DeInitDataqueue_entail_wit_4_2_split_goal_2.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_3": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_3",
        "parent": "proof_of_DeInitDataqueue_entail_wit_4_2",
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_3 : DeInitDataqueue_entail_wit_4_2_split_goal_3.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_2": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_2",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_2 : DeInitDataqueue_entail_wit_4_2.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_1": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_1",
        "parent": "proof_of_DeInitDataqueue_entail_wit_4_3",
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_1 : DeInitDataqueue_entail_wit_4_3_split_goal_1.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_2": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_2",
        "parent": "proof_of_DeInitDataqueue_entail_wit_4_3",
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_2 : DeInitDataqueue_entail_wit_4_3_split_goal_2.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_3": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_3",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_3 : DeInitDataqueue_entail_wit_4_3.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_1": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_1",
        "parent": "proof_of_DeInitDataqueue_entail_wit_4_4",
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_1 : DeInitDataqueue_entail_wit_4_4_split_goal_1.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_2": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_2",
        "parent": "proof_of_DeInitDataqueue_entail_wit_4_4",
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_2 : DeInitDataqueue_entail_wit_4_4_split_goal_2.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_4_4": {
        "name": "proof_of_DeInitDataqueue_entail_wit_4_4",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_4_4 : DeInitDataqueue_entail_wit_4_4.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_5_1": {
        "name": "proof_of_DeInitDataqueue_entail_wit_5_1",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_5_1 : DeInitDataqueue_entail_wit_5_1.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_5_2": {
        "name": "proof_of_DeInitDataqueue_entail_wit_5_2",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_5_2 : DeInitDataqueue_entail_wit_5_2.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_5_3": {
        "name": "proof_of_DeInitDataqueue_entail_wit_5_3",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_5_3 : DeInitDataqueue_entail_wit_5_3.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_5_4": {
        "name": "proof_of_DeInitDataqueue_entail_wit_5_4",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_5_4 : DeInitDataqueue_entail_wit_5_4.\n"
      },
      "proof_of_DeInitDataqueue_which_implies_wit_1": {
        "name": "proof_of_DeInitDataqueue_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_which_implies_wit_1 : DeInitDataqueue_which_implies_wit_1.\n"
      }
    },
    "top_level": [
      "proof_of_DeInitDataqueue_entail_wit_1",
      "proof_of_DeInitDataqueue_entail_wit_4_1",
      "proof_of_DeInitDataqueue_entail_wit_4_2",
      "proof_of_DeInitDataqueue_entail_wit_4_3",
      "proof_of_DeInitDataqueue_entail_wit_4_4",
      "proof_of_DeInitDataqueue_entail_wit_5_1",
      "proof_of_DeInitDataqueue_entail_wit_5_2",
      "proof_of_DeInitDataqueue_entail_wit_5_3",
      "proof_of_DeInitDataqueue_entail_wit_5_4",
      "proof_of_DeInitDataqueue_which_implies_wit_1"
    ],
    "split_goals": {
      "proof_of_DeInitDataqueue_entail_wit_1": [
        "proof_of_DeInitDataqueue_entail_wit_1_split_goal_1",
        "proof_of_DeInitDataqueue_entail_wit_1_split_goal_2"
      ],
      "proof_of_DeInitDataqueue_entail_wit_4_1": [
        "proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_1",
        "proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_2",
        "proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_3"
      ],
      "proof_of_DeInitDataqueue_entail_wit_4_2": [
        "proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_1",
        "proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_2",
        "proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_3"
      ],
      "proof_of_DeInitDataqueue_entail_wit_4_3": [
        "proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_1",
        "proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_2"
      ],
      "proof_of_DeInitDataqueue_entail_wit_4_4": [
        "proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_1",
        "proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_2"
      ],
      "proof_of_DeInitDataqueue_entail_wit_5_1": [],
      "proof_of_DeInitDataqueue_entail_wit_5_2": [],
      "proof_of_DeInitDataqueue_entail_wit_5_3": [],
      "proof_of_DeInitDataqueue_entail_wit_5_4": [],
      "proof_of_DeInitDataqueue_which_implies_wit_1": []
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
      "DeInitDataqueue-20261118171259",
      "--round",
      "DeInitDataqueue-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
