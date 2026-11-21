# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "LinklistSuspendSemaphore-annotation-r2",
  "round": "LinklistSuspendSemaphore-annotation-r2",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/pendlist/LinklistSuspend.c",
    "formal_directory": "VC/pendlist",
    "formal_case_lib": "VC/pendlist/LinklistSuspendSemaphore_lib.v",
    "goal_file": "VC/pendlist/LinklistSuspendSemaphore_goal.v",
    "proof_auto_file": "VC/pendlist/LinklistSuspendSemaphore_proof_auto.v",
    "proof_manual_file": "VC/pendlist/LinklistSuspendSemaphore_proof_manual.v",
    "goal_check_file": "VC/pendlist/LinklistSuspendSemaphore_goal_check.v",
    "case_name": "LinklistSuspendSemaphore",
    "active_case_theory": "CRTOS_Verify.VC.pendlist"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/annotation-attempts/annotation-attempt2/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/annotation-attempts/annotation-attempt2/agent_output.md",
  "feedback": "[\n  {\n    \"failure_class\": \"annotation-gap\",\n    \"kind\": \"missing-import\",\n    \"vcs\": [\n      {\n        \"name\": \"proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic\",\n        \"parent\": null,\n        \"annotation_location\": \"LinklistSuspend canonical C formal imports / generated shallow FuncSig and Spec prelude\"\n      }\n    ],\n    \"message\": \"Current generated goal fails to elaborate LinklistSuspend_sig at line 1824: pointer/struct ctype syntax is unavailable because the prelude does not import existing SimpleCtypeNotations. Import the existing SimpleC.CoreLang.CTypes.SimpleCtypeNotations module from the canonical C formal prelude and regenerate; preserve the current CRTOS assertion instance and derived-spec obligation. No mathematical premise or new assumption is requested. Actual subsequent elaboration remains to be checked.\",\n    \"repair_boundary\": \"C annotation import\"\n  }\n]",
  "feedback_sources": [
    {
      "phase": "vc-checking",
      "attempt_id": "LinklistSuspendSemaphore-vc-checking-r1",
      "evidence": [
        "/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-checking-r1/agent_report.json",
        "/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-checking-r1/agent_output.md"
      ]
    }
  ],
  "previous_attempt": "LinklistSuspendSemaphore-vc-checking-r1",
  "plan": "/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/annotation-attempts/annotation-attempt2/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify canonical LinklistSuspend current semaphore_ic and derived semaphore_prio_ic contracts, Pop/Push runtime closure. dq-pop-push-predicate/spec-20261118-r1 reviewed; shared header macro repair dq-runtime-align-decl-20261119-r1 independently reviewed behavior/spec preserving. Original crtoslatest full branch shape retained: invalid flag returns before suspension, FIFO inserts before head, priority loop breaks at first strictly lower priority; no sorted-list premise, equal priority remain before new task. IC nested lock removal per approved source processing. SuspendKTask and DLL insertion specs imported reused boundaries (check actual applicability and canonical interfaces, don't prove/copy bodies). CONTAINER_OF model existing boundary. Need actual loop invariant/ownership, original source readonly. Use current global library, no duplicate state model/trial/module_context. TrustBase .agents/skills/verify-an-os-function/references/TrustBase.md, default whitelist as applicable. User no cumulative proof limit, preapproves justified fixes with actual reviews/checks mandatory. Native auto/manual preserved; generated auto solver trust allowed; only assigned manual spans handwritten. Local controller checks/debug, no private source via Rocq MCP after previous rejection. Keep vo. First stage, Pop root and Tick leaf done/final-check; this new contract body is not yet proved. Complete workflow/final-check. Existing Prop obligations are not lemmas."
  },
  "failed_vcs": [
    {
      "source_attempt": "LinklistSuspendSemaphore-vc-checking-r1",
      "manual": "/home/xinra/crtos-verify/verification_runs/LinklistSuspendSemaphore-20261119031206/annotation_history/annotation-attempt1/after/VC/pendlist/LinklistSuspendSemaphore_proof_manual.v",
      "message": "Current generated goal fails to elaborate LinklistSuspend_sig at line 1824: pointer/struct ctype syntax is unavailable because the prelude does not import existing SimpleCtypeNotations. Import the existing SimpleC.CoreLang.CTypes.SimpleCtypeNotations module from the canonical C formal prelude and regenerate; preserve the current CRTOS assertion instance and derived-spec obligation. No mathematical premise or new assumption is requested. Actual subsequent elaboration remains to be checked.",
      "name": "proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic",
      "parent": null,
      "annotation_location": "LinklistSuspend canonical C formal imports / generated shallow FuncSig and Spec prelude"
    }
  ],
  "writable_files": [
    "annotated_C/src/kernel/pendlist/LinklistSuspend.c"
  ],
  "user_spec": {
    "functions": [
      "LinklistSuspend"
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
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-check",
      "--run",
      "LinklistSuspendSemaphore-20261119031206",
      "--round",
      "LinklistSuspendSemaphore-annotation-r2",
      "--target-kind",
      "formal-case-lib-design"
    ],
    "cwd": "/home/xinra/crtos-verify"
  },
  {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "symexec",
      "--run",
      "LinklistSuspendSemaphore-20261119031206",
      "--round",
      "LinklistSuspendSemaphore-annotation-r2"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
