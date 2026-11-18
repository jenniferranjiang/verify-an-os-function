# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "DeInitDataqueue-annotation-r1",
  "round": "DeInitDataqueue-annotation-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/dataqueue/DeInitDataqueue.c",
    "formal_directory": "VC/dataqueue",
    "formal_case_lib": "VC/dataqueue/DeInitDataqueue_lib.v",
    "goal_file": "VC/dataqueue/DeInitDataqueue_goal.v",
    "proof_auto_file": "VC/dataqueue/DeInitDataqueue_proof_auto.v",
    "proof_manual_file": "VC/dataqueue/DeInitDataqueue_proof_manual.v",
    "goal_check_file": "VC/dataqueue/DeInitDataqueue_goal_check.v",
    "case_name": "DeInitDataqueue",
    "active_case_theory": "CRTOS_Verify.VC.dataqueue"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos-verify/reports/DeInitDataqueue-20261118121138/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify approved map-based DeInitDataqueue init_cleanup only (unpublished private initialization rollback). User-authorized concrete dataqueue_layout_abi and prior IRQ resource boundary. KSemaphoreDelete IC is subsequent stage1 proof target, imported lower contracts remain reused boundaries. User explicitly permits Rocq MCP development and removes proof time budget. Only manual proof spans may be hand edited; generated goal/auto/check immutable. Similar justified annotation/model repairs preapproved, review still actual. Original crtoslatest read-only; preserve .vo."
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/kernel/dataqueue/DeInitDataqueue.c"
  ],
  "user_spec": {
    "functions": [
      "DeInitDataqueue"
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
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-annotation-r1",
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
      "DeInitDataqueue-20261118121138",
      "--round",
      "DeInitDataqueue-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
