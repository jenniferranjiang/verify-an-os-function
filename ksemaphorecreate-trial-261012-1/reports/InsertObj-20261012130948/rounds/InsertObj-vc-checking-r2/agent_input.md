# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "InsertObj-vc-checking-r2",
  "round": "InsertObj-vc-checking-r2",
  "main_root": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
  "target_files": {
    "c_file": "annotated_C/src/InsertObj.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/InsertObj_lib.v",
    "goal_file": "VC/InsertObj_goal.v",
    "proof_auto_file": "VC/InsertObj_proof_auto.v",
    "proof_manual_file": "VC/InsertObj_proof_manual.v",
    "goal_check_file": "VC/InsertObj_goal_check.v",
    "case_name": "InsertObj",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-checking-r2/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-checking-r2/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "accepted_shared_inputs": {
    "accepted_at_utc": "2026-10-12T15:43:16.469941+00:00",
    "basis": "User one-time automatic acceptance of independent review-passed revisions, plus explicit DCHG-20261012-01 authorization",
    "source_revision": "source-r2-0c50c37013e9",
    "source_manifest": "0c50c37013e9cd306791865c9deafadfa2051eaaf523ee78fdfef6b8812c4651",
    "predicate_revision": "predicate-nonzero-candidate-fe8c4261db5c",
    "predicate_manifest": "fe8c4261db5cff754395f3d9038769b3e50420d542347262a831aa3ce6a422b3",
    "predicate_reviewer": "/root/nonzero_source_review",
    "predicate_status": "review-passed",
    "spec_revision": "spec-r5-480669e8557a",
    "spec_manifest": "480669e8557a5f09a7683b69c5de2b087857f93649ef9c6729096df1c6a8b3cf",
    "spec_author": "spec_author",
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
    "spec_review": ".docs/Report/2026-10-12-4-spec-review.md",
    "predicate_review": ".docs/Report/2026-10-12-6-predicate-review.md",
    "coqproject_sha256": "31614155daad904f4bb2411acc60639d7c99aaf3749eb967d185d7b56d930f15",
    "compiler": "/home/xinra/.opam/pv-bench-8.20.1/bin/coqc",
    "framework": "official Rocq Arch32 LittleEndian, explicit trial shared/framework candidates",
    "design_change": ".docs/Report/design-changes/2026-10-12-3-object-address-validity.md"
  },
  "shared_input_note": "Current accepted manifests supersede historical revision labels in the original problem statement; semantic goals and frozen function contracts remain required. Accepted predicate sources listed in evidence/predicate-manifest.json and their formal dependencies are read-only semantic inputs for interpreting and proving the goals. This grants no edits to those inputs.",
  "group_plan": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-checking-r2/group_plan.json",
  "debug_manual": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/InsertObj-20261012130948/rounds/InsertObj-vc-checking-r2/InsertObj_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_InsertObj_entail_wit_1": {
        "name": "proof_of_InsertObj_entail_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_entail_wit_1 : InsertObj_entail_wit_1.\n"
      },
      "proof_of_InsertObj_entail_wit_2": {
        "name": "proof_of_InsertObj_entail_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_entail_wit_2 : InsertObj_entail_wit_2.\n"
      },
      "proof_of_InsertObj_entail_wit_3_1_split_goal_1": {
        "name": "proof_of_InsertObj_entail_wit_3_1_split_goal_1",
        "parent": "proof_of_InsertObj_entail_wit_3_1",
        "statement": "Lemma proof_of_InsertObj_entail_wit_3_1_split_goal_1 : InsertObj_entail_wit_3_1_split_goal_1.\n"
      },
      "proof_of_InsertObj_entail_wit_3_1_split_goal_spatial": {
        "name": "proof_of_InsertObj_entail_wit_3_1_split_goal_spatial",
        "parent": "proof_of_InsertObj_entail_wit_3_1",
        "statement": "Lemma proof_of_InsertObj_entail_wit_3_1_split_goal_spatial : InsertObj_entail_wit_3_1_split_goal_spatial.\n"
      },
      "proof_of_InsertObj_entail_wit_3_1": {
        "name": "proof_of_InsertObj_entail_wit_3_1",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_entail_wit_3_1 : InsertObj_entail_wit_3_1.\n"
      },
      "proof_of_InsertObj_entail_wit_3_2_split_goal_spatial": {
        "name": "proof_of_InsertObj_entail_wit_3_2_split_goal_spatial",
        "parent": "proof_of_InsertObj_entail_wit_3_2",
        "statement": "Lemma proof_of_InsertObj_entail_wit_3_2_split_goal_spatial : InsertObj_entail_wit_3_2_split_goal_spatial.\n"
      },
      "proof_of_InsertObj_entail_wit_3_2": {
        "name": "proof_of_InsertObj_entail_wit_3_2",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_entail_wit_3_2 : InsertObj_entail_wit_3_2.\n"
      },
      "proof_of_InsertObj_return_wit_1_split_goal_spatial": {
        "name": "proof_of_InsertObj_return_wit_1_split_goal_spatial",
        "parent": "proof_of_InsertObj_return_wit_1",
        "statement": "Lemma proof_of_InsertObj_return_wit_1_split_goal_spatial : InsertObj_return_wit_1_split_goal_spatial.\n"
      },
      "proof_of_InsertObj_return_wit_1": {
        "name": "proof_of_InsertObj_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_return_wit_1 : InsertObj_return_wit_1.\n"
      },
      "proof_of_InsertObj_safety_wit_1": {
        "name": "proof_of_InsertObj_safety_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_safety_wit_1 : InsertObj_safety_wit_1.\n"
      },
      "proof_of_InsertObj_safety_wit_2": {
        "name": "proof_of_InsertObj_safety_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_safety_wit_2 : InsertObj_safety_wit_2.\n"
      },
      "proof_of_InsertObj_safety_wit_3": {
        "name": "proof_of_InsertObj_safety_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_safety_wit_3 : InsertObj_safety_wit_3.\n"
      },
      "proof_of_InsertObj_safety_wit_4": {
        "name": "proof_of_InsertObj_safety_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_safety_wit_4 : InsertObj_safety_wit_4.\n"
      },
      "proof_of_InsertObj_safety_wit_5": {
        "name": "proof_of_InsertObj_safety_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_safety_wit_5 : InsertObj_safety_wit_5.\n"
      },
      "proof_of_InsertObj_safety_wit_6": {
        "name": "proof_of_InsertObj_safety_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_safety_wit_6 : InsertObj_safety_wit_6.\n"
      },
      "proof_of_InsertObj_safety_wit_7": {
        "name": "proof_of_InsertObj_safety_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_safety_wit_7 : InsertObj_safety_wit_7.\n"
      },
      "proof_of_InsertObj_safety_wit_8": {
        "name": "proof_of_InsertObj_safety_wit_8",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_safety_wit_8 : InsertObj_safety_wit_8.\n"
      },
      "proof_of_InsertObj_safety_wit_9": {
        "name": "proof_of_InsertObj_safety_wit_9",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_safety_wit_9 : InsertObj_safety_wit_9.\n"
      },
      "proof_of_InsertObj_safety_wit_10": {
        "name": "proof_of_InsertObj_safety_wit_10",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_safety_wit_10 : InsertObj_safety_wit_10.\n"
      },
      "proof_of_InsertObj_partial_solve_wit_1_pure": {
        "name": "proof_of_InsertObj_partial_solve_wit_1_pure",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_partial_solve_wit_1_pure : InsertObj_partial_solve_wit_1_pure.\n"
      },
      "proof_of_InsertObj_partial_solve_wit_1": {
        "name": "proof_of_InsertObj_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_partial_solve_wit_1 : InsertObj_partial_solve_wit_1.\n"
      },
      "proof_of_InsertObj_partial_solve_wit_2_pure": {
        "name": "proof_of_InsertObj_partial_solve_wit_2_pure",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_partial_solve_wit_2_pure : InsertObj_partial_solve_wit_2_pure.\n"
      },
      "proof_of_InsertObj_partial_solve_wit_2": {
        "name": "proof_of_InsertObj_partial_solve_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_InsertObj_partial_solve_wit_2 : InsertObj_partial_solve_wit_2.\n"
      }
    },
    "top_level": [
      "proof_of_InsertObj_entail_wit_1",
      "proof_of_InsertObj_entail_wit_2",
      "proof_of_InsertObj_entail_wit_3_1",
      "proof_of_InsertObj_entail_wit_3_2",
      "proof_of_InsertObj_return_wit_1",
      "proof_of_InsertObj_safety_wit_1",
      "proof_of_InsertObj_safety_wit_2",
      "proof_of_InsertObj_safety_wit_3",
      "proof_of_InsertObj_safety_wit_4",
      "proof_of_InsertObj_safety_wit_5",
      "proof_of_InsertObj_safety_wit_6",
      "proof_of_InsertObj_safety_wit_7",
      "proof_of_InsertObj_safety_wit_8",
      "proof_of_InsertObj_safety_wit_9",
      "proof_of_InsertObj_safety_wit_10",
      "proof_of_InsertObj_partial_solve_wit_1_pure",
      "proof_of_InsertObj_partial_solve_wit_1",
      "proof_of_InsertObj_partial_solve_wit_2_pure",
      "proof_of_InsertObj_partial_solve_wit_2"
    ],
    "split_goals": {
      "proof_of_InsertObj_entail_wit_1": [],
      "proof_of_InsertObj_entail_wit_2": [],
      "proof_of_InsertObj_entail_wit_3_1": [
        "proof_of_InsertObj_entail_wit_3_1_split_goal_1",
        "proof_of_InsertObj_entail_wit_3_1_split_goal_spatial"
      ],
      "proof_of_InsertObj_entail_wit_3_2": [
        "proof_of_InsertObj_entail_wit_3_2_split_goal_spatial"
      ],
      "proof_of_InsertObj_return_wit_1": [
        "proof_of_InsertObj_return_wit_1_split_goal_spatial"
      ],
      "proof_of_InsertObj_safety_wit_1": [],
      "proof_of_InsertObj_safety_wit_2": [],
      "proof_of_InsertObj_safety_wit_3": [],
      "proof_of_InsertObj_safety_wit_4": [],
      "proof_of_InsertObj_safety_wit_5": [],
      "proof_of_InsertObj_safety_wit_6": [],
      "proof_of_InsertObj_safety_wit_7": [],
      "proof_of_InsertObj_safety_wit_8": [],
      "proof_of_InsertObj_safety_wit_9": [],
      "proof_of_InsertObj_safety_wit_10": [],
      "proof_of_InsertObj_partial_solve_wit_1_pure": [],
      "proof_of_InsertObj_partial_solve_wit_1": [],
      "proof_of_InsertObj_partial_solve_wit_2_pure": [],
      "proof_of_InsertObj_partial_solve_wit_2": []
    }
  },
  "max_witnesses_per_group": 12,
  "annotation_comparisons": [
    {
      "source": {
        "attempt": "InsertObj-vc-proving-r1:manager_open",
        "name": "proof_of_InsertObj_entail_wit_2",
        "annotation_location": "annotated_C/src/InsertObj.c:103 (head != 0)"
      },
      "current": [
        "proof_of_InsertObj_entail_wit_2"
      ],
      "old_gap": "The BSS bucket representation does not entail a nonzero selected bucket head; typed cell validity permits address zero.",
      "change": "Accepted predicate-nonzero-candidate-fe8c4261db5c supplies head nonzero in store_uninit_idbucket and both branches of store_idbucket_cases. Current whole VC preserves the same selected bucket, manager/bitmap and frame resources and both target shapes; the missing BSS-head fact now follows from its store_idbuckets premise via existing split/cases lemmas.",
      "result": "resolved"
    },
    {
      "source": {
        "attempt": "InsertObj-vc-proving-r1:bucket_insert_ready",
        "name": "proof_of_InsertObj_entail_wit_3_1",
        "annotation_location": "annotated_C/src/InsertObj.c:130 (&(idnode->link)!=0)"
      },
      "current": [
        "proof_of_InsertObj_entail_wit_3_1"
      ],
      "old_gap": "Detached ID-node ownership and idnode nonzero do not entail the abstract embedded link address nonzero; the empty-bucket branch has no accepted concrete offset bridge.",
      "change": "Propagated accepted store_sem_id_detached link-nonzero metadata through the first two Assert points. The current empty-bucket whole VC retains the original conclusion/resources/witnesses and now has the exact link-nonzero fact as PreH6 in both alternatives; no unsupported layout implication is required.",
      "result": "resolved"
    },
    {
      "source": {
        "attempt": "InsertObj-vc-proving-r1:bucket_insert_ready",
        "name": "proof_of_InsertObj_entail_wit_3_2",
        "annotation_location": "annotated_C/src/InsertObj.c:130 (&(idnode->link)!=0)"
      },
      "current": [
        "proof_of_InsertObj_entail_wit_3_2"
      ],
      "old_gap": "Detached ID-node ownership and idnode nonzero do not entail the abstract embedded link address nonzero; initialized bucket links provide no fact about the new node's link address.",
      "change": "Propagated accepted store_sem_id_detached link-nonzero metadata through the first two Assert points. The current initialized-bucket whole VC retains the original conclusion/resources/witnesses and now has the exact link-nonzero fact as PreH7 in both alternatives; existing DLL spatial conversion remains required.",
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
      "InsertObj-20261012130948",
      "--round",
      "InsertObj-vc-checking-r2"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
