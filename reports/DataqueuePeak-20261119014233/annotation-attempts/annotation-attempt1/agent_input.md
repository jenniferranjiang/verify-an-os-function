# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "DataqueuePeak-annotation-r1",
  "round": "DataqueuePeak-annotation-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/dataqueue/DataqueuePeak.c",
    "formal_directory": "VC/dataqueue",
    "formal_case_lib": "VC/dataqueue/DataqueuePeak_lib.v",
    "goal_file": "VC/dataqueue/DataqueuePeak_goal.v",
    "proof_auto_file": "VC/dataqueue/DataqueuePeak_proof_auto.v",
    "proof_manual_file": "VC/dataqueue/DataqueuePeak_proof_manual.v",
    "goal_check_file": "VC/dataqueue/DataqueuePeak_goal_check.v",
    "case_name": "DataqueuePeak",
    "active_case_theory": "CRTOS_Verify.VC.dataqueue"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/DataqueuePeak-20261119014233/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/DataqueuePeak-20261119014233/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos-verify/reports/DataqueuePeak-20261119014233/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify DataqueuePeak canonical current map+ABI spec: dq-predicate-map-20261117-r1/dq-spec-map-20261117-r1 and approved mapABI applicability. Actual scope one critical-section shared observation, empty returns -1 preserving optional output cells, nonempty returns0 copying front payload ptr/length without owning pointee. Existing approved source fix moves lock before front/rear read; source crtoslatest readonly. Use current global dataqueue_map os_inv, no new object model. CriticalAreaLock/UnLock existing trusted IRQ/API boundary. Default ReviewWhitelist001 applies dataqueue_peak_entry assertS, not VC exemption. TrustBase .agents/skills/verify-an-os-function/references/TrustBase.md. User removed all cumulative VC budgets and preapproved justified fixes, actual design reviews/checks remain. Preserve native auto/manual division and solver-trusted generated auto, no transfer. Only manual assigned spans handwritten, generated goal/auto/check tool-owned. No project source transmission via Rocq MCP after previous approval rejection; use local controller debug/check. Keep .vo. Existing InitDataqueue/DeInitDataqueue and all four SemaphoreCreate/Delete IC workflows now done; global libs unchanged. Formal no-case-lib policy, use current shared libs rather than duplicate models. Author/reviewer split and complete QCP workflow through final-check required."
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/kernel/dataqueue/DataqueuePeak.c"
  ],
  "user_spec": {
    "functions": [
      "DataqueuePeak"
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
      "DataqueuePeak-20261119014233",
      "--round",
      "DataqueuePeak-annotation-r1",
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
      "DataqueuePeak-20261119014233",
      "--round",
      "DataqueuePeak-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
