# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "KSemaphoreDeleteIC-annotation-r1",
  "round": "KSemaphoreDeleteIC-annotation-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/semaphore/KSemaphoreDelete.c",
    "formal_directory": "VC/semaphore",
    "formal_case_lib": "VC/semaphore/KSemaphoreDeleteIC_lib.v",
    "goal_file": "VC/semaphore/KSemaphoreDeleteIC_goal.v",
    "proof_auto_file": "VC/semaphore/KSemaphoreDeleteIC_proof_auto.v",
    "proof_manual_file": "VC/semaphore/KSemaphoreDeleteIC_proof_manual.v",
    "goal_check_file": "VC/semaphore/KSemaphoreDeleteIC_goal_check.v",
    "case_name": "KSemaphoreDeleteIC",
    "active_case_theory": "CRTOS_Verify.VC.semaphore"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/KSemaphoreDeleteIC-20261119013710/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/KSemaphoreDeleteIC-20261119013710/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos-verify/reports/KSemaphoreDeleteIC-20261119013710/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify canonical KSemaphoreDelete named dataqueue_cleanup_ic, default IC macro1, preserve OC path. Underlying _SemaphoreDelete IC just completed SemaphoreDeleteIC-20261118235913 done/final-check; quiescent init cleanup scope only. dq-semaphore-ic-canonical-20261118-r1 reviewed source/spec and current global map/ABI unchanged. Wrapper alone is target. TrustBase .agents/skills/verify-an-os-function/references/TrustBase.md. User removed cumulative proof budget, preapproved justified fixes; real checks required. Keep native QCP auto/manual division, generated auto solver trust permitted, no auto-to-manual transfer. Only assigned manual spans handwritten; no assumptions added. Use local controller debug/check, no private project source via Rocq MCP following prior approval rejection. Source crtoslatest readonly; keep .vo; no handwritten generated goal/auto/check changes. Main handles root build list and reports after done."
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/kernel/semaphore/KSemaphoreDelete.c"
  ],
  "user_spec": {
    "functions": [
      "KSemaphoreDelete"
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
      "KSemaphoreDeleteIC-20261119013710",
      "--round",
      "KSemaphoreDeleteIC-annotation-r1",
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
      "KSemaphoreDeleteIC-20261119013710",
      "--round",
      "KSemaphoreDeleteIC-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
