# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "MutexDelete-vc-checking-r1",
  "round": "MutexDelete-vc-checking-r1",
  "main_root": "/home/xinra/crtos/kmutexdelete-trial-261103-1",
  "target_files": {
    "c_file": "annotated_C/src/_MutexDelete.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/MutexDelete_lib.v",
    "goal_file": "VC/MutexDelete_goal.v",
    "proof_auto_file": "VC/MutexDelete_proof_auto.v",
    "proof_manual_file": "VC/MutexDelete_proof_manual.v",
    "goal_check_file": "VC/MutexDelete_goal_check.v",
    "case_name": "MutexDelete",
    "active_case_theory": "KMutexDeleteProof.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/rounds/MutexDelete-vc-checking-r1/MutexDelete_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of__MutexDelete_safety_wit_1": {
        "name": "proof_of__MutexDelete_safety_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_safety_wit_1 : _MutexDelete_safety_wit_1.\n"
      },
      "proof_of__MutexDelete_safety_wit_2": {
        "name": "proof_of__MutexDelete_safety_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_safety_wit_2 : _MutexDelete_safety_wit_2.\n"
      },
      "proof_of__MutexDelete_safety_wit_3": {
        "name": "proof_of__MutexDelete_safety_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_safety_wit_3 : _MutexDelete_safety_wit_3.\n"
      },
      "proof_of__MutexDelete_entail_wit_1": {
        "name": "proof_of__MutexDelete_entail_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_entail_wit_1 : _MutexDelete_entail_wit_1.\n"
      },
      "proof_of__MutexDelete_entail_wit_2": {
        "name": "proof_of__MutexDelete_entail_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_entail_wit_2 : _MutexDelete_entail_wit_2.\n"
      },
      "proof_of__MutexDelete_return_wit_1": {
        "name": "proof_of__MutexDelete_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_return_wit_1 : _MutexDelete_return_wit_1.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_1_pure": {
        "name": "proof_of__MutexDelete_partial_solve_wit_1_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_1_pure : _MutexDelete_partial_solve_wit_1_pure.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_1": {
        "name": "proof_of__MutexDelete_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_1 : _MutexDelete_partial_solve_wit_1.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_2": {
        "name": "proof_of__MutexDelete_partial_solve_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_2 : _MutexDelete_partial_solve_wit_2.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_3_pure": {
        "name": "proof_of__MutexDelete_partial_solve_wit_3_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_3_pure : _MutexDelete_partial_solve_wit_3_pure.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_3": {
        "name": "proof_of__MutexDelete_partial_solve_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_3 : _MutexDelete_partial_solve_wit_3.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_4_pure": {
        "name": "proof_of__MutexDelete_partial_solve_wit_4_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_4_pure : _MutexDelete_partial_solve_wit_4_pure.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_4": {
        "name": "proof_of__MutexDelete_partial_solve_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_4 : _MutexDelete_partial_solve_wit_4.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_5_pure": {
        "name": "proof_of__MutexDelete_partial_solve_wit_5_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_5_pure : _MutexDelete_partial_solve_wit_5_pure.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_5": {
        "name": "proof_of__MutexDelete_partial_solve_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_5 : _MutexDelete_partial_solve_wit_5.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_6": {
        "name": "proof_of__MutexDelete_partial_solve_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_6 : _MutexDelete_partial_solve_wit_6.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_7": {
        "name": "proof_of__MutexDelete_partial_solve_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_7 : _MutexDelete_partial_solve_wit_7.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_8": {
        "name": "proof_of__MutexDelete_partial_solve_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_8 : _MutexDelete_partial_solve_wit_8.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_9_pure": {
        "name": "proof_of__MutexDelete_partial_solve_wit_9_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_9_pure : _MutexDelete_partial_solve_wit_9_pure.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_9": {
        "name": "proof_of__MutexDelete_partial_solve_wit_9",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_9 : _MutexDelete_partial_solve_wit_9.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_10_pure": {
        "name": "proof_of__MutexDelete_partial_solve_wit_10_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_10_pure : _MutexDelete_partial_solve_wit_10_pure.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_10": {
        "name": "proof_of__MutexDelete_partial_solve_wit_10",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_10 : _MutexDelete_partial_solve_wit_10.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_11": {
        "name": "proof_of__MutexDelete_partial_solve_wit_11",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_11 : _MutexDelete_partial_solve_wit_11.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_12": {
        "name": "proof_of__MutexDelete_partial_solve_wit_12",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_12 : _MutexDelete_partial_solve_wit_12.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_13_pure": {
        "name": "proof_of__MutexDelete_partial_solve_wit_13_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_13_pure : _MutexDelete_partial_solve_wit_13_pure.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_13": {
        "name": "proof_of__MutexDelete_partial_solve_wit_13",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_13 : _MutexDelete_partial_solve_wit_13.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_14": {
        "name": "proof_of__MutexDelete_partial_solve_wit_14",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_14 : _MutexDelete_partial_solve_wit_14.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_15": {
        "name": "proof_of__MutexDelete_partial_solve_wit_15",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_15 : _MutexDelete_partial_solve_wit_15.\n"
      },
      "proof_of__MutexDelete_entail_wit_3_1_split_goal_1": {
        "name": "proof_of__MutexDelete_entail_wit_3_1_split_goal_1",
        "parent": "proof_of__MutexDelete_entail_wit_3_1",
        "statement": "Lemma proof_of__MutexDelete_entail_wit_3_1_split_goal_1 : _MutexDelete_entail_wit_3_1_split_goal_1.\n"
      },
      "proof_of__MutexDelete_entail_wit_3_1_split_goal_2": {
        "name": "proof_of__MutexDelete_entail_wit_3_1_split_goal_2",
        "parent": "proof_of__MutexDelete_entail_wit_3_1",
        "statement": "Lemma proof_of__MutexDelete_entail_wit_3_1_split_goal_2 : _MutexDelete_entail_wit_3_1_split_goal_2.\n"
      },
      "proof_of__MutexDelete_entail_wit_3_1_split_goal_spatial": {
        "name": "proof_of__MutexDelete_entail_wit_3_1_split_goal_spatial",
        "parent": "proof_of__MutexDelete_entail_wit_3_1",
        "statement": "Lemma proof_of__MutexDelete_entail_wit_3_1_split_goal_spatial : _MutexDelete_entail_wit_3_1_split_goal_spatial.\n"
      },
      "proof_of__MutexDelete_entail_wit_3_1": {
        "name": "proof_of__MutexDelete_entail_wit_3_1",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_entail_wit_3_1 : _MutexDelete_entail_wit_3_1.\n"
      },
      "proof_of__MutexDelete_entail_wit_3_2_split_goal_1": {
        "name": "proof_of__MutexDelete_entail_wit_3_2_split_goal_1",
        "parent": "proof_of__MutexDelete_entail_wit_3_2",
        "statement": "Lemma proof_of__MutexDelete_entail_wit_3_2_split_goal_1 : _MutexDelete_entail_wit_3_2_split_goal_1.\n"
      },
      "proof_of__MutexDelete_entail_wit_3_2_split_goal_2": {
        "name": "proof_of__MutexDelete_entail_wit_3_2_split_goal_2",
        "parent": "proof_of__MutexDelete_entail_wit_3_2",
        "statement": "Lemma proof_of__MutexDelete_entail_wit_3_2_split_goal_2 : _MutexDelete_entail_wit_3_2_split_goal_2.\n"
      },
      "proof_of__MutexDelete_entail_wit_3_2_split_goal_spatial": {
        "name": "proof_of__MutexDelete_entail_wit_3_2_split_goal_spatial",
        "parent": "proof_of__MutexDelete_entail_wit_3_2",
        "statement": "Lemma proof_of__MutexDelete_entail_wit_3_2_split_goal_spatial : _MutexDelete_entail_wit_3_2_split_goal_spatial.\n"
      },
      "proof_of__MutexDelete_entail_wit_3_2": {
        "name": "proof_of__MutexDelete_entail_wit_3_2",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_entail_wit_3_2 : _MutexDelete_entail_wit_3_2.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_2_pure_split_goal_1": {
        "name": "proof_of__MutexDelete_partial_solve_wit_2_pure_split_goal_1",
        "parent": "proof_of__MutexDelete_partial_solve_wit_2_pure",
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_2_pure_split_goal_1 : _MutexDelete_partial_solve_wit_2_pure_split_goal_1.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_2_pure": {
        "name": "proof_of__MutexDelete_partial_solve_wit_2_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_2_pure : _MutexDelete_partial_solve_wit_2_pure.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_1": {
        "name": "proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_1",
        "parent": "proof_of__MutexDelete_partial_solve_wit_8_pure",
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_1 : _MutexDelete_partial_solve_wit_8_pure_split_goal_1.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_2": {
        "name": "proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_2",
        "parent": "proof_of__MutexDelete_partial_solve_wit_8_pure",
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_2 : _MutexDelete_partial_solve_wit_8_pure_split_goal_2.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_3": {
        "name": "proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_3",
        "parent": "proof_of__MutexDelete_partial_solve_wit_8_pure",
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_3 : _MutexDelete_partial_solve_wit_8_pure_split_goal_3.\n"
      },
      "proof_of__MutexDelete_partial_solve_wit_8_pure": {
        "name": "proof_of__MutexDelete_partial_solve_wit_8_pure",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_partial_solve_wit_8_pure : _MutexDelete_partial_solve_wit_8_pure.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_1_split_goal_1": {
        "name": "proof_of__MutexDelete_which_implies_wit_1_split_goal_1",
        "parent": "proof_of__MutexDelete_which_implies_wit_1",
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_1_split_goal_1 : _MutexDelete_which_implies_wit_1_split_goal_1.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_1": {
        "name": "proof_of__MutexDelete_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_1 : _MutexDelete_which_implies_wit_1.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_2_split_goal_1": {
        "name": "proof_of__MutexDelete_which_implies_wit_2_split_goal_1",
        "parent": "proof_of__MutexDelete_which_implies_wit_2",
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_2_split_goal_1 : _MutexDelete_which_implies_wit_2_split_goal_1.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_2": {
        "name": "proof_of__MutexDelete_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_2 : _MutexDelete_which_implies_wit_2.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_3": {
        "name": "proof_of__MutexDelete_which_implies_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_3 : _MutexDelete_which_implies_wit_3.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_4_split_goal_spatial": {
        "name": "proof_of__MutexDelete_which_implies_wit_4_split_goal_spatial",
        "parent": "proof_of__MutexDelete_which_implies_wit_4",
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_4_split_goal_spatial : _MutexDelete_which_implies_wit_4_split_goal_spatial.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_4": {
        "name": "proof_of__MutexDelete_which_implies_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_4 : _MutexDelete_which_implies_wit_4.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_5_split_goal_spatial": {
        "name": "proof_of__MutexDelete_which_implies_wit_5_split_goal_spatial",
        "parent": "proof_of__MutexDelete_which_implies_wit_5",
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_5_split_goal_spatial : _MutexDelete_which_implies_wit_5_split_goal_spatial.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_5": {
        "name": "proof_of__MutexDelete_which_implies_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_5 : _MutexDelete_which_implies_wit_5.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_6_split_goal_1": {
        "name": "proof_of__MutexDelete_which_implies_wit_6_split_goal_1",
        "parent": "proof_of__MutexDelete_which_implies_wit_6",
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_6_split_goal_1 : _MutexDelete_which_implies_wit_6_split_goal_1.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_6_split_goal_spatial": {
        "name": "proof_of__MutexDelete_which_implies_wit_6_split_goal_spatial",
        "parent": "proof_of__MutexDelete_which_implies_wit_6",
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_6_split_goal_spatial : _MutexDelete_which_implies_wit_6_split_goal_spatial.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_6": {
        "name": "proof_of__MutexDelete_which_implies_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_6 : _MutexDelete_which_implies_wit_6.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_7_split_goal_spatial": {
        "name": "proof_of__MutexDelete_which_implies_wit_7_split_goal_spatial",
        "parent": "proof_of__MutexDelete_which_implies_wit_7",
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_7_split_goal_spatial : _MutexDelete_which_implies_wit_7_split_goal_spatial.\n"
      },
      "proof_of__MutexDelete_which_implies_wit_7": {
        "name": "proof_of__MutexDelete_which_implies_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__MutexDelete_which_implies_wit_7 : _MutexDelete_which_implies_wit_7.\n"
      }
    },
    "top_level": [
      "proof_of__MutexDelete_safety_wit_1",
      "proof_of__MutexDelete_safety_wit_2",
      "proof_of__MutexDelete_safety_wit_3",
      "proof_of__MutexDelete_entail_wit_1",
      "proof_of__MutexDelete_entail_wit_2",
      "proof_of__MutexDelete_return_wit_1",
      "proof_of__MutexDelete_partial_solve_wit_1_pure",
      "proof_of__MutexDelete_partial_solve_wit_1",
      "proof_of__MutexDelete_partial_solve_wit_2",
      "proof_of__MutexDelete_partial_solve_wit_3_pure",
      "proof_of__MutexDelete_partial_solve_wit_3",
      "proof_of__MutexDelete_partial_solve_wit_4_pure",
      "proof_of__MutexDelete_partial_solve_wit_4",
      "proof_of__MutexDelete_partial_solve_wit_5_pure",
      "proof_of__MutexDelete_partial_solve_wit_5",
      "proof_of__MutexDelete_partial_solve_wit_6",
      "proof_of__MutexDelete_partial_solve_wit_7",
      "proof_of__MutexDelete_partial_solve_wit_8",
      "proof_of__MutexDelete_partial_solve_wit_9_pure",
      "proof_of__MutexDelete_partial_solve_wit_9",
      "proof_of__MutexDelete_partial_solve_wit_10_pure",
      "proof_of__MutexDelete_partial_solve_wit_10",
      "proof_of__MutexDelete_partial_solve_wit_11",
      "proof_of__MutexDelete_partial_solve_wit_12",
      "proof_of__MutexDelete_partial_solve_wit_13_pure",
      "proof_of__MutexDelete_partial_solve_wit_13",
      "proof_of__MutexDelete_partial_solve_wit_14",
      "proof_of__MutexDelete_partial_solve_wit_15",
      "proof_of__MutexDelete_entail_wit_3_1",
      "proof_of__MutexDelete_entail_wit_3_2",
      "proof_of__MutexDelete_partial_solve_wit_2_pure",
      "proof_of__MutexDelete_partial_solve_wit_8_pure",
      "proof_of__MutexDelete_which_implies_wit_1",
      "proof_of__MutexDelete_which_implies_wit_2",
      "proof_of__MutexDelete_which_implies_wit_3",
      "proof_of__MutexDelete_which_implies_wit_4",
      "proof_of__MutexDelete_which_implies_wit_5",
      "proof_of__MutexDelete_which_implies_wit_6",
      "proof_of__MutexDelete_which_implies_wit_7"
    ],
    "split_goals": {
      "proof_of__MutexDelete_safety_wit_1": [],
      "proof_of__MutexDelete_safety_wit_2": [],
      "proof_of__MutexDelete_safety_wit_3": [],
      "proof_of__MutexDelete_entail_wit_1": [],
      "proof_of__MutexDelete_entail_wit_2": [],
      "proof_of__MutexDelete_return_wit_1": [],
      "proof_of__MutexDelete_partial_solve_wit_1_pure": [],
      "proof_of__MutexDelete_partial_solve_wit_1": [],
      "proof_of__MutexDelete_partial_solve_wit_2": [],
      "proof_of__MutexDelete_partial_solve_wit_3_pure": [],
      "proof_of__MutexDelete_partial_solve_wit_3": [],
      "proof_of__MutexDelete_partial_solve_wit_4_pure": [],
      "proof_of__MutexDelete_partial_solve_wit_4": [],
      "proof_of__MutexDelete_partial_solve_wit_5_pure": [],
      "proof_of__MutexDelete_partial_solve_wit_5": [],
      "proof_of__MutexDelete_partial_solve_wit_6": [],
      "proof_of__MutexDelete_partial_solve_wit_7": [],
      "proof_of__MutexDelete_partial_solve_wit_8": [],
      "proof_of__MutexDelete_partial_solve_wit_9_pure": [],
      "proof_of__MutexDelete_partial_solve_wit_9": [],
      "proof_of__MutexDelete_partial_solve_wit_10_pure": [],
      "proof_of__MutexDelete_partial_solve_wit_10": [],
      "proof_of__MutexDelete_partial_solve_wit_11": [],
      "proof_of__MutexDelete_partial_solve_wit_12": [],
      "proof_of__MutexDelete_partial_solve_wit_13_pure": [],
      "proof_of__MutexDelete_partial_solve_wit_13": [],
      "proof_of__MutexDelete_partial_solve_wit_14": [],
      "proof_of__MutexDelete_partial_solve_wit_15": [],
      "proof_of__MutexDelete_entail_wit_3_1": [
        "proof_of__MutexDelete_entail_wit_3_1_split_goal_1",
        "proof_of__MutexDelete_entail_wit_3_1_split_goal_2",
        "proof_of__MutexDelete_entail_wit_3_1_split_goal_spatial"
      ],
      "proof_of__MutexDelete_entail_wit_3_2": [
        "proof_of__MutexDelete_entail_wit_3_2_split_goal_1",
        "proof_of__MutexDelete_entail_wit_3_2_split_goal_2",
        "proof_of__MutexDelete_entail_wit_3_2_split_goal_spatial"
      ],
      "proof_of__MutexDelete_partial_solve_wit_2_pure": [
        "proof_of__MutexDelete_partial_solve_wit_2_pure_split_goal_1"
      ],
      "proof_of__MutexDelete_partial_solve_wit_8_pure": [
        "proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_1",
        "proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_2",
        "proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_3"
      ],
      "proof_of__MutexDelete_which_implies_wit_1": [
        "proof_of__MutexDelete_which_implies_wit_1_split_goal_1"
      ],
      "proof_of__MutexDelete_which_implies_wit_2": [
        "proof_of__MutexDelete_which_implies_wit_2_split_goal_1"
      ],
      "proof_of__MutexDelete_which_implies_wit_3": [],
      "proof_of__MutexDelete_which_implies_wit_4": [
        "proof_of__MutexDelete_which_implies_wit_4_split_goal_spatial"
      ],
      "proof_of__MutexDelete_which_implies_wit_5": [
        "proof_of__MutexDelete_which_implies_wit_5_split_goal_spatial"
      ],
      "proof_of__MutexDelete_which_implies_wit_6": [
        "proof_of__MutexDelete_which_implies_wit_6_split_goal_1",
        "proof_of__MutexDelete_which_implies_wit_6_split_goal_spatial"
      ],
      "proof_of__MutexDelete_which_implies_wit_7": [
        "proof_of__MutexDelete_which_implies_wit_7_split_goal_spatial"
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
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-debug",
      "--run",
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
