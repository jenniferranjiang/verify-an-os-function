# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "SemaphoreCreateIC-annotation-r1",
  "round": "SemaphoreCreateIC-annotation-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/semaphore/_SemaphoreCreate.c",
    "formal_directory": "VC/semaphore",
    "formal_case_lib": "VC/semaphore/SemaphoreCreateIC_lib.v",
    "goal_file": "VC/semaphore/SemaphoreCreateIC_goal.v",
    "proof_auto_file": "VC/semaphore/SemaphoreCreateIC_proof_auto.v",
    "proof_manual_file": "VC/semaphore/SemaphoreCreateIC_proof_manual.v",
    "goal_check_file": "VC/semaphore/SemaphoreCreateIC_goal_check.v",
    "case_name": "SemaphoreCreateIC",
    "active_case_theory": "CRTOS_Verify.VC.semaphore"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos-verify/reports/SemaphoreCreateIC-20261118193701/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify _SemaphoreCreate named dataqueue_ic implementation at canonical existing source, default CRTOS_DATAQUEUE_SEMAPHORE_IC=1. Independent source/spec review passed; one shared body, nested lock removal per approved OS source-processing. Preserve optional original OC path. Current globals/maps/ABI reviewed. Imported ID/DLL contracts are reused-spec boundaries, not body targets. Native QCP auto/manual division must remain unchanged, generated auto Admitted allowed as user-accepted solver trust; only manual goals need handwritten proof. User removed time budget and preapproved justified design fixes, real reviews remain. Local controller proofs, no project source transmission to Rocq MCP after approval denial. Keep .vo, readonly crtoslatest. Do not handedit generated goal/auto/check."
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/kernel/semaphore/_SemaphoreCreate.c"
  ],
  "user_spec": {
    "functions": [
      "_SemaphoreCreate"
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
      "SemaphoreCreateIC-20261118193701",
      "--round",
      "SemaphoreCreateIC-annotation-r1",
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
      "SemaphoreCreateIC-20261118193701",
      "--round",
      "SemaphoreCreateIC-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
