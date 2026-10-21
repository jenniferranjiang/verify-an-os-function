# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "CriticalAreaLock-vc-checking-r2",
  "round": "CriticalAreaLock-vc-checking-r2",
  "main_root": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
  "target_files": {
    "c_file": "annotated_C/src/CriticalAreaLock.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/CriticalAreaLock_lib.v",
    "goal_file": "VC/CriticalAreaLock_goal.v",
    "proof_auto_file": "VC/CriticalAreaLock_proof_auto.v",
    "proof_manual_file": "VC/CriticalAreaLock_proof_manual.v",
    "goal_check_file": "VC/CriticalAreaLock_goal_check.v",
    "case_name": "CriticalAreaLock",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaLock-20261012130948/rounds/CriticalAreaLock-vc-checking-r2/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaLock-20261012130948/rounds/CriticalAreaLock-vc-checking-r2/agent_output.md",
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
  "shared_input_note": "Current accepted manifests supersede historical revision labels in the original problem statement; semantic goals and frozen function contracts remain required.",
  "group_plan": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaLock-20261012130948/rounds/CriticalAreaLock-vc-checking-r2/group_plan.json",
  "debug_manual": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/CriticalAreaLock-20261012130948/rounds/CriticalAreaLock-vc-checking-r2/CriticalAreaLock_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_CriticalAreaLock_entail_wit_1_split_goal_1": {
        "name": "proof_of_CriticalAreaLock_entail_wit_1_split_goal_1",
        "parent": "proof_of_CriticalAreaLock_entail_wit_1",
        "statement": "Lemma proof_of_CriticalAreaLock_entail_wit_1_split_goal_1 : CriticalAreaLock_entail_wit_1_split_goal_1.\n"
      },
      "proof_of_CriticalAreaLock_entail_wit_1_split_goal_spatial": {
        "name": "proof_of_CriticalAreaLock_entail_wit_1_split_goal_spatial",
        "parent": "proof_of_CriticalAreaLock_entail_wit_1",
        "statement": "Lemma proof_of_CriticalAreaLock_entail_wit_1_split_goal_spatial : CriticalAreaLock_entail_wit_1_split_goal_spatial.\n"
      },
      "proof_of_CriticalAreaLock_entail_wit_1": {
        "name": "proof_of_CriticalAreaLock_entail_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_CriticalAreaLock_entail_wit_1 : CriticalAreaLock_entail_wit_1.\n"
      },
      "proof_of_CriticalAreaLock_return_wit_1": {
        "name": "proof_of_CriticalAreaLock_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_CriticalAreaLock_return_wit_1 : CriticalAreaLock_return_wit_1.\n"
      },
      "proof_of_CriticalAreaLock_partial_solve_wit_1": {
        "name": "proof_of_CriticalAreaLock_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_CriticalAreaLock_partial_solve_wit_1 : CriticalAreaLock_partial_solve_wit_1.\n"
      }
    },
    "top_level": [
      "proof_of_CriticalAreaLock_entail_wit_1",
      "proof_of_CriticalAreaLock_return_wit_1",
      "proof_of_CriticalAreaLock_partial_solve_wit_1"
    ],
    "split_goals": {
      "proof_of_CriticalAreaLock_entail_wit_1": [
        "proof_of_CriticalAreaLock_entail_wit_1_split_goal_1",
        "proof_of_CriticalAreaLock_entail_wit_1_split_goal_spatial"
      ],
      "proof_of_CriticalAreaLock_return_wit_1": [],
      "proof_of_CriticalAreaLock_partial_solve_wit_1": []
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
      "CriticalAreaLock-20261012130948",
      "--round",
      "CriticalAreaLock-vc-checking-r2"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
