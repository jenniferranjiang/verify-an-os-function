# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "SemaphoreCreate-vc-checking-r1",
  "round": "SemaphoreCreate-vc-checking-r1",
  "main_root": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
  "target_files": {
    "c_file": "annotated_C/src/_SemaphoreCreate.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/SemaphoreCreate_lib.v",
    "goal_file": "VC/SemaphoreCreate_goal.v",
    "proof_auto_file": "VC/SemaphoreCreate_proof_auto.v",
    "proof_manual_file": "VC/SemaphoreCreate_proof_manual.v",
    "goal_check_file": "VC/SemaphoreCreate_goal_check.v",
    "case_name": "SemaphoreCreate",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/SemaphoreCreate-20261022181446/rounds/SemaphoreCreate-vc-checking-r1/SemaphoreCreate_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of__SemaphoreCreate_entail_wit_1_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_1_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_entail_wit_1",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_1 : _SemaphoreCreate_entail_wit_1_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_1_split_goal_2": {
        "name": "proof_of__SemaphoreCreate_entail_wit_1_split_goal_2",
        "parent": "proof_of__SemaphoreCreate_entail_wit_1",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_2 : _SemaphoreCreate_entail_wit_1_split_goal_2.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_entail_wit_2",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_1 : _SemaphoreCreate_entail_wit_2_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2_split_goal_2": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2_split_goal_2",
        "parent": "proof_of__SemaphoreCreate_entail_wit_2",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_2 : _SemaphoreCreate_entail_wit_2_split_goal_2.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2_split_goal_3": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2_split_goal_3",
        "parent": "proof_of__SemaphoreCreate_entail_wit_2",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_3 : _SemaphoreCreate_entail_wit_2_split_goal_3.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial",
        "parent": "proof_of__SemaphoreCreate_entail_wit_2",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial : _SemaphoreCreate_entail_wit_2_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2 : _SemaphoreCreate_entail_wit_2.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_3_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_3_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_entail_wit_3",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_1 : _SemaphoreCreate_entail_wit_3_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_3_split_goal_2": {
        "name": "proof_of__SemaphoreCreate_entail_wit_3_split_goal_2",
        "parent": "proof_of__SemaphoreCreate_entail_wit_3",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_2 : _SemaphoreCreate_entail_wit_3_split_goal_2.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_3_split_goal_3": {
        "name": "proof_of__SemaphoreCreate_entail_wit_3_split_goal_3",
        "parent": "proof_of__SemaphoreCreate_entail_wit_3",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_3 : _SemaphoreCreate_entail_wit_3_split_goal_3.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial": {
        "name": "proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial",
        "parent": "proof_of__SemaphoreCreate_entail_wit_3",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial : _SemaphoreCreate_entail_wit_3_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_3": {
        "name": "proof_of__SemaphoreCreate_entail_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_entail_wit_4_1",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_1 : _SemaphoreCreate_entail_wit_4_1_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_spatial": {
        "name": "proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_spatial",
        "parent": "proof_of__SemaphoreCreate_entail_wit_4_1",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_spatial : _SemaphoreCreate_entail_wit_4_1_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_4_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_4_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_4_1 : _SemaphoreCreate_entail_wit_4_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_entail_wit_4_2",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_1 : _SemaphoreCreate_entail_wit_4_2_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_2": {
        "name": "proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_2",
        "parent": "proof_of__SemaphoreCreate_entail_wit_4_2",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_2 : _SemaphoreCreate_entail_wit_4_2_split_goal_2.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_spatial": {
        "name": "proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_spatial",
        "parent": "proof_of__SemaphoreCreate_entail_wit_4_2",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_spatial : _SemaphoreCreate_entail_wit_4_2_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_4_2": {
        "name": "proof_of__SemaphoreCreate_entail_wit_4_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_4_2 : _SemaphoreCreate_entail_wit_4_2.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_5": {
        "name": "proof_of__SemaphoreCreate_entail_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_5 : _SemaphoreCreate_entail_wit_5.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial": {
        "name": "proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial",
        "parent": "proof_of__SemaphoreCreate_entail_wit_6",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial : _SemaphoreCreate_entail_wit_6_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_6": {
        "name": "proof_of__SemaphoreCreate_entail_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_6 : _SemaphoreCreate_entail_wit_6.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_7_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_7_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_entail_wit_7",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_7_split_goal_1 : _SemaphoreCreate_entail_wit_7_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial": {
        "name": "proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial",
        "parent": "proof_of__SemaphoreCreate_entail_wit_7",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial : _SemaphoreCreate_entail_wit_7_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_7": {
        "name": "proof_of__SemaphoreCreate_entail_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_7 : _SemaphoreCreate_entail_wit_7.\n"
      },
      "proof_of__SemaphoreCreate_return_wit_1_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_return_wit_1_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_return_wit_1",
        "statement": "Lemma proof_of__SemaphoreCreate_return_wit_1_split_goal_1 : _SemaphoreCreate_return_wit_1_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_return_wit_1": {
        "name": "proof_of__SemaphoreCreate_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.\n"
      },
      "proof_of__SemaphoreCreate_return_wit_2_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_return_wit_2_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_return_wit_2",
        "statement": "Lemma proof_of__SemaphoreCreate_return_wit_2_split_goal_1 : _SemaphoreCreate_return_wit_2_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_return_wit_2": {
        "name": "proof_of__SemaphoreCreate_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.\n"
      },
      "proof_of__SemaphoreCreate_return_wit_3_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_return_wit_3_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_return_wit_3",
        "statement": "Lemma proof_of__SemaphoreCreate_return_wit_3_split_goal_1 : _SemaphoreCreate_return_wit_3_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_return_wit_3": {
        "name": "proof_of__SemaphoreCreate_return_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_partial_solve_wit_6_pure",
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_6_pure": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_6_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_partial_solve_wit_8_pure",
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_8_pure": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_8_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_8_pure : _SemaphoreCreate_partial_solve_wit_8_pure.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_1": {
        "name": "proof_of__SemaphoreCreate_safety_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_1 : _SemaphoreCreate_safety_wit_1.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_2": {
        "name": "proof_of__SemaphoreCreate_safety_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_2 : _SemaphoreCreate_safety_wit_2.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_3": {
        "name": "proof_of__SemaphoreCreate_safety_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_3 : _SemaphoreCreate_safety_wit_3.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_4": {
        "name": "proof_of__SemaphoreCreate_safety_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_4 : _SemaphoreCreate_safety_wit_4.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_5": {
        "name": "proof_of__SemaphoreCreate_safety_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_5 : _SemaphoreCreate_safety_wit_5.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_6": {
        "name": "proof_of__SemaphoreCreate_safety_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_6 : _SemaphoreCreate_safety_wit_6.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_7": {
        "name": "proof_of__SemaphoreCreate_safety_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_7 : _SemaphoreCreate_safety_wit_7.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_8": {
        "name": "proof_of__SemaphoreCreate_safety_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_8 : _SemaphoreCreate_safety_wit_8.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_9": {
        "name": "proof_of__SemaphoreCreate_safety_wit_9",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_9 : _SemaphoreCreate_safety_wit_9.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_10": {
        "name": "proof_of__SemaphoreCreate_safety_wit_10",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_10 : _SemaphoreCreate_safety_wit_10.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_11": {
        "name": "proof_of__SemaphoreCreate_safety_wit_11",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_11 : _SemaphoreCreate_safety_wit_11.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_12": {
        "name": "proof_of__SemaphoreCreate_safety_wit_12",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_12 : _SemaphoreCreate_safety_wit_12.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_13": {
        "name": "proof_of__SemaphoreCreate_safety_wit_13",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_13 : _SemaphoreCreate_safety_wit_13.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_14": {
        "name": "proof_of__SemaphoreCreate_safety_wit_14",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_14 : _SemaphoreCreate_safety_wit_14.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_15": {
        "name": "proof_of__SemaphoreCreate_safety_wit_15",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_15 : _SemaphoreCreate_safety_wit_15.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_16": {
        "name": "proof_of__SemaphoreCreate_safety_wit_16",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_16 : _SemaphoreCreate_safety_wit_16.\n"
      },
      "proof_of__SemaphoreCreate_safety_wit_17": {
        "name": "proof_of__SemaphoreCreate_safety_wit_17",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_safety_wit_17 : _SemaphoreCreate_safety_wit_17.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_1_pure": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_1_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_1_pure : _SemaphoreCreate_partial_solve_wit_1_pure.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_1": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_2_pure": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_2_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_2": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_3": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_4": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_5": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_6": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_7": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_8": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_8 : _SemaphoreCreate_partial_solve_wit_8.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_9_pure": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_9_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_9_pure : _SemaphoreCreate_partial_solve_wit_9_pure.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_9": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_9",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_9 : _SemaphoreCreate_partial_solve_wit_9.\n"
      }
    },
    "top_level": [
      "proof_of__SemaphoreCreate_entail_wit_1",
      "proof_of__SemaphoreCreate_entail_wit_2",
      "proof_of__SemaphoreCreate_entail_wit_3",
      "proof_of__SemaphoreCreate_entail_wit_4_1",
      "proof_of__SemaphoreCreate_entail_wit_4_2",
      "proof_of__SemaphoreCreate_entail_wit_5",
      "proof_of__SemaphoreCreate_entail_wit_6",
      "proof_of__SemaphoreCreate_entail_wit_7",
      "proof_of__SemaphoreCreate_return_wit_1",
      "proof_of__SemaphoreCreate_return_wit_2",
      "proof_of__SemaphoreCreate_return_wit_3",
      "proof_of__SemaphoreCreate_partial_solve_wit_6_pure",
      "proof_of__SemaphoreCreate_partial_solve_wit_8_pure",
      "proof_of__SemaphoreCreate_safety_wit_1",
      "proof_of__SemaphoreCreate_safety_wit_2",
      "proof_of__SemaphoreCreate_safety_wit_3",
      "proof_of__SemaphoreCreate_safety_wit_4",
      "proof_of__SemaphoreCreate_safety_wit_5",
      "proof_of__SemaphoreCreate_safety_wit_6",
      "proof_of__SemaphoreCreate_safety_wit_7",
      "proof_of__SemaphoreCreate_safety_wit_8",
      "proof_of__SemaphoreCreate_safety_wit_9",
      "proof_of__SemaphoreCreate_safety_wit_10",
      "proof_of__SemaphoreCreate_safety_wit_11",
      "proof_of__SemaphoreCreate_safety_wit_12",
      "proof_of__SemaphoreCreate_safety_wit_13",
      "proof_of__SemaphoreCreate_safety_wit_14",
      "proof_of__SemaphoreCreate_safety_wit_15",
      "proof_of__SemaphoreCreate_safety_wit_16",
      "proof_of__SemaphoreCreate_safety_wit_17",
      "proof_of__SemaphoreCreate_partial_solve_wit_1_pure",
      "proof_of__SemaphoreCreate_partial_solve_wit_1",
      "proof_of__SemaphoreCreate_partial_solve_wit_2_pure",
      "proof_of__SemaphoreCreate_partial_solve_wit_2",
      "proof_of__SemaphoreCreate_partial_solve_wit_3",
      "proof_of__SemaphoreCreate_partial_solve_wit_4",
      "proof_of__SemaphoreCreate_partial_solve_wit_5",
      "proof_of__SemaphoreCreate_partial_solve_wit_6",
      "proof_of__SemaphoreCreate_partial_solve_wit_7",
      "proof_of__SemaphoreCreate_partial_solve_wit_8",
      "proof_of__SemaphoreCreate_partial_solve_wit_9_pure",
      "proof_of__SemaphoreCreate_partial_solve_wit_9"
    ],
    "split_goals": {
      "proof_of__SemaphoreCreate_entail_wit_1": [
        "proof_of__SemaphoreCreate_entail_wit_1_split_goal_1",
        "proof_of__SemaphoreCreate_entail_wit_1_split_goal_2"
      ],
      "proof_of__SemaphoreCreate_entail_wit_2": [
        "proof_of__SemaphoreCreate_entail_wit_2_split_goal_1",
        "proof_of__SemaphoreCreate_entail_wit_2_split_goal_2",
        "proof_of__SemaphoreCreate_entail_wit_2_split_goal_3",
        "proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial"
      ],
      "proof_of__SemaphoreCreate_entail_wit_3": [
        "proof_of__SemaphoreCreate_entail_wit_3_split_goal_1",
        "proof_of__SemaphoreCreate_entail_wit_3_split_goal_2",
        "proof_of__SemaphoreCreate_entail_wit_3_split_goal_3",
        "proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial"
      ],
      "proof_of__SemaphoreCreate_entail_wit_4_1": [
        "proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_1",
        "proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_spatial"
      ],
      "proof_of__SemaphoreCreate_entail_wit_4_2": [
        "proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_1",
        "proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_2",
        "proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_spatial"
      ],
      "proof_of__SemaphoreCreate_entail_wit_5": [],
      "proof_of__SemaphoreCreate_entail_wit_6": [
        "proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial"
      ],
      "proof_of__SemaphoreCreate_entail_wit_7": [
        "proof_of__SemaphoreCreate_entail_wit_7_split_goal_1",
        "proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial"
      ],
      "proof_of__SemaphoreCreate_return_wit_1": [
        "proof_of__SemaphoreCreate_return_wit_1_split_goal_1"
      ],
      "proof_of__SemaphoreCreate_return_wit_2": [
        "proof_of__SemaphoreCreate_return_wit_2_split_goal_1"
      ],
      "proof_of__SemaphoreCreate_return_wit_3": [
        "proof_of__SemaphoreCreate_return_wit_3_split_goal_1"
      ],
      "proof_of__SemaphoreCreate_partial_solve_wit_6_pure": [
        "proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1"
      ],
      "proof_of__SemaphoreCreate_partial_solve_wit_8_pure": [
        "proof_of__SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1"
      ],
      "proof_of__SemaphoreCreate_safety_wit_1": [],
      "proof_of__SemaphoreCreate_safety_wit_2": [],
      "proof_of__SemaphoreCreate_safety_wit_3": [],
      "proof_of__SemaphoreCreate_safety_wit_4": [],
      "proof_of__SemaphoreCreate_safety_wit_5": [],
      "proof_of__SemaphoreCreate_safety_wit_6": [],
      "proof_of__SemaphoreCreate_safety_wit_7": [],
      "proof_of__SemaphoreCreate_safety_wit_8": [],
      "proof_of__SemaphoreCreate_safety_wit_9": [],
      "proof_of__SemaphoreCreate_safety_wit_10": [],
      "proof_of__SemaphoreCreate_safety_wit_11": [],
      "proof_of__SemaphoreCreate_safety_wit_12": [],
      "proof_of__SemaphoreCreate_safety_wit_13": [],
      "proof_of__SemaphoreCreate_safety_wit_14": [],
      "proof_of__SemaphoreCreate_safety_wit_15": [],
      "proof_of__SemaphoreCreate_safety_wit_16": [],
      "proof_of__SemaphoreCreate_safety_wit_17": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_1_pure": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_1": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_2_pure": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_2": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_3": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_4": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_5": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_6": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_7": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_8": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_9_pure": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_9": []
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
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-debug",
      "--run",
      "SemaphoreCreate-20261022181446",
      "--round",
      "SemaphoreCreate-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
