# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "InitDataqueue-annotation-r2",
  "round": "InitDataqueue-annotation-r2",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/dataqueue/InitDataqueue.c",
    "formal_directory": "VC/dataqueue",
    "formal_case_lib": "VC/dataqueue/InitDataqueue_lib.v",
    "goal_file": "VC/dataqueue/InitDataqueue_goal.v",
    "proof_auto_file": "VC/dataqueue/InitDataqueue_proof_auto.v",
    "proof_manual_file": "VC/dataqueue/InitDataqueue_proof_manual.v",
    "goal_check_file": "VC/dataqueue/InitDataqueue_goal_check.v",
    "case_name": "InitDataqueue",
    "active_case_theory": "CRTOS_Verify.VC.dataqueue"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/annotation-attempts/annotation-attempt2/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/annotation-attempts/annotation-attempt2/agent_output.md",
  "feedback": null,
  "feedback_sources": [
    {
      "phase": "group",
      "attempt_id": "InitDataqueue-vc-proving-r1:storage_views",
      "evidence": [
        "/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r1/groups/group_03__storage_views/group_worker_report.json",
        "/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/rounds/InitDataqueue-vc-proving-r1/groups/group_03__storage_views/group_worker_output.md"
      ]
    }
  ],
  "previous_attempt": "InitDataqueue-vc-proving-r1",
  "plan": "/home/xinra/crtos-verify/reports/InitDataqueue-20261117224043/annotation-attempts/annotation-attempt2/annotation_plan.json",
  "problem": {
    "problem_statement": "Verify approved map-based InitDataqueue, including failure cleanup. DataqueueInv.dataqueue_layout_abi is user-authorized concrete ILP32 layout only. Reused ID/DLL contracts remain boundaries. No unproved obligation Props may be assumed. Manual proof edits only in manual files. Per-function cumulative VC proof budget 100 minutes, prior attempts conservatively charged 15 minutes. Original crtoslatest read-only. Preserve .vo."
  },
  "failed_vcs": [
    {
      "source_attempt": "InitDataqueue-vc-proving-r1:storage_views",
      "manual": "/home/xinra/crtos-verify/verification_runs/InitDataqueue-20261117224043/InitDataqueue-vc-proving-r1/groups/group_03__storage_views/InitDataqueue_proof_manual.v",
      "message": "The byte-array view quantifies arbitrary p and retains only CharArray.full, whose cells require alignment 1; typed UShort/Ptr/Int postcondition requires alignment 2/4. Entry DataqueueStorage already provides addr_aligned(p,4), but this fact was omitted from the local view premise. Preserve it in the annotation; no stronger public Require or new ABI assumption is needed.",
      "name": "proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial",
      "parent": "proof_of_InitDataqueue_which_implies_wit_2",
      "annotation_location": "InitDataqueue.c which-implies immediately after memset"
    }
  ],
  "writable_files": [
    "annotated_C/src/kernel/dataqueue/InitDataqueue.c"
  ],
  "user_spec": {
    "functions": [
      "InitDataqueue"
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
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-annotation-r2",
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
      "InitDataqueue-20261117224043",
      "--round",
      "InitDataqueue-annotation-r2"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
