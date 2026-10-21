# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "_SemaphoreCreate-annotation-r2",
  "round": "_SemaphoreCreate-annotation-r2",
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
  "report": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/annotation-attempts/annotation-attempt2/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/annotation-attempts/annotation-attempt2/agent_output.md",
  "feedback": "[\n  {\n    \"failure_class\": \"dependency-gap\",\n    \"kind\": \"missing_formal_sizeof_layout_bridge\",\n    \"vcs\": [\n      {\n        \"name\": \"proof_of__SemaphoreCreate_partial_solve_wit_1_pure\",\n        \"parent\": null,\n        \"annotation_location\": \"annotated_C/src/_SemaphoreCreate.c:121 (x_malloc Require at line 31)\"\n      },\n      {\n        \"name\": \"proof_of__SemaphoreCreate_partial_solve_wit_2_pure\",\n        \"parent\": null,\n        \"annotation_location\": \"annotated_C/src/_SemaphoreCreate.c:125 (memset Require at line 37)\"\n      }\n    ],\n    \"message\": \"Both non-split pure top-level goals require sizeof(\\\"Semaphore\\\") = 32. Official CNotation interprets this as the unconstrained Parameter sizeof_alias_type \\\"Semaphore\\\"; no current premise or imported layout fact fixes it to 32. Interpret that Parameter as 64 while retaining valid disjoint scalar locals, an empty-stack OutsideCritical state at nest zero, and (for witness 2) the independently literal 32-byte allocated block. Each antecedent can hold while its consequent is false. The unsuffixed pure -> aux goals are not classified as false by this argument.\",\n    \"repair_boundary\": \"Return to annotation/spec/source-extraction owner for an authorized, independently checked source-to-formal layout repair or exact compile-time constant normalization, with any changed semantic input revision rebound. Preserve frozen contracts and real three-path/critical/IRQ/task/scheduler behavior. Do not add an unproved layout axiom or Require premise, edit canonical generated goals, or ask a group worker to prove these false raw obligations.\"\n  }\n]",
  "feedback_sources": [
    {
      "phase": "vc-checking",
      "attempt_id": "_SemaphoreCreate-vc-checking-r1",
      "evidence": [
        "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-checking-r1/agent_report.json",
        "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-checking-r1/agent_output.md"
      ]
    }
  ],
  "previous_attempt": "_SemaphoreCreate-vc-checking-r1",
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
  "plan": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/annotation-attempts/annotation-attempt2/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify CRTOS KSemaphoreCreate under the accepted source/config and predicates/specs.\nAuthoritative accepted inputs: evidence/accepted-revisions.json.\nSource: source-r2-0c50c37013e9, Cortex-M3 Thumb ILP32, STM32F103 nano, non-SMP.\nPredicate: predicate-r3-16b6ee4a4e02, independently review-passed.\nSpec: spec-r2-6d54bb88379e, independently review-passed.\nDomain: entry scheduler_lock_nest < 65535, explicitly authorized by user.\nPreserve ordinary nested calls and exact caller IRQ/heap ownership.\n\nThe complete required non-trusted closure has nine unique canonical active bodies:\nannotated_C/src/KSemaphoreCreate.c\nannotated_C/src/_SemaphoreCreate.c\nannotated_C/src/CriticalAreaLock.c\nannotated_C/src/CriticalAreaUnLock.c\nannotated_C/src/IdInsertObj.c\nannotated_C/src/AllocId.c\nannotated_C/src/InsertObj.c\nannotated_C/src/InitDoubleLinkList.c\nannotated_C/src/DoubleLinkListInsertNodeAfter.c\nAll canonical contracts and caller-local API copies are frozen accepted inputs.\nOnly these six C symbols are trusted, with the existing reviewed contracts:\nx_malloc, x_free, memset, DisableLocalInterrupt, EnableLocalInterrupt, KPrintf.\nDeclaration contracts do not constitute verified callee bodies.\n\nAbsolutely do not read, enumerate, search, copy, import, or depend on any file in\n/home/xinra/crtos/ksemaphorecreate-trial-260928-1.\nThis includes ancestor-root searches, load paths, proof lookup and dependency closure.\nNo other historical trial is an authorized formal/proof reference.\nDo not change root shared library definitions, authoritative C/config, or any skills.\nOnly this new trial and already authorized project path configuration may be changed.\nDo not create a second active body for a canonical symbol or a central specs header.\nDo not add axioms, parameters, Admitted/admit, placeholders, weaker postconditions,\nunjustified stronger preconditions, deleted paths or omitted VCs.\n\nThe user authorizes automatic acceptance of independently reviewed, machine-checked\npredicate/spec revisions within the approved semantics. Such changes must return to\nthe appropriate independent design review and bind new manifests before resuming.\nMaterial semantic changes require explicit user authorization. No routine phase gate\nrequires another user confirmation.\n\nMain must follow only the verification-orchestrator controller actions. If the current\ncontroller does not support this CRTOS trial layout, retain its original blocker;\ndo not improvise another implementation workflow.\nCompletion additionally requires complete closure proofs, goal checks, full coqchk,\ntrust scan, C/VC/proof integrity, and a final integrity record. Historical 172 VCs is\nonly a diagnostic baseline, never a target for deleting or weakening obligations.\n\nExplicit user exception (2026-10-12): \u5141\u8bb8\u5728\u65b0 trial \u5185\u9002\u914d controller.\nThe local controller adapter may support canonical annotated_C/src and VC paths,\nread-only existing external dependencies, and the full nine-case closure. Preserve\nall original owner, symbolic, acceptance, proof and final-check actions.",
    "target_function": "_SemaphoreCreate"
  },
  "failed_vcs": [
    {
      "source_attempt": "_SemaphoreCreate-vc-checking-r1",
      "manual": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/annotation_history/annotation-attempt1/after/VC/_SemaphoreCreate_proof_manual.v",
      "message": "Both non-split pure top-level goals require sizeof(\"Semaphore\") = 32. Official CNotation interprets this as the unconstrained Parameter sizeof_alias_type \"Semaphore\"; no current premise or imported layout fact fixes it to 32. Interpret that Parameter as 64 while retaining valid disjoint scalar locals, an empty-stack OutsideCritical state at nest zero, and (for witness 2) the independently literal 32-byte allocated block. Each antecedent can hold while its consequent is false. The unsuffixed pure -> aux goals are not classified as false by this argument.",
      "name": "proof_of__SemaphoreCreate_partial_solve_wit_1_pure",
      "parent": null,
      "annotation_location": "annotated_C/src/_SemaphoreCreate.c:121 (x_malloc Require at line 31)"
    },
    {
      "source_attempt": "_SemaphoreCreate-vc-checking-r1",
      "manual": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/annotation_history/annotation-attempt1/after/VC/_SemaphoreCreate_proof_manual.v",
      "message": "Both non-split pure top-level goals require sizeof(\"Semaphore\") = 32. Official CNotation interprets this as the unconstrained Parameter sizeof_alias_type \"Semaphore\"; no current premise or imported layout fact fixes it to 32. Interpret that Parameter as 64 while retaining valid disjoint scalar locals, an empty-stack OutsideCritical state at nest zero, and (for witness 2) the independently literal 32-byte allocated block. Each antecedent can hold while its consequent is false. The unsuffixed pure -> aux goals are not classified as false by this argument.",
      "name": "proof_of__SemaphoreCreate_partial_solve_wit_2_pure",
      "parent": null,
      "annotation_location": "annotated_C/src/_SemaphoreCreate.c:125 (memset Require at line 37)"
    }
  ],
  "writable_files": [
    "annotated_C/src/_SemaphoreCreate.c"
  ],
  "user_spec": {
    "functions": [
      "CriticalAreaLock",
      "CriticalAreaUnLock",
      "DoubleLinkListInsertNodeAfter",
      "IdInsertObj",
      "InitDoubleLinkList",
      "_SemaphoreCreate",
      "memset",
      "x_free",
      "x_malloc"
    ],
    "frozen": true
  }
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
      "coq-check",
      "--run",
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-annotation-r2",
      "--target-kind",
      "formal-case-lib-design"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  },
  {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "symexec",
      "--run",
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-annotation-r2"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
