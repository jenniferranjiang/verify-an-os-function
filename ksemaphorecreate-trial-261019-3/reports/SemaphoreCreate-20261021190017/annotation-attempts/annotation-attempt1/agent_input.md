# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "SemaphoreCreate-annotation-r1",
  "round": "SemaphoreCreate-annotation-r1",
  "main_root": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3",
  "target_files": {
    "c_file": "annotated_C/src/_SemaphoreCreate.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/SemaphoreCreate_lib.v",
    "goal_file": "VC/SemaphoreCreate_goal.v",
    "proof_auto_file": "VC/SemaphoreCreate_proof_auto.v",
    "proof_manual_file": "VC/SemaphoreCreate_proof_manual.v",
    "goal_check_file": "VC/SemaphoreCreate_goal_check.v",
    "case_name": "SemaphoreCreate",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Prove the current _SemaphoreCreate implementation against its frozen spec. The user requests implementation proof only for _SemaphoreCreate and KSemaphoreCreate and says helpers are already proved; reuse matching contracts without re-proving helpers. Trust boundary: /home/xinra/TrustBase.md. Shared semantic sources are frozen in checks/implement-frozen-inputs.json. Do not change predicate or contract semantics. The local controller adapts the CRTOS layout and uses Coq 8.20.1 with ARM32 little-endian QCP. Existing historical reviews predate current authorized changes and are not claimed current; report any actual semantic issue explicitly.",
    "target_function": "_SemaphoreCreate"
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/_SemaphoreCreate.c",
    "VC/SemaphoreCreate_lib.v"
  ],
  "user_spec": {
    "functions": [
      "CriticalAreaLock",
      "CriticalAreaUnLock",
      "DoubleLinkListInsertNodeAfter",
      "IdInsertObj",
      "InitDoubleLinkList",
      "KPrintf",
      "_SemaphoreCreate",
      "memset",
      "x_free",
      "x_malloc"
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
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-annotation-r1",
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
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-annotation-r1"
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
      "SemaphoreCreate-20261021190017",
      "--round",
      "SemaphoreCreate-annotation-r1",
      "--target-kind",
      "formal-case-lib"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
