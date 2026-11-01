# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "SemaphoreDelete-annotation-r1",
  "round": "SemaphoreDelete-annotation-r1",
  "main_root": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
  "target_files": {
    "c_file": "annotated_C/src/_SemaphoreDelete.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/SemaphoreDelete_lib.v",
    "goal_file": "VC/SemaphoreDelete_goal.v",
    "proof_auto_file": "VC/SemaphoreDelete_proof_auto.v",
    "proof_manual_file": "VC/SemaphoreDelete_proof_manual.v",
    "goal_check_file": "VC/SemaphoreDelete_goal_check.v",
    "case_name": "SemaphoreDelete",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "# KSemaphoreDelete \u5b9e\u73b0\u9636\u6bb5\u4ea4\u63a5\u51c6\u5907\n\n2026-10-30\u3002\u7528\u6237\u5df2\u660e\u786e\u786e\u8ba4\u4e0b\u8ff0 review-passed revisions \u5e76\u8981\u6c42\u5f00\u59cb\u5b9e\u73b0\uff1b\u672c\u6587\u4ef6\u4f5c\u4e3a workflow \u4ea4\u63a5\u7ea6\u675f\u3002\u8fd0\u884c\u72b6\u6001\u4ee5 controller \u62a5\u544a\u4e3a\u51c6\u3002\n\n## \u56fa\u5b9a\u8bbe\u8ba1\u8f93\u5165\n\n- Predicate\uff1a`KSemaphoreDelete-pred-r7`\uff0c\u5185\u5bb9\u6458\u8981 `9a204245814625aade45188ff92e1cc911bc1aad78fee08d7f2f5dfab8b9d786`\u3002\n- Spec\uff1a`KSemaphoreDelete-spec-r9`\uff0c\u5185\u5bb9\u6458\u8981 `00bad529f9b7b9f5a29415d443d27d7e6a7875e9ffc798acefdd6e3285a4c17b`\u3002\n- \u5ba1\u9605\u7ed3\u8bba\u4ee5 `checks/predicate-revision.json`\u3001`checks/spec-revision.json` \u53ca\u94fe\u63a5\u62a5\u544a\u4e3a\u51c6\u3002\n- TrustBase\uff1a`/home/xinra/TrustBase.md`\uff1b\u4ec5\u4eba\u5de5\u7ef4\u62a4\u3002\n- \u5de5\u7a0b\uff1a`/home/xinra/crtos/ksemaphoredelete-trial-261025-1/`\uff1b\u7ee7\u7eed\u4f7f\u7528\u6b64\u76ee\u5f55\uff0c\u4e0d\u521b\u5efa\u66ff\u4ee3 trial\u3002\n- \u8def\u5f84\uff1a\u73b0\u6709 `_CoqProject`\u3001`annotated_C/include/logic.h`\u3001`annotated_C/include/slice_types.h`\uff1b\u6b63\u5f0f\u5e93\u6765\u81ea\u6839 `lib/` \u7684 `CRTOS_Verify.lib`\u3002\n\n## \u51fd\u6570\u4f53\u8bc1\u660e\u76ee\u6807\n\n- `KSemaphoreDelete`\uff1a`annotated_C/src/KSemaphoreDelete.c`\u3002\n- `_SemaphoreDelete`\uff1a`annotated_C/src/_SemaphoreDelete.c`\u3002\n- `LinklistResumeAll`\uff1a`annotated_C/src/LinklistResumeAll.c`\u3002\n\n## \u5916\u90e8\u5951\u7ea6\u8fb9\u754c\n\n\u672c\u8f6e\u5728\u4e0b\u5217\u5bfc\u5165\u5951\u7ea6\u5904\u505c\u6b62\u9012\u5f52\uff0c\u4e0d\u751f\u6210\u5b83\u4eec\u7684\u5b9e\u73b0 VC\u3002\u9010\u9879\u6765\u6e90\u3001revision \u548c\u6240\u9009\u63a5\u53e3\u89c1 `checks/verification-scope.json`\uff1b\u4e0d\u80fd\u628a\u5b83\u4eec\u8ba1\u4e3a\u672c\u8f6e\u65b0\u5b8c\u6210\u7684\u5b9e\u73b0\u8bc1\u660e\u3002\n\n`KTaskWakeup`, `_KTaskWakeup`, `GetTaskWithIdnodeInfo`, `KTaskUnSetDelay`, `KTaskInsertToReadyVector`, `AssignPolicyInsert`, `RoundRobinRemainReadyVectorInsert`, `KTaskStateSet`, `KTaskStatSetAsReady`, `JudgeKTaskStatIsSuspend`, `DoubleLinkListRmNode`, `DoubleLinkListInsertNodeBefore`, `DoubleLinkListInsertNodeAfter`, `InitDoubleLinkList`, `IsDoubleLinkListEmpty`, `FreeId`, `RemoveObj`, `GetObj`, `IdGetObj`, `IdRemoveObj`\u3002\n\n`LinklistResumeAll` \u8c03\u7528 `KTaskWakeup` \u9009\u62e9 `semaphore_pending_head_ic`\uff0c\u5176 before \u662f\u5199 exstatus \u540e\u7684 marked \u72b6\u6001\u3002\n\n\u65e2\u5b9a\u6a21\u578b/\u4fe1\u4efb\u8fb9\u754c\uff1a`CONTAINER_OF_IDNODE_LINK`, `CONTAINER_OF_SEMAPHORE_ID`, `CONTAINER_OF_TASK_ID`, `CONTAINER_OF_TASK_SCHED`, `CriticalAreaLock`, `CriticalAreaUnLock`, `KTASK_ASSIGN`, `x_free`\u3002\n\n## \u6267\u884c\u7ea6\u675f\n\n\u6309 `/home/xinra/qcp-binary-democases/AGENTS.md` \u6307\u5b9a\u7684 verification-orchestrator \u542f\u52a8\uff1b\u5f53\u524d\u5de5\u5177\u9700\u652f\u6301\u5df2\u6709 trial \u683c\u5f0f\u53ca\u5916\u90e8\u5e93\u8def\u5f84\uff0c\u4e0d\u80fd\u628a\u5de5\u7a0b\u91cd\u7ec4\u4e3a QCP_examples/Rocq \u793a\u4f8b\u76ee\u5f55\u3002\u7b26\u53f7\u6267\u884c\u3001\u4f9d\u8d56\u5206\u6790\u3001Coq \u7f16\u8bd1\u548c final-check \u5fc5\u987b\u91c7\u7528\u540c\u4e00\u6620\u5c04\u3002\n\n\u7528\u6237\u786e\u8ba4 review-passed \u7248\u672c\u540e\uff0c\u4ee5\u4e0a predicate/spec \u4f5c\u4e3a\u51bb\u7ed3\u8f93\u5165\u3002Annotation owner \u53ef\u4ee5\u6dfb\u52a0\u6216\u4fee\u6b63\u5408\u6cd5\u7684 by local\u3001call where\u3001branch-control\u3001Inv \u548c multi-inv \u7b49\u51fd\u6570\u4f53\u6ce8\u89e3\uff0c\u76f8\u5173\u4e8b\u5b9e\u4ecd\u987b\u8bc1\u660e\uff0c\u4e0d\u5f97\u6539\u53ef\u6267\u884c C \u884c\u4e3a\u6216\u901a\u8fc7\u65e0\u4f9d\u636e\u5047\u8bbe\u6d88\u9664\u4e49\u52a1\u3002\u51bb\u7ed3\u8bed\u4e49\u9700\u8981\u4fee\u6539\u65f6\u9075\u5faa workflow \u7684\u5ba1\u9605\u53ca\u5ba1\u6279\u6d41\u7a0b\u3002\n\n\u4ec5\u6309 controller \u8fd4\u56de\u7684 action \u6267\u884c\uff1b\u4e0d\u80fd\u7528\u624b\u5de5\u751f\u6210 VC \u6216\u7f16\u8bd1\u7ed5\u8fc7\u63a5\u7eb3\u3002\u5b9e\u73b0\u7ed3\u675f\u4f7f\u7528 controller final-check\uff0c\u53e6\u590d\u6838\u6e90\u7801\u4e00\u81f4\u6027\u8bb0\u5f55\u662f\u5426\u4ecd\u6709\u6548\u3002\n\n## \u672c\u5730\u5f85\u8bc1\u4e49\u52a1\n\n\u8d44\u6e90 view/strategy \u7684\u6b63\u786e\u6027\u3001exstatus \u5199\u6743\u9650\u53ca task map \u91cd\u7d22\u5f15\u3001Wakeup \u961f\u9996\u4e0e ID \u5173\u8054\u3001\u5faa\u73af\u548c\u6279\u91cf\u6548\u679c\u8fde\u63a5\u3001ID found \u8d44\u6e90\u6062\u590d\u3001\u6ce8\u9500\u4e0e\u6458\u94fe\u4e2d\u95f4\u6001\u3001SemaphoreRetired \u5230 SemaphoreRaw \u8f6c\u6362\u5747\u672a\u7531\u8bbe\u8ba1\u5ba1\u9605\u8bc1\u660e\u3002\n\n\u5f53\u524d\u6e90\u7801/\u7c7b\u578b/\u63a5\u53e3\u8bc1\u636e\u89c1 `checks/review-261030/`\uff1b\u6e90\u7801\u62a5\u544a\u89c1 `.docs/Report/source-check-2026-10-30.md`\u3002",
    "target_function": "_SemaphoreDelete",
    "spec_hint": [
      "This run proves only _SemaphoreDelete. LinklistResumeAll has a separate body proof run. Preserve canonical and caller-local specs and C executable tokens. Body by local, call where, branch-control, Inv and multi-inv are allowed; all facts remain proof obligations. Use CRTOS 32-bit LittleEndian semantics and frozen predicates. Auxiliary views and lemmas may be added to the active case lib, without changing frozen semantics."
    ]
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/_SemaphoreDelete.c",
    "VC/SemaphoreDelete_lib.v"
  ],
  "user_spec": {
    "functions": [
      "CONTAINER_OF_SEMAPHORE_ID",
      "CriticalAreaLock",
      "CriticalAreaUnLock",
      "DoubleLinkListRmNode",
      "IdGetObj",
      "IdRemoveObj",
      "IsDoubleLinkListEmpty",
      "KTASK_ASSIGN",
      "LinklistResumeAll",
      "_SemaphoreDelete",
      "x_free"
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
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-annotation-r1",
      "--target-kind",
      "formal-case-lib-design"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "symexec",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  },
  {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-check",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-annotation-r1",
      "--target-kind",
      "formal-case-lib"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
