# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "PopDataqueue-annotation-r1",
  "round": "PopDataqueue-annotation-r1",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/dataqueue/PopDataqueue.c",
    "formal_directory": "VC/dataqueue",
    "formal_case_lib": "VC/dataqueue/PopDataqueue_lib.v",
    "goal_file": "VC/dataqueue/PopDataqueue_goal.v",
    "proof_auto_file": "VC/dataqueue/PopDataqueue_proof_auto.v",
    "proof_manual_file": "VC/dataqueue/PopDataqueue_proof_manual.v",
    "goal_check_file": "VC/dataqueue/PopDataqueue_goal_check.v",
    "case_name": "PopDataqueue",
    "active_case_theory": "CRTOS_Verify.VC.dataqueue"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos-verify/reports/PopDataqueue-20261119021132/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify PopDataqueue current canonical approved repaired copy. Predicate/spec dq-pop-push-predicate-20261118-r1/dq-pop-push-spec-20261118-r1 independently reviewed; lib72 hash and nine canonical+headers match reviewed revisions including header guard update. DQ02/03 already approved and canonical: every timeout passed once, Obtain error returns -1 preserving output, no ring/Abandon; success retains empty branch with return0 and Abandon, nonempty reads front then increments modulo max_len; Abandon return ignored per source/spec. Protect shared semaphore ID reads using current approved source adaptation. Preserve full public spec/no weakening. New KSemaphoreObtain/Abandon and recursive non-imported closure still must be proved serially after Pop root before Push; not trusted, root conclusion conditional until completed. Existing ID/DLL/task helpers remain reused-contract boundaries. TrustBase .agents/skills/verify-an-os-function/references/TrustBase.md and ReviewWhitelist001 apply. Use one current dataqueue_map os_inv; no new model duplication/trial/module_context/body analysis copies. First stage Init/DeInit/Peak and four Semaphore Create/Delete IC now done/final-check; global libs unchanged. User no per-function time limit, preapproved justified fixes but actual reviews mandatory. Native auto/manual preserved, generated auto solver trust allowed, only assigned manual spans handwritten. No project source via Rocq MCP after previous approval rejection; use local controller checks/debug. Readonly crtoslatest, keep .vo. Existing Peak proof is useful for map/slot/wand/read outputs, but must verify actual Pop update/continuations."
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/kernel/dataqueue/PopDataqueue.c"
  ],
  "user_spec": {
    "functions": [
      "PopDataqueue"
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
      "PopDataqueue-20261119021132",
      "--round",
      "PopDataqueue-annotation-r1",
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
      "PopDataqueue-20261119021132",
      "--round",
      "PopDataqueue-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
