# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "KSemaphoreObtainRuntime-annotation-r1",
  "round": "KSemaphoreObtainRuntime-annotation-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/semaphore/KSemaphoreObtain.c",
    "formal_directory": "VC/semaphore",
    "formal_case_lib": "VC/semaphore/KSemaphoreObtainRuntime_lib.v",
    "goal_file": "VC/semaphore/KSemaphoreObtainRuntime_goal.v",
    "proof_auto_file": "VC/semaphore/KSemaphoreObtainRuntime_proof_auto.v",
    "proof_manual_file": "VC/semaphore/KSemaphoreObtainRuntime_proof_manual.v",
    "goal_check_file": "VC/semaphore/KSemaphoreObtainRuntime_goal_check.v",
    "case_name": "KSemaphoreObtainRuntime",
    "active_case_theory": "CRTOS_Verify.VC.semaphore"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/KSemaphoreObtainRuntime-20261119084641/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/KSemaphoreObtainRuntime-20261119084641/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos-verify/reports/KSemaphoreObtainRuntime-20261119084641/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify current canonical KSemaphoreObtain wrapper semaphore_obtain_oc. Reviewed runtime predicate/spec dq-pop-push-20261118-r1, latest KObtain continuation extraction definitionally equal and reviewed. Callee _SemaphoreObtain now done/final-check in SemaphoreObtainRuntime-20261119060206 with root .vo restored; ensure caller exact contract consistency. Static done dispatch only, source_root /home/xinra/crtoslatest readonly. TrustBase .agents/skills/verify-an-os-function/references/TrustBase.md and default whitelist apply. User authorizes justified modifications, no cumulative proof time limit; actual reviews/checks required. No arbitrary strengthening/weakening/axioms/new trusted symbols. Keep global organization and native generated auto/manual split; handwritten proofs only assigned manual spans. Use local controller checks/debug, no private-source Rocq MCP payload after approval rejection. Keep .vo, complete workflow final-check."
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/kernel/semaphore/KSemaphoreObtain.c"
  ],
  "user_spec": {
    "functions": [
      "KSemaphoreObtain"
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
      "KSemaphoreObtainRuntime-20261119084641",
      "--round",
      "KSemaphoreObtainRuntime-annotation-r1",
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
      "KSemaphoreObtainRuntime-20261119084641",
      "--round",
      "KSemaphoreObtainRuntime-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
