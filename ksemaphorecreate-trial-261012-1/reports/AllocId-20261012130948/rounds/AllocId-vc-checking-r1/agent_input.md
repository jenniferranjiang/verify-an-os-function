# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "AllocId-vc-checking-r1",
  "round": "AllocId-vc-checking-r1",
  "main_root": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
  "target_files": {
    "c_file": "annotated_C/src/AllocId.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/AllocId_lib.v",
    "goal_file": "VC/AllocId_goal.v",
    "proof_auto_file": "VC/AllocId_proof_auto.v",
    "proof_manual_file": "VC/AllocId_proof_manual.v",
    "goal_check_file": "VC/AllocId_goal_check.v",
    "case_name": "AllocId",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-checking-r1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "accepted_shared_inputs": {
    "accepted_at_utc": "2026-10-12T06:58:00.683783+00:00",
    "basis": "User one-time automatic acceptance of independent review-passed revisions, plus explicit DCHG-20261012-01 authorization",
    "source_revision": "source-r2-0c50c37013e9",
    "source_manifest": "0c50c37013e9cd306791865c9deafadfa2051eaaf523ee78fdfef6b8812c4651",
    "predicate_revision": "predicate-r5-0a139d64743c",
    "predicate_manifest": "0a139d64743cce8000b0910d7880d6c5a0bf89147b730665aa6ebefbfb45585a",
    "predicate_reviewer": "source_analysis",
    "predicate_status": "review-passed",
    "spec_revision": "spec-r4-9f3ebc915b99",
    "spec_manifest": "9f3ebc915b995fc8655bab8014878df4648f3dca6602cef7d65b936714274c48",
    "spec_author": "spec_author",
    "spec_reviewer": "/root",
    "spec_status": "review-passed",
    "domain": "entry scheduler_lock_nest < 65535; deeper entries excluded",
    "trusted": [
      "x_malloc",
      "x_free",
      "memset",
      "DisableLocalInterrupt",
      "EnableLocalInterrupt",
      "KPrintf"
    ],
    "implementation_verified": false,
    "spec_review": ".docs/Report/2026-10-12-3-spec-review.md",
    "predicate_review": ".docs/Report/2026-10-12-5-predicate-review.md",
    "coqproject_sha256": "31614155daad904f4bb2411acc60639d7c99aaf3749eb967d185d7b56d930f15",
    "compiler": "/home/xinra/.opam/pv-bench-8.20.1/bin/coqc",
    "framework": "official Rocq Arch32 LittleEndian, explicit trial shared/framework candidates"
  },
  "shared_input_note": "Current accepted manifests supersede historical revision labels in the original problem statement; semantic goals and frozen function contracts remain required. Accepted predicate sources listed in evidence/predicate-manifest.json and their formal dependencies are read-only semantic inputs for interpreting and proving the goals. This grants no edits to those inputs.",
  "group_plan": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/AllocId-20261012130948/rounds/AllocId-vc-checking-r1/AllocId_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_AllocId_safety_wit_9_split_goal_1": {
        "name": "proof_of_AllocId_safety_wit_9_split_goal_1",
        "parent": "proof_of_AllocId_safety_wit_9",
        "statement": "Lemma proof_of_AllocId_safety_wit_9_split_goal_1 : AllocId_safety_wit_9_split_goal_1.\n"
      },
      "proof_of_AllocId_safety_wit_9_split_goal_2": {
        "name": "proof_of_AllocId_safety_wit_9_split_goal_2",
        "parent": "proof_of_AllocId_safety_wit_9",
        "statement": "Lemma proof_of_AllocId_safety_wit_9_split_goal_2 : AllocId_safety_wit_9_split_goal_2.\n"
      },
      "proof_of_AllocId_safety_wit_9": {
        "name": "proof_of_AllocId_safety_wit_9",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_9 : AllocId_safety_wit_9.\n"
      },
      "proof_of_AllocId_safety_wit_19_split_goal_1": {
        "name": "proof_of_AllocId_safety_wit_19_split_goal_1",
        "parent": "proof_of_AllocId_safety_wit_19",
        "statement": "Lemma proof_of_AllocId_safety_wit_19_split_goal_1 : AllocId_safety_wit_19_split_goal_1.\n"
      },
      "proof_of_AllocId_safety_wit_19_split_goal_2": {
        "name": "proof_of_AllocId_safety_wit_19_split_goal_2",
        "parent": "proof_of_AllocId_safety_wit_19",
        "statement": "Lemma proof_of_AllocId_safety_wit_19_split_goal_2 : AllocId_safety_wit_19_split_goal_2.\n"
      },
      "proof_of_AllocId_safety_wit_19": {
        "name": "proof_of_AllocId_safety_wit_19",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_19 : AllocId_safety_wit_19.\n"
      },
      "proof_of_AllocId_safety_wit_22_split_goal_1": {
        "name": "proof_of_AllocId_safety_wit_22_split_goal_1",
        "parent": "proof_of_AllocId_safety_wit_22",
        "statement": "Lemma proof_of_AllocId_safety_wit_22_split_goal_1 : AllocId_safety_wit_22_split_goal_1.\n"
      },
      "proof_of_AllocId_safety_wit_22_split_goal_2": {
        "name": "proof_of_AllocId_safety_wit_22_split_goal_2",
        "parent": "proof_of_AllocId_safety_wit_22",
        "statement": "Lemma proof_of_AllocId_safety_wit_22_split_goal_2 : AllocId_safety_wit_22_split_goal_2.\n"
      },
      "proof_of_AllocId_safety_wit_22": {
        "name": "proof_of_AllocId_safety_wit_22",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_22 : AllocId_safety_wit_22.\n"
      },
      "proof_of_AllocId_safety_wit_27_split_goal_1": {
        "name": "proof_of_AllocId_safety_wit_27_split_goal_1",
        "parent": "proof_of_AllocId_safety_wit_27",
        "statement": "Lemma proof_of_AllocId_safety_wit_27_split_goal_1 : AllocId_safety_wit_27_split_goal_1.\n"
      },
      "proof_of_AllocId_safety_wit_27_split_goal_2": {
        "name": "proof_of_AllocId_safety_wit_27_split_goal_2",
        "parent": "proof_of_AllocId_safety_wit_27",
        "statement": "Lemma proof_of_AllocId_safety_wit_27_split_goal_2 : AllocId_safety_wit_27_split_goal_2.\n"
      },
      "proof_of_AllocId_safety_wit_27_split_goal_3": {
        "name": "proof_of_AllocId_safety_wit_27_split_goal_3",
        "parent": "proof_of_AllocId_safety_wit_27",
        "statement": "Lemma proof_of_AllocId_safety_wit_27_split_goal_3 : AllocId_safety_wit_27_split_goal_3.\n"
      },
      "proof_of_AllocId_safety_wit_27_split_goal_4": {
        "name": "proof_of_AllocId_safety_wit_27_split_goal_4",
        "parent": "proof_of_AllocId_safety_wit_27",
        "statement": "Lemma proof_of_AllocId_safety_wit_27_split_goal_4 : AllocId_safety_wit_27_split_goal_4.\n"
      },
      "proof_of_AllocId_safety_wit_27": {
        "name": "proof_of_AllocId_safety_wit_27",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_27 : AllocId_safety_wit_27.\n"
      },
      "proof_of_AllocId_entail_wit_2": {
        "name": "proof_of_AllocId_entail_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_entail_wit_2 : AllocId_entail_wit_2.\n"
      },
      "proof_of_AllocId_entail_wit_3_split_goal_1": {
        "name": "proof_of_AllocId_entail_wit_3_split_goal_1",
        "parent": "proof_of_AllocId_entail_wit_3",
        "statement": "Lemma proof_of_AllocId_entail_wit_3_split_goal_1 : AllocId_entail_wit_3_split_goal_1.\n"
      },
      "proof_of_AllocId_entail_wit_3_split_goal_2": {
        "name": "proof_of_AllocId_entail_wit_3_split_goal_2",
        "parent": "proof_of_AllocId_entail_wit_3",
        "statement": "Lemma proof_of_AllocId_entail_wit_3_split_goal_2 : AllocId_entail_wit_3_split_goal_2.\n"
      },
      "proof_of_AllocId_entail_wit_3": {
        "name": "proof_of_AllocId_entail_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_entail_wit_3 : AllocId_entail_wit_3.\n"
      },
      "proof_of_AllocId_entail_wit_4_split_goal_1": {
        "name": "proof_of_AllocId_entail_wit_4_split_goal_1",
        "parent": "proof_of_AllocId_entail_wit_4",
        "statement": "Lemma proof_of_AllocId_entail_wit_4_split_goal_1 : AllocId_entail_wit_4_split_goal_1.\n"
      },
      "proof_of_AllocId_entail_wit_4": {
        "name": "proof_of_AllocId_entail_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_entail_wit_4 : AllocId_entail_wit_4.\n"
      },
      "proof_of_AllocId_entail_wit_5_split_goal_1": {
        "name": "proof_of_AllocId_entail_wit_5_split_goal_1",
        "parent": "proof_of_AllocId_entail_wit_5",
        "statement": "Lemma proof_of_AllocId_entail_wit_5_split_goal_1 : AllocId_entail_wit_5_split_goal_1.\n"
      },
      "proof_of_AllocId_entail_wit_5": {
        "name": "proof_of_AllocId_entail_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_entail_wit_5 : AllocId_entail_wit_5.\n"
      },
      "proof_of_AllocId_entail_wit_6_split_goal_1": {
        "name": "proof_of_AllocId_entail_wit_6_split_goal_1",
        "parent": "proof_of_AllocId_entail_wit_6",
        "statement": "Lemma proof_of_AllocId_entail_wit_6_split_goal_1 : AllocId_entail_wit_6_split_goal_1.\n"
      },
      "proof_of_AllocId_entail_wit_6": {
        "name": "proof_of_AllocId_entail_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_entail_wit_6 : AllocId_entail_wit_6.\n"
      },
      "proof_of_AllocId_return_wit_1": {
        "name": "proof_of_AllocId_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_return_wit_1 : AllocId_return_wit_1.\n"
      },
      "proof_of_AllocId_return_wit_2": {
        "name": "proof_of_AllocId_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_return_wit_2 : AllocId_return_wit_2.\n"
      },
      "proof_of_AllocId_return_wit_3": {
        "name": "proof_of_AllocId_return_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_return_wit_3 : AllocId_return_wit_3.\n"
      },
      "proof_of_AllocId_safety_wit_1": {
        "name": "proof_of_AllocId_safety_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_1 : AllocId_safety_wit_1.\n"
      },
      "proof_of_AllocId_safety_wit_2": {
        "name": "proof_of_AllocId_safety_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_2 : AllocId_safety_wit_2.\n"
      },
      "proof_of_AllocId_safety_wit_3": {
        "name": "proof_of_AllocId_safety_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_3 : AllocId_safety_wit_3.\n"
      },
      "proof_of_AllocId_safety_wit_4": {
        "name": "proof_of_AllocId_safety_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_4 : AllocId_safety_wit_4.\n"
      },
      "proof_of_AllocId_safety_wit_5": {
        "name": "proof_of_AllocId_safety_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_5 : AllocId_safety_wit_5.\n"
      },
      "proof_of_AllocId_safety_wit_6": {
        "name": "proof_of_AllocId_safety_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_6 : AllocId_safety_wit_6.\n"
      },
      "proof_of_AllocId_safety_wit_7": {
        "name": "proof_of_AllocId_safety_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_7 : AllocId_safety_wit_7.\n"
      },
      "proof_of_AllocId_safety_wit_8": {
        "name": "proof_of_AllocId_safety_wit_8",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_8 : AllocId_safety_wit_8.\n"
      },
      "proof_of_AllocId_safety_wit_10": {
        "name": "proof_of_AllocId_safety_wit_10",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_10 : AllocId_safety_wit_10.\n"
      },
      "proof_of_AllocId_safety_wit_11": {
        "name": "proof_of_AllocId_safety_wit_11",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_11 : AllocId_safety_wit_11.\n"
      },
      "proof_of_AllocId_safety_wit_12": {
        "name": "proof_of_AllocId_safety_wit_12",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_12 : AllocId_safety_wit_12.\n"
      },
      "proof_of_AllocId_safety_wit_13": {
        "name": "proof_of_AllocId_safety_wit_13",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_13 : AllocId_safety_wit_13.\n"
      },
      "proof_of_AllocId_safety_wit_14": {
        "name": "proof_of_AllocId_safety_wit_14",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_14 : AllocId_safety_wit_14.\n"
      },
      "proof_of_AllocId_safety_wit_15": {
        "name": "proof_of_AllocId_safety_wit_15",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_15 : AllocId_safety_wit_15.\n"
      },
      "proof_of_AllocId_safety_wit_16": {
        "name": "proof_of_AllocId_safety_wit_16",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_16 : AllocId_safety_wit_16.\n"
      },
      "proof_of_AllocId_safety_wit_17": {
        "name": "proof_of_AllocId_safety_wit_17",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_17 : AllocId_safety_wit_17.\n"
      },
      "proof_of_AllocId_safety_wit_18": {
        "name": "proof_of_AllocId_safety_wit_18",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_18 : AllocId_safety_wit_18.\n"
      },
      "proof_of_AllocId_safety_wit_20": {
        "name": "proof_of_AllocId_safety_wit_20",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_20 : AllocId_safety_wit_20.\n"
      },
      "proof_of_AllocId_safety_wit_21": {
        "name": "proof_of_AllocId_safety_wit_21",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_21 : AllocId_safety_wit_21.\n"
      },
      "proof_of_AllocId_safety_wit_23": {
        "name": "proof_of_AllocId_safety_wit_23",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_23 : AllocId_safety_wit_23.\n"
      },
      "proof_of_AllocId_safety_wit_24": {
        "name": "proof_of_AllocId_safety_wit_24",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_24 : AllocId_safety_wit_24.\n"
      },
      "proof_of_AllocId_safety_wit_25": {
        "name": "proof_of_AllocId_safety_wit_25",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_25 : AllocId_safety_wit_25.\n"
      },
      "proof_of_AllocId_safety_wit_26": {
        "name": "proof_of_AllocId_safety_wit_26",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_26 : AllocId_safety_wit_26.\n"
      },
      "proof_of_AllocId_safety_wit_28": {
        "name": "proof_of_AllocId_safety_wit_28",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_28 : AllocId_safety_wit_28.\n"
      },
      "proof_of_AllocId_safety_wit_29": {
        "name": "proof_of_AllocId_safety_wit_29",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_29 : AllocId_safety_wit_29.\n"
      },
      "proof_of_AllocId_safety_wit_30": {
        "name": "proof_of_AllocId_safety_wit_30",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_safety_wit_30 : AllocId_safety_wit_30.\n"
      },
      "proof_of_AllocId_entail_wit_1": {
        "name": "proof_of_AllocId_entail_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_entail_wit_1 : AllocId_entail_wit_1.\n"
      },
      "proof_of_AllocId_partial_solve_wit_1": {
        "name": "proof_of_AllocId_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_partial_solve_wit_1 : AllocId_partial_solve_wit_1.\n"
      },
      "proof_of_AllocId_partial_solve_wit_2": {
        "name": "proof_of_AllocId_partial_solve_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_partial_solve_wit_2 : AllocId_partial_solve_wit_2.\n"
      },
      "proof_of_AllocId_partial_solve_wit_3": {
        "name": "proof_of_AllocId_partial_solve_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_partial_solve_wit_3 : AllocId_partial_solve_wit_3.\n"
      },
      "proof_of_AllocId_partial_solve_wit_4": {
        "name": "proof_of_AllocId_partial_solve_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_AllocId_partial_solve_wit_4 : AllocId_partial_solve_wit_4.\n"
      }
    },
    "top_level": [
      "proof_of_AllocId_safety_wit_9",
      "proof_of_AllocId_safety_wit_19",
      "proof_of_AllocId_safety_wit_22",
      "proof_of_AllocId_safety_wit_27",
      "proof_of_AllocId_entail_wit_2",
      "proof_of_AllocId_entail_wit_3",
      "proof_of_AllocId_entail_wit_4",
      "proof_of_AllocId_entail_wit_5",
      "proof_of_AllocId_entail_wit_6",
      "proof_of_AllocId_return_wit_1",
      "proof_of_AllocId_return_wit_2",
      "proof_of_AllocId_return_wit_3",
      "proof_of_AllocId_safety_wit_1",
      "proof_of_AllocId_safety_wit_2",
      "proof_of_AllocId_safety_wit_3",
      "proof_of_AllocId_safety_wit_4",
      "proof_of_AllocId_safety_wit_5",
      "proof_of_AllocId_safety_wit_6",
      "proof_of_AllocId_safety_wit_7",
      "proof_of_AllocId_safety_wit_8",
      "proof_of_AllocId_safety_wit_10",
      "proof_of_AllocId_safety_wit_11",
      "proof_of_AllocId_safety_wit_12",
      "proof_of_AllocId_safety_wit_13",
      "proof_of_AllocId_safety_wit_14",
      "proof_of_AllocId_safety_wit_15",
      "proof_of_AllocId_safety_wit_16",
      "proof_of_AllocId_safety_wit_17",
      "proof_of_AllocId_safety_wit_18",
      "proof_of_AllocId_safety_wit_20",
      "proof_of_AllocId_safety_wit_21",
      "proof_of_AllocId_safety_wit_23",
      "proof_of_AllocId_safety_wit_24",
      "proof_of_AllocId_safety_wit_25",
      "proof_of_AllocId_safety_wit_26",
      "proof_of_AllocId_safety_wit_28",
      "proof_of_AllocId_safety_wit_29",
      "proof_of_AllocId_safety_wit_30",
      "proof_of_AllocId_entail_wit_1",
      "proof_of_AllocId_partial_solve_wit_1",
      "proof_of_AllocId_partial_solve_wit_2",
      "proof_of_AllocId_partial_solve_wit_3",
      "proof_of_AllocId_partial_solve_wit_4"
    ],
    "split_goals": {
      "proof_of_AllocId_safety_wit_9": [
        "proof_of_AllocId_safety_wit_9_split_goal_1",
        "proof_of_AllocId_safety_wit_9_split_goal_2"
      ],
      "proof_of_AllocId_safety_wit_19": [
        "proof_of_AllocId_safety_wit_19_split_goal_1",
        "proof_of_AllocId_safety_wit_19_split_goal_2"
      ],
      "proof_of_AllocId_safety_wit_22": [
        "proof_of_AllocId_safety_wit_22_split_goal_1",
        "proof_of_AllocId_safety_wit_22_split_goal_2"
      ],
      "proof_of_AllocId_safety_wit_27": [
        "proof_of_AllocId_safety_wit_27_split_goal_1",
        "proof_of_AllocId_safety_wit_27_split_goal_2",
        "proof_of_AllocId_safety_wit_27_split_goal_3",
        "proof_of_AllocId_safety_wit_27_split_goal_4"
      ],
      "proof_of_AllocId_entail_wit_2": [],
      "proof_of_AllocId_entail_wit_3": [
        "proof_of_AllocId_entail_wit_3_split_goal_1",
        "proof_of_AllocId_entail_wit_3_split_goal_2"
      ],
      "proof_of_AllocId_entail_wit_4": [
        "proof_of_AllocId_entail_wit_4_split_goal_1"
      ],
      "proof_of_AllocId_entail_wit_5": [
        "proof_of_AllocId_entail_wit_5_split_goal_1"
      ],
      "proof_of_AllocId_entail_wit_6": [
        "proof_of_AllocId_entail_wit_6_split_goal_1"
      ],
      "proof_of_AllocId_return_wit_1": [],
      "proof_of_AllocId_return_wit_2": [],
      "proof_of_AllocId_return_wit_3": [],
      "proof_of_AllocId_safety_wit_1": [],
      "proof_of_AllocId_safety_wit_2": [],
      "proof_of_AllocId_safety_wit_3": [],
      "proof_of_AllocId_safety_wit_4": [],
      "proof_of_AllocId_safety_wit_5": [],
      "proof_of_AllocId_safety_wit_6": [],
      "proof_of_AllocId_safety_wit_7": [],
      "proof_of_AllocId_safety_wit_8": [],
      "proof_of_AllocId_safety_wit_10": [],
      "proof_of_AllocId_safety_wit_11": [],
      "proof_of_AllocId_safety_wit_12": [],
      "proof_of_AllocId_safety_wit_13": [],
      "proof_of_AllocId_safety_wit_14": [],
      "proof_of_AllocId_safety_wit_15": [],
      "proof_of_AllocId_safety_wit_16": [],
      "proof_of_AllocId_safety_wit_17": [],
      "proof_of_AllocId_safety_wit_18": [],
      "proof_of_AllocId_safety_wit_20": [],
      "proof_of_AllocId_safety_wit_21": [],
      "proof_of_AllocId_safety_wit_23": [],
      "proof_of_AllocId_safety_wit_24": [],
      "proof_of_AllocId_safety_wit_25": [],
      "proof_of_AllocId_safety_wit_26": [],
      "proof_of_AllocId_safety_wit_28": [],
      "proof_of_AllocId_safety_wit_29": [],
      "proof_of_AllocId_safety_wit_30": [],
      "proof_of_AllocId_entail_wit_1": [],
      "proof_of_AllocId_partial_solve_wit_1": [],
      "proof_of_AllocId_partial_solve_wit_2": [],
      "proof_of_AllocId_partial_solve_wit_3": [],
      "proof_of_AllocId_partial_solve_wit_4": []
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
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-debug",
      "--run",
      "AllocId-20261012130948",
      "--round",
      "AllocId-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
