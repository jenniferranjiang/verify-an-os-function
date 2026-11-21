# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "SemaphoreObtainRuntime-vc-checking-r3",
  "round": "SemaphoreObtainRuntime-vc-checking-r3",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/semaphore/_SemaphoreObtain.c",
    "formal_directory": "VC/semaphore",
    "formal_case_lib": "VC/semaphore/SemaphoreObtainRuntime_lib.v",
    "goal_file": "VC/semaphore/SemaphoreObtainRuntime_goal.v",
    "proof_auto_file": "VC/semaphore/SemaphoreObtainRuntime_proof_auto.v",
    "proof_manual_file": "VC/semaphore/SemaphoreObtainRuntime_proof_manual.v",
    "goal_check_file": "VC/semaphore/SemaphoreObtainRuntime_goal_check.v",
    "case_name": "SemaphoreObtainRuntime",
    "active_case_theory": "CRTOS_Verify.VC.semaphore"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-checking-r3/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-checking-r3/agent_output.md",
  "feedback": null,
  "feedback_sources": [
    {
      "phase": "group",
      "attempt_id": "SemaphoreObtainRuntime-vc-proving-r1:task_prepare",
      "evidence": [
        "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_02__task_prepare/group_worker_report.json",
        "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_02__task_prepare/group_worker_output.md"
      ]
    },
    {
      "phase": "group",
      "attempt_id": "SemaphoreObtainRuntime-vc-proving-r1:delay_failure_restoration",
      "evidence": [
        "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_03__delay_failure_restoration/group_worker_report.json",
        "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-proving-r1/groups/group_03__delay_failure_restoration/group_worker_output.md"
      ]
    }
  ],
  "previous_attempt": "SemaphoreObtainRuntime-vc-proving-r1",
  "group_plan": "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-checking-r3/group_plan.json",
  "debug_manual": "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-checking-r3/SemaphoreObtainRuntime_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_1_1",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1 : _SemaphoreObtain_entail_wit_1_1_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2",
        "parent": "proof_of__SemaphoreObtain_entail_wit_1_1",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2 : _SemaphoreObtain_entail_wit_1_1_split_goal_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_1_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_1_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_1_1 : _SemaphoreObtain_entail_wit_1_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_1_2",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1 : _SemaphoreObtain_entail_wit_1_2_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2",
        "parent": "proof_of__SemaphoreObtain_entail_wit_1_2",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2 : _SemaphoreObtain_entail_wit_1_2_split_goal_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_1_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_1_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_1_2 : _SemaphoreObtain_entail_wit_1_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_1_3",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1 : _SemaphoreObtain_entail_wit_1_3_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2",
        "parent": "proof_of__SemaphoreObtain_entail_wit_1_3",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2 : _SemaphoreObtain_entail_wit_1_3_split_goal_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3": {
        "name": "proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3",
        "parent": "proof_of__SemaphoreObtain_entail_wit_1_3",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3 : _SemaphoreObtain_entail_wit_1_3_split_goal_3.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_1_3": {
        "name": "proof_of__SemaphoreObtain_entail_wit_1_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_1_3 : _SemaphoreObtain_entail_wit_1_3.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_3_1",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_1 : _SemaphoreObtain_entail_wit_3_1_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2",
        "parent": "proof_of__SemaphoreObtain_entail_wit_3_1",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2 : _SemaphoreObtain_entail_wit_3_1_split_goal_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_entail_wit_3_1",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial : _SemaphoreObtain_entail_wit_3_1_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_3_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_3_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_3_1 : _SemaphoreObtain_entail_wit_3_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_3_2",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1 : _SemaphoreObtain_entail_wit_3_2_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2",
        "parent": "proof_of__SemaphoreObtain_entail_wit_3_2",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2 : _SemaphoreObtain_entail_wit_3_2_split_goal_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_entail_wit_3_2",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial : _SemaphoreObtain_entail_wit_3_2_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_3_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_3_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_3_2 : _SemaphoreObtain_entail_wit_3_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_4": {
        "name": "proof_of__SemaphoreObtain_entail_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_4 : _SemaphoreObtain_entail_wit_4.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_5_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_5_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_5",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_1 : _SemaphoreObtain_entail_wit_5_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_5_split_goal_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_5_split_goal_2",
        "parent": "proof_of__SemaphoreObtain_entail_wit_5",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_2 : _SemaphoreObtain_entail_wit_5_split_goal_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_entail_wit_5",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial : _SemaphoreObtain_entail_wit_5_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_5": {
        "name": "proof_of__SemaphoreObtain_entail_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_5 : _SemaphoreObtain_entail_wit_5.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_6_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_6_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_6",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_6_split_goal_1 : _SemaphoreObtain_entail_wit_6_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_6_split_goal_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_6_split_goal_2",
        "parent": "proof_of__SemaphoreObtain_entail_wit_6",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_6_split_goal_2 : _SemaphoreObtain_entail_wit_6_split_goal_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_6": {
        "name": "proof_of__SemaphoreObtain_entail_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_6 : _SemaphoreObtain_entail_wit_6.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_7_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_7_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_7",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_7_split_goal_1 : _SemaphoreObtain_entail_wit_7_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_7_split_goal_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_7_split_goal_2",
        "parent": "proof_of__SemaphoreObtain_entail_wit_7",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_7_split_goal_2 : _SemaphoreObtain_entail_wit_7_split_goal_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_7": {
        "name": "proof_of__SemaphoreObtain_entail_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_7 : _SemaphoreObtain_entail_wit_7.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_8": {
        "name": "proof_of__SemaphoreObtain_entail_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_8 : _SemaphoreObtain_entail_wit_8.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_9_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_9_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_9",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_1 : _SemaphoreObtain_entail_wit_9_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_9_split_goal_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_9_split_goal_2",
        "parent": "proof_of__SemaphoreObtain_entail_wit_9",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_2 : _SemaphoreObtain_entail_wit_9_split_goal_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_9_split_goal_3": {
        "name": "proof_of__SemaphoreObtain_entail_wit_9_split_goal_3",
        "parent": "proof_of__SemaphoreObtain_entail_wit_9",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_3 : _SemaphoreObtain_entail_wit_9_split_goal_3.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_entail_wit_9",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial : _SemaphoreObtain_entail_wit_9_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_9": {
        "name": "proof_of__SemaphoreObtain_entail_wit_9",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_9 : _SemaphoreObtain_entail_wit_9.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_10": {
        "name": "proof_of__SemaphoreObtain_entail_wit_10",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_10 : _SemaphoreObtain_entail_wit_10.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_11": {
        "name": "proof_of__SemaphoreObtain_entail_wit_11",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_11 : _SemaphoreObtain_entail_wit_11.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_12_1",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_1 : _SemaphoreObtain_entail_wit_12_1_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_entail_wit_12_1",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_spatial : _SemaphoreObtain_entail_wit_12_1_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_12_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_12_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_12_1 : _SemaphoreObtain_entail_wit_12_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_12_2",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_1 : _SemaphoreObtain_entail_wit_12_2_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_entail_wit_12_2",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_spatial : _SemaphoreObtain_entail_wit_12_2_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_12_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_12_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_12_2 : _SemaphoreObtain_entail_wit_12_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_13_1",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_1 : _SemaphoreObtain_entail_wit_13_1_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_2",
        "parent": "proof_of__SemaphoreObtain_entail_wit_13_1",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_2 : _SemaphoreObtain_entail_wit_13_1_split_goal_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_13_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_13_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_13_1 : _SemaphoreObtain_entail_wit_13_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_13_2",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_1 : _SemaphoreObtain_entail_wit_13_2_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_2",
        "parent": "proof_of__SemaphoreObtain_entail_wit_13_2",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_2 : _SemaphoreObtain_entail_wit_13_2_split_goal_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_13_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_13_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_13_2 : _SemaphoreObtain_entail_wit_13_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_14_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_14_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_14_1 : _SemaphoreObtain_entail_wit_14_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_14_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_14_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_14_2 : _SemaphoreObtain_entail_wit_14_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_14_3": {
        "name": "proof_of__SemaphoreObtain_entail_wit_14_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_14_3 : _SemaphoreObtain_entail_wit_14_3.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_15_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_15_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_15",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_15_split_goal_1 : _SemaphoreObtain_entail_wit_15_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_15": {
        "name": "proof_of__SemaphoreObtain_entail_wit_15",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_15 : _SemaphoreObtain_entail_wit_15.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_16": {
        "name": "proof_of__SemaphoreObtain_entail_wit_16",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_16 : _SemaphoreObtain_entail_wit_16.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_17_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_entail_wit_17_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_entail_wit_17",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_1 : _SemaphoreObtain_entail_wit_17_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_17_split_goal_2": {
        "name": "proof_of__SemaphoreObtain_entail_wit_17_split_goal_2",
        "parent": "proof_of__SemaphoreObtain_entail_wit_17",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_2 : _SemaphoreObtain_entail_wit_17_split_goal_2.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_entail_wit_17",
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial : _SemaphoreObtain_entail_wit_17_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_entail_wit_17": {
        "name": "proof_of__SemaphoreObtain_entail_wit_17",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_entail_wit_17 : _SemaphoreObtain_entail_wit_17.\n"
      },
      "proof_of__SemaphoreObtain_return_wit_6_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_return_wit_6_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_return_wit_6",
        "statement": "Lemma proof_of__SemaphoreObtain_return_wit_6_split_goal_1 : _SemaphoreObtain_return_wit_6_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_return_wit_6": {
        "name": "proof_of__SemaphoreObtain_return_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_return_wit_6 : _SemaphoreObtain_return_wit_6.\n"
      },
      "proof_of__SemaphoreObtain_return_wit_7_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_return_wit_7_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_return_wit_7",
        "statement": "Lemma proof_of__SemaphoreObtain_return_wit_7_split_goal_1 : _SemaphoreObtain_return_wit_7_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_return_wit_7": {
        "name": "proof_of__SemaphoreObtain_return_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_return_wit_7 : _SemaphoreObtain_return_wit_7.\n"
      },
      "proof_of__SemaphoreObtain_return_wit_8_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_return_wit_8_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_return_wit_8",
        "statement": "Lemma proof_of__SemaphoreObtain_return_wit_8_split_goal_1 : _SemaphoreObtain_return_wit_8_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_return_wit_8": {
        "name": "proof_of__SemaphoreObtain_return_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_return_wit_8 : _SemaphoreObtain_return_wit_8.\n"
      },
      "proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1": {
        "name": "proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1",
        "parent": "proof_of__SemaphoreObtain_partial_solve_wit_19_pure",
        "statement": "Lemma proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1 : _SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1.\n"
      },
      "proof_of__SemaphoreObtain_partial_solve_wit_19_pure": {
        "name": "proof_of__SemaphoreObtain_partial_solve_wit_19_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_partial_solve_wit_19_pure : _SemaphoreObtain_partial_solve_wit_19_pure.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_which_implies_wit_1",
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial : _SemaphoreObtain_which_implies_wit_1_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_1": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_1 : _SemaphoreObtain_which_implies_wit_1.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_which_implies_wit_2",
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial : _SemaphoreObtain_which_implies_wit_2_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_2": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_2 : _SemaphoreObtain_which_implies_wit_2.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_3_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_3_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_which_implies_wit_3",
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_3_split_goal_spatial : _SemaphoreObtain_which_implies_wit_3_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_3": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_3 : _SemaphoreObtain_which_implies_wit_3.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_4": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_4 : _SemaphoreObtain_which_implies_wit_4.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_6_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_6_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_which_implies_wit_6",
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_6_split_goal_spatial : _SemaphoreObtain_which_implies_wit_6_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_6": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_6 : _SemaphoreObtain_which_implies_wit_6.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_which_implies_wit_7",
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial : _SemaphoreObtain_which_implies_wit_7_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_7": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_7 : _SemaphoreObtain_which_implies_wit_7.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_which_implies_wit_8",
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial : _SemaphoreObtain_which_implies_wit_8_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_8": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_8 : _SemaphoreObtain_which_implies_wit_8.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_10": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_10",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_10 : _SemaphoreObtain_which_implies_wit_10.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial",
        "parent": "proof_of__SemaphoreObtain_which_implies_wit_11",
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial : _SemaphoreObtain_which_implies_wit_11_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreObtain_which_implies_wit_11": {
        "name": "proof_of__SemaphoreObtain_which_implies_wit_11",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreObtain_which_implies_wit_11 : _SemaphoreObtain_which_implies_wit_11.\n"
      }
    },
    "top_level": [
      "proof_of__SemaphoreObtain_entail_wit_1_1",
      "proof_of__SemaphoreObtain_entail_wit_1_2",
      "proof_of__SemaphoreObtain_entail_wit_1_3",
      "proof_of__SemaphoreObtain_entail_wit_3_1",
      "proof_of__SemaphoreObtain_entail_wit_3_2",
      "proof_of__SemaphoreObtain_entail_wit_4",
      "proof_of__SemaphoreObtain_entail_wit_5",
      "proof_of__SemaphoreObtain_entail_wit_6",
      "proof_of__SemaphoreObtain_entail_wit_7",
      "proof_of__SemaphoreObtain_entail_wit_8",
      "proof_of__SemaphoreObtain_entail_wit_9",
      "proof_of__SemaphoreObtain_entail_wit_10",
      "proof_of__SemaphoreObtain_entail_wit_11",
      "proof_of__SemaphoreObtain_entail_wit_12_1",
      "proof_of__SemaphoreObtain_entail_wit_12_2",
      "proof_of__SemaphoreObtain_entail_wit_13_1",
      "proof_of__SemaphoreObtain_entail_wit_13_2",
      "proof_of__SemaphoreObtain_entail_wit_14_1",
      "proof_of__SemaphoreObtain_entail_wit_14_2",
      "proof_of__SemaphoreObtain_entail_wit_14_3",
      "proof_of__SemaphoreObtain_entail_wit_15",
      "proof_of__SemaphoreObtain_entail_wit_16",
      "proof_of__SemaphoreObtain_entail_wit_17",
      "proof_of__SemaphoreObtain_return_wit_6",
      "proof_of__SemaphoreObtain_return_wit_7",
      "proof_of__SemaphoreObtain_return_wit_8",
      "proof_of__SemaphoreObtain_partial_solve_wit_19_pure",
      "proof_of__SemaphoreObtain_which_implies_wit_1",
      "proof_of__SemaphoreObtain_which_implies_wit_2",
      "proof_of__SemaphoreObtain_which_implies_wit_3",
      "proof_of__SemaphoreObtain_which_implies_wit_4",
      "proof_of__SemaphoreObtain_which_implies_wit_6",
      "proof_of__SemaphoreObtain_which_implies_wit_7",
      "proof_of__SemaphoreObtain_which_implies_wit_8",
      "proof_of__SemaphoreObtain_which_implies_wit_10",
      "proof_of__SemaphoreObtain_which_implies_wit_11"
    ],
    "split_goals": {
      "proof_of__SemaphoreObtain_entail_wit_1_1": [
        "proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2"
      ],
      "proof_of__SemaphoreObtain_entail_wit_1_2": [
        "proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2"
      ],
      "proof_of__SemaphoreObtain_entail_wit_1_3": [
        "proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2",
        "proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3"
      ],
      "proof_of__SemaphoreObtain_entail_wit_3_1": [
        "proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2",
        "proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_entail_wit_3_2": [
        "proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2",
        "proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_entail_wit_4": [],
      "proof_of__SemaphoreObtain_entail_wit_5": [
        "proof_of__SemaphoreObtain_entail_wit_5_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_5_split_goal_2",
        "proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_entail_wit_6": [
        "proof_of__SemaphoreObtain_entail_wit_6_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_6_split_goal_2"
      ],
      "proof_of__SemaphoreObtain_entail_wit_7": [
        "proof_of__SemaphoreObtain_entail_wit_7_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_7_split_goal_2"
      ],
      "proof_of__SemaphoreObtain_entail_wit_8": [],
      "proof_of__SemaphoreObtain_entail_wit_9": [
        "proof_of__SemaphoreObtain_entail_wit_9_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_9_split_goal_2",
        "proof_of__SemaphoreObtain_entail_wit_9_split_goal_3",
        "proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_entail_wit_10": [],
      "proof_of__SemaphoreObtain_entail_wit_11": [],
      "proof_of__SemaphoreObtain_entail_wit_12_1": [
        "proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_entail_wit_12_2": [
        "proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_entail_wit_13_1": [
        "proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_2"
      ],
      "proof_of__SemaphoreObtain_entail_wit_13_2": [
        "proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_2"
      ],
      "proof_of__SemaphoreObtain_entail_wit_14_1": [],
      "proof_of__SemaphoreObtain_entail_wit_14_2": [],
      "proof_of__SemaphoreObtain_entail_wit_14_3": [],
      "proof_of__SemaphoreObtain_entail_wit_15": [
        "proof_of__SemaphoreObtain_entail_wit_15_split_goal_1"
      ],
      "proof_of__SemaphoreObtain_entail_wit_16": [],
      "proof_of__SemaphoreObtain_entail_wit_17": [
        "proof_of__SemaphoreObtain_entail_wit_17_split_goal_1",
        "proof_of__SemaphoreObtain_entail_wit_17_split_goal_2",
        "proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_return_wit_6": [
        "proof_of__SemaphoreObtain_return_wit_6_split_goal_1"
      ],
      "proof_of__SemaphoreObtain_return_wit_7": [
        "proof_of__SemaphoreObtain_return_wit_7_split_goal_1"
      ],
      "proof_of__SemaphoreObtain_return_wit_8": [
        "proof_of__SemaphoreObtain_return_wit_8_split_goal_1"
      ],
      "proof_of__SemaphoreObtain_partial_solve_wit_19_pure": [
        "proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1"
      ],
      "proof_of__SemaphoreObtain_which_implies_wit_1": [
        "proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_which_implies_wit_2": [
        "proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_which_implies_wit_3": [
        "proof_of__SemaphoreObtain_which_implies_wit_3_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_which_implies_wit_4": [],
      "proof_of__SemaphoreObtain_which_implies_wit_6": [
        "proof_of__SemaphoreObtain_which_implies_wit_6_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_which_implies_wit_7": [
        "proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_which_implies_wit_8": [
        "proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial"
      ],
      "proof_of__SemaphoreObtain_which_implies_wit_10": [],
      "proof_of__SemaphoreObtain_which_implies_wit_11": [
        "proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial"
      ]
    }
  },
  "max_witnesses_per_group": 12,
  "annotation_comparisons": [
    {
      "source": {
        "attempt": "SemaphoreObtainRuntime-vc-checking-r1",
        "name": "proof_of__SemaphoreObtain_partial_solve_wit_21_pure",
        "annotation_location": "KTaskSetDelay finite-wait call / for_null_inactive null-delay precondition branch"
      },
      "current": [
        "proof_of__SemaphoreObtain_partial_solve_wit_21_pure"
      ],
      "old_gap": "Both old alternatives incorrectly demanded inactive_map(0) <> None for the permitted null-delay case.",
      "change": "Equivalent caller-local null-or-inactive proposition written as tdDelay != 0 => inactive_map(tdDelay) != None; no change to canonical contract or public target spec.",
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
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-debug",
      "--run",
      "SemaphoreObtainRuntime-20261119060206",
      "--round",
      "SemaphoreObtainRuntime-vc-checking-r3"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
