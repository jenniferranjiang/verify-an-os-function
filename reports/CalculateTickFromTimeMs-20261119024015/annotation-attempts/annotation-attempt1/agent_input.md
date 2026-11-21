# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "CalculateTickFromTimeMs-annotation-r1",
  "round": "CalculateTickFromTimeMs-annotation-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/common/CalculateTickFromTimeMs.c",
    "formal_directory": "VC/common",
    "formal_case_lib": "VC/common/CalculateTickFromTimeMs_lib.v",
    "goal_file": "VC/common/CalculateTickFromTimeMs_goal.v",
    "proof_auto_file": "VC/common/CalculateTickFromTimeMs_proof_auto.v",
    "proof_manual_file": "VC/common/CalculateTickFromTimeMs_proof_manual.v",
    "goal_check_file": "VC/common/CalculateTickFromTimeMs_goal_check.v",
    "case_name": "CalculateTickFromTimeMs",
    "active_case_theory": "CRTOS_Verify.VC.common"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos-verify/reports/CalculateTickFromTimeMs-20261119024015/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify current CalculateTickFromTimeMs canonical, new Pop/Push runtime closure leaf (not reused old32bit spec). Reviewed dq-pop-push-predicate/spec-20261118-r1 current100Hz crtoslatest; uint64 cast before multiply, unsigned32 input, quotient cast uint32, min1 and original rem5..9 conditional must remain. tick_from_time_ms exact existing abstract definition, Require emp unchanged. No new library semantics needed. First stage and Pop root done/final-check; Pop closure pending. TrustBase .agents/skills/verify-an-os-function/references/TrustBase.md. User no cumulative proof time budget, preapproved justified fixes with actual review/checks required. Keep native auto/manual solver division; generated auto solver trust permitted, only manual assigned spans handwritten, no generated edits. No private source payload via Rocq MCP after previous rejection; use local controller checks/debug. Source root readonly, keep vo. Imported library abstract Prop not assumed. No trial or copied body. Complete workflow/final-check."
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/kernel/common/CalculateTickFromTimeMs.c"
  ],
  "user_spec": {
    "functions": [
      "CalculateTickFromTimeMs"
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
      "CalculateTickFromTimeMs-20261119024015",
      "--round",
      "CalculateTickFromTimeMs-annotation-r1",
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
      "CalculateTickFromTimeMs-20261119024015",
      "--round",
      "CalculateTickFromTimeMs-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
