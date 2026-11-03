# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "MutexCreate-vc-checking-r1",
  "round": "MutexCreate-vc-checking-r1",
  "main_root": "/home/xinra/crtos/kmutexcreate-trial-261101-1",
  "target_files": {
    "c_file": "annotated_C/src/_MutexCreate.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/MutexCreate_lib.v",
    "goal_file": "VC/MutexCreate_goal.v",
    "proof_auto_file": "VC/MutexCreate_proof_auto.v",
    "proof_manual_file": "VC/MutexCreate_proof_manual.v",
    "goal_check_file": "VC/MutexCreate_goal_check.v",
    "case_name": "MutexCreate",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos/kmutexcreate-trial-261101-1/reports/MutexCreate-20261101164709/rounds/MutexCreate-vc-checking-r1/MutexCreate_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of__MutexCreate_safety_wit_1": {
        "name": "proof_of__MutexCreate_safety_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_1 : _MutexCreate_safety_wit_1.\n"
      },
      "proof_of__MutexCreate_safety_wit_2": {
        "name": "proof_of__MutexCreate_safety_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_2 : _MutexCreate_safety_wit_2.\n"
      },
      "proof_of__MutexCreate_safety_wit_3": {
        "name": "proof_of__MutexCreate_safety_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_3 : _MutexCreate_safety_wit_3.\n"
      },
      "proof_of__MutexCreate_safety_wit_4": {
        "name": "proof_of__MutexCreate_safety_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_4 : _MutexCreate_safety_wit_4.\n"
      },
      "proof_of__MutexCreate_safety_wit_5": {
        "name": "proof_of__MutexCreate_safety_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_5 : _MutexCreate_safety_wit_5.\n"
      },
      "proof_of__MutexCreate_safety_wit_6": {
        "name": "proof_of__MutexCreate_safety_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_6 : _MutexCreate_safety_wit_6.\n"
      },
      "proof_of__MutexCreate_safety_wit_7": {
        "name": "proof_of__MutexCreate_safety_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_7 : _MutexCreate_safety_wit_7.\n"
      },
      "proof_of__MutexCreate_safety_wit_8": {
        "name": "proof_of__MutexCreate_safety_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_8 : _MutexCreate_safety_wit_8.\n"
      },
      "proof_of__MutexCreate_safety_wit_9": {
        "name": "proof_of__MutexCreate_safety_wit_9",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_9 : _MutexCreate_safety_wit_9.\n"
      },
      "proof_of__MutexCreate_safety_wit_10": {
        "name": "proof_of__MutexCreate_safety_wit_10",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_10 : _MutexCreate_safety_wit_10.\n"
      },
      "proof_of__MutexCreate_safety_wit_11": {
        "name": "proof_of__MutexCreate_safety_wit_11",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_11 : _MutexCreate_safety_wit_11.\n"
      },
      "proof_of__MutexCreate_safety_wit_12": {
        "name": "proof_of__MutexCreate_safety_wit_12",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_12 : _MutexCreate_safety_wit_12.\n"
      },
      "proof_of__MutexCreate_safety_wit_13": {
        "name": "proof_of__MutexCreate_safety_wit_13",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_13 : _MutexCreate_safety_wit_13.\n"
      },
      "proof_of__MutexCreate_safety_wit_14": {
        "name": "proof_of__MutexCreate_safety_wit_14",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_14 : _MutexCreate_safety_wit_14.\n"
      },
      "proof_of__MutexCreate_safety_wit_15": {
        "name": "proof_of__MutexCreate_safety_wit_15",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_15 : _MutexCreate_safety_wit_15.\n"
      },
      "proof_of__MutexCreate_safety_wit_16": {
        "name": "proof_of__MutexCreate_safety_wit_16",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_16 : _MutexCreate_safety_wit_16.\n"
      },
      "proof_of__MutexCreate_safety_wit_17": {
        "name": "proof_of__MutexCreate_safety_wit_17",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_17 : _MutexCreate_safety_wit_17.\n"
      },
      "proof_of__MutexCreate_safety_wit_18": {
        "name": "proof_of__MutexCreate_safety_wit_18",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_18 : _MutexCreate_safety_wit_18.\n"
      },
      "proof_of__MutexCreate_safety_wit_19": {
        "name": "proof_of__MutexCreate_safety_wit_19",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_19 : _MutexCreate_safety_wit_19.\n"
      },
      "proof_of__MutexCreate_safety_wit_20": {
        "name": "proof_of__MutexCreate_safety_wit_20",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_safety_wit_20 : _MutexCreate_safety_wit_20.\n"
      },
      "proof_of__MutexCreate_return_wit_1": {
        "name": "proof_of__MutexCreate_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_return_wit_1 : _MutexCreate_return_wit_1.\n"
      },
      "proof_of__MutexCreate_return_wit_2": {
        "name": "proof_of__MutexCreate_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_return_wit_2 : _MutexCreate_return_wit_2.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_1_pure": {
        "name": "proof_of__MutexCreate_partial_solve_wit_1_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_1_pure : _MutexCreate_partial_solve_wit_1_pure.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_1": {
        "name": "proof_of__MutexCreate_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_1 : _MutexCreate_partial_solve_wit_1.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_2_pure": {
        "name": "proof_of__MutexCreate_partial_solve_wit_2_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_2_pure : _MutexCreate_partial_solve_wit_2_pure.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_2": {
        "name": "proof_of__MutexCreate_partial_solve_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_2 : _MutexCreate_partial_solve_wit_2.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_3_pure": {
        "name": "proof_of__MutexCreate_partial_solve_wit_3_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_3_pure : _MutexCreate_partial_solve_wit_3_pure.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_3": {
        "name": "proof_of__MutexCreate_partial_solve_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_3 : _MutexCreate_partial_solve_wit_3.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_4": {
        "name": "proof_of__MutexCreate_partial_solve_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_4 : _MutexCreate_partial_solve_wit_4.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_5": {
        "name": "proof_of__MutexCreate_partial_solve_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_5 : _MutexCreate_partial_solve_wit_5.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_6": {
        "name": "proof_of__MutexCreate_partial_solve_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_6 : _MutexCreate_partial_solve_wit_6.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_7_pure": {
        "name": "proof_of__MutexCreate_partial_solve_wit_7_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_7_pure : _MutexCreate_partial_solve_wit_7_pure.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_7": {
        "name": "proof_of__MutexCreate_partial_solve_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_7 : _MutexCreate_partial_solve_wit_7.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_8_pure": {
        "name": "proof_of__MutexCreate_partial_solve_wit_8_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_8_pure : _MutexCreate_partial_solve_wit_8_pure.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_8": {
        "name": "proof_of__MutexCreate_partial_solve_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_8 : _MutexCreate_partial_solve_wit_8.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_9": {
        "name": "proof_of__MutexCreate_partial_solve_wit_9",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_9 : _MutexCreate_partial_solve_wit_9.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_10": {
        "name": "proof_of__MutexCreate_partial_solve_wit_10",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_10 : _MutexCreate_partial_solve_wit_10.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_11": {
        "name": "proof_of__MutexCreate_partial_solve_wit_11",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_11 : _MutexCreate_partial_solve_wit_11.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_12_pure": {
        "name": "proof_of__MutexCreate_partial_solve_wit_12_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_12_pure : _MutexCreate_partial_solve_wit_12_pure.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_12": {
        "name": "proof_of__MutexCreate_partial_solve_wit_12",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_12 : _MutexCreate_partial_solve_wit_12.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_13": {
        "name": "proof_of__MutexCreate_partial_solve_wit_13",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_13 : _MutexCreate_partial_solve_wit_13.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_14_pure": {
        "name": "proof_of__MutexCreate_partial_solve_wit_14_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_14_pure : _MutexCreate_partial_solve_wit_14_pure.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_14": {
        "name": "proof_of__MutexCreate_partial_solve_wit_14",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_14 : _MutexCreate_partial_solve_wit_14.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_15_pure": {
        "name": "proof_of__MutexCreate_partial_solve_wit_15_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_15_pure : _MutexCreate_partial_solve_wit_15_pure.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_15": {
        "name": "proof_of__MutexCreate_partial_solve_wit_15",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_15 : _MutexCreate_partial_solve_wit_15.\n"
      },
      "proof_of__MutexCreate_entail_wit_1_1": {
        "name": "proof_of__MutexCreate_entail_wit_1_1",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_entail_wit_1_1 : _MutexCreate_entail_wit_1_1.\n"
      },
      "proof_of__MutexCreate_entail_wit_1_2": {
        "name": "proof_of__MutexCreate_entail_wit_1_2",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_entail_wit_1_2 : _MutexCreate_entail_wit_1_2.\n"
      },
      "proof_of__MutexCreate_return_wit_3_split_goal_1": {
        "name": "proof_of__MutexCreate_return_wit_3_split_goal_1",
        "parent": "proof_of__MutexCreate_return_wit_3",
        "statement": "Lemma proof_of__MutexCreate_return_wit_3_split_goal_1 : _MutexCreate_return_wit_3_split_goal_1.\n"
      },
      "proof_of__MutexCreate_return_wit_3": {
        "name": "proof_of__MutexCreate_return_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_return_wit_3 : _MutexCreate_return_wit_3.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_13_pure_split_goal_1": {
        "name": "proof_of__MutexCreate_partial_solve_wit_13_pure_split_goal_1",
        "parent": "proof_of__MutexCreate_partial_solve_wit_13_pure",
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_13_pure_split_goal_1 : _MutexCreate_partial_solve_wit_13_pure_split_goal_1.\n"
      },
      "proof_of__MutexCreate_partial_solve_wit_13_pure": {
        "name": "proof_of__MutexCreate_partial_solve_wit_13_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_partial_solve_wit_13_pure : _MutexCreate_partial_solve_wit_13_pure.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_1_split_goal_1": {
        "name": "proof_of__MutexCreate_which_implies_wit_1_split_goal_1",
        "parent": "proof_of__MutexCreate_which_implies_wit_1",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_1_split_goal_1 : _MutexCreate_which_implies_wit_1_split_goal_1.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_1_split_goal_2": {
        "name": "proof_of__MutexCreate_which_implies_wit_1_split_goal_2",
        "parent": "proof_of__MutexCreate_which_implies_wit_1",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_1_split_goal_2 : _MutexCreate_which_implies_wit_1_split_goal_2.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_1_split_goal_spatial": {
        "name": "proof_of__MutexCreate_which_implies_wit_1_split_goal_spatial",
        "parent": "proof_of__MutexCreate_which_implies_wit_1",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_1_split_goal_spatial : _MutexCreate_which_implies_wit_1_split_goal_spatial.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_1": {
        "name": "proof_of__MutexCreate_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_1 : _MutexCreate_which_implies_wit_1.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_2_split_goal_1": {
        "name": "proof_of__MutexCreate_which_implies_wit_2_split_goal_1",
        "parent": "proof_of__MutexCreate_which_implies_wit_2",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_1 : _MutexCreate_which_implies_wit_2_split_goal_1.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_2_split_goal_2": {
        "name": "proof_of__MutexCreate_which_implies_wit_2_split_goal_2",
        "parent": "proof_of__MutexCreate_which_implies_wit_2",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_2 : _MutexCreate_which_implies_wit_2_split_goal_2.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_2_split_goal_3": {
        "name": "proof_of__MutexCreate_which_implies_wit_2_split_goal_3",
        "parent": "proof_of__MutexCreate_which_implies_wit_2",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_3 : _MutexCreate_which_implies_wit_2_split_goal_3.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_2_split_goal_4": {
        "name": "proof_of__MutexCreate_which_implies_wit_2_split_goal_4",
        "parent": "proof_of__MutexCreate_which_implies_wit_2",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_4 : _MutexCreate_which_implies_wit_2_split_goal_4.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_2_split_goal_spatial": {
        "name": "proof_of__MutexCreate_which_implies_wit_2_split_goal_spatial",
        "parent": "proof_of__MutexCreate_which_implies_wit_2",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_spatial : _MutexCreate_which_implies_wit_2_split_goal_spatial.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_2": {
        "name": "proof_of__MutexCreate_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_2 : _MutexCreate_which_implies_wit_2.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_3_split_goal_1": {
        "name": "proof_of__MutexCreate_which_implies_wit_3_split_goal_1",
        "parent": "proof_of__MutexCreate_which_implies_wit_3",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_3_split_goal_1 : _MutexCreate_which_implies_wit_3_split_goal_1.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_3_split_goal_2": {
        "name": "proof_of__MutexCreate_which_implies_wit_3_split_goal_2",
        "parent": "proof_of__MutexCreate_which_implies_wit_3",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_3_split_goal_2 : _MutexCreate_which_implies_wit_3_split_goal_2.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_3_split_goal_spatial": {
        "name": "proof_of__MutexCreate_which_implies_wit_3_split_goal_spatial",
        "parent": "proof_of__MutexCreate_which_implies_wit_3",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_3_split_goal_spatial : _MutexCreate_which_implies_wit_3_split_goal_spatial.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_3": {
        "name": "proof_of__MutexCreate_which_implies_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_3 : _MutexCreate_which_implies_wit_3.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_4": {
        "name": "proof_of__MutexCreate_which_implies_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_4 : _MutexCreate_which_implies_wit_4.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_5_split_goal_spatial": {
        "name": "proof_of__MutexCreate_which_implies_wit_5_split_goal_spatial",
        "parent": "proof_of__MutexCreate_which_implies_wit_5",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_5_split_goal_spatial : _MutexCreate_which_implies_wit_5_split_goal_spatial.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_5": {
        "name": "proof_of__MutexCreate_which_implies_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_5 : _MutexCreate_which_implies_wit_5.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_6_split_goal_1": {
        "name": "proof_of__MutexCreate_which_implies_wit_6_split_goal_1",
        "parent": "proof_of__MutexCreate_which_implies_wit_6",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_1 : _MutexCreate_which_implies_wit_6_split_goal_1.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_6_split_goal_2": {
        "name": "proof_of__MutexCreate_which_implies_wit_6_split_goal_2",
        "parent": "proof_of__MutexCreate_which_implies_wit_6",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_2 : _MutexCreate_which_implies_wit_6_split_goal_2.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_6_split_goal_3": {
        "name": "proof_of__MutexCreate_which_implies_wit_6_split_goal_3",
        "parent": "proof_of__MutexCreate_which_implies_wit_6",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_3 : _MutexCreate_which_implies_wit_6_split_goal_3.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_6_split_goal_4": {
        "name": "proof_of__MutexCreate_which_implies_wit_6_split_goal_4",
        "parent": "proof_of__MutexCreate_which_implies_wit_6",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_4 : _MutexCreate_which_implies_wit_6_split_goal_4.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_6_split_goal_spatial": {
        "name": "proof_of__MutexCreate_which_implies_wit_6_split_goal_spatial",
        "parent": "proof_of__MutexCreate_which_implies_wit_6",
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_spatial : _MutexCreate_which_implies_wit_6_split_goal_spatial.\n"
      },
      "proof_of__MutexCreate_which_implies_wit_6": {
        "name": "proof_of__MutexCreate_which_implies_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__MutexCreate_which_implies_wit_6 : _MutexCreate_which_implies_wit_6.\n"
      }
    },
    "top_level": [
      "proof_of__MutexCreate_safety_wit_1",
      "proof_of__MutexCreate_safety_wit_2",
      "proof_of__MutexCreate_safety_wit_3",
      "proof_of__MutexCreate_safety_wit_4",
      "proof_of__MutexCreate_safety_wit_5",
      "proof_of__MutexCreate_safety_wit_6",
      "proof_of__MutexCreate_safety_wit_7",
      "proof_of__MutexCreate_safety_wit_8",
      "proof_of__MutexCreate_safety_wit_9",
      "proof_of__MutexCreate_safety_wit_10",
      "proof_of__MutexCreate_safety_wit_11",
      "proof_of__MutexCreate_safety_wit_12",
      "proof_of__MutexCreate_safety_wit_13",
      "proof_of__MutexCreate_safety_wit_14",
      "proof_of__MutexCreate_safety_wit_15",
      "proof_of__MutexCreate_safety_wit_16",
      "proof_of__MutexCreate_safety_wit_17",
      "proof_of__MutexCreate_safety_wit_18",
      "proof_of__MutexCreate_safety_wit_19",
      "proof_of__MutexCreate_safety_wit_20",
      "proof_of__MutexCreate_return_wit_1",
      "proof_of__MutexCreate_return_wit_2",
      "proof_of__MutexCreate_partial_solve_wit_1_pure",
      "proof_of__MutexCreate_partial_solve_wit_1",
      "proof_of__MutexCreate_partial_solve_wit_2_pure",
      "proof_of__MutexCreate_partial_solve_wit_2",
      "proof_of__MutexCreate_partial_solve_wit_3_pure",
      "proof_of__MutexCreate_partial_solve_wit_3",
      "proof_of__MutexCreate_partial_solve_wit_4",
      "proof_of__MutexCreate_partial_solve_wit_5",
      "proof_of__MutexCreate_partial_solve_wit_6",
      "proof_of__MutexCreate_partial_solve_wit_7_pure",
      "proof_of__MutexCreate_partial_solve_wit_7",
      "proof_of__MutexCreate_partial_solve_wit_8_pure",
      "proof_of__MutexCreate_partial_solve_wit_8",
      "proof_of__MutexCreate_partial_solve_wit_9",
      "proof_of__MutexCreate_partial_solve_wit_10",
      "proof_of__MutexCreate_partial_solve_wit_11",
      "proof_of__MutexCreate_partial_solve_wit_12_pure",
      "proof_of__MutexCreate_partial_solve_wit_12",
      "proof_of__MutexCreate_partial_solve_wit_13",
      "proof_of__MutexCreate_partial_solve_wit_14_pure",
      "proof_of__MutexCreate_partial_solve_wit_14",
      "proof_of__MutexCreate_partial_solve_wit_15_pure",
      "proof_of__MutexCreate_partial_solve_wit_15",
      "proof_of__MutexCreate_entail_wit_1_1",
      "proof_of__MutexCreate_entail_wit_1_2",
      "proof_of__MutexCreate_return_wit_3",
      "proof_of__MutexCreate_partial_solve_wit_13_pure",
      "proof_of__MutexCreate_which_implies_wit_1",
      "proof_of__MutexCreate_which_implies_wit_2",
      "proof_of__MutexCreate_which_implies_wit_3",
      "proof_of__MutexCreate_which_implies_wit_4",
      "proof_of__MutexCreate_which_implies_wit_5",
      "proof_of__MutexCreate_which_implies_wit_6"
    ],
    "split_goals": {
      "proof_of__MutexCreate_safety_wit_1": [],
      "proof_of__MutexCreate_safety_wit_2": [],
      "proof_of__MutexCreate_safety_wit_3": [],
      "proof_of__MutexCreate_safety_wit_4": [],
      "proof_of__MutexCreate_safety_wit_5": [],
      "proof_of__MutexCreate_safety_wit_6": [],
      "proof_of__MutexCreate_safety_wit_7": [],
      "proof_of__MutexCreate_safety_wit_8": [],
      "proof_of__MutexCreate_safety_wit_9": [],
      "proof_of__MutexCreate_safety_wit_10": [],
      "proof_of__MutexCreate_safety_wit_11": [],
      "proof_of__MutexCreate_safety_wit_12": [],
      "proof_of__MutexCreate_safety_wit_13": [],
      "proof_of__MutexCreate_safety_wit_14": [],
      "proof_of__MutexCreate_safety_wit_15": [],
      "proof_of__MutexCreate_safety_wit_16": [],
      "proof_of__MutexCreate_safety_wit_17": [],
      "proof_of__MutexCreate_safety_wit_18": [],
      "proof_of__MutexCreate_safety_wit_19": [],
      "proof_of__MutexCreate_safety_wit_20": [],
      "proof_of__MutexCreate_return_wit_1": [],
      "proof_of__MutexCreate_return_wit_2": [],
      "proof_of__MutexCreate_partial_solve_wit_1_pure": [],
      "proof_of__MutexCreate_partial_solve_wit_1": [],
      "proof_of__MutexCreate_partial_solve_wit_2_pure": [],
      "proof_of__MutexCreate_partial_solve_wit_2": [],
      "proof_of__MutexCreate_partial_solve_wit_3_pure": [],
      "proof_of__MutexCreate_partial_solve_wit_3": [],
      "proof_of__MutexCreate_partial_solve_wit_4": [],
      "proof_of__MutexCreate_partial_solve_wit_5": [],
      "proof_of__MutexCreate_partial_solve_wit_6": [],
      "proof_of__MutexCreate_partial_solve_wit_7_pure": [],
      "proof_of__MutexCreate_partial_solve_wit_7": [],
      "proof_of__MutexCreate_partial_solve_wit_8_pure": [],
      "proof_of__MutexCreate_partial_solve_wit_8": [],
      "proof_of__MutexCreate_partial_solve_wit_9": [],
      "proof_of__MutexCreate_partial_solve_wit_10": [],
      "proof_of__MutexCreate_partial_solve_wit_11": [],
      "proof_of__MutexCreate_partial_solve_wit_12_pure": [],
      "proof_of__MutexCreate_partial_solve_wit_12": [],
      "proof_of__MutexCreate_partial_solve_wit_13": [],
      "proof_of__MutexCreate_partial_solve_wit_14_pure": [],
      "proof_of__MutexCreate_partial_solve_wit_14": [],
      "proof_of__MutexCreate_partial_solve_wit_15_pure": [],
      "proof_of__MutexCreate_partial_solve_wit_15": [],
      "proof_of__MutexCreate_entail_wit_1_1": [],
      "proof_of__MutexCreate_entail_wit_1_2": [],
      "proof_of__MutexCreate_return_wit_3": [
        "proof_of__MutexCreate_return_wit_3_split_goal_1"
      ],
      "proof_of__MutexCreate_partial_solve_wit_13_pure": [
        "proof_of__MutexCreate_partial_solve_wit_13_pure_split_goal_1"
      ],
      "proof_of__MutexCreate_which_implies_wit_1": [
        "proof_of__MutexCreate_which_implies_wit_1_split_goal_1",
        "proof_of__MutexCreate_which_implies_wit_1_split_goal_2",
        "proof_of__MutexCreate_which_implies_wit_1_split_goal_spatial"
      ],
      "proof_of__MutexCreate_which_implies_wit_2": [
        "proof_of__MutexCreate_which_implies_wit_2_split_goal_1",
        "proof_of__MutexCreate_which_implies_wit_2_split_goal_2",
        "proof_of__MutexCreate_which_implies_wit_2_split_goal_3",
        "proof_of__MutexCreate_which_implies_wit_2_split_goal_4",
        "proof_of__MutexCreate_which_implies_wit_2_split_goal_spatial"
      ],
      "proof_of__MutexCreate_which_implies_wit_3": [
        "proof_of__MutexCreate_which_implies_wit_3_split_goal_1",
        "proof_of__MutexCreate_which_implies_wit_3_split_goal_2",
        "proof_of__MutexCreate_which_implies_wit_3_split_goal_spatial"
      ],
      "proof_of__MutexCreate_which_implies_wit_4": [],
      "proof_of__MutexCreate_which_implies_wit_5": [
        "proof_of__MutexCreate_which_implies_wit_5_split_goal_spatial"
      ],
      "proof_of__MutexCreate_which_implies_wit_6": [
        "proof_of__MutexCreate_which_implies_wit_6_split_goal_1",
        "proof_of__MutexCreate_which_implies_wit_6_split_goal_2",
        "proof_of__MutexCreate_which_implies_wit_6_split_goal_3",
        "proof_of__MutexCreate_which_implies_wit_6_split_goal_4",
        "proof_of__MutexCreate_which_implies_wit_6_split_goal_spatial"
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
      "/home/xinra/crtos/kmutexcreate-trial-261101-1",
      "coq-debug",
      "--run",
      "MutexCreate-20261101164709",
      "--round",
      "MutexCreate-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos/kmutexcreate-trial-261101-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
