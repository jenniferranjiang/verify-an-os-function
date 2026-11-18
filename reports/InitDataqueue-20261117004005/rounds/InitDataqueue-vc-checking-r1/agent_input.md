# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "InitDataqueue-vc-checking-r1",
  "round": "InitDataqueue-vc-checking-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/dataqueue/InitDataqueue.c",
    "formal_directory": "VC/dataqueue",
    "formal_case_lib": "VC/dataqueue/InitDataqueue_lib.v",
    "goal_file": "VC/dataqueue/InitDataqueue_goal.v",
    "proof_auto_file": "VC/dataqueue/InitDataqueue_proof_auto.v",
    "proof_manual_file": "VC/dataqueue/InitDataqueue_proof_manual.v",
    "goal_check_file": "VC/dataqueue/InitDataqueue_goal_check.v",
    "case_name": "InitDataqueue",
    "active_case_theory": "CRTOS_Verify.VC.dataqueue"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos-verify/reports/InitDataqueue-20261117004005/rounds/InitDataqueue-vc-checking-r1/InitDataqueue_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_InitDataqueue_safety_wit_1": {
        "name": "proof_of_InitDataqueue_safety_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_1 : InitDataqueue_safety_wit_1.\n"
      },
      "proof_of_InitDataqueue_safety_wit_2": {
        "name": "proof_of_InitDataqueue_safety_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_2 : InitDataqueue_safety_wit_2.\n"
      },
      "proof_of_InitDataqueue_safety_wit_3": {
        "name": "proof_of_InitDataqueue_safety_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_3 : InitDataqueue_safety_wit_3.\n"
      },
      "proof_of_InitDataqueue_safety_wit_4": {
        "name": "proof_of_InitDataqueue_safety_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_4 : InitDataqueue_safety_wit_4.\n"
      },
      "proof_of_InitDataqueue_safety_wit_5": {
        "name": "proof_of_InitDataqueue_safety_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_5 : InitDataqueue_safety_wit_5.\n"
      },
      "proof_of_InitDataqueue_safety_wit_6": {
        "name": "proof_of_InitDataqueue_safety_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_6 : InitDataqueue_safety_wit_6.\n"
      },
      "proof_of_InitDataqueue_safety_wit_7": {
        "name": "proof_of_InitDataqueue_safety_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_7 : InitDataqueue_safety_wit_7.\n"
      },
      "proof_of_InitDataqueue_safety_wit_8": {
        "name": "proof_of_InitDataqueue_safety_wit_8",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_8 : InitDataqueue_safety_wit_8.\n"
      },
      "proof_of_InitDataqueue_safety_wit_9": {
        "name": "proof_of_InitDataqueue_safety_wit_9",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_9 : InitDataqueue_safety_wit_9.\n"
      },
      "proof_of_InitDataqueue_safety_wit_10": {
        "name": "proof_of_InitDataqueue_safety_wit_10",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_10 : InitDataqueue_safety_wit_10.\n"
      },
      "proof_of_InitDataqueue_safety_wit_11": {
        "name": "proof_of_InitDataqueue_safety_wit_11",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_11 : InitDataqueue_safety_wit_11.\n"
      },
      "proof_of_InitDataqueue_safety_wit_13": {
        "name": "proof_of_InitDataqueue_safety_wit_13",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_13 : InitDataqueue_safety_wit_13.\n"
      },
      "proof_of_InitDataqueue_safety_wit_14": {
        "name": "proof_of_InitDataqueue_safety_wit_14",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_14 : InitDataqueue_safety_wit_14.\n"
      },
      "proof_of_InitDataqueue_safety_wit_15": {
        "name": "proof_of_InitDataqueue_safety_wit_15",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_15 : InitDataqueue_safety_wit_15.\n"
      },
      "proof_of_InitDataqueue_safety_wit_16": {
        "name": "proof_of_InitDataqueue_safety_wit_16",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_16 : InitDataqueue_safety_wit_16.\n"
      },
      "proof_of_InitDataqueue_safety_wit_17": {
        "name": "proof_of_InitDataqueue_safety_wit_17",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_17 : InitDataqueue_safety_wit_17.\n"
      },
      "proof_of_InitDataqueue_safety_wit_18": {
        "name": "proof_of_InitDataqueue_safety_wit_18",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_18 : InitDataqueue_safety_wit_18.\n"
      },
      "proof_of_InitDataqueue_safety_wit_19": {
        "name": "proof_of_InitDataqueue_safety_wit_19",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_19 : InitDataqueue_safety_wit_19.\n"
      },
      "proof_of_InitDataqueue_safety_wit_20": {
        "name": "proof_of_InitDataqueue_safety_wit_20",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_20 : InitDataqueue_safety_wit_20.\n"
      },
      "proof_of_InitDataqueue_safety_wit_21": {
        "name": "proof_of_InitDataqueue_safety_wit_21",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_21 : InitDataqueue_safety_wit_21.\n"
      },
      "proof_of_InitDataqueue_safety_wit_22": {
        "name": "proof_of_InitDataqueue_safety_wit_22",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_22 : InitDataqueue_safety_wit_22.\n"
      },
      "proof_of_InitDataqueue_safety_wit_23": {
        "name": "proof_of_InitDataqueue_safety_wit_23",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_23 : InitDataqueue_safety_wit_23.\n"
      },
      "proof_of_InitDataqueue_safety_wit_24": {
        "name": "proof_of_InitDataqueue_safety_wit_24",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_24 : InitDataqueue_safety_wit_24.\n"
      },
      "proof_of_InitDataqueue_safety_wit_25": {
        "name": "proof_of_InitDataqueue_safety_wit_25",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_25 : InitDataqueue_safety_wit_25.\n"
      },
      "proof_of_InitDataqueue_safety_wit_26": {
        "name": "proof_of_InitDataqueue_safety_wit_26",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_26 : InitDataqueue_safety_wit_26.\n"
      },
      "proof_of_InitDataqueue_safety_wit_27": {
        "name": "proof_of_InitDataqueue_safety_wit_27",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_27 : InitDataqueue_safety_wit_27.\n"
      },
      "proof_of_InitDataqueue_safety_wit_28": {
        "name": "proof_of_InitDataqueue_safety_wit_28",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_28 : InitDataqueue_safety_wit_28.\n"
      },
      "proof_of_InitDataqueue_safety_wit_29": {
        "name": "proof_of_InitDataqueue_safety_wit_29",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_29 : InitDataqueue_safety_wit_29.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_1": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_1 : InitDataqueue_partial_solve_wit_1.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_2": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_2 : InitDataqueue_partial_solve_wit_2.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_3_pure": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_3_pure",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_3_pure : InitDataqueue_partial_solve_wit_3_pure.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_3": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_3 : InitDataqueue_partial_solve_wit_3.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_4": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_4 : InitDataqueue_partial_solve_wit_4.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_5": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_5 : InitDataqueue_partial_solve_wit_5.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_6": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_6 : InitDataqueue_partial_solve_wit_6.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_7": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_7 : InitDataqueue_partial_solve_wit_7.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_8_pure": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_8_pure",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_8_pure : InitDataqueue_partial_solve_wit_8_pure.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_8": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_8",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_8 : InitDataqueue_partial_solve_wit_8.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_9_pure": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_9_pure",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_9_pure : InitDataqueue_partial_solve_wit_9_pure.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_9": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_9",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_9 : InitDataqueue_partial_solve_wit_9.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_10_pure": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_10_pure",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_10_pure : InitDataqueue_partial_solve_wit_10_pure.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_10": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_10",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_10 : InitDataqueue_partial_solve_wit_10.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_11_pure": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_11_pure",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_11_pure : InitDataqueue_partial_solve_wit_11_pure.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_11": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_11",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_11 : InitDataqueue_partial_solve_wit_11.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_12_pure": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_12_pure",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_12_pure : InitDataqueue_partial_solve_wit_12_pure.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_12": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_12",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_12 : InitDataqueue_partial_solve_wit_12.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_13_pure": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_13_pure",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_13_pure : InitDataqueue_partial_solve_wit_13_pure.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_13": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_13",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_13 : InitDataqueue_partial_solve_wit_13.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_14_pure": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_14_pure",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_14_pure : InitDataqueue_partial_solve_wit_14_pure.\n"
      },
      "proof_of_InitDataqueue_partial_solve_wit_14": {
        "name": "proof_of_InitDataqueue_partial_solve_wit_14",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_partial_solve_wit_14 : InitDataqueue_partial_solve_wit_14.\n"
      },
      "proof_of_InitDataqueue_safety_wit_12_split_goal_1": {
        "name": "proof_of_InitDataqueue_safety_wit_12_split_goal_1",
        "parent": "proof_of_InitDataqueue_safety_wit_12",
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_12_split_goal_1 : InitDataqueue_safety_wit_12_split_goal_1.\n"
      },
      "proof_of_InitDataqueue_safety_wit_12_split_goal_2": {
        "name": "proof_of_InitDataqueue_safety_wit_12_split_goal_2",
        "parent": "proof_of_InitDataqueue_safety_wit_12",
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_12_split_goal_2 : InitDataqueue_safety_wit_12_split_goal_2.\n"
      },
      "proof_of_InitDataqueue_safety_wit_12": {
        "name": "proof_of_InitDataqueue_safety_wit_12",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_safety_wit_12 : InitDataqueue_safety_wit_12.\n"
      },
      "proof_of_InitDataqueue_entail_wit_1": {
        "name": "proof_of_InitDataqueue_entail_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_entail_wit_1 : InitDataqueue_entail_wit_1.\n"
      },
      "proof_of_InitDataqueue_entail_wit_2_1": {
        "name": "proof_of_InitDataqueue_entail_wit_2_1",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_entail_wit_2_1 : InitDataqueue_entail_wit_2_1.\n"
      },
      "proof_of_InitDataqueue_entail_wit_2_2": {
        "name": "proof_of_InitDataqueue_entail_wit_2_2",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_entail_wit_2_2 : InitDataqueue_entail_wit_2_2.\n"
      },
      "proof_of_InitDataqueue_entail_wit_2_3": {
        "name": "proof_of_InitDataqueue_entail_wit_2_3",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_entail_wit_2_3 : InitDataqueue_entail_wit_2_3.\n"
      },
      "proof_of_InitDataqueue_entail_wit_2_4": {
        "name": "proof_of_InitDataqueue_entail_wit_2_4",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_entail_wit_2_4 : InitDataqueue_entail_wit_2_4.\n"
      },
      "proof_of_InitDataqueue_return_wit_1": {
        "name": "proof_of_InitDataqueue_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_return_wit_1 : InitDataqueue_return_wit_1.\n"
      },
      "proof_of_InitDataqueue_return_wit_2": {
        "name": "proof_of_InitDataqueue_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_return_wit_2 : InitDataqueue_return_wit_2.\n"
      },
      "proof_of_InitDataqueue_return_wit_3": {
        "name": "proof_of_InitDataqueue_return_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_return_wit_3 : InitDataqueue_return_wit_3.\n"
      },
      "proof_of_InitDataqueue_return_wit_4": {
        "name": "proof_of_InitDataqueue_return_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_return_wit_4 : InitDataqueue_return_wit_4.\n"
      },
      "proof_of_InitDataqueue_which_implies_wit_1_split_goal_1": {
        "name": "proof_of_InitDataqueue_which_implies_wit_1_split_goal_1",
        "parent": "proof_of_InitDataqueue_which_implies_wit_1",
        "statement": "Lemma proof_of_InitDataqueue_which_implies_wit_1_split_goal_1 : InitDataqueue_which_implies_wit_1_split_goal_1.\n"
      },
      "proof_of_InitDataqueue_which_implies_wit_1_split_goal_2": {
        "name": "proof_of_InitDataqueue_which_implies_wit_1_split_goal_2",
        "parent": "proof_of_InitDataqueue_which_implies_wit_1",
        "statement": "Lemma proof_of_InitDataqueue_which_implies_wit_1_split_goal_2 : InitDataqueue_which_implies_wit_1_split_goal_2.\n"
      },
      "proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial": {
        "name": "proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial",
        "parent": "proof_of_InitDataqueue_which_implies_wit_1",
        "statement": "Lemma proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial : InitDataqueue_which_implies_wit_1_split_goal_spatial.\n"
      },
      "proof_of_InitDataqueue_which_implies_wit_1": {
        "name": "proof_of_InitDataqueue_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_which_implies_wit_1 : InitDataqueue_which_implies_wit_1.\n"
      },
      "proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial": {
        "name": "proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial",
        "parent": "proof_of_InitDataqueue_which_implies_wit_2",
        "statement": "Lemma proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial : InitDataqueue_which_implies_wit_2_split_goal_spatial.\n"
      },
      "proof_of_InitDataqueue_which_implies_wit_2": {
        "name": "proof_of_InitDataqueue_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_InitDataqueue_which_implies_wit_2 : InitDataqueue_which_implies_wit_2.\n"
      }
    },
    "top_level": [
      "proof_of_InitDataqueue_safety_wit_1",
      "proof_of_InitDataqueue_safety_wit_2",
      "proof_of_InitDataqueue_safety_wit_3",
      "proof_of_InitDataqueue_safety_wit_4",
      "proof_of_InitDataqueue_safety_wit_5",
      "proof_of_InitDataqueue_safety_wit_6",
      "proof_of_InitDataqueue_safety_wit_7",
      "proof_of_InitDataqueue_safety_wit_8",
      "proof_of_InitDataqueue_safety_wit_9",
      "proof_of_InitDataqueue_safety_wit_10",
      "proof_of_InitDataqueue_safety_wit_11",
      "proof_of_InitDataqueue_safety_wit_13",
      "proof_of_InitDataqueue_safety_wit_14",
      "proof_of_InitDataqueue_safety_wit_15",
      "proof_of_InitDataqueue_safety_wit_16",
      "proof_of_InitDataqueue_safety_wit_17",
      "proof_of_InitDataqueue_safety_wit_18",
      "proof_of_InitDataqueue_safety_wit_19",
      "proof_of_InitDataqueue_safety_wit_20",
      "proof_of_InitDataqueue_safety_wit_21",
      "proof_of_InitDataqueue_safety_wit_22",
      "proof_of_InitDataqueue_safety_wit_23",
      "proof_of_InitDataqueue_safety_wit_24",
      "proof_of_InitDataqueue_safety_wit_25",
      "proof_of_InitDataqueue_safety_wit_26",
      "proof_of_InitDataqueue_safety_wit_27",
      "proof_of_InitDataqueue_safety_wit_28",
      "proof_of_InitDataqueue_safety_wit_29",
      "proof_of_InitDataqueue_partial_solve_wit_1",
      "proof_of_InitDataqueue_partial_solve_wit_2",
      "proof_of_InitDataqueue_partial_solve_wit_3_pure",
      "proof_of_InitDataqueue_partial_solve_wit_3",
      "proof_of_InitDataqueue_partial_solve_wit_4",
      "proof_of_InitDataqueue_partial_solve_wit_5",
      "proof_of_InitDataqueue_partial_solve_wit_6",
      "proof_of_InitDataqueue_partial_solve_wit_7",
      "proof_of_InitDataqueue_partial_solve_wit_8_pure",
      "proof_of_InitDataqueue_partial_solve_wit_8",
      "proof_of_InitDataqueue_partial_solve_wit_9_pure",
      "proof_of_InitDataqueue_partial_solve_wit_9",
      "proof_of_InitDataqueue_partial_solve_wit_10_pure",
      "proof_of_InitDataqueue_partial_solve_wit_10",
      "proof_of_InitDataqueue_partial_solve_wit_11_pure",
      "proof_of_InitDataqueue_partial_solve_wit_11",
      "proof_of_InitDataqueue_partial_solve_wit_12_pure",
      "proof_of_InitDataqueue_partial_solve_wit_12",
      "proof_of_InitDataqueue_partial_solve_wit_13_pure",
      "proof_of_InitDataqueue_partial_solve_wit_13",
      "proof_of_InitDataqueue_partial_solve_wit_14_pure",
      "proof_of_InitDataqueue_partial_solve_wit_14",
      "proof_of_InitDataqueue_safety_wit_12",
      "proof_of_InitDataqueue_entail_wit_1",
      "proof_of_InitDataqueue_entail_wit_2_1",
      "proof_of_InitDataqueue_entail_wit_2_2",
      "proof_of_InitDataqueue_entail_wit_2_3",
      "proof_of_InitDataqueue_entail_wit_2_4",
      "proof_of_InitDataqueue_return_wit_1",
      "proof_of_InitDataqueue_return_wit_2",
      "proof_of_InitDataqueue_return_wit_3",
      "proof_of_InitDataqueue_return_wit_4",
      "proof_of_InitDataqueue_which_implies_wit_1",
      "proof_of_InitDataqueue_which_implies_wit_2"
    ],
    "split_goals": {
      "proof_of_InitDataqueue_safety_wit_1": [],
      "proof_of_InitDataqueue_safety_wit_2": [],
      "proof_of_InitDataqueue_safety_wit_3": [],
      "proof_of_InitDataqueue_safety_wit_4": [],
      "proof_of_InitDataqueue_safety_wit_5": [],
      "proof_of_InitDataqueue_safety_wit_6": [],
      "proof_of_InitDataqueue_safety_wit_7": [],
      "proof_of_InitDataqueue_safety_wit_8": [],
      "proof_of_InitDataqueue_safety_wit_9": [],
      "proof_of_InitDataqueue_safety_wit_10": [],
      "proof_of_InitDataqueue_safety_wit_11": [],
      "proof_of_InitDataqueue_safety_wit_13": [],
      "proof_of_InitDataqueue_safety_wit_14": [],
      "proof_of_InitDataqueue_safety_wit_15": [],
      "proof_of_InitDataqueue_safety_wit_16": [],
      "proof_of_InitDataqueue_safety_wit_17": [],
      "proof_of_InitDataqueue_safety_wit_18": [],
      "proof_of_InitDataqueue_safety_wit_19": [],
      "proof_of_InitDataqueue_safety_wit_20": [],
      "proof_of_InitDataqueue_safety_wit_21": [],
      "proof_of_InitDataqueue_safety_wit_22": [],
      "proof_of_InitDataqueue_safety_wit_23": [],
      "proof_of_InitDataqueue_safety_wit_24": [],
      "proof_of_InitDataqueue_safety_wit_25": [],
      "proof_of_InitDataqueue_safety_wit_26": [],
      "proof_of_InitDataqueue_safety_wit_27": [],
      "proof_of_InitDataqueue_safety_wit_28": [],
      "proof_of_InitDataqueue_safety_wit_29": [],
      "proof_of_InitDataqueue_partial_solve_wit_1": [],
      "proof_of_InitDataqueue_partial_solve_wit_2": [],
      "proof_of_InitDataqueue_partial_solve_wit_3_pure": [],
      "proof_of_InitDataqueue_partial_solve_wit_3": [],
      "proof_of_InitDataqueue_partial_solve_wit_4": [],
      "proof_of_InitDataqueue_partial_solve_wit_5": [],
      "proof_of_InitDataqueue_partial_solve_wit_6": [],
      "proof_of_InitDataqueue_partial_solve_wit_7": [],
      "proof_of_InitDataqueue_partial_solve_wit_8_pure": [],
      "proof_of_InitDataqueue_partial_solve_wit_8": [],
      "proof_of_InitDataqueue_partial_solve_wit_9_pure": [],
      "proof_of_InitDataqueue_partial_solve_wit_9": [],
      "proof_of_InitDataqueue_partial_solve_wit_10_pure": [],
      "proof_of_InitDataqueue_partial_solve_wit_10": [],
      "proof_of_InitDataqueue_partial_solve_wit_11_pure": [],
      "proof_of_InitDataqueue_partial_solve_wit_11": [],
      "proof_of_InitDataqueue_partial_solve_wit_12_pure": [],
      "proof_of_InitDataqueue_partial_solve_wit_12": [],
      "proof_of_InitDataqueue_partial_solve_wit_13_pure": [],
      "proof_of_InitDataqueue_partial_solve_wit_13": [],
      "proof_of_InitDataqueue_partial_solve_wit_14_pure": [],
      "proof_of_InitDataqueue_partial_solve_wit_14": [],
      "proof_of_InitDataqueue_safety_wit_12": [
        "proof_of_InitDataqueue_safety_wit_12_split_goal_1",
        "proof_of_InitDataqueue_safety_wit_12_split_goal_2"
      ],
      "proof_of_InitDataqueue_entail_wit_1": [],
      "proof_of_InitDataqueue_entail_wit_2_1": [],
      "proof_of_InitDataqueue_entail_wit_2_2": [],
      "proof_of_InitDataqueue_entail_wit_2_3": [],
      "proof_of_InitDataqueue_entail_wit_2_4": [],
      "proof_of_InitDataqueue_return_wit_1": [],
      "proof_of_InitDataqueue_return_wit_2": [],
      "proof_of_InitDataqueue_return_wit_3": [],
      "proof_of_InitDataqueue_return_wit_4": [],
      "proof_of_InitDataqueue_which_implies_wit_1": [
        "proof_of_InitDataqueue_which_implies_wit_1_split_goal_1",
        "proof_of_InitDataqueue_which_implies_wit_1_split_goal_2",
        "proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial"
      ],
      "proof_of_InitDataqueue_which_implies_wit_2": [
        "proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial"
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
      "InitDataqueue-20261117004005",
      "--round",
      "InitDataqueue-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
