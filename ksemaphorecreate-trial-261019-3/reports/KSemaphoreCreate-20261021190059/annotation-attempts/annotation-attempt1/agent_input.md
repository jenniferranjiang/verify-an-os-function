# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "KSemaphoreCreate-annotation-r1",
  "round": "KSemaphoreCreate-annotation-r1",
  "main_root": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
  "target_files": {
    "c_file": "annotated_C/src/KSemaphoreCreate.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/KSemaphoreCreate_lib.v",
    "goal_file": "VC/KSemaphoreCreate_goal.v",
    "proof_auto_file": "VC/KSemaphoreCreate_proof_auto.v",
    "proof_manual_file": "VC/KSemaphoreCreate_proof_manual.v",
    "goal_check_file": "VC/KSemaphoreCreate_goal_check.v",
    "case_name": "KSemaphoreCreate",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/KSemaphoreCreate-20261021190059/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/KSemaphoreCreate-20261021190059/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/KSemaphoreCreate-20261021190059/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Prove current KSemaphoreCreate wrapper against its frozen spec; use the matching _SemaphoreCreate declaration contract. The separate _SemaphoreCreate run must succeed before reporting the combined API verified. User requests only these two functions, no helper re-proofs. Trust boundary: /home/xinra/TrustBase.md. Shared semantic sources are frozen in checks/implement-frozen-inputs.json. Do not change predicates or contract semantics. Local adapter uses trial _CoqProject and ARM32 little-endian QCP. Current authorization is implement, historical reviews are not asserted current; report actual semantic issues.",
    "target_function": "KSemaphoreCreate"
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/KSemaphoreCreate.c",
    "VC/KSemaphoreCreate_lib.v"
  ],
  "user_spec": {
    "functions": [
      "KSemaphoreCreate",
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
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-check",
      "--run",
      "KSemaphoreCreate-20261021190059",
      "--round",
      "KSemaphoreCreate-annotation-r1",
      "--target-kind",
      "formal-case-lib-design"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  },
  {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "symexec",
      "--run",
      "KSemaphoreCreate-20261021190059",
      "--round",
      "KSemaphoreCreate-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  },
  {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
      "coq-check",
      "--run",
      "KSemaphoreCreate-20261021190059",
      "--round",
      "KSemaphoreCreate-annotation-r1",
      "--target-kind",
      "formal-case-lib"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
