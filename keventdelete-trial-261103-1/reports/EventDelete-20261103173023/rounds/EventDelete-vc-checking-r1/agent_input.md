# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "EventDelete-vc-checking-r1",
  "round": "EventDelete-vc-checking-r1",
  "main_root": "/home/xinra/crtos/keventdelete-trial-261103-1",
  "target_files": {
    "c_file": "annotated_C/src/_EventDelete.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/EventDelete_lib.v",
    "goal_file": "VC/EventDelete_goal.v",
    "proof_auto_file": "VC/EventDelete_proof_auto.v",
    "proof_manual_file": "VC/EventDelete_proof_manual.v",
    "goal_check_file": "VC/EventDelete_goal_check.v",
    "case_name": "EventDelete",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventDelete-20261103173023/rounds/EventDelete-vc-checking-r1/EventDelete_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of__EventDelete_safety_wit_1": {
        "name": "proof_of__EventDelete_safety_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_safety_wit_1 : _EventDelete_safety_wit_1.\n"
      },
      "proof_of__EventDelete_safety_wit_2": {
        "name": "proof_of__EventDelete_safety_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_safety_wit_2 : _EventDelete_safety_wit_2.\n"
      },
      "proof_of__EventDelete_safety_wit_3": {
        "name": "proof_of__EventDelete_safety_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_safety_wit_3 : _EventDelete_safety_wit_3.\n"
      },
      "proof_of__EventDelete_safety_wit_4": {
        "name": "proof_of__EventDelete_safety_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_safety_wit_4 : _EventDelete_safety_wit_4.\n"
      },
      "proof_of__EventDelete_safety_wit_5": {
        "name": "proof_of__EventDelete_safety_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_safety_wit_5 : _EventDelete_safety_wit_5.\n"
      },
      "proof_of__EventDelete_safety_wit_6": {
        "name": "proof_of__EventDelete_safety_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_safety_wit_6 : _EventDelete_safety_wit_6.\n"
      },
      "proof_of__EventDelete_safety_wit_7": {
        "name": "proof_of__EventDelete_safety_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_safety_wit_7 : _EventDelete_safety_wit_7.\n"
      },
      "proof_of__EventDelete_safety_wit_8": {
        "name": "proof_of__EventDelete_safety_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_safety_wit_8 : _EventDelete_safety_wit_8.\n"
      },
      "proof_of__EventDelete_safety_wit_9": {
        "name": "proof_of__EventDelete_safety_wit_9",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_safety_wit_9 : _EventDelete_safety_wit_9.\n"
      },
      "proof_of__EventDelete_safety_wit_10": {
        "name": "proof_of__EventDelete_safety_wit_10",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_safety_wit_10 : _EventDelete_safety_wit_10.\n"
      },
      "proof_of__EventDelete_entail_wit_1": {
        "name": "proof_of__EventDelete_entail_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_entail_wit_1 : _EventDelete_entail_wit_1.\n"
      },
      "proof_of__EventDelete_entail_wit_2": {
        "name": "proof_of__EventDelete_entail_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_entail_wit_2 : _EventDelete_entail_wit_2.\n"
      },
      "proof_of__EventDelete_entail_wit_3_1": {
        "name": "proof_of__EventDelete_entail_wit_3_1",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_entail_wit_3_1 : _EventDelete_entail_wit_3_1.\n"
      },
      "proof_of__EventDelete_entail_wit_3_2": {
        "name": "proof_of__EventDelete_entail_wit_3_2",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_entail_wit_3_2 : _EventDelete_entail_wit_3_2.\n"
      },
      "proof_of__EventDelete_entail_wit_5_1": {
        "name": "proof_of__EventDelete_entail_wit_5_1",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_entail_wit_5_1 : _EventDelete_entail_wit_5_1.\n"
      },
      "proof_of__EventDelete_entail_wit_5_2": {
        "name": "proof_of__EventDelete_entail_wit_5_2",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_entail_wit_5_2 : _EventDelete_entail_wit_5_2.\n"
      },
      "proof_of__EventDelete_entail_wit_6_1": {
        "name": "proof_of__EventDelete_entail_wit_6_1",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_entail_wit_6_1 : _EventDelete_entail_wit_6_1.\n"
      },
      "proof_of__EventDelete_entail_wit_6_2": {
        "name": "proof_of__EventDelete_entail_wit_6_2",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_entail_wit_6_2 : _EventDelete_entail_wit_6_2.\n"
      },
      "proof_of__EventDelete_return_wit_1": {
        "name": "proof_of__EventDelete_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_return_wit_1 : _EventDelete_return_wit_1.\n"
      },
      "proof_of__EventDelete_return_wit_2": {
        "name": "proof_of__EventDelete_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_return_wit_2 : _EventDelete_return_wit_2.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_1_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_1_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_1_pure : _EventDelete_partial_solve_wit_1_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_1": {
        "name": "proof_of__EventDelete_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_1 : _EventDelete_partial_solve_wit_1.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_2_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_2_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_2_pure : _EventDelete_partial_solve_wit_2_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_2": {
        "name": "proof_of__EventDelete_partial_solve_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_2 : _EventDelete_partial_solve_wit_2.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_3": {
        "name": "proof_of__EventDelete_partial_solve_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_3 : _EventDelete_partial_solve_wit_3.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_4_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_4_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_4_pure : _EventDelete_partial_solve_wit_4_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_4": {
        "name": "proof_of__EventDelete_partial_solve_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_4 : _EventDelete_partial_solve_wit_4.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_5_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_5_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_5_pure : _EventDelete_partial_solve_wit_5_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_5": {
        "name": "proof_of__EventDelete_partial_solve_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_5 : _EventDelete_partial_solve_wit_5.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_6_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_6_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_6_pure : _EventDelete_partial_solve_wit_6_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_6": {
        "name": "proof_of__EventDelete_partial_solve_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_6 : _EventDelete_partial_solve_wit_6.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_7_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_7_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_7_pure : _EventDelete_partial_solve_wit_7_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_7": {
        "name": "proof_of__EventDelete_partial_solve_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_7 : _EventDelete_partial_solve_wit_7.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_8_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_8_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_8_pure : _EventDelete_partial_solve_wit_8_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_8": {
        "name": "proof_of__EventDelete_partial_solve_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_8 : _EventDelete_partial_solve_wit_8.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_9_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_9_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_9_pure : _EventDelete_partial_solve_wit_9_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_9": {
        "name": "proof_of__EventDelete_partial_solve_wit_9",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_9 : _EventDelete_partial_solve_wit_9.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_10_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_10_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_10_pure : _EventDelete_partial_solve_wit_10_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_10": {
        "name": "proof_of__EventDelete_partial_solve_wit_10",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_10 : _EventDelete_partial_solve_wit_10.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_11_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_11_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_11_pure : _EventDelete_partial_solve_wit_11_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_11": {
        "name": "proof_of__EventDelete_partial_solve_wit_11",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_11 : _EventDelete_partial_solve_wit_11.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_12_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_12_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_12_pure : _EventDelete_partial_solve_wit_12_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_12": {
        "name": "proof_of__EventDelete_partial_solve_wit_12",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_12 : _EventDelete_partial_solve_wit_12.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_13_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_13_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_13_pure : _EventDelete_partial_solve_wit_13_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_13": {
        "name": "proof_of__EventDelete_partial_solve_wit_13",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_13 : _EventDelete_partial_solve_wit_13.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_14_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_14_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_14_pure : _EventDelete_partial_solve_wit_14_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_14": {
        "name": "proof_of__EventDelete_partial_solve_wit_14",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_14 : _EventDelete_partial_solve_wit_14.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_15_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_15_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_15_pure : _EventDelete_partial_solve_wit_15_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_15": {
        "name": "proof_of__EventDelete_partial_solve_wit_15",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_15 : _EventDelete_partial_solve_wit_15.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_16": {
        "name": "proof_of__EventDelete_partial_solve_wit_16",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_16 : _EventDelete_partial_solve_wit_16.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_17": {
        "name": "proof_of__EventDelete_partial_solve_wit_17",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_17 : _EventDelete_partial_solve_wit_17.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_18_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_18_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_18_pure : _EventDelete_partial_solve_wit_18_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_18": {
        "name": "proof_of__EventDelete_partial_solve_wit_18",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_18 : _EventDelete_partial_solve_wit_18.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_19_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_19_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_19_pure : _EventDelete_partial_solve_wit_19_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_19": {
        "name": "proof_of__EventDelete_partial_solve_wit_19",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_19 : _EventDelete_partial_solve_wit_19.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_20": {
        "name": "proof_of__EventDelete_partial_solve_wit_20",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_20 : _EventDelete_partial_solve_wit_20.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_21": {
        "name": "proof_of__EventDelete_partial_solve_wit_21",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_21 : _EventDelete_partial_solve_wit_21.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_22": {
        "name": "proof_of__EventDelete_partial_solve_wit_22",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_22 : _EventDelete_partial_solve_wit_22.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_23": {
        "name": "proof_of__EventDelete_partial_solve_wit_23",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_23 : _EventDelete_partial_solve_wit_23.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_24": {
        "name": "proof_of__EventDelete_partial_solve_wit_24",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_24 : _EventDelete_partial_solve_wit_24.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_25": {
        "name": "proof_of__EventDelete_partial_solve_wit_25",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_25 : _EventDelete_partial_solve_wit_25.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_26_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_26_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_26_pure : _EventDelete_partial_solve_wit_26_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_26": {
        "name": "proof_of__EventDelete_partial_solve_wit_26",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_26 : _EventDelete_partial_solve_wit_26.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_27_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_27_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_27_pure : _EventDelete_partial_solve_wit_27_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_27": {
        "name": "proof_of__EventDelete_partial_solve_wit_27",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_27 : _EventDelete_partial_solve_wit_27.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_28": {
        "name": "proof_of__EventDelete_partial_solve_wit_28",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_28 : _EventDelete_partial_solve_wit_28.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_29": {
        "name": "proof_of__EventDelete_partial_solve_wit_29",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_29 : _EventDelete_partial_solve_wit_29.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_30": {
        "name": "proof_of__EventDelete_partial_solve_wit_30",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_30 : _EventDelete_partial_solve_wit_30.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_31": {
        "name": "proof_of__EventDelete_partial_solve_wit_31",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_31 : _EventDelete_partial_solve_wit_31.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_32_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_32_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_32_pure : _EventDelete_partial_solve_wit_32_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_32": {
        "name": "proof_of__EventDelete_partial_solve_wit_32",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_32 : _EventDelete_partial_solve_wit_32.\n"
      },
      "proof_of__EventDelete_entail_wit_4_1_split_goal_1": {
        "name": "proof_of__EventDelete_entail_wit_4_1_split_goal_1",
        "parent": "proof_of__EventDelete_entail_wit_4_1",
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_1_split_goal_1 : _EventDelete_entail_wit_4_1_split_goal_1.\n"
      },
      "proof_of__EventDelete_entail_wit_4_1_split_goal_2": {
        "name": "proof_of__EventDelete_entail_wit_4_1_split_goal_2",
        "parent": "proof_of__EventDelete_entail_wit_4_1",
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_1_split_goal_2 : _EventDelete_entail_wit_4_1_split_goal_2.\n"
      },
      "proof_of__EventDelete_entail_wit_4_1_split_goal_spatial": {
        "name": "proof_of__EventDelete_entail_wit_4_1_split_goal_spatial",
        "parent": "proof_of__EventDelete_entail_wit_4_1",
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_1_split_goal_spatial : _EventDelete_entail_wit_4_1_split_goal_spatial.\n"
      },
      "proof_of__EventDelete_entail_wit_4_1": {
        "name": "proof_of__EventDelete_entail_wit_4_1",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_1 : _EventDelete_entail_wit_4_1.\n"
      },
      "proof_of__EventDelete_entail_wit_4_2_split_goal_1": {
        "name": "proof_of__EventDelete_entail_wit_4_2_split_goal_1",
        "parent": "proof_of__EventDelete_entail_wit_4_2",
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_2_split_goal_1 : _EventDelete_entail_wit_4_2_split_goal_1.\n"
      },
      "proof_of__EventDelete_entail_wit_4_2_split_goal_2": {
        "name": "proof_of__EventDelete_entail_wit_4_2_split_goal_2",
        "parent": "proof_of__EventDelete_entail_wit_4_2",
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_2_split_goal_2 : _EventDelete_entail_wit_4_2_split_goal_2.\n"
      },
      "proof_of__EventDelete_entail_wit_4_2_split_goal_spatial": {
        "name": "proof_of__EventDelete_entail_wit_4_2_split_goal_spatial",
        "parent": "proof_of__EventDelete_entail_wit_4_2",
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_2_split_goal_spatial : _EventDelete_entail_wit_4_2_split_goal_spatial.\n"
      },
      "proof_of__EventDelete_entail_wit_4_2": {
        "name": "proof_of__EventDelete_entail_wit_4_2",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_2 : _EventDelete_entail_wit_4_2.\n"
      },
      "proof_of__EventDelete_entail_wit_4_3_split_goal_1": {
        "name": "proof_of__EventDelete_entail_wit_4_3_split_goal_1",
        "parent": "proof_of__EventDelete_entail_wit_4_3",
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_3_split_goal_1 : _EventDelete_entail_wit_4_3_split_goal_1.\n"
      },
      "proof_of__EventDelete_entail_wit_4_3_split_goal_2": {
        "name": "proof_of__EventDelete_entail_wit_4_3_split_goal_2",
        "parent": "proof_of__EventDelete_entail_wit_4_3",
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_3_split_goal_2 : _EventDelete_entail_wit_4_3_split_goal_2.\n"
      },
      "proof_of__EventDelete_entail_wit_4_3_split_goal_spatial": {
        "name": "proof_of__EventDelete_entail_wit_4_3_split_goal_spatial",
        "parent": "proof_of__EventDelete_entail_wit_4_3",
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_3_split_goal_spatial : _EventDelete_entail_wit_4_3_split_goal_spatial.\n"
      },
      "proof_of__EventDelete_entail_wit_4_3": {
        "name": "proof_of__EventDelete_entail_wit_4_3",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_3 : _EventDelete_entail_wit_4_3.\n"
      },
      "proof_of__EventDelete_entail_wit_4_4_split_goal_1": {
        "name": "proof_of__EventDelete_entail_wit_4_4_split_goal_1",
        "parent": "proof_of__EventDelete_entail_wit_4_4",
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_4_split_goal_1 : _EventDelete_entail_wit_4_4_split_goal_1.\n"
      },
      "proof_of__EventDelete_entail_wit_4_4_split_goal_2": {
        "name": "proof_of__EventDelete_entail_wit_4_4_split_goal_2",
        "parent": "proof_of__EventDelete_entail_wit_4_4",
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_4_split_goal_2 : _EventDelete_entail_wit_4_4_split_goal_2.\n"
      },
      "proof_of__EventDelete_entail_wit_4_4_split_goal_spatial": {
        "name": "proof_of__EventDelete_entail_wit_4_4_split_goal_spatial",
        "parent": "proof_of__EventDelete_entail_wit_4_4",
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_4_split_goal_spatial : _EventDelete_entail_wit_4_4_split_goal_spatial.\n"
      },
      "proof_of__EventDelete_entail_wit_4_4": {
        "name": "proof_of__EventDelete_entail_wit_4_4",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_entail_wit_4_4 : _EventDelete_entail_wit_4_4.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_20_pure_split_goal_1": {
        "name": "proof_of__EventDelete_partial_solve_wit_20_pure_split_goal_1",
        "parent": "proof_of__EventDelete_partial_solve_wit_20_pure",
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_20_pure_split_goal_1 : _EventDelete_partial_solve_wit_20_pure_split_goal_1.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_20_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_20_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_20_pure : _EventDelete_partial_solve_wit_20_pure.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_21_pure_split_goal_1": {
        "name": "proof_of__EventDelete_partial_solve_wit_21_pure_split_goal_1",
        "parent": "proof_of__EventDelete_partial_solve_wit_21_pure",
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_21_pure_split_goal_1 : _EventDelete_partial_solve_wit_21_pure_split_goal_1.\n"
      },
      "proof_of__EventDelete_partial_solve_wit_21_pure": {
        "name": "proof_of__EventDelete_partial_solve_wit_21_pure",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_partial_solve_wit_21_pure : _EventDelete_partial_solve_wit_21_pure.\n"
      },
      "proof_of__EventDelete_which_implies_wit_1": {
        "name": "proof_of__EventDelete_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_1 : _EventDelete_which_implies_wit_1.\n"
      },
      "proof_of__EventDelete_which_implies_wit_2_split_goal_1": {
        "name": "proof_of__EventDelete_which_implies_wit_2_split_goal_1",
        "parent": "proof_of__EventDelete_which_implies_wit_2",
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_2_split_goal_1 : _EventDelete_which_implies_wit_2_split_goal_1.\n"
      },
      "proof_of__EventDelete_which_implies_wit_2_split_goal_spatial": {
        "name": "proof_of__EventDelete_which_implies_wit_2_split_goal_spatial",
        "parent": "proof_of__EventDelete_which_implies_wit_2",
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_2_split_goal_spatial : _EventDelete_which_implies_wit_2_split_goal_spatial.\n"
      },
      "proof_of__EventDelete_which_implies_wit_2": {
        "name": "proof_of__EventDelete_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_2 : _EventDelete_which_implies_wit_2.\n"
      },
      "proof_of__EventDelete_which_implies_wit_3_split_goal_1": {
        "name": "proof_of__EventDelete_which_implies_wit_3_split_goal_1",
        "parent": "proof_of__EventDelete_which_implies_wit_3",
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_3_split_goal_1 : _EventDelete_which_implies_wit_3_split_goal_1.\n"
      },
      "proof_of__EventDelete_which_implies_wit_3_split_goal_2": {
        "name": "proof_of__EventDelete_which_implies_wit_3_split_goal_2",
        "parent": "proof_of__EventDelete_which_implies_wit_3",
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_3_split_goal_2 : _EventDelete_which_implies_wit_3_split_goal_2.\n"
      },
      "proof_of__EventDelete_which_implies_wit_3": {
        "name": "proof_of__EventDelete_which_implies_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_3 : _EventDelete_which_implies_wit_3.\n"
      },
      "proof_of__EventDelete_which_implies_wit_4_split_goal_1": {
        "name": "proof_of__EventDelete_which_implies_wit_4_split_goal_1",
        "parent": "proof_of__EventDelete_which_implies_wit_4",
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_4_split_goal_1 : _EventDelete_which_implies_wit_4_split_goal_1.\n"
      },
      "proof_of__EventDelete_which_implies_wit_4": {
        "name": "proof_of__EventDelete_which_implies_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_4 : _EventDelete_which_implies_wit_4.\n"
      },
      "proof_of__EventDelete_which_implies_wit_5_split_goal_1": {
        "name": "proof_of__EventDelete_which_implies_wit_5_split_goal_1",
        "parent": "proof_of__EventDelete_which_implies_wit_5",
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_5_split_goal_1 : _EventDelete_which_implies_wit_5_split_goal_1.\n"
      },
      "proof_of__EventDelete_which_implies_wit_5_split_goal_2": {
        "name": "proof_of__EventDelete_which_implies_wit_5_split_goal_2",
        "parent": "proof_of__EventDelete_which_implies_wit_5",
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_5_split_goal_2 : _EventDelete_which_implies_wit_5_split_goal_2.\n"
      },
      "proof_of__EventDelete_which_implies_wit_5": {
        "name": "proof_of__EventDelete_which_implies_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_5 : _EventDelete_which_implies_wit_5.\n"
      },
      "proof_of__EventDelete_which_implies_wit_6": {
        "name": "proof_of__EventDelete_which_implies_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_6 : _EventDelete_which_implies_wit_6.\n"
      },
      "proof_of__EventDelete_which_implies_wit_7_split_goal_spatial": {
        "name": "proof_of__EventDelete_which_implies_wit_7_split_goal_spatial",
        "parent": "proof_of__EventDelete_which_implies_wit_7",
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_7_split_goal_spatial : _EventDelete_which_implies_wit_7_split_goal_spatial.\n"
      },
      "proof_of__EventDelete_which_implies_wit_7": {
        "name": "proof_of__EventDelete_which_implies_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_7 : _EventDelete_which_implies_wit_7.\n"
      },
      "proof_of__EventDelete_which_implies_wit_8_split_goal_spatial": {
        "name": "proof_of__EventDelete_which_implies_wit_8_split_goal_spatial",
        "parent": "proof_of__EventDelete_which_implies_wit_8",
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_8_split_goal_spatial : _EventDelete_which_implies_wit_8_split_goal_spatial.\n"
      },
      "proof_of__EventDelete_which_implies_wit_8": {
        "name": "proof_of__EventDelete_which_implies_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_8 : _EventDelete_which_implies_wit_8.\n"
      },
      "proof_of__EventDelete_which_implies_wit_9_split_goal_spatial": {
        "name": "proof_of__EventDelete_which_implies_wit_9_split_goal_spatial",
        "parent": "proof_of__EventDelete_which_implies_wit_9",
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_9_split_goal_spatial : _EventDelete_which_implies_wit_9_split_goal_spatial.\n"
      },
      "proof_of__EventDelete_which_implies_wit_9": {
        "name": "proof_of__EventDelete_which_implies_wit_9",
        "parent": null,
        "statement": "Lemma proof_of__EventDelete_which_implies_wit_9 : _EventDelete_which_implies_wit_9.\n"
      }
    },
    "top_level": [
      "proof_of__EventDelete_safety_wit_1",
      "proof_of__EventDelete_safety_wit_2",
      "proof_of__EventDelete_safety_wit_3",
      "proof_of__EventDelete_safety_wit_4",
      "proof_of__EventDelete_safety_wit_5",
      "proof_of__EventDelete_safety_wit_6",
      "proof_of__EventDelete_safety_wit_7",
      "proof_of__EventDelete_safety_wit_8",
      "proof_of__EventDelete_safety_wit_9",
      "proof_of__EventDelete_safety_wit_10",
      "proof_of__EventDelete_entail_wit_1",
      "proof_of__EventDelete_entail_wit_2",
      "proof_of__EventDelete_entail_wit_3_1",
      "proof_of__EventDelete_entail_wit_3_2",
      "proof_of__EventDelete_entail_wit_5_1",
      "proof_of__EventDelete_entail_wit_5_2",
      "proof_of__EventDelete_entail_wit_6_1",
      "proof_of__EventDelete_entail_wit_6_2",
      "proof_of__EventDelete_return_wit_1",
      "proof_of__EventDelete_return_wit_2",
      "proof_of__EventDelete_partial_solve_wit_1_pure",
      "proof_of__EventDelete_partial_solve_wit_1",
      "proof_of__EventDelete_partial_solve_wit_2_pure",
      "proof_of__EventDelete_partial_solve_wit_2",
      "proof_of__EventDelete_partial_solve_wit_3",
      "proof_of__EventDelete_partial_solve_wit_4_pure",
      "proof_of__EventDelete_partial_solve_wit_4",
      "proof_of__EventDelete_partial_solve_wit_5_pure",
      "proof_of__EventDelete_partial_solve_wit_5",
      "proof_of__EventDelete_partial_solve_wit_6_pure",
      "proof_of__EventDelete_partial_solve_wit_6",
      "proof_of__EventDelete_partial_solve_wit_7_pure",
      "proof_of__EventDelete_partial_solve_wit_7",
      "proof_of__EventDelete_partial_solve_wit_8_pure",
      "proof_of__EventDelete_partial_solve_wit_8",
      "proof_of__EventDelete_partial_solve_wit_9_pure",
      "proof_of__EventDelete_partial_solve_wit_9",
      "proof_of__EventDelete_partial_solve_wit_10_pure",
      "proof_of__EventDelete_partial_solve_wit_10",
      "proof_of__EventDelete_partial_solve_wit_11_pure",
      "proof_of__EventDelete_partial_solve_wit_11",
      "proof_of__EventDelete_partial_solve_wit_12_pure",
      "proof_of__EventDelete_partial_solve_wit_12",
      "proof_of__EventDelete_partial_solve_wit_13_pure",
      "proof_of__EventDelete_partial_solve_wit_13",
      "proof_of__EventDelete_partial_solve_wit_14_pure",
      "proof_of__EventDelete_partial_solve_wit_14",
      "proof_of__EventDelete_partial_solve_wit_15_pure",
      "proof_of__EventDelete_partial_solve_wit_15",
      "proof_of__EventDelete_partial_solve_wit_16",
      "proof_of__EventDelete_partial_solve_wit_17",
      "proof_of__EventDelete_partial_solve_wit_18_pure",
      "proof_of__EventDelete_partial_solve_wit_18",
      "proof_of__EventDelete_partial_solve_wit_19_pure",
      "proof_of__EventDelete_partial_solve_wit_19",
      "proof_of__EventDelete_partial_solve_wit_20",
      "proof_of__EventDelete_partial_solve_wit_21",
      "proof_of__EventDelete_partial_solve_wit_22",
      "proof_of__EventDelete_partial_solve_wit_23",
      "proof_of__EventDelete_partial_solve_wit_24",
      "proof_of__EventDelete_partial_solve_wit_25",
      "proof_of__EventDelete_partial_solve_wit_26_pure",
      "proof_of__EventDelete_partial_solve_wit_26",
      "proof_of__EventDelete_partial_solve_wit_27_pure",
      "proof_of__EventDelete_partial_solve_wit_27",
      "proof_of__EventDelete_partial_solve_wit_28",
      "proof_of__EventDelete_partial_solve_wit_29",
      "proof_of__EventDelete_partial_solve_wit_30",
      "proof_of__EventDelete_partial_solve_wit_31",
      "proof_of__EventDelete_partial_solve_wit_32_pure",
      "proof_of__EventDelete_partial_solve_wit_32",
      "proof_of__EventDelete_entail_wit_4_1",
      "proof_of__EventDelete_entail_wit_4_2",
      "proof_of__EventDelete_entail_wit_4_3",
      "proof_of__EventDelete_entail_wit_4_4",
      "proof_of__EventDelete_partial_solve_wit_20_pure",
      "proof_of__EventDelete_partial_solve_wit_21_pure",
      "proof_of__EventDelete_which_implies_wit_1",
      "proof_of__EventDelete_which_implies_wit_2",
      "proof_of__EventDelete_which_implies_wit_3",
      "proof_of__EventDelete_which_implies_wit_4",
      "proof_of__EventDelete_which_implies_wit_5",
      "proof_of__EventDelete_which_implies_wit_6",
      "proof_of__EventDelete_which_implies_wit_7",
      "proof_of__EventDelete_which_implies_wit_8",
      "proof_of__EventDelete_which_implies_wit_9"
    ],
    "split_goals": {
      "proof_of__EventDelete_safety_wit_1": [],
      "proof_of__EventDelete_safety_wit_2": [],
      "proof_of__EventDelete_safety_wit_3": [],
      "proof_of__EventDelete_safety_wit_4": [],
      "proof_of__EventDelete_safety_wit_5": [],
      "proof_of__EventDelete_safety_wit_6": [],
      "proof_of__EventDelete_safety_wit_7": [],
      "proof_of__EventDelete_safety_wit_8": [],
      "proof_of__EventDelete_safety_wit_9": [],
      "proof_of__EventDelete_safety_wit_10": [],
      "proof_of__EventDelete_entail_wit_1": [],
      "proof_of__EventDelete_entail_wit_2": [],
      "proof_of__EventDelete_entail_wit_3_1": [],
      "proof_of__EventDelete_entail_wit_3_2": [],
      "proof_of__EventDelete_entail_wit_5_1": [],
      "proof_of__EventDelete_entail_wit_5_2": [],
      "proof_of__EventDelete_entail_wit_6_1": [],
      "proof_of__EventDelete_entail_wit_6_2": [],
      "proof_of__EventDelete_return_wit_1": [],
      "proof_of__EventDelete_return_wit_2": [],
      "proof_of__EventDelete_partial_solve_wit_1_pure": [],
      "proof_of__EventDelete_partial_solve_wit_1": [],
      "proof_of__EventDelete_partial_solve_wit_2_pure": [],
      "proof_of__EventDelete_partial_solve_wit_2": [],
      "proof_of__EventDelete_partial_solve_wit_3": [],
      "proof_of__EventDelete_partial_solve_wit_4_pure": [],
      "proof_of__EventDelete_partial_solve_wit_4": [],
      "proof_of__EventDelete_partial_solve_wit_5_pure": [],
      "proof_of__EventDelete_partial_solve_wit_5": [],
      "proof_of__EventDelete_partial_solve_wit_6_pure": [],
      "proof_of__EventDelete_partial_solve_wit_6": [],
      "proof_of__EventDelete_partial_solve_wit_7_pure": [],
      "proof_of__EventDelete_partial_solve_wit_7": [],
      "proof_of__EventDelete_partial_solve_wit_8_pure": [],
      "proof_of__EventDelete_partial_solve_wit_8": [],
      "proof_of__EventDelete_partial_solve_wit_9_pure": [],
      "proof_of__EventDelete_partial_solve_wit_9": [],
      "proof_of__EventDelete_partial_solve_wit_10_pure": [],
      "proof_of__EventDelete_partial_solve_wit_10": [],
      "proof_of__EventDelete_partial_solve_wit_11_pure": [],
      "proof_of__EventDelete_partial_solve_wit_11": [],
      "proof_of__EventDelete_partial_solve_wit_12_pure": [],
      "proof_of__EventDelete_partial_solve_wit_12": [],
      "proof_of__EventDelete_partial_solve_wit_13_pure": [],
      "proof_of__EventDelete_partial_solve_wit_13": [],
      "proof_of__EventDelete_partial_solve_wit_14_pure": [],
      "proof_of__EventDelete_partial_solve_wit_14": [],
      "proof_of__EventDelete_partial_solve_wit_15_pure": [],
      "proof_of__EventDelete_partial_solve_wit_15": [],
      "proof_of__EventDelete_partial_solve_wit_16": [],
      "proof_of__EventDelete_partial_solve_wit_17": [],
      "proof_of__EventDelete_partial_solve_wit_18_pure": [],
      "proof_of__EventDelete_partial_solve_wit_18": [],
      "proof_of__EventDelete_partial_solve_wit_19_pure": [],
      "proof_of__EventDelete_partial_solve_wit_19": [],
      "proof_of__EventDelete_partial_solve_wit_20": [],
      "proof_of__EventDelete_partial_solve_wit_21": [],
      "proof_of__EventDelete_partial_solve_wit_22": [],
      "proof_of__EventDelete_partial_solve_wit_23": [],
      "proof_of__EventDelete_partial_solve_wit_24": [],
      "proof_of__EventDelete_partial_solve_wit_25": [],
      "proof_of__EventDelete_partial_solve_wit_26_pure": [],
      "proof_of__EventDelete_partial_solve_wit_26": [],
      "proof_of__EventDelete_partial_solve_wit_27_pure": [],
      "proof_of__EventDelete_partial_solve_wit_27": [],
      "proof_of__EventDelete_partial_solve_wit_28": [],
      "proof_of__EventDelete_partial_solve_wit_29": [],
      "proof_of__EventDelete_partial_solve_wit_30": [],
      "proof_of__EventDelete_partial_solve_wit_31": [],
      "proof_of__EventDelete_partial_solve_wit_32_pure": [],
      "proof_of__EventDelete_partial_solve_wit_32": [],
      "proof_of__EventDelete_entail_wit_4_1": [
        "proof_of__EventDelete_entail_wit_4_1_split_goal_1",
        "proof_of__EventDelete_entail_wit_4_1_split_goal_2",
        "proof_of__EventDelete_entail_wit_4_1_split_goal_spatial"
      ],
      "proof_of__EventDelete_entail_wit_4_2": [
        "proof_of__EventDelete_entail_wit_4_2_split_goal_1",
        "proof_of__EventDelete_entail_wit_4_2_split_goal_2",
        "proof_of__EventDelete_entail_wit_4_2_split_goal_spatial"
      ],
      "proof_of__EventDelete_entail_wit_4_3": [
        "proof_of__EventDelete_entail_wit_4_3_split_goal_1",
        "proof_of__EventDelete_entail_wit_4_3_split_goal_2",
        "proof_of__EventDelete_entail_wit_4_3_split_goal_spatial"
      ],
      "proof_of__EventDelete_entail_wit_4_4": [
        "proof_of__EventDelete_entail_wit_4_4_split_goal_1",
        "proof_of__EventDelete_entail_wit_4_4_split_goal_2",
        "proof_of__EventDelete_entail_wit_4_4_split_goal_spatial"
      ],
      "proof_of__EventDelete_partial_solve_wit_20_pure": [
        "proof_of__EventDelete_partial_solve_wit_20_pure_split_goal_1"
      ],
      "proof_of__EventDelete_partial_solve_wit_21_pure": [
        "proof_of__EventDelete_partial_solve_wit_21_pure_split_goal_1"
      ],
      "proof_of__EventDelete_which_implies_wit_1": [],
      "proof_of__EventDelete_which_implies_wit_2": [
        "proof_of__EventDelete_which_implies_wit_2_split_goal_1",
        "proof_of__EventDelete_which_implies_wit_2_split_goal_spatial"
      ],
      "proof_of__EventDelete_which_implies_wit_3": [
        "proof_of__EventDelete_which_implies_wit_3_split_goal_1",
        "proof_of__EventDelete_which_implies_wit_3_split_goal_2"
      ],
      "proof_of__EventDelete_which_implies_wit_4": [
        "proof_of__EventDelete_which_implies_wit_4_split_goal_1"
      ],
      "proof_of__EventDelete_which_implies_wit_5": [
        "proof_of__EventDelete_which_implies_wit_5_split_goal_1",
        "proof_of__EventDelete_which_implies_wit_5_split_goal_2"
      ],
      "proof_of__EventDelete_which_implies_wit_6": [],
      "proof_of__EventDelete_which_implies_wit_7": [
        "proof_of__EventDelete_which_implies_wit_7_split_goal_spatial"
      ],
      "proof_of__EventDelete_which_implies_wit_8": [
        "proof_of__EventDelete_which_implies_wit_8_split_goal_spatial"
      ],
      "proof_of__EventDelete_which_implies_wit_9": [
        "proof_of__EventDelete_which_implies_wit_9_split_goal_spatial"
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
      "EventDelete-20261103173023",
      "--round",
      "EventDelete-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
