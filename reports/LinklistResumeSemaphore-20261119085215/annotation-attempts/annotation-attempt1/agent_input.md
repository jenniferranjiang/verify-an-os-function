# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "LinklistResumeSemaphore-annotation-r1",
  "round": "LinklistResumeSemaphore-annotation-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/semaphore/LinklistResume.c",
    "formal_directory": "VC/semaphore",
    "formal_case_lib": "VC/semaphore/LinklistResumeSemaphore_lib.v",
    "goal_file": "VC/semaphore/LinklistResumeSemaphore_goal.v",
    "proof_auto_file": "VC/semaphore/LinklistResumeSemaphore_proof_auto.v",
    "proof_manual_file": "VC/semaphore/LinklistResumeSemaphore_proof_manual.v",
    "goal_check_file": "VC/semaphore/LinklistResumeSemaphore_goal_check.v",
    "case_name": "LinklistResumeSemaphore",
    "active_case_theory": "CRTOS_Verify.VC.semaphore"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify canonical LinklistResume semaphore_head_ic, reviewed Pop/Push runtime closure predicate/spec 20261118-r1. Current source_root /home/xinra/crtoslatest readonly, existing IC nested-lock adaptation approved; retain true pending head wakeup behavior and no exstatus write. KTaskWakeup contracts reused from existing canonical LinklistResumeAll.c; applicability/id registration/pending-head identity must prove, do not copy/prove imported function bodies. CONTAINER_OF approved model boundary. Existing global lib only, no new case-lib/trial/module_context. TrustBase .agents/skills/verify-an-os-function/references/TrustBase.md and default review whitelist apply. User no cumulative proof time limit, justified changes preauthorized but actual independent design checks required. Do not add arbitrary Require/Ensure changes, axioms, trusted functions. Only assigned manual proof spans handwritten, generated goal/auto/check tool-owned; retain native auto. Use local controller tools/debug, no private source Rocq MCP after prior approval rejection. Keep .vo. Derivative spec declarations imported do not become new body targets. If necessary evaluate-once argument split needs narrow source-equivalence review; no algorithm changes silently. Complete workflow final-check."
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/kernel/semaphore/LinklistResume.c"
  ],
  "user_spec": {
    "functions": [
      "LinklistResume"
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
      "LinklistResumeSemaphore-20261119085215",
      "--round",
      "LinklistResumeSemaphore-annotation-r1",
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
      "LinklistResumeSemaphore-20261119085215",
      "--round",
      "LinklistResumeSemaphore-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
