# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "KSemaphoreCreate-annotation-r1",
  "round": "KSemaphoreCreate-annotation-r1",
  "main_root": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
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
  "report": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/KSemaphoreCreate-20261022181446/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/KSemaphoreCreate-20261022181446/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/reports/KSemaphoreCreate-20261022181446/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "The user explicitly requests implementation proofs ONLY for KSemaphoreCreate and _SemaphoreCreate in this new trial, keeping the selected VRTOS callee specs unchanged. This is modular verification under external helper contracts; do not reprove helper C or claim full transitive implementation closure. VRTOS text alignment is checked by checks/check_vrtos_specs.py (9 interfaces, 16 copies). Public function specs and all callee specs are frozen. Preserve the uint16 by-local range fact in _SemaphoreCreate. Keep C executable semantics, LittleEndian and global model unchanged. Old trial and VRTOS are read-only.\nThe user explicitly approved checked ABI assumptions and their placement with memory predicates as in LiteOS. The sole added field-offset axiom is TrialShared.SemaphoreInv.semaphore_field_offsets_trusted; record checks/abi-authorization.json. No new assumptions/axioms/admissions may be added. checks/implement-frozen-inputs.json freezes semantic inputs.\nUseful compiled bridge libraries (import in the active case-lib seed before group proving): KSemaphoreCreateTrial.SemaphoreByteLayout (semaphore_zero_bytes_object, takes layout + malloc positivity/bound/alignment and preserves pend/link nonzero), KSemaphoreCreateTrial.SemaphoreOwnership (semaphore_zero_insert_ready; semaphore_insert_failure_raw), KSemaphoreCreateTrial.SemaphoreSpecBridge (None iff full; Some implies min; generic dispatch at sentinel equals head insertion). Layout predicate and approved axiom are exported by TrialShared.SemaphoreInv. x_free deliberately consumes SemaphoreRaw, not SemaphoreZero, under the existing trusted KERNEL_FREE macro target; it is not called a matching VRTOS spec. Keep the real malloc base and whole-object ownership.\nReference previous proofs read-only in /home/xinra/crtos/ksemaphorecreate-trial-261019-3/VC and its verification_runs. The old helper contracts differ, so never copy old VC statements or replace current specs. Valid pure/refinement/world-invariant helper proofs may be reused after matching their actual statements. The old 41/4 VC counts are not the new counts. New symbolic output is authoritative.\nUse the controller role skills and exact returned invocations. Do not modify generated goal/auto/goal-check files manually. Any auto admissions are promoted by the adapter into exact manual obligations. Driver is Arch32/LittleEndian with --no-CRules, matching the current custom Assertion carrier. Formal case stem SemaphoreCreate corresponds to C function _SemaphoreCreate.",
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
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-check",
      "--run",
      "KSemaphoreCreate-20261022181446",
      "--round",
      "KSemaphoreCreate-annotation-r1",
      "--target-kind",
      "formal-case-lib-design"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  },
  {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "symexec",
      "--run",
      "KSemaphoreCreate-20261022181446",
      "--round",
      "KSemaphoreCreate-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  },
  {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261022-1",
      "coq-check",
      "--run",
      "KSemaphoreCreate-20261022181446",
      "--round",
      "KSemaphoreCreate-annotation-r1",
      "--target-kind",
      "formal-case-lib"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261022-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
