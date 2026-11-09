# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "EventLinklistResumeAll-vc-checking-r2",
  "round": "EventLinklistResumeAll-vc-checking-r2",
  "main_root": "/home/xinra/crtos/keventdelete-trial-261103-1",
  "target_files": {
    "c_file": "annotated_C/src/LinklistResumeAll.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/EventLinklistResumeAll_lib.v",
    "goal_file": "VC/EventLinklistResumeAll_goal.v",
    "proof_auto_file": "VC/EventLinklistResumeAll_proof_auto.v",
    "proof_manual_file": "VC/EventLinklistResumeAll_proof_manual.v",
    "goal_check_file": "VC/EventLinklistResumeAll_goal_check.v",
    "case_name": "EventLinklistResumeAll",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-checking-r2/agent_report.json",
  "notes": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-checking-r2/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-checking-r2/group_plan.json",
  "debug_manual": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-checking-r2/EventLinklistResumeAll_proof_manual.v",
  "obligations": {
    "by_name": {
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
      "proof_of_LinklistResumeAll_safety_wit_10": {
        "name": "proof_of_LinklistResumeAll_safety_wit_10",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_safety_wit_10 : LinklistResumeAll_safety_wit_10.\n"
      },
      "proof_of_LinklistResumeAll_safety_wit_11": {
        "name": "proof_of_LinklistResumeAll_safety_wit_11",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_safety_wit_11 : LinklistResumeAll_safety_wit_11.\n"
      },
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
      "proof_of_LinklistResumeAll_return_wit_1": {
        "name": "proof_of_LinklistResumeAll_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_return_wit_1 : LinklistResumeAll_return_wit_1.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_1_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_1_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_1_pure : LinklistResumeAll_partial_solve_wit_1_pure.\n"
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
      "proof_of_LinklistResumeAll_partial_solve_wit_3_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_3_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_3_pure : LinklistResumeAll_partial_solve_wit_3_pure.\n"
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
      "proof_of_LinklistResumeAll_partial_solve_wit_8_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_8_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_8_pure : LinklistResumeAll_partial_solve_wit_8_pure.\n"
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
      "proof_of_LinklistResumeAll_partial_solve_wit_10": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_10",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_10 : LinklistResumeAll_partial_solve_wit_10.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_11_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_11_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_11_pure : LinklistResumeAll_partial_solve_wit_11_pure.\n"
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
      "proof_of_LinklistResumeAll_partial_solve_wit_13": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_13",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_14_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_14_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_14_pure : LinklistResumeAll_partial_solve_wit_14_pure.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_14": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_14",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_14 : LinklistResumeAll_partial_solve_wit_14.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_15_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_15_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_15_pure : LinklistResumeAll_partial_solve_wit_15_pure.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_15": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_15",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_15 : LinklistResumeAll_partial_solve_wit_15.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_16_pure": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_16_pure",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_16_pure : LinklistResumeAll_partial_solve_wit_16_pure.\n"
      },
      "proof_of_LinklistResumeAll_partial_solve_wit_16": {
        "name": "proof_of_LinklistResumeAll_partial_solve_wit_16",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_partial_solve_wit_16 : LinklistResumeAll_partial_solve_wit_16.\n"
      },
      "proof_of_LinklistResumeAll_entail_wit_3": {
        "name": "proof_of_LinklistResumeAll_entail_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_entail_wit_3 : LinklistResumeAll_entail_wit_3.\n"
      },
      "proof_of_LinklistResumeAll_entail_wit_4_1": {
        "name": "proof_of_LinklistResumeAll_entail_wit_4_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_entail_wit_4_1 : LinklistResumeAll_entail_wit_4_1.\n"
      },
      "proof_of_LinklistResumeAll_entail_wit_4_2": {
        "name": "proof_of_LinklistResumeAll_entail_wit_4_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_entail_wit_4_2 : LinklistResumeAll_entail_wit_4_2.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_1": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_1 : LinklistResumeAll_which_implies_wit_1.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_2": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_2 : LinklistResumeAll_which_implies_wit_2.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial",
        "parent": "proof_of_LinklistResumeAll_which_implies_wit_3",
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial : LinklistResumeAll_which_implies_wit_3_split_goal_spatial.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_3": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_3 : LinklistResumeAll_which_implies_wit_3.\n"
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
      "proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial",
        "parent": "proof_of_LinklistResumeAll_which_implies_wit_6",
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial : LinklistResumeAll_which_implies_wit_6_split_goal_spatial.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_6": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_6 : LinklistResumeAll_which_implies_wit_6.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_7": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_7 : LinklistResumeAll_which_implies_wit_7.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial",
        "parent": "proof_of_LinklistResumeAll_which_implies_wit_8",
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial : LinklistResumeAll_which_implies_wit_8_split_goal_spatial.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_8": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_8",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_8 : LinklistResumeAll_which_implies_wit_8.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1",
        "parent": "proof_of_LinklistResumeAll_which_implies_wit_9",
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1 : LinklistResumeAll_which_implies_wit_9_split_goal_1.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2",
        "parent": "proof_of_LinklistResumeAll_which_implies_wit_9",
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2 : LinklistResumeAll_which_implies_wit_9_split_goal_2.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3",
        "parent": "proof_of_LinklistResumeAll_which_implies_wit_9",
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3 : LinklistResumeAll_which_implies_wit_9_split_goal_3.\n"
      },
      "proof_of_LinklistResumeAll_which_implies_wit_9": {
        "name": "proof_of_LinklistResumeAll_which_implies_wit_9",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResumeAll_which_implies_wit_9 : LinklistResumeAll_which_implies_wit_9.\n"
      },
      "proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic": {
        "name": "proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic",
        "parent": null,
        "statement": "Lemma proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic : KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic.\n"
      },
      "proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic": {
        "name": "proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic",
        "parent": null,
        "statement": "Lemma proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic : KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic.\n"
      }
    },
    "top_level": [
      "proof_of_LinklistResumeAll_safety_wit_1",
      "proof_of_LinklistResumeAll_safety_wit_2",
      "proof_of_LinklistResumeAll_safety_wit_3",
      "proof_of_LinklistResumeAll_safety_wit_4",
      "proof_of_LinklistResumeAll_safety_wit_5",
      "proof_of_LinklistResumeAll_safety_wit_6",
      "proof_of_LinklistResumeAll_safety_wit_7",
      "proof_of_LinklistResumeAll_safety_wit_8",
      "proof_of_LinklistResumeAll_safety_wit_9",
      "proof_of_LinklistResumeAll_safety_wit_10",
      "proof_of_LinklistResumeAll_safety_wit_11",
      "proof_of_LinklistResumeAll_entail_wit_1",
      "proof_of_LinklistResumeAll_entail_wit_2",
      "proof_of_LinklistResumeAll_return_wit_1",
      "proof_of_LinklistResumeAll_partial_solve_wit_1_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_1",
      "proof_of_LinklistResumeAll_partial_solve_wit_2_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_2",
      "proof_of_LinklistResumeAll_partial_solve_wit_3_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_3",
      "proof_of_LinklistResumeAll_partial_solve_wit_4",
      "proof_of_LinklistResumeAll_partial_solve_wit_5",
      "proof_of_LinklistResumeAll_partial_solve_wit_6_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_6",
      "proof_of_LinklistResumeAll_partial_solve_wit_7_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_7",
      "proof_of_LinklistResumeAll_partial_solve_wit_8_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_8",
      "proof_of_LinklistResumeAll_partial_solve_wit_9",
      "proof_of_LinklistResumeAll_partial_solve_wit_10",
      "proof_of_LinklistResumeAll_partial_solve_wit_11_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_11",
      "proof_of_LinklistResumeAll_partial_solve_wit_12",
      "proof_of_LinklistResumeAll_partial_solve_wit_13",
      "proof_of_LinklistResumeAll_partial_solve_wit_14_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_14",
      "proof_of_LinklistResumeAll_partial_solve_wit_15_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_15",
      "proof_of_LinklistResumeAll_partial_solve_wit_16_pure",
      "proof_of_LinklistResumeAll_partial_solve_wit_16",
      "proof_of_LinklistResumeAll_entail_wit_3",
      "proof_of_LinklistResumeAll_entail_wit_4_1",
      "proof_of_LinklistResumeAll_entail_wit_4_2",
      "proof_of_LinklistResumeAll_which_implies_wit_1",
      "proof_of_LinklistResumeAll_which_implies_wit_2",
      "proof_of_LinklistResumeAll_which_implies_wit_3",
      "proof_of_LinklistResumeAll_which_implies_wit_4",
      "proof_of_LinklistResumeAll_which_implies_wit_5",
      "proof_of_LinklistResumeAll_which_implies_wit_6",
      "proof_of_LinklistResumeAll_which_implies_wit_7",
      "proof_of_LinklistResumeAll_which_implies_wit_8",
      "proof_of_LinklistResumeAll_which_implies_wit_9",
      "proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic",
      "proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic"
    ],
    "split_goals": {
      "proof_of_LinklistResumeAll_safety_wit_1": [],
      "proof_of_LinklistResumeAll_safety_wit_2": [],
      "proof_of_LinklistResumeAll_safety_wit_3": [],
      "proof_of_LinklistResumeAll_safety_wit_4": [],
      "proof_of_LinklistResumeAll_safety_wit_5": [],
      "proof_of_LinklistResumeAll_safety_wit_6": [],
      "proof_of_LinklistResumeAll_safety_wit_7": [],
      "proof_of_LinklistResumeAll_safety_wit_8": [],
      "proof_of_LinklistResumeAll_safety_wit_9": [],
      "proof_of_LinklistResumeAll_safety_wit_10": [],
      "proof_of_LinklistResumeAll_safety_wit_11": [],
      "proof_of_LinklistResumeAll_entail_wit_1": [],
      "proof_of_LinklistResumeAll_entail_wit_2": [],
      "proof_of_LinklistResumeAll_return_wit_1": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_1_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_1": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_2_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_2": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_3_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_3": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_4": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_5": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_6_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_6": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_7_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_7": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_8_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_8": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_9": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_10": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_11_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_11": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_12": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_13": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_14_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_14": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_15_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_15": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_16_pure": [],
      "proof_of_LinklistResumeAll_partial_solve_wit_16": [],
      "proof_of_LinklistResumeAll_entail_wit_3": [],
      "proof_of_LinklistResumeAll_entail_wit_4_1": [],
      "proof_of_LinklistResumeAll_entail_wit_4_2": [],
      "proof_of_LinklistResumeAll_which_implies_wit_1": [],
      "proof_of_LinklistResumeAll_which_implies_wit_2": [],
      "proof_of_LinklistResumeAll_which_implies_wit_3": [
        "proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial"
      ],
      "proof_of_LinklistResumeAll_which_implies_wit_4": [],
      "proof_of_LinklistResumeAll_which_implies_wit_5": [
        "proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial"
      ],
      "proof_of_LinklistResumeAll_which_implies_wit_6": [
        "proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial"
      ],
      "proof_of_LinklistResumeAll_which_implies_wit_7": [],
      "proof_of_LinklistResumeAll_which_implies_wit_8": [
        "proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial"
      ],
      "proof_of_LinklistResumeAll_which_implies_wit_9": [
        "proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1",
        "proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2",
        "proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3"
      ],
      "proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic": [],
      "proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic": []
    }
  },
  "max_witnesses_per_group": 12,
  "annotation_comparisons": [
    {
      "source": {
        "attempt": "EventLinklistResumeAll-vc-checking-r1",
        "name": "proof_of_LinklistResumeAll_entail_wit_4_2",
        "annotation_location": "LinklistResumeAll: successful KTaskWakeup return / loop-invariant backedge"
      },
      "current": [
        "proof_of_LinklistResumeAll_entail_wit_4_2",
        "proof_of_LinklistResumeAll_which_implies_wit_4",
        "proof_of_LinklistResumeAll_which_implies_wit_7"
      ],
      "old_gap": "\u65e7os_inv\u88abWakeup\u6d88\u8d39\u540e\u53ea\u5269os_inv(after)\uff0c\u4e22\u5931\u65e7sched-owner\u4e92\u65a5\u4e8b\u5b9e\uff0c\u5141\u8bb8\u65e7task\u540c\u65f6\u6302Event\u548cSemaphore\u7684\u53cd\u4f8b\u3002",
      "change": "\u4ece\u65e2\u6709current os_inv\u5728which_implies_wit_4\u5bfc\u51faos_world_wf/task_world_wf\uff0c\u4ecemarked os_inv\u5728which_implies_wit_7\u540c\u6837\u5bfc\u51fa\u5e76\u4fdd\u7559\u7eaf\u4e8b\u5b9e\uff1b\u51bb\u7ed3\u51fd\u6570\u5408\u540c\u3001\u7eafstep\u53ca\u6574\u4f53effect\u5747\u4e0d\u6539\u3002",
      "result": "resolved"
    }
  ]
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
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-vc-checking-r2"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
