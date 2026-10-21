# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "SemaphoreCreate-annotation-r2",
  "round": "SemaphoreCreate-annotation-r2",
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
  "report": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/annotation-attempts/annotation-attempt2/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/annotation-attempts/annotation-attempt2/agent_output.md",
  "feedback": null,
  "feedback_sources": [
    {
      "phase": "group",
      "attempt_id": "SemaphoreCreate-vc-proving-r1:publish",
      "evidence": [
        "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_00__publish/group_worker_report.json",
        "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_00__publish/group_worker_output.md"
      ]
    },
    {
      "phase": "group",
      "attempt_id": "SemaphoreCreate-vc-proving-r1:list_prepare",
      "evidence": [
        "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_02__list_prepare/group_worker_report.json",
        "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_02__list_prepare/group_worker_output.md"
      ]
    },
    {
      "phase": "group",
      "attempt_id": "SemaphoreCreate-vc-proving-r1:entry_calls",
      "evidence": [
        "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_04__entry_calls/group_worker_report.json",
        "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/rounds/SemaphoreCreate-vc-proving-r1/groups/group_04__entry_calls/group_worker_output.md"
      ]
    }
  ],
  "previous_attempt": "SemaphoreCreate-vc-proving-r1",
  "plan": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/reports/SemaphoreCreate-20261021190017/annotation-attempts/annotation-attempt2/annotation_plan.json",
  "problem": {
    "problem_statement": "Prove the current _SemaphoreCreate implementation against its frozen spec. The user requests implementation proof only for _SemaphoreCreate and KSemaphoreCreate and says helpers are already proved; reuse matching contracts without re-proving helpers. Trust boundary: /home/xinra/TrustBase.md. Shared semantic sources are frozen in checks/implement-frozen-inputs.json. Do not change predicate or contract semantics. The local controller adapts the CRTOS layout and uses Coq 8.20.1 with ARM32 little-endian QCP. Existing historical reviews predate current authorized changes and are not claimed current; report any actual semantic issue explicitly.",
    "target_function": "_SemaphoreCreate"
  },
  "failed_vcs": [
    {
      "source_attempt": "SemaphoreCreate-vc-proving-r1:publish",
      "manual": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_00__publish/SemaphoreCreate_proof_manual.v",
      "message": "The publication premise contains store_node_self_linked for sem.pend_list, DllInsertedCut for sem.link and dllseg_shift_rev for the old management list, but none retains the respective pending-head nonzero, new-link nonzero or old dll_nodes_nonzero facts required by store_dll in the target os_inv. sem <> 0 and alignment do not establish separately addressed subobject nonzero; SemaphoreLayout is not a premise, and isvalidptr permits zero. These facts were available or required before the helper calls but are absent from their current postconditions and the exposed tail.",
      "name": "proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial",
      "parent": "proof_of__SemaphoreCreate_entail_wit_5",
      "annotation_location": "annotated_C/src/_SemaphoreCreate.c:226"
    },
    {
      "source_attempt": "SemaphoreCreate-vc-proving-r1:list_prepare",
      "manual": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_02__list_prepare/SemaphoreCreate_proof_manual.v",
      "message": "The antecedent owns NodeZero for sem.link and sem.pend_list and knows sem<>0, but NodeZero contains no node-base nonzero fact. The consequent DllInsertAfterCut and NodeStorage require both embedded node bases <>0. eval_addr_expr is abstract; SemaphoreLayout is only an unproved proposition and is absent from the premises, so typed field ownership supplies no bridge to those required base-address facts.",
      "name": "proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial",
      "parent": "proof_of__SemaphoreCreate_entail_wit_4",
      "annotation_location": "annotated_C/src/_SemaphoreCreate.c:198"
    },
    {
      "source_attempt": "SemaphoreCreate-vc-proving-r1:entry_calls",
      "manual": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_04__entry_calls/SemaphoreCreate_proof_manual.v",
      "message": "Current premises supply safeExec, value bounds, OutsideCritical and (for memset) SemaphoreRaw, but no premise or imported proved fact establishes sizeof(\"Semaphore\") = 32. SemaphoreLayout is only an unproved Prop definition. Named sizes remain abstract in CNotation, so the required allocation/zero-fill size equality does not follow.",
      "name": "proof_of__SemaphoreCreate_partial_solve_wit_1_pure",
      "parent": null,
      "annotation_location": "annotated_C/src/_SemaphoreCreate.c:150"
    },
    {
      "source_attempt": "SemaphoreCreate-vc-proving-r1:entry_calls",
      "manual": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_04__entry_calls/SemaphoreCreate_proof_manual.v",
      "message": "Current premises supply safeExec, value bounds, OutsideCritical and (for memset) SemaphoreRaw, but no premise or imported proved fact establishes sizeof(\"Semaphore\") = 32. SemaphoreLayout is only an unproved Prop definition. Named sizes remain abstract in CNotation, so the required allocation/zero-fill size equality does not follow.",
      "name": "proof_of__SemaphoreCreate_partial_solve_wit_1",
      "parent": null,
      "annotation_location": "annotated_C/src/_SemaphoreCreate.c:150"
    },
    {
      "source_attempt": "SemaphoreCreate-vc-proving-r1:entry_calls",
      "manual": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_04__entry_calls/SemaphoreCreate_proof_manual.v",
      "message": "Current premises supply safeExec, value bounds, OutsideCritical and (for memset) SemaphoreRaw, but no premise or imported proved fact establishes sizeof(\"Semaphore\") = 32. SemaphoreLayout is only an unproved Prop definition. Named sizes remain abstract in CNotation, so the required allocation/zero-fill size equality does not follow.",
      "name": "proof_of__SemaphoreCreate_partial_solve_wit_2_pure",
      "parent": null,
      "annotation_location": "annotated_C/src/_SemaphoreCreate.c:153"
    },
    {
      "source_attempt": "SemaphoreCreate-vc-proving-r1:entry_calls",
      "manual": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3/verification_runs/SemaphoreCreate-20261021190017/SemaphoreCreate-vc-proving-r1/groups/group_04__entry_calls/SemaphoreCreate_proof_manual.v",
      "message": "Current premises supply safeExec, value bounds, OutsideCritical and (for memset) SemaphoreRaw, but no premise or imported proved fact establishes sizeof(\"Semaphore\") = 32. SemaphoreLayout is only an unproved Prop definition. Named sizes remain abstract in CNotation, so the required allocation/zero-fill size equality does not follow.",
      "name": "proof_of__SemaphoreCreate_partial_solve_wit_2",
      "parent": null,
      "annotation_location": "annotated_C/src/_SemaphoreCreate.c:153"
    }
  ],
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
      "SemaphoreCreate-annotation-r2",
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
      "SemaphoreCreate-annotation-r2"
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
      "SemaphoreCreate-annotation-r2",
      "--target-kind",
      "formal-case-lib"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261019-3"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
