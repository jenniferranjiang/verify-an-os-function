# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "EventLinklistResumeAll-annotation-r2",
  "round": "EventLinklistResumeAll-annotation-r2",
  "main_root": "/home/xinra/crtos/keventdelete-trial-261103-1",
  "target_files": {
    "c_file": "annotated_C/src/LinklistResumeAll.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/EventLinklistResumeAll_lib.v",
    "goal_file": "VC/EventLinklistResumeAll_goal.v",
    "proof_auto_file": "VC/EventLinklistResumeAll_proof_auto.v",
    "proof_manual_file": "VC/EventLinklistResumeAll_proof_manual.v",
    "goal_check_file": "VC/EventLinklistResumeAll_goal_check.v",
    "case_name": "EventLinklistResumeAll",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/annotation-attempts/annotation-attempt2/agent_report.json",
  "notes": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/annotation-attempts/annotation-attempt2/agent_output.md",
  "feedback": "[\n  {\n    \"failure_class\": \"annotation-gap\",\n    \"kind\": \"missing-old-state-exclusivity\",\n    \"vcs\": [\n      {\n        \"name\": \"proof_of_LinklistResumeAll_entail_wit_4_2\",\n        \"parent\": null,\n        \"annotation_location\": \"LinklistResumeAll: successful KTaskWakeup return / loop-invariant backedge\"\n      }\n    ],\n    \"message\": \"The successful Wakeup backedge owns only os_inv(after), not old os_inv/current exclusivity. Its pure generic ktask_wakeup_step admits an old SUSPEND task simultaneously in the target Event and a Semaphore pending queue, removes it from both, and reaches a valid after state. With waiting=remaining=[task] and locked=current, old progress is reflexive, but new empty-remainder progress demands an Event-only batch effect that preserves the changed Semaphore, so the consequent fails. Extract and retain old sched-owner NoDup/world facts from the pre-call invariant across the call.\",\n    \"repair_boundary\": \"C annotation\"\n  }\n]",
  "feedback_sources": [
    {
      "phase": "vc-checking",
      "attempt_id": "EventLinklistResumeAll-vc-checking-r1",
      "evidence": [
        "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-checking-r1/agent_report.json",
        "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/rounds/EventLinklistResumeAll-vc-checking-r1/agent_output.md"
      ]
    }
  ],
  "previous_attempt": "EventLinklistResumeAll-vc-checking-r1",
  "plan": "/home/xinra/crtos/keventdelete-trial-261103-1/reports/EventLinklistResumeAll-20261103172104/annotation-attempts/annotation-attempt2/annotation_plan.json",
  "problem": {
    "problem_statement": "# Approved implementation handoff\n\n2026-11-03 \u7528\u6237\u5728 predicate/spec \u5747review-passed\u53ca\u5171\u4eab\u8fc1\u79fb\u5b8c\u6210\u540e\u56de\u590d\u201c\u505a\u5427\u201d\uff0c\u6279\u51c6\u5f00\u59cb\u5b9e\u73b0\u8bc1\u660e\u3002\n\u51bb\u7ed3\u8f93\u5165\uff1akeventdelete-predicate-r1\u3001keventdelete-spec-r1\u53cachecks/migration.json\u4e2d\u7684\u8bed\u4e49\u4e0d\u53d8\u5171\u4eab\u8def\u5f84\u7248\u672c\u3002\n\u539fC\u4e0d\u4fee\u6539\uff0c\u5148\u524d proposed-event-delete-fix.patch \u4e0d\u5e94\u7528\u3002TrustBase\uff1a/home/xinra/TrustBase.md\uff08\u4ec5\u4eba\u53ef\u4fee\u6539\uff09\u3002\n\u8303\u56f4\u9650\u5236\uff1a0 <= id < 65536\uff1bD1\u540c\u4e00allocation\u4ece\u547d\u4e2d\u5230\u6ce8\u9500\u4e0d\u88ab\u4ed6\u4eba\u56de\u6536/\u590d\u7528\uff1bD2\u89c2\u5bdf/\u6e05\u7a7a\u540e\u7684empty pending\u5230\u6ce8\u9500\u4fdd\u6301empty\u3002\nCriticalAreaLock\u7684event_delete_gap\u662f\u8be5\u7528\u6237\u73af\u5883\u8303\u56f4\u4e0b\u7684\u53ef\u4fe1\u63a5\u53e3\uff0c\u4e0d\u53ef\u5f53\u4f5cordinary\u7684\u5df2\u8bc1\u660e\u7279\u5316\uff0c\u4e0d\u53ef\u6269\u5927\u5230\u5176\u4ed6\u8c03\u7528\u94fe\u3002\n\n\u672c\u8f6e\u5b9e\u73b0\u76ee\u68074\u4e2a\uff1aFindEventById\u3001LinklistResumeAll\uff08Event OC\u573a\u666f\uff09\u3001_EventDelete\u3001KEventDelete\u3002\u6309\u4f9d\u8d56\u4ece\u4e0b\u5411\u4e0a\u5206\u522b\u8fd0\u884ccontroller\u3002\nreused-spec\u8fb9\u754c\uff1aIdGetObj\u3001IdRemoveObj\u3001IsDoubleLinkListEmpty\u3001DoubleLinkListRmNode\u3001KTaskWakeup\u3002\u6765\u6e90\u4e0erevision\uff1achecks/source-slices/manifest.json\uff1bcanonical\u5bfc\u5165\u5408\u540c\u5728annotated_C/src\u540c\u540d\u6587\u4ef6\u3002\u4e0d\u8981\u751f\u6210\u8fd95\u4e2a\u51fd\u6570\u7684VC\u6216\u91cd\u8bc1\u5b83\u4eec\u7684body\u3002\n\u6a21\u578b/API\u8fb9\u754c\uff1aCriticalAreaLock\u3001CriticalAreaUnLock\u3001CONTAINER_OF_EVENT_ID\u3001CONTAINER_OF_TASK_SCHED\u3001x_free\u3001KTASK_ASSIGN\uff0c\u5206\u522b\u4f9d\u636eTrustBase\u53ca\u6e90\u4ee3\u7801\u5904\u7406\u89c4\u5219\uff1b\u4e0d\u8ba1\u4e3a\u672c\u8f6eC\u5b9e\u73b0\u8bc1\u660e\u3002\n\n\u5de5\u7a0b\u4fdd\u6301\u73b0\u6709annotated_C\u548c\u5168\u5c40\u5e93\u5f15\u7528\uff0c\u4e0d\u590d\u5236\u4f9d\u8d56\u3001\u4e0d\u91cd\u547d\u540d\u903b\u8f91\u6a21\u5757\uff1b_CoqProject\u53ea\u65b0\u589e\u672ctrial\u7684VC\u8f93\u51fa\u6620\u5c04\u3002\u63a7\u5236\u5668\u5df2\u6709project_layout.py\u539f\u751ftrial\u9002\u914d\uff0cqcp-project.json\u91c7\u7528\u5b83\u8981\u6c42\u768432\u4f4d\u3001\u5c0f\u7aef\u3001no_crules\u3001gcc\u6a21\u5f0f\u3002\n\u5171\u4eablib\u6587\u4ef6\u7684\u8bbe\u8ba1\u8bed\u4e49\u51bb\u7ed3\u3002\u6bcf\u4e2arun\u5141\u8bb8\u81ea\u5df1\u7684VC/<case>_lib.v\u4f5c\u4e3a\u8f85\u52a9\u8bc1\u660e\u5e93\uff0c\u4e0d\u4ee5\u4fee\u6539\u5168\u5c40predicate\u7ed5\u8fc7\u51bb\u7ed3\u8f93\u5165\u3002\nOS Annotation\u9002\u914d\uff1a\u5141\u8bb8by local\u3001call where\u3001branch-control\u3001\u666e\u901aInv\u53camulti-inv\u7b49\u5408\u6cd5\u6ce8\u89e3\uff1b\u4e8b\u5b9e\u4ecd\u987b\u8bc1\u660e\uff0c\u4e0d\u80fd\u589e\u52a0\u65e0\u4f9d\u636e\u5047\u8bbe\u3001\u4e22\u8def\u5f84/\u8d44\u6e90\u6216\u6539\u53ef\u6267\u884cC\u884c\u4e3a\u3002\u52a8\u6001where\u53c2\u6570\u3001which implies\u3001\u5c40\u90e8\u62c6\u5206\u53ca\u5faa\u73af\u6ce8\u89e3\u5728\u6b64\u9636\u6bb5\u5b8c\u6210\u3002\n\n\u5de5\u5177\u914d\u7f6e\u6cbf\u7528tools/rocq/toolchain.json\u7684pv-bench-8.20.1\u786e\u5207core\uff1b\u73b0\u6709QCP/Rocq\u6210\u529f\u9a8c\u6536\u53ef\u590d\u7528\u3002\u672c\u8f6e\u5f53\u524dRocq MCP\u5df2\u5b9e\u9645\u6210\u529f\u5bfc\u5165\u5171\u4eabKEventDelete\u5e76\u67e5\u8be2abs_event_delete/event_delete_guard\uff0c\u786e\u8ba4\u672c\u8fde\u63a5\u517c\u5bb9\u3002\u5b9e\u9645C/symbolic/\u7f16\u8bd1/\u7ec8\u68c0\u7531controller\u7edf\u4e00\u8c03\u5ea6\u3002",
    "target_function": "LinklistResumeAll"
  },
  "failed_vcs": [
    {
      "source_attempt": "EventLinklistResumeAll-vc-checking-r1",
      "manual": "/home/xinra/crtos/keventdelete-trial-261103-1/verification_runs/EventLinklistResumeAll-20261103172104/annotation_history/annotation-attempt1/after/VC/EventLinklistResumeAll_proof_manual.v",
      "message": "The successful Wakeup backedge owns only os_inv(after), not old os_inv/current exclusivity. Its pure generic ktask_wakeup_step admits an old SUSPEND task simultaneously in the target Event and a Semaphore pending queue, removes it from both, and reaches a valid after state. With waiting=remaining=[task] and locked=current, old progress is reflexive, but new empty-remainder progress demands an Event-only batch effect that preserves the changed Semaphore, so the consequent fails. Extract and retain old sched-owner NoDup/world facts from the pre-call invariant across the call.",
      "name": "proof_of_LinklistResumeAll_entail_wit_4_2",
      "parent": null,
      "annotation_location": "LinklistResumeAll: successful KTaskWakeup return / loop-invariant backedge"
    }
  ],
  "writable_files": [
    "annotated_C/src/LinklistResumeAll.c",
    "VC/EventLinklistResumeAll_lib.v"
  ],
  "user_spec": {
    "functions": [
      "LinklistResumeAll"
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
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-annotation-r2",
      "--target-kind",
      "formal-case-lib-design"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "symexec",
      "--run",
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-annotation-r2"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  },
  {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventdelete-trial-261103-1",
      "coq-check",
      "--run",
      "EventLinklistResumeAll-20261103172104",
      "--round",
      "EventLinklistResumeAll-annotation-r2",
      "--target-kind",
      "formal-case-lib"
    ],
    "cwd": "/home/xinra/crtos/keventdelete-trial-261103-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
