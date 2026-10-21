# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "KSemaphoreCreate-vc-checking-r1",
  "round": "KSemaphoreCreate-vc-checking-r1",
  "main_root": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
  "target_files": {
    "c_file": "annotated_C/src/KSemaphoreCreate.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/KSemaphoreCreate_lib.v",
    "goal_file": "VC/KSemaphoreCreate_goal.v",
    "proof_auto_file": "VC/KSemaphoreCreate_proof_auto.v",
    "proof_manual_file": "VC/KSemaphoreCreate_proof_manual.v",
    "goal_check_file": "VC/KSemaphoreCreate_goal_check.v",
    "case_name": "KSemaphoreCreate",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/KSemaphoreCreate-20261012131015/rounds/KSemaphoreCreate-vc-checking-r1/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/KSemaphoreCreate-20261012131015/rounds/KSemaphoreCreate-vc-checking-r1/agent_output.md",
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
    "implementation_pending": [],
    "implementation_resolved": [
      {
        "issue": "IMPL-20261016-BODY-01",
        "owner": "original _SemaphoreCreate annotation owner",
        "required": "Resolve Basics import composition-notation conflict and regenerate/typecheck under controller",
        "status": "resolved-at-actual-generated-goal-typechecking",
        "evidence": "reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-checking-r2/agent_output.md",
        "limitation": "This closes the body interface typing issue, not any C VC proof."
      },
      {
        "issue": "IMPL-20261016-BODY-02",
        "owner": "original _SemaphoreCreate annotation owner",
        "required": "Use real getData/getPtr projections and regenerate/typecheck under controller",
        "status": "resolved-at-actual-generated-goal-typechecking",
        "evidence": "reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-checking-r2/agent_output.md",
        "limitation": "This closes the body interface typing issue, not any C VC proof."
      },
      {
        "issue": "original_sizeof_VCs",
        "required": "Regenerate and independently recheck actual pure size obligations; no deletion or proof claim yet",
        "status": "proved-in-accepted-normalized_calls-group",
        "evidence": "reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_00__normalized_calls/group_worker_output.md",
        "limitation": "Original VC identities preserved and proved after reviewed extraction normalization; whole function final-check pending."
      }
    ]
  },
  "shared_input_note": "Current accepted manifests supersede historical revision labels in the original problem statement; semantic goals and frozen function contracts remain required. Accepted predicate sources listed in evidence/predicate-manifest.json and their formal dependencies are read-only semantic inputs for interpreting and proving the goals. This grants no edits to those inputs.",
  "group_plan": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/KSemaphoreCreate-20261012131015/rounds/KSemaphoreCreate-vc-checking-r1/group_plan.json",
  "debug_manual": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/KSemaphoreCreate-20261012131015/rounds/KSemaphoreCreate-vc-checking-r1/KSemaphoreCreate_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_KSemaphoreCreate_return_wit_1": {
        "name": "proof_of_KSemaphoreCreate_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_KSemaphoreCreate_return_wit_1 : KSemaphoreCreate_return_wit_1.\n"
      },
      "proof_of_KSemaphoreCreate_return_wit_2": {
        "name": "proof_of_KSemaphoreCreate_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_KSemaphoreCreate_return_wit_2 : KSemaphoreCreate_return_wit_2.\n"
      },
      "proof_of_KSemaphoreCreate_return_wit_3": {
        "name": "proof_of_KSemaphoreCreate_return_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_KSemaphoreCreate_return_wit_3 : KSemaphoreCreate_return_wit_3.\n"
      },
      "proof_of_KSemaphoreCreate_partial_solve_wit_1_pure": {
        "name": "proof_of_KSemaphoreCreate_partial_solve_wit_1_pure",
        "parent": null,
        "statement": "Lemma proof_of_KSemaphoreCreate_partial_solve_wit_1_pure : KSemaphoreCreate_partial_solve_wit_1_pure.\n"
      },
      "proof_of_KSemaphoreCreate_partial_solve_wit_1": {
        "name": "proof_of_KSemaphoreCreate_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_KSemaphoreCreate_partial_solve_wit_1 : KSemaphoreCreate_partial_solve_wit_1.\n"
      }
    },
    "top_level": [
      "proof_of_KSemaphoreCreate_return_wit_1",
      "proof_of_KSemaphoreCreate_return_wit_2",
      "proof_of_KSemaphoreCreate_return_wit_3",
      "proof_of_KSemaphoreCreate_partial_solve_wit_1_pure",
      "proof_of_KSemaphoreCreate_partial_solve_wit_1"
    ],
    "split_goals": {
      "proof_of_KSemaphoreCreate_return_wit_1": [],
      "proof_of_KSemaphoreCreate_return_wit_2": [],
      "proof_of_KSemaphoreCreate_return_wit_3": [],
      "proof_of_KSemaphoreCreate_partial_solve_wit_1_pure": [],
      "proof_of_KSemaphoreCreate_partial_solve_wit_1": []
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
      "KSemaphoreCreate-20261012131015",
      "--round",
      "KSemaphoreCreate-vc-checking-r1"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
