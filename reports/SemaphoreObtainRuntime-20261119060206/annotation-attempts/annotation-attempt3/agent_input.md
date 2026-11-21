# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "SemaphoreObtainRuntime-annotation-r3",
  "round": "SemaphoreObtainRuntime-annotation-r3",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/semaphore/_SemaphoreObtain.c",
    "formal_directory": "VC/semaphore",
    "formal_case_lib": "VC/semaphore/SemaphoreObtainRuntime_lib.v",
    "goal_file": "VC/semaphore/SemaphoreObtainRuntime_goal.v",
    "proof_auto_file": "VC/semaphore/SemaphoreObtainRuntime_proof_auto.v",
    "proof_manual_file": "VC/semaphore/SemaphoreObtainRuntime_proof_manual.v",
    "goal_check_file": "VC/semaphore/SemaphoreObtainRuntime_goal_check.v",
    "case_name": "SemaphoreObtainRuntime",
    "active_case_theory": "CRTOS_Verify.VC.semaphore"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/annotation-attempts/annotation-attempt3/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/annotation-attempts/annotation-attempt3/agent_output.md",
  "feedback": "vc_comparisons[0] annotation location differs from the failed VC",
  "feedback_sources": [
    {
      "phase": "vc-checking",
      "attempt_id": "SemaphoreObtainRuntime-vc-checking-r3",
      "evidence": [
        "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-checking-r3/agent_report.json",
        "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/rounds/SemaphoreObtainRuntime-vc-checking-r3/agent_output.md"
      ]
    }
  ],
  "previous_attempt": "SemaphoreObtainRuntime-vc-checking-r3",
  "plan": "/home/xinra/crtos-verify/reports/SemaphoreObtainRuntime-20261119060206/annotation-attempts/annotation-attempt3/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify current canonical _SemaphoreObtain semaphore_obtain_oc, reviewed Pop/Push runtime closure dq-pop-push-predicate/spec-20261118-r1. Current Tick conversion and LinklistSuspendSemaphore including semaphore_prio_ic derived entail now done/final-check; use exact caller contracts. Full id/msec errors, positive value decrement, immediate timeout, running task exstatus clear, priority suspend, finite delay failure rollback, infinite/finite scheduling and protected resumed exstatus read all retained. No blocking termination guarantee beyond current partial-correctness spec. IdGetObj/GetKTaskDescriptor/KTaskSetDelay/KTaskWakeup imported contracts are reused boundaries; IRQ/KTASK_ASSIGN/CONTAINER_OF approved model boundaries; do not copy bodies or silently trust new symbols. Real registered task call applicability still must prove. TrustBase .agents/skills/verify-an-os-function/references/TrustBase.md, whitelist001 applies original assertS observations only. Shared runtime header macro fix reviewed dq-runtime-align-decl-20261119-r1. Canonical body original reviewed repaired/adapted version, source_root readonly. User no proof time limit, justified modifications preapproved but real reviews/checks required; no arbitrary Require/Ensure or assumptions. Keep global organization, no trial/module_context/body analysis copies. Only assigned manual proof spans handwritten, native auto solver-trusted generation kept unchanged. Local controller checks/debug, no private source via Rocq MCP after prior approval rejection. Keep vo. Missing named continuation/library interfaces must request narrow design author+review, not invent unproved obligations. Complete full workflow/final-check."
  },
  "failed_vcs": [
    {
      "source_attempt": "SemaphoreObtainRuntime-vc-checking-r3",
      "manual": "/home/xinra/crtos-verify/verification_runs/SemaphoreObtainRuntime-20261119060206/annotation_history/annotation-attempt2/after/VC/semaphore/SemaphoreObtainRuntime_proof_manual.v",
      "message": "The unchanged whole VC requires assignRunningTask(os_assign held) <> 0 in both consequent alternatives before LinklistSuspend, but current os_inv, admissibility and the universal future-delay condition do not establish it. A registered task at base zero with wait_time = -1 is not excluded by these premises. The prior task_prepare annotation gap remains unresolved.",
      "name": "proof_of__SemaphoreObtain_entail_wit_8",
      "parent": null,
      "annotation_location": "annotated_C/src/kernel/semaphore/_SemaphoreObtain.c:260-263 (pre-LinklistSuspend task focus Assert)"
    }
  ],
  "writable_files": [
    "annotated_C/src/kernel/semaphore/_SemaphoreObtain.c"
  ],
  "user_spec": {
    "functions": [
      "_SemaphoreObtain"
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
      "SemaphoreObtainRuntime-20261119060206",
      "--round",
      "SemaphoreObtainRuntime-annotation-r3",
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
      "SemaphoreObtainRuntime-20261119060206",
      "--round",
      "SemaphoreObtainRuntime-annotation-r3"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
