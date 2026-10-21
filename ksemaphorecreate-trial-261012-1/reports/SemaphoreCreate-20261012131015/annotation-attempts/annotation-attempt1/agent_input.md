# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "_SemaphoreCreate-annotation-r1",
  "round": "_SemaphoreCreate-annotation-r1",
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
  "report": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/annotation-attempts/annotation-attempt1/agent_output.md",
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
  "plan": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify CRTOS KSemaphoreCreate under the accepted source/config and predicates/specs.\nAuthoritative accepted inputs: evidence/accepted-revisions.json.\nSource: source-r2-0c50c37013e9, Cortex-M3 Thumb ILP32, STM32F103 nano, non-SMP.\nPredicate: predicate-r3-16b6ee4a4e02, independently review-passed.\nSpec: spec-r2-6d54bb88379e, independently review-passed.\nDomain: entry scheduler_lock_nest < 65535, explicitly authorized by user.\nPreserve ordinary nested calls and exact caller IRQ/heap ownership.\n\nThe complete required non-trusted closure has nine unique canonical active bodies:\nannotated_C/src/KSemaphoreCreate.c\nannotated_C/src/_SemaphoreCreate.c\nannotated_C/src/CriticalAreaLock.c\nannotated_C/src/CriticalAreaUnLock.c\nannotated_C/src/IdInsertObj.c\nannotated_C/src/AllocId.c\nannotated_C/src/InsertObj.c\nannotated_C/src/InitDoubleLinkList.c\nannotated_C/src/DoubleLinkListInsertNodeAfter.c\nAll canonical contracts and caller-local API copies are frozen accepted inputs.\nOnly these six C symbols are trusted, with the existing reviewed contracts:\nx_malloc, x_free, memset, DisableLocalInterrupt, EnableLocalInterrupt, KPrintf.\nDeclaration contracts do not constitute verified callee bodies.\n\nAbsolutely do not read, enumerate, search, copy, import, or depend on any file in\n/home/xinra/crtos/ksemaphorecreate-trial-260928-1.\nThis includes ancestor-root searches, load paths, proof lookup and dependency closure.\nNo other historical trial is an authorized formal/proof reference.\nDo not change root shared library definitions, authoritative C/config, or any skills.\nOnly this new trial and already authorized project path configuration may be changed.\nDo not create a second active body for a canonical symbol or a central specs header.\nDo not add axioms, parameters, Admitted/admit, placeholders, weaker postconditions,\nunjustified stronger preconditions, deleted paths or omitted VCs.\n\nThe user authorizes automatic acceptance of independently reviewed, machine-checked\npredicate/spec revisions within the approved semantics. Such changes must return to\nthe appropriate independent design review and bind new manifests before resuming.\nMaterial semantic changes require explicit user authorization. No routine phase gate\nrequires another user confirmation.\n\nMain must follow only the verification-orchestrator controller actions. If the current\ncontroller does not support this CRTOS trial layout, retain its original blocker;\ndo not improvise another implementation workflow.\nCompletion additionally requires complete closure proofs, goal checks, full coqchk,\ntrust scan, C/VC/proof integrity, and a final integrity record. Historical 172 VCs is\nonly a diagnostic baseline, never a target for deleting or weakening obligations.\n\nExplicit user exception (2026-10-12): \u5141\u8bb8\u5728\u65b0 trial \u5185\u9002\u914d controller.\nThe local controller adapter may support canonical annotated_C/src and VC paths,\nread-only existing external dependencies, and the full nine-case closure. Preserve\nall original owner, symbolic, acceptance, proof and final-check actions.",
    "target_function": "_SemaphoreCreate"
  },
  "failed_vcs": [],
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
      "_SemaphoreCreate-annotation-r1",
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
      "_SemaphoreCreate-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
