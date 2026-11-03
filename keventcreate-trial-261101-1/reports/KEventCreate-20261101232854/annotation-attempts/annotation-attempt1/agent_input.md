# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "KEventCreate-annotation-r1",
  "round": "KEventCreate-annotation-r1",
  "main_root": "/home/xinra/crtos/keventcreate-trial-261101-1",
  "target_files": {
    "c_file": "annotated_C/src/KEventCreate.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/KEventCreate_lib.v",
    "goal_file": "VC/KEventCreate_goal.v",
    "proof_auto_file": "VC/KEventCreate_proof_auto.v",
    "proof_manual_file": "VC/KEventCreate_proof_manual.v",
    "goal_check_file": "VC/KEventCreate_goal_check.v",
    "case_name": "KEventCreate",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/keventcreate-trial-261101-1/reports/KEventCreate-20261101232854/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos/keventcreate-trial-261101-1/reports/KEventCreate-20261101232854/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos/keventcreate-trial-261101-1/reports/KEventCreate-20261101232854/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "# KEventCreate implement \u6388\u6743\u4e0e\u8fb9\u754c\n\n\u7528\u6237\u660e\u786e\u6307\u4ee4\uff1a\u201cok\u6211\u4eec\u6765implement\u5427\u201d\u3002\u8fd9\u662f\u5bf9\u5f53\u524dreview-passed revisions\u53ca\u5176\u5171\u4eab\u8fc1\u79fb\u7684\u6279\u51c6\uff0c\u89e3\u9664\u5148\u524d\u4ec5\u8bbe\u8ba1\u3001\u4e0d\u8fd0\u884csymbolic/VC/\u8bc1\u660e\u7684\u9636\u6bb5\u9650\u5236\u3002\nPredicate revision bc9e9bde2236e66d076beac531d82c6ad1175d71225e1f8477f0f46e6c2c61ca\uff1bspec revision 1c4a7b5920e164a40891b6d64dc6f18be0debede36a1c79946dd82dad5138f00\u3002\u6765\u6e90\u89c1checks/predicate-manifest.json\u3001spec-manifest.json\u53camigration.json\u3002\n\n\u5de5\u7a0b\u6cbf\u7528\u672ctrial\u7684annotated_C/src\u3001include\u548c_CoqProject\uff1b\u5171\u4eab\u5b9a\u4e49\u76f4\u63a5\u5f15\u7528/home/xinra/crtos/lib\uff08CRTOS_Verify.lib\uff09\uff0ctrial/lib\u548cchecks/review-inputs\u662f\u53ea\u8bfb\u5ba1\u9605\u5feb\u7167\uff0c\u4e0d\u53c2\u4e0e\u5f53\u524d\u6784\u5efa\u3002\u65b0\u589e\u8bc1\u660e\u4ea7\u7269\u4f4d\u4e8etrial/VC\uff0c\u552f\u4e00\u6620\u5c04CRTOS_Verify.VC\uff1bcase\u8f85\u52a9\u5e93\u53ef\u5bfc\u5165\u5171\u4eab\u5b9a\u4e49\u5e76\u8865\u5145\u8bc1\u660e\uff0c\u4e0d\u590d\u5236\u6216\u91cd\u5b9a\u4e49\u51bb\u7ed3predicate\uff0c\u4e0d\u65b0\u589eAxiom/Parameter\u6216\u7528Admitted\u5192\u5145\u8bc1\u660e\u3002\n\n\u8bc1\u660e\u76ee\u6807\u53ea\u6709_EventCreate\uff08case EventCreate\uff0c\u5148\u5b8c\u6210\uff09\u53caKEventCreate\uff08\u968f\u540e\u72ec\u7acbcase\uff09\u3002\u5fc5\u987b\u9a8c\u8bc1\u4e24\u4e2a\u771f\u5b9eactive body\u3002\u4e09\u4e2areused-spec\u8fb9\u754c\u4e0d\u751f\u6210\u672c\u8f6eVC\u6216\u91cd\u8bc1body\uff1aIdInsertObj\u6765\u81ea\u6839annotated_C/src/headers/id_module_spec.h\uff1bInitDoubleLinkList\u3001DoubleLinkListInsertNodeAfter\u6765\u81ea\u6839\u540c\u540dC\u6587\u4ef6\uff08\u9009\u62e9dispatch_case\uff09\u3002\u6bcf\u4e2acaller-local\u5408\u540c\u987b\u4e0e\u91c7\u7528\u7684canonical\u4e00\u81f4\uff1b\u6765\u6e90\u7248\u672c\u89c1source-manifest.json\u4e0espec-review.md\u3002\n\nTrustBase\u8def\u5f84/home/xinra/TrustBase.md\uff0c\u53ea\u8bfb\u3002CriticalAreaLock/UnLock\u3001x_malloc/x_free\u5bf9\u5e94KERNEL_MALLOC/FREE\u5b8f\u53camemset\u4e3a\u5df2\u6709TrustBase\u8fb9\u754c\uff1bevent_object free\u6d88\u8d39\u5b8c\u6574EventRaw\u4e14\u5fc5\u987b\u6765\u81ea\u672c\u6b21malloc\u7684\u539f\u57fa\u5740\u3002\u4e0d\u5f97\u6269\u5927trusted symbol\u6216\u5408\u540c\u3002\u65e0\u4f9d\u636e\u7684\u5e03\u5c40\u4e8b\u5b9e\u4e0d\u5f97\u4f5c\u4e3a\u5df2\u8bc1lemma\u4f7f\u7528\uff1bEventInv\u4e2d\u7684event_byte_layout\u53ca\u5404obligation\u662f\u660e\u786e\u5f85\u8bc1\u547d\u9898\uff0c\u987b\u901a\u8fc7\u5b9e\u9645QCP\u5e03\u5c40\u63a5\u53e3/\u65e2\u6709\u53ef\u4fe1\u5e03\u5c40\u673a\u5236\u6216\u6709\u6548\u8bc1\u660e\u5904\u7406\uff0c\u53d1\u73b0\u9700\u8981\u65b0\u7684\u4fe1\u4efb\u5047\u8bbe\u5219\u62a5\u544amain\u3002\n\n\u4f4d\u57df\u9002\u914d\u5df2\u5ba1\uff1a\u975eSMP\u3001Arch32\u3001LittleEndian\uff1b\u6743\u5a01Event\u4f4d\u57df\u5bf9\u8c6132\u5b57\u8282\uff0c\u6a21\u578b\u5c55\u5f00options/events\u4e3a\u72ec\u7acbuint32\u540e36\u5b57\u8282\uff0cslice\u663e\u5f0foptions & 7U\u4fdd\u6301\u4f4e3\u4f4d\u3002\u4e0d\u80fd\u628a\u4e24\u79cd\u5e03\u5c40\u58f0\u79f0\u4e3a\u76f8\u540cABI\u3002Create\u4ecd\u63a5\u53d7uint32\u5168\u57df\uff0c\u7981\u6b62\u5c06Require\u6536\u7a84\u5230FIFO/PRIO\u3002\u4e09\u6761\u8fd4\u56de\u8def\u5f84\u5747\u9700\u8bc1\u660e\uff1amalloc\u5931\u8d25\u9501\u5916-5\uff1bID\u5931\u8d25\u539fmanager+\u672a\u77e5insert_ready\u6062\u590d\u5b8c\u6574\u79c1\u6709\u5bf9\u8c61\uff0cunlock\u540efree\u539f\u57fa\u5740\u8fd4\u56de-5\uff1b\u6210\u529f\u6700\u5c0f\u7a7a\u95f2ID\uff0cevents=0\u3001options\u4f4e3\u4f4d\u3001\u7a7apending\u3001ID\u4e0e\u7ba1\u7406\u94fe\u5934\u63d2\uff0c\u6062\u590dos_inv\u540eunlock\u8fd4\u56deID\u3002\u590d\u7528ID\u5931\u8d25\u5408\u540c\u4e0d\u4fdd\u8bc1\u5df2\u6ee1\u3002\n\nOS Annotation\u9636\u6bb5\u5141\u8bb8\u5728\u51fd\u6570\u4f53\u4e2d\u65b0\u589e/\u4fee\u6b63by local\u3001where\u3001branch-control\u3001Inv/multi-inv\u7b49\u5408\u6cd5QCP\u6ce8\u89e3\uff1b\u8303\u56f4\u4e8b\u5b9e\u3001\u8c03\u7528\u524d\u63d0\u4ecd\u987b\u8bc1\u660e\uff0c\u4e0d\u5f97\u589e\u52a0\u65e0\u636e\u5047\u8bbe\u3001\u6539\u53ef\u6267\u884c\u7b97\u6cd5\u6216\u9057\u6f0f\u8def\u5f84/\u8d44\u6e90\u3002\u51bb\u7ed3spec/predicate\u82e5\u9700\u8bed\u4e49\u53d8\u66f4\u5148\u505c\u6b62\u5e76\u63d0\u51fa\u5177\u4f53\u65b9\u6848\uff0c\u7ecf\u7528\u6237\u786e\u8ba4\u540e\u624dunfreeze\uff1b\u666e\u901aproof-local\u6ce8\u89e3\u53ef\u5728\u672cattempt\u5185\u5b8c\u5584\u3002\n\n\u6e90\u7801\u95ee\u9898\u5df2\u7ecf\u6309\u7528\u6237\u9009\u62e9\u5904\u7406\uff1aE1\u53caE2\u975e\u6cd5\u7b56\u7565\u6309\u540e\u7eedAPI\u5408\u6cd5\u8f93\u5165\u8303\u56f4\u8bf4\u660e\uff1b\u7528\u6237\u660e\u786eE3\u4f7f\u7528\u671f\u95f4\u4e0d\u4f1a\u5220\u9664\u3002E2\u5408\u6cd5\u53c2\u6570\u4e0b\u7684\u5ef6\u65f6\u5206\u914d\u5931\u8d25\u5df2\u4fee\u590d\u4e3atrial/source_fixes/_EventProcess.c\u5019\u9009\uff0c16\u4e3b\u673a\u573a\u666f\u901a\u8fc7\uff0c\u6743\u5a01event.c\u4fdd\u6301\u539f\u6837\u3002\u8be5\u4fee\u590d\u5019\u9009\u4e0d\u5728Create\u8c03\u7528\u95ed\u5305\uff0c\u4e0d\u5c5e\u4e8e\u672c\u8f6e\u8bc1\u660e\u76ee\u6807\uff1b\u4e0d\u5f97\u4ee5\u672c\u8bc1\u660e\u58f0\u79f0\u6743\u5a01Event\u6a21\u5757\u5df2\u4fee\u590d\u6216\u4efb\u610f\u4f7f\u7528/\u5220\u9664\u5747\u4fdd\u6301os_inv\u3002\u4fdd\u7559source-errors.md\u53cae2-fix-review.md\u7684\u9002\u7528\u8303\u56f4\u3002\u7528\u6237\u8981\u6c42\u4eca\u540e\u6e90\u7801\u4fee\u590d\u4fdd\u5b58\u5728trial\u5e76\u6ce8\u91ca\uff0c\u4e0d\u6539\u6743\u5a01C\u3002\n\n\u5f53\u524d\u73af\u5883\u6cbf\u7528\u5df2\u6210\u529f\u9a8c\u8bc1MutexCreate\u7684QCP\u5de5\u5177\u9002\u914d\u548cCoq8.20.1\u5de5\u5177\u94fe\uff1b\u914d\u7f6e\u4e3aGCC\u9884\u5904\u7406\u3001Arch32\u3001\u5c0f\u7aef\u3001no_crules\u3002\u6309\u73b0\u6709controller\u5b9e\u73b0\u8bc6\u522bannotated_C/src\u4e0e\u5916\u90e8_CoqProject\u8def\u5f84\uff0c\u4e0d\u590d\u5236\u5e93\u3001\u4e0d\u53e6\u6362\u76ee\u5f55\u5e03\u5c40\u3002Rocq\u8bc1\u660e\u987b\u6309owner\u89d2\u8272\u8981\u6c42\u4f7f\u7528MCP\u4ea4\u4e92\uff1b\u82e5\u73af\u5883\u51fa\u73b0\u5b9e\u9645\u9519\u8bef\u5148\u4fee\u590d\uff0c\u4e0d\u80fd\u9759\u9ed8\u7528\u6279\u91cf\u7f16\u8bd1\u66ff\u4ee3\u4ea4\u4e92\u3002\u5386\u53f2mutex\u5b9e\u73b0\u8bc1\u660e\u53ef\u53ea\u8bfb\u53c2\u8003\uff0c\u4e0d\u80fd\u5047\u5b9a\u65e7\u5b8c\u6574OS\u72b6\u6001\u8bc1\u660e\u9002\u7528\u4e8e\u5f53\u524d\u542bEvent\u7684\u72b6\u6001\uff1b\u65b0\u7684goal\u68c0\u67e5\u987b\u5b9e\u9645\u6210\u529f\u3002",
    "target_function": "KEventCreate",
    "reference_case_hints": [
      "/home/xinra/crtos/kmutexcreate-trial-261101-1/VC/KMutexCreate_lib.v"
    ]
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/KEventCreate.c",
    "VC/KEventCreate_lib.v"
  ],
  "user_spec": {
    "functions": [
      "KEventCreate",
      "_EventCreate"
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
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-check",
      "--run",
      "KEventCreate-20261101232854",
      "--round",
      "KEventCreate-annotation-r1",
      "--target-kind",
      "formal-case-lib-design"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  },
  {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "symexec",
      "--run",
      "KEventCreate-20261101232854",
      "--round",
      "KEventCreate-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  },
  {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/keventcreate-trial-261101-1",
      "coq-check",
      "--run",
      "KEventCreate-20261101232854",
      "--round",
      "KEventCreate-annotation-r1",
      "--target-kind",
      "formal-case-lib"
    ],
    "cwd": "/home/xinra/crtos/keventcreate-trial-261101-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
