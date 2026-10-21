# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "_SemaphoreCreate-vc-checking-r2",
  "round": "_SemaphoreCreate-vc-checking-r2",
  "main_root": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
  "target_files": {
    "c_file": "annotated_C/src/_SemaphoreCreate.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/_SemaphoreCreate_lib.v",
    "goal_file": "VC/_SemaphoreCreate_goal.v",
    "proof_auto_file": "VC/_SemaphoreCreate_proof_auto.v",
    "proof_manual_file": "VC/_SemaphoreCreate_proof_manual.v",
    "goal_check_file": "VC/_SemaphoreCreate_goal_check.v",
    "case_name": "_SemaphoreCreate",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-checking-r2/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-checking-r2/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "accepted_shared_inputs": {
    "accepted_at_utc": "2026-10-15T16:22:40.209315+00:00",
    "basis": "User one-time automatic acceptance of independent review-passed revisions, plus explicit DCHG-20261012-01 authorization",
    "source_revision": "source-r2-0c50c37013e9",
    "source_manifest": "0c50c37013e9cd306791865c9deafadfa2051eaaf523ee78fdfef6b8812c4651",
    "predicate_revision": "predicate-nonzero-candidate-fe8c4261db5c",
    "predicate_manifest": "fe8c4261db5cff754395f3d9038769b3e50420d542347262a831aa3ce6a422b3",
    "predicate_reviewer": "/root/nonzero_source_review",
    "predicate_status": "review-passed",
    "spec_revision": "spec-r6-ae22a04e2c95",
    "spec_manifest": "ae22a04e2c951be960fddd724fae8d23a5f2034b8f65765318472ff549c79e18",
    "spec_author": "/root/sizeof_spec_author",
    "spec_reviewer": "/root/nonzero_source_review",
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
    "spec_review": ".docs/Report/2026-10-16-1-spec-review.md",
    "predicate_review": ".docs/Report/2026-10-12-6-predicate-review.md",
    "coqproject_sha256": "31614155daad904f4bb2411acc60639d7c99aaf3749eb967d185d7b56d930f15",
    "compiler": "/home/xinra/.opam/pv-bench-8.20.1/bin/coqc",
    "framework": "official Rocq Arch32 LittleEndian, explicit trial shared/framework candidates",
    "design_change": ".docs/Report/design-changes/2026-10-16-1-sizeof-normalization.md",
    "implementation_pending": [
      {
        "issue": "IMPL-20261016-BODY-01",
        "owner": "original _SemaphoreCreate annotation owner",
        "required": "Resolve Basics import composition-notation conflict and regenerate/typecheck under controller"
      },
      {
        "issue": "IMPL-20261016-BODY-02",
        "owner": "original _SemaphoreCreate annotation owner",
        "required": "Use real getData/getPtr projections and regenerate/typecheck under controller"
      },
      {
        "issue": "original_sizeof_VCs",
        "required": "Regenerate and independently recheck actual pure size obligations; no deletion or proof claim yet"
      }
    ]
  },
  "shared_input_note": "Current accepted manifests supersede historical revision labels in the original problem statement; semantic goals and frozen function contracts remain required. Accepted predicate sources listed in evidence/predicate-manifest.json and their formal dependencies are read-only semantic inputs for interpreting and proving the goals. This grants no edits to those inputs.",
  "group_plan": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-checking-r2/group_plan.json",
  "debug_manual": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-checking-r2/_SemaphoreCreate_proof_manual.v",
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
      "proof_of__SemaphoreCreate_entail_wit_1_split_goal_3": {
        "name": "proof_of__SemaphoreCreate_entail_wit_1_split_goal_3",
        "parent": "proof_of__SemaphoreCreate_entail_wit_1",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_3 : _SemaphoreCreate_entail_wit_1_split_goal_3.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial": {
        "name": "proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial",
        "parent": "proof_of__SemaphoreCreate_entail_wit_1",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial : _SemaphoreCreate_entail_wit_1_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_entail_wit_2_1",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_1 : _SemaphoreCreate_entail_wit_2_1_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial",
        "parent": "proof_of__SemaphoreCreate_entail_wit_2_1",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial : _SemaphoreCreate_entail_wit_2_1_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2_1 : _SemaphoreCreate_entail_wit_2_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_entail_wit_2_2",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1 : _SemaphoreCreate_entail_wit_2_2_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_2": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_2",
        "parent": "proof_of__SemaphoreCreate_entail_wit_2_2",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_2 : _SemaphoreCreate_entail_wit_2_2_split_goal_2.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_3": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_3",
        "parent": "proof_of__SemaphoreCreate_entail_wit_2_2",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_3 : _SemaphoreCreate_entail_wit_2_2_split_goal_3.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial",
        "parent": "proof_of__SemaphoreCreate_entail_wit_2_2",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial : _SemaphoreCreate_entail_wit_2_2_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_2_2": {
        "name": "proof_of__SemaphoreCreate_entail_wit_2_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_2_2 : _SemaphoreCreate_entail_wit_2_2.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_3": {
        "name": "proof_of__SemaphoreCreate_entail_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_4": {
        "name": "proof_of__SemaphoreCreate_entail_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_4 : _SemaphoreCreate_entail_wit_4.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_5_split_goal_1": {
        "name": "proof_of__SemaphoreCreate_entail_wit_5_split_goal_1",
        "parent": "proof_of__SemaphoreCreate_entail_wit_5",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_1 : _SemaphoreCreate_entail_wit_5_split_goal_1.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_5_split_goal_2": {
        "name": "proof_of__SemaphoreCreate_entail_wit_5_split_goal_2",
        "parent": "proof_of__SemaphoreCreate_entail_wit_5",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_2 : _SemaphoreCreate_entail_wit_5_split_goal_2.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial": {
        "name": "proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial",
        "parent": "proof_of__SemaphoreCreate_entail_wit_5",
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial : _SemaphoreCreate_entail_wit_5_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreCreate_entail_wit_5": {
        "name": "proof_of__SemaphoreCreate_entail_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_entail_wit_5 : _SemaphoreCreate_entail_wit_5.\n"
      },
      "proof_of__SemaphoreCreate_return_wit_1": {
        "name": "proof_of__SemaphoreCreate_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.\n"
      },
      "proof_of__SemaphoreCreate_return_wit_2": {
        "name": "proof_of__SemaphoreCreate_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.\n"
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
      "proof_of__SemaphoreCreate_return_wit_3": {
        "name": "proof_of__SemaphoreCreate_return_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.\n"
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
      "proof_of__SemaphoreCreate_partial_solve_wit_3_pure": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_3_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_3_pure : _SemaphoreCreate_partial_solve_wit_3_pure.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_3": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_4_pure": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_4_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_4_pure : _SemaphoreCreate_partial_solve_wit_4_pure.\n"
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
      "proof_of__SemaphoreCreate_partial_solve_wit_6_pure": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_6_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_6": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_7_pure": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_7_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_7_pure : _SemaphoreCreate_partial_solve_wit_7_pure.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_7": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.\n"
      },
      "proof_of__SemaphoreCreate_partial_solve_wit_8_pure": {
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_8_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreCreate_partial_solve_wit_8_pure : _SemaphoreCreate_partial_solve_wit_8_pure.\n"
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
      "proof_of__SemaphoreCreate_entail_wit_2_1",
      "proof_of__SemaphoreCreate_entail_wit_2_2",
      "proof_of__SemaphoreCreate_entail_wit_3",
      "proof_of__SemaphoreCreate_entail_wit_4",
      "proof_of__SemaphoreCreate_entail_wit_5",
      "proof_of__SemaphoreCreate_return_wit_1",
      "proof_of__SemaphoreCreate_return_wit_2",
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
      "proof_of__SemaphoreCreate_return_wit_3",
      "proof_of__SemaphoreCreate_partial_solve_wit_1_pure",
      "proof_of__SemaphoreCreate_partial_solve_wit_1",
      "proof_of__SemaphoreCreate_partial_solve_wit_2_pure",
      "proof_of__SemaphoreCreate_partial_solve_wit_2",
      "proof_of__SemaphoreCreate_partial_solve_wit_3_pure",
      "proof_of__SemaphoreCreate_partial_solve_wit_3",
      "proof_of__SemaphoreCreate_partial_solve_wit_4_pure",
      "proof_of__SemaphoreCreate_partial_solve_wit_4",
      "proof_of__SemaphoreCreate_partial_solve_wit_5",
      "proof_of__SemaphoreCreate_partial_solve_wit_6_pure",
      "proof_of__SemaphoreCreate_partial_solve_wit_6",
      "proof_of__SemaphoreCreate_partial_solve_wit_7_pure",
      "proof_of__SemaphoreCreate_partial_solve_wit_7",
      "proof_of__SemaphoreCreate_partial_solve_wit_8_pure",
      "proof_of__SemaphoreCreate_partial_solve_wit_8",
      "proof_of__SemaphoreCreate_partial_solve_wit_9_pure",
      "proof_of__SemaphoreCreate_partial_solve_wit_9"
    ],
    "split_goals": {
      "proof_of__SemaphoreCreate_entail_wit_1": [
        "proof_of__SemaphoreCreate_entail_wit_1_split_goal_1",
        "proof_of__SemaphoreCreate_entail_wit_1_split_goal_2",
        "proof_of__SemaphoreCreate_entail_wit_1_split_goal_3",
        "proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial"
      ],
      "proof_of__SemaphoreCreate_entail_wit_2_1": [
        "proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_1",
        "proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial"
      ],
      "proof_of__SemaphoreCreate_entail_wit_2_2": [
        "proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1",
        "proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_2",
        "proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_3",
        "proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial"
      ],
      "proof_of__SemaphoreCreate_entail_wit_3": [],
      "proof_of__SemaphoreCreate_entail_wit_4": [],
      "proof_of__SemaphoreCreate_entail_wit_5": [
        "proof_of__SemaphoreCreate_entail_wit_5_split_goal_1",
        "proof_of__SemaphoreCreate_entail_wit_5_split_goal_2",
        "proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial"
      ],
      "proof_of__SemaphoreCreate_return_wit_1": [],
      "proof_of__SemaphoreCreate_return_wit_2": [],
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
      "proof_of__SemaphoreCreate_return_wit_3": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_1_pure": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_1": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_2_pure": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_2": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_3_pure": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_3": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_4_pure": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_4": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_5": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_6_pure": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_6": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_7_pure": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_7": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_8_pure": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_8": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_9_pure": [],
      "proof_of__SemaphoreCreate_partial_solve_wit_9": []
    }
  },
  "max_witnesses_per_group": 12,
  "annotation_comparisons": [
    {
      "source": {
        "attempt": "_SemaphoreCreate-vc-checking-r1",
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_1_pure",
        "annotation_location": "annotated_C/src/_SemaphoreCreate.c:121 (x_malloc Require at line 31)"
      },
      "current": [
        "proof_of__SemaphoreCreate_partial_solve_wit_1_pure"
      ],
      "old_gap": "The unconstrained formal sizeof_alias_type \"Semaphore\" had no premise equating it to 32.",
      "change": "Main activated independently reviewed spec-r6-ae22a04e2c95, normalizing only this fixed-size call argument to (x_size_t)32; this owner regenerated through the controller without changing any Require/Ensure. The complete old and new pure definitions are identical except that sizeof(\"Semaphore\") is now the literal 32, so the unchanged caller footprint entails 32 = 32.",
      "result": "resolved"
    },
    {
      "source": {
        "attempt": "_SemaphoreCreate-vc-checking-r1",
        "name": "proof_of__SemaphoreCreate_partial_solve_wit_2_pure",
        "annotation_location": "annotated_C/src/_SemaphoreCreate.c:125 (memset Require at line 37)"
      },
      "current": [
        "proof_of__SemaphoreCreate_partial_solve_wit_2_pure"
      ],
      "old_gap": "The unconstrained formal sizeof_alias_type \"Semaphore\" had no premise equating it to 32.",
      "change": "Main activated independently reviewed spec-r6-ae22a04e2c95, normalizing only this fixed-size call argument to (x_size_t)32; this owner regenerated through the controller without changing any Require/Ensure. The complete old and new pure definitions are identical except that sizeof(\"Semaphore\") is now the literal 32; allocated ownership and all pure premises remain identical, and the conclusion is 0 = 0 and 32 = 32.",
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
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-debug",
      "--run",
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-checking-r2"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
