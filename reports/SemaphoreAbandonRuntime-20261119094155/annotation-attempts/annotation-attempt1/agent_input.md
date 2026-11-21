# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "SemaphoreAbandonRuntime-annotation-r1",
  "round": "SemaphoreAbandonRuntime-annotation-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/semaphore/_SemaphoreAbandon.c",
    "formal_directory": "VC/semaphore",
    "formal_case_lib": "VC/semaphore/SemaphoreAbandonRuntime_lib.v",
    "goal_file": "VC/semaphore/SemaphoreAbandonRuntime_goal.v",
    "proof_auto_file": "VC/semaphore/SemaphoreAbandonRuntime_proof_auto.v",
    "proof_manual_file": "VC/semaphore/SemaphoreAbandonRuntime_proof_manual.v",
    "goal_check_file": "VC/semaphore/SemaphoreAbandonRuntime_goal_check.v",
    "case_name": "SemaphoreAbandonRuntime",
    "active_case_theory": "CRTOS_Verify.VC.semaphore"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/SemaphoreAbandonRuntime-20261119094155/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/SemaphoreAbandonRuntime-20261119094155/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos-verify/reports/SemaphoreAbandonRuntime-20261119094155/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify current canonical _SemaphoreAbandon semaphore_abandon_oc, reviewed Pop/Push runtime design predicate/spec 20261118-r1. Preserve invalid ID/missing ID -1, empty pending saturated count -3, count increment success, nonempty pending head wakeup success and outside-critical KTASK_ASSIGN only for wakeup. LinklistResumeSemaphore-20261119085215 now done/final-check+root .vo restored; use same canonical semaphore_head_ic contract. IdGetObj/IsDoubleLinkListEmpty are existing reused-spec boundaries; IRQ/CONTAINER_OF/KTASK_ASSIGN approved model boundaries; don't copy bodies or expand trusted. TrustBase .agents/skills/verify-an-os-function/references/TrustBase.md, default whitelist001 applies original observations. Source_root /home/xinra/crtoslatest readonly, current ILP32 configuration. Global lib/annotated C/VC organization only, no trial/module_context/new case-lib. User no cumulative proof limit, preauthorizes justified changes but actual independent reviews/checks must pass. No arbitrary assumptions or Require/Ensure changes. Only assigned manual spans handwritten; native generated auto retained; goal/auto/check tool-owned. Local controller tools/checks/debug; no private source via Rocq MCP after prior approval rejection. Keep .vo. Named continuation extraction if needed must preserve definitions and receive independent review/dependency rebuild, not new unproved premise. Existing SemaphoreObtainRuntime and LinklistResumeSemaphore proofs can be read as relevant resource/wand/state examples. Complete workflow final-check."
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/kernel/semaphore/_SemaphoreAbandon.c"
  ],
  "user_spec": {
    "functions": [
      "_SemaphoreAbandon"
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
      "SemaphoreAbandonRuntime-20261119094155",
      "--round",
      "SemaphoreAbandonRuntime-annotation-r1",
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
      "SemaphoreAbandonRuntime-20261119094155",
      "--round",
      "SemaphoreAbandonRuntime-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
