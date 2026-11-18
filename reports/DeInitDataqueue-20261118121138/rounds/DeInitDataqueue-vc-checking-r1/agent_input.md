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
  "report": "/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/rounds/DeInitDataqueue-vc-checking-r1/DeInitDataqueue_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_DeInitDataqueue_safety_wit_1": {
        "name": "proof_of_DeInitDataqueue_safety_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_1 : DeInitDataqueue_safety_wit_1.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_2": {
        "name": "proof_of_DeInitDataqueue_safety_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_2 : DeInitDataqueue_safety_wit_2.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_3": {
        "name": "proof_of_DeInitDataqueue_safety_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_3 : DeInitDataqueue_safety_wit_3.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_4": {
        "name": "proof_of_DeInitDataqueue_safety_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_4 : DeInitDataqueue_safety_wit_4.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_5": {
        "name": "proof_of_DeInitDataqueue_safety_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_5 : DeInitDataqueue_safety_wit_5.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_6": {
        "name": "proof_of_DeInitDataqueue_safety_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_6 : DeInitDataqueue_safety_wit_6.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_7": {
        "name": "proof_of_DeInitDataqueue_safety_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_7 : DeInitDataqueue_safety_wit_7.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_8": {
        "name": "proof_of_DeInitDataqueue_safety_wit_8",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_8 : DeInitDataqueue_safety_wit_8.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_9": {
        "name": "proof_of_DeInitDataqueue_safety_wit_9",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_9 : DeInitDataqueue_safety_wit_9.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_10": {
        "name": "proof_of_DeInitDataqueue_safety_wit_10",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_10 : DeInitDataqueue_safety_wit_10.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_11": {
        "name": "proof_of_DeInitDataqueue_safety_wit_11",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_11 : DeInitDataqueue_safety_wit_11.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_12": {
        "name": "proof_of_DeInitDataqueue_safety_wit_12",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_12 : DeInitDataqueue_safety_wit_12.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_13": {
        "name": "proof_of_DeInitDataqueue_safety_wit_13",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_13 : DeInitDataqueue_safety_wit_13.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_14": {
        "name": "proof_of_DeInitDataqueue_safety_wit_14",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_14 : DeInitDataqueue_safety_wit_14.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_15": {
        "name": "proof_of_DeInitDataqueue_safety_wit_15",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_15 : DeInitDataqueue_safety_wit_15.\n"
      },
      "proof_of_DeInitDataqueue_safety_wit_16": {
        "name": "proof_of_DeInitDataqueue_safety_wit_16",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_safety_wit_16 : DeInitDataqueue_safety_wit_16.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_2_1": {
        "name": "proof_of_DeInitDataqueue_entail_wit_2_1",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_2_1 : DeInitDataqueue_entail_wit_2_1.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_2_2": {
        "name": "proof_of_DeInitDataqueue_entail_wit_2_2",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_2_2 : DeInitDataqueue_entail_wit_2_2.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_3_1": {
        "name": "proof_of_DeInitDataqueue_entail_wit_3_1",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_3_1 : DeInitDataqueue_entail_wit_3_1.\n"
      },
      "proof_of_DeInitDataqueue_entail_wit_3_2": {
        "name": "proof_of_DeInitDataqueue_entail_wit_3_2",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_entail_wit_3_2 : DeInitDataqueue_entail_wit_3_2.\n"
      },
      "proof_of_DeInitDataqueue_return_wit_1": {
        "name": "proof_of_DeInitDataqueue_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_return_wit_1 : DeInitDataqueue_return_wit_1.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_1": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_1 : DeInitDataqueue_partial_solve_wit_1.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_2": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_2 : DeInitDataqueue_partial_solve_wit_2.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_3_pure": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_3_pure",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_3_pure : DeInitDataqueue_partial_solve_wit_3_pure.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_3": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_3 : DeInitDataqueue_partial_solve_wit_3.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_4_pure": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_4_pure",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_4_pure : DeInitDataqueue_partial_solve_wit_4_pure.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_4": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_4 : DeInitDataqueue_partial_solve_wit_4.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_5_pure": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_5_pure",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_5_pure : DeInitDataqueue_partial_solve_wit_5_pure.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_5": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_5 : DeInitDataqueue_partial_solve_wit_5.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_6_pure": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_6_pure",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_6_pure : DeInitDataqueue_partial_solve_wit_6_pure.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_6": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_6 : DeInitDataqueue_partial_solve_wit_6.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_7_pure": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_7_pure",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_7_pure : DeInitDataqueue_partial_solve_wit_7_pure.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_7": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_7 : DeInitDataqueue_partial_solve_wit_7.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_8_pure": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_8_pure",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_8_pure : DeInitDataqueue_partial_solve_wit_8_pure.\n"
      },
      "proof_of_DeInitDataqueue_partial_solve_wit_8": {
        "name": "proof_of_DeInitDataqueue_partial_solve_wit_8",
        "parent": null,
        "statement": "Lemma proof_of_DeInitDataqueue_partial_solve_wit_8 : DeInitDataqueue_partial_solve_wit_8.\n"
      },
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
      "proof_of_DeInitDataqueue_safety_wit_1",
      "proof_of_DeInitDataqueue_safety_wit_2",
      "proof_of_DeInitDataqueue_safety_wit_3",
      "proof_of_DeInitDataqueue_safety_wit_4",
      "proof_of_DeInitDataqueue_safety_wit_5",
      "proof_of_DeInitDataqueue_safety_wit_6",
      "proof_of_DeInitDataqueue_safety_wit_7",
      "proof_of_DeInitDataqueue_safety_wit_8",
      "proof_of_DeInitDataqueue_safety_wit_9",
      "proof_of_DeInitDataqueue_safety_wit_10",
      "proof_of_DeInitDataqueue_safety_wit_11",
      "proof_of_DeInitDataqueue_safety_wit_12",
      "proof_of_DeInitDataqueue_safety_wit_13",
      "proof_of_DeInitDataqueue_safety_wit_14",
      "proof_of_DeInitDataqueue_safety_wit_15",
      "proof_of_DeInitDataqueue_safety_wit_16",
      "proof_of_DeInitDataqueue_entail_wit_2_1",
      "proof_of_DeInitDataqueue_entail_wit_2_2",
      "proof_of_DeInitDataqueue_entail_wit_3_1",
      "proof_of_DeInitDataqueue_entail_wit_3_2",
      "proof_of_DeInitDataqueue_return_wit_1",
      "proof_of_DeInitDataqueue_partial_solve_wit_1",
      "proof_of_DeInitDataqueue_partial_solve_wit_2",
      "proof_of_DeInitDataqueue_partial_solve_wit_3_pure",
      "proof_of_DeInitDataqueue_partial_solve_wit_3",
      "proof_of_DeInitDataqueue_partial_solve_wit_4_pure",
      "proof_of_DeInitDataqueue_partial_solve_wit_4",
      "proof_of_DeInitDataqueue_partial_solve_wit_5_pure",
      "proof_of_DeInitDataqueue_partial_solve_wit_5",
      "proof_of_DeInitDataqueue_partial_solve_wit_6_pure",
      "proof_of_DeInitDataqueue_partial_solve_wit_6",
      "proof_of_DeInitDataqueue_partial_solve_wit_7_pure",
      "proof_of_DeInitDataqueue_partial_solve_wit_7",
      "proof_of_DeInitDataqueue_partial_solve_wit_8_pure",
      "proof_of_DeInitDataqueue_partial_solve_wit_8",
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
      "proof_of_DeInitDataqueue_safety_wit_1": [],
      "proof_of_DeInitDataqueue_safety_wit_2": [],
      "proof_of_DeInitDataqueue_safety_wit_3": [],
      "proof_of_DeInitDataqueue_safety_wit_4": [],
      "proof_of_DeInitDataqueue_safety_wit_5": [],
      "proof_of_DeInitDataqueue_safety_wit_6": [],
      "proof_of_DeInitDataqueue_safety_wit_7": [],
      "proof_of_DeInitDataqueue_safety_wit_8": [],
      "proof_of_DeInitDataqueue_safety_wit_9": [],
      "proof_of_DeInitDataqueue_safety_wit_10": [],
      "proof_of_DeInitDataqueue_safety_wit_11": [],
      "proof_of_DeInitDataqueue_safety_wit_12": [],
      "proof_of_DeInitDataqueue_safety_wit_13": [],
      "proof_of_DeInitDataqueue_safety_wit_14": [],
      "proof_of_DeInitDataqueue_safety_wit_15": [],
      "proof_of_DeInitDataqueue_safety_wit_16": [],
      "proof_of_DeInitDataqueue_entail_wit_2_1": [],
      "proof_of_DeInitDataqueue_entail_wit_2_2": [],
      "proof_of_DeInitDataqueue_entail_wit_3_1": [],
      "proof_of_DeInitDataqueue_entail_wit_3_2": [],
      "proof_of_DeInitDataqueue_return_wit_1": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_1": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_2": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_3_pure": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_3": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_4_pure": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_4": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_5_pure": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_5": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_6_pure": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_6": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_7_pure": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_7": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_8_pure": [],
      "proof_of_DeInitDataqueue_partial_solve_wit_8": [],
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
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
