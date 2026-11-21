# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "SemaphoreDeleteIC-annotation-r1",
  "round": "SemaphoreDeleteIC-annotation-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/semaphore/_SemaphoreDelete.c",
    "formal_directory": "VC/semaphore",
    "formal_case_lib": "VC/semaphore/SemaphoreDeleteIC_lib.v",
    "goal_file": "VC/semaphore/SemaphoreDeleteIC_goal.v",
    "proof_auto_file": "VC/semaphore/SemaphoreDeleteIC_proof_auto.v",
    "proof_manual_file": "VC/semaphore/SemaphoreDeleteIC_proof_manual.v",
    "goal_check_file": "VC/semaphore/SemaphoreDeleteIC_goal_check.v",
    "case_name": "SemaphoreDeleteIC",
    "active_case_theory": "CRTOS_Verify.VC.semaphore"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos-verify/reports/SemaphoreDeleteIC-20261118235913/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify current canonical _SemaphoreDelete named dataqueue_cleanup_ic, default CRTOS_DATAQUEUE_SEMAPHORE_IC=1; preserve optional OC path and shared complete body. dq-semaphore-ic-canonical-20261118-r1 source/spec review passed. Scope quiescent private initialization cleanup, no pending waiters or published queue references; prove unreachable retained branches, do not delete them just to ease proofs. Current maps/global libs/ABI reviewed. Imported ID/DLL contracts and documented models remain boundaries, not new body targets. TrustBase .agents/skills/verify-an-os-function/references/TrustBase.md. User removed cumulative proof time limit and preapproved justified fixes; actual reviews/checks required. Native QCP auto/manual division unchanged, generated auto solver-trusted Admitted preserved, no transfer. Only manual assigned proof spans handwritten. No private-source transmission to Rocq MCP after prior approval rejection; use local controller checks/debug. Original crtoslatest readonly. Keep .vo, no manual edits generated goal/auto/check. Old OC SemaphoreDelete_lib may be stale; prefer current global library and full dataqueue frame. Follow workflow repair for real missing annotations, no ungrounded premises."
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
  ],
  "user_spec": {
    "functions": [
      "_SemaphoreDelete"
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
      "SemaphoreDeleteIC-20261118235913",
      "--round",
      "SemaphoreDeleteIC-annotation-r1",
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
      "SemaphoreDeleteIC-20261118235913",
      "--round",
      "SemaphoreDeleteIC-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
