# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "InitDataqueue-annotation-r1",
  "round": "InitDataqueue-annotation-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/dataqueue/InitDataqueue.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/InitDataqueue_lib.v",
    "goal_file": "VC/InitDataqueue_goal.v",
    "proof_auto_file": "VC/InitDataqueue_proof_auto.v",
    "proof_manual_file": "VC/InitDataqueue_proof_manual.v",
    "goal_check_file": "VC/InitDataqueue_goal_check.v",
    "case_name": "InitDataqueue",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/InitDataqueue-20261117003811/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/InitDataqueue-20261117003811/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos-verify/reports/InitDataqueue-20261117003811/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {},
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/kernel/dataqueue/InitDataqueue.c"
  ],
  "user_spec": {
    "functions": [
      "InitDataqueue"
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
      "InitDataqueue-20261117003811",
      "--round",
      "InitDataqueue-annotation-r1",
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
      "InitDataqueue-20261117003811",
      "--round",
      "InitDataqueue-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
