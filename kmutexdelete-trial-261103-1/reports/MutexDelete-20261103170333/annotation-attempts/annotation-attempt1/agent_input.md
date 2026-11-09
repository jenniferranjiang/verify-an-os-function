# annotation

Read /home/xinra/qcp-binary-democases/.agents/skills/annotation-designing/SKILL.md and its required documents.

Edit only the listed annotation sources. Generated files change only through symexec. A frozen user spec needs user approval and main's unfreeze before changes. Keep correcting gaps in this attempt; every failed VC comparison must be resolved.

```json
{
  "attempt": "MutexDelete-annotation-r1",
  "round": "MutexDelete-annotation-r1",
  "main_root": "/home/xinra/crtos/kmutexdelete-trial-261103-1",
  "target_files": {
    "c_file": "annotated_C/src/_MutexDelete.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/MutexDelete_lib.v",
    "goal_file": "VC/MutexDelete_goal.v",
    "proof_auto_file": "VC/MutexDelete_proof_auto.v",
    "proof_manual_file": "VC/MutexDelete_proof_manual.v",
    "goal_check_file": "VC/MutexDelete_goal_check.v",
    "case_name": "MutexDelete",
    "active_case_theory": "KMutexDeleteProof.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/annotation-attempts/annotation-attempt1/agent_report.json",
  "notes": "/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/annotation-attempts/annotation-attempt1/agent_output.md",
  "feedback": "User-approved specification unfreeze; resume the same annotation owner and attempt. Previous blocker: {\"failure_class\": \"infrastructure\", \"kind\": \"ambiguous-ghost-struct-field\", \"vcs\": [], \"message\": \"QCP rejects frozen IdRemoveObj high_level_spec at annotated_C/src/_MutexDelete.c:73:26: idnode->id inferred RecordIdNode versus Z in equality with 65535. Logical addr binder cannot disambiguate C struct. No generated VCs. Explicit IdNode field_addr/store normalization is documented in notes and repository precedents, but changes frozen tokens and requires coordinated reused canonical/caller repair beyond owner boundary.\", \"repair_boundary\": \"Main approval/freeze handling for syntax-equivalent IdRemoveObj contracts in annotated_C/src/_MutexDelete.c and annotated_C/src/IdRemoveObj.c; do not change their semantics.\"}",
  "feedback_sources": [],
  "previous_attempt": null,
  "plan": "/home/xinra/crtos/kmutexdelete-trial-261103-1/reports/MutexDelete-20261103170333/annotation-attempts/annotation-attempt1/annotation_plan.json",
  "problem": {
    "problem_statement": "# Frozen KMutexDelete implementation handoff\n\nUser now explicitly authorizes implement for this reviewed KMutexDelete experiment. Freeze predicate `kmutexdelete-predicate-r1` and spec `S2-19632ed3e5482b4086f38e90555d504a40f14a9eb89a23fc04ccf5d377ad4271`. See `.docs/Report/predicate-review.md`, `spec-review.md`, `source-consistency.md`, and `.docs/checks/shared-migration.json`. Live predicate is `/home/xinra/crtos/lib/KMutexDelete.v`, hash 7a4fe9106548d5f07aca0fa278e182b37535b9d346654e7c4d30ae041da63d50. All shared predicate semantics and every caller-local/canonical contract are frozen. Shared files and the four reused-spec files are read-only during per-case owner work; do not silently change their meaning or add assumptions.\n\nThree implementation targets (separate controller cases): LinklistResumeAll (mutex_waiters_oc), _MutexDelete (assumed_environment), KMutexDelete (assumed_environment). Preserve the original three critical-section boundaries and all executable C behavior. Do not apply proposed source fixes. Reused-spec boundaries: IdGetObj, IdRemoveObj.low_level_spec, DoubleLinkListRmNode.remove_member, KTaskWakeup.wakeup_by_id_ic; sources/hashes are in `.docs/Report/reused-spec-imports.md`. Do not generate implementation VCs or reprove their bodies. Other new target contracts are modular callee boundaries whose own implementation runs must also complete before overall success.\n\nTrustBase: `/home/xinra/TrustBase.md`, readonly. Existing CriticalAreaLock/UnLock, allocator x_free via KERNEL_FREE, and CONTAINER_OF model contracts retain their listed scope. User additionally approved A1: same allocation survives from successful lookup through this removal (no other delete/free/reuse); A2: no new waiter joins after drain until removal. These are explicit caller-scoped environment restrictions. mutex_live/mutex_drained lock contracts and guarded observation programs implement exactly these restrictions; do not turn them into ordinary global lock guarantees, freeze unrelated state, add axioms, or assume a pending proof obligation as a fact. Original defects remain in unrestricted executions.\n\nOS annotation adaptation: may add/fix by local, where instantiations, branch-control, Inv/multi-inv, and which-implies annotations. These must retain every real path, ownership and generated proof obligation. C bodies are single-function slices; spec stage intentionally did not supply complete invariants/ghost inference. Add/prove function-specific auxiliary lemmas in each allowed case lib, directly importing the real shared definitions; no Admitted/Parameter/Axiom or placeholder definitions. If frozen spec/predicate needs semantic change, produce concrete proposed delta and stop for main/user review; do not unfreeze yourself.\n\nKeep existing trial annotated_C, _CoqProject, external mappings and global library namespace. QCP tool-side project_layout adapter supports this trial with qcp-project.json (32-bit little-endian no-CRules GCC); VC output uses KMutexDeleteProof.VC. Do not copy shared dependency trees or change to QCP_examples layout. Toolchain is `/home/xinra/crtos/tools/rocq/toolchain.json`, same exact Coq core as prior successful interactive checks. Use required Rocq MCP interaction for proofs; batch compile does not replace it. Main drives all controller actions until done or explicit blocker.\n\nFormal *_obligation definitions are unproved proposition statements. In particular, prove required drain loop/aggregate bridge and retirement resource transformations; never use those definitions as theorem evidence. Case-specific helpers must leave reviewed source semantics unchanged. Original source/config unchanged since design, so source consistency review remains applicable unless body/config is changed.",
    "target_function": "_MutexDelete"
  },
  "failed_vcs": [],
  "writable_files": [
    "annotated_C/src/_MutexDelete.c",
    "VC/MutexDelete_lib.v"
  ],
  "user_spec": {
    "functions": [
      "CriticalAreaLock",
      "CriticalAreaUnLock",
      "DoubleLinkListRmNode",
      "IdRemoveObj",
      "LinklistResumeAll",
      "_MutexDelete",
      "x_free"
    ],
    "frozen": false
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
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-check",
      "--run",
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-annotation-r1",
      "--target-kind",
      "formal-case-lib-design"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  },
  {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "symexec",
      "--run",
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-annotation-r1"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  },
  {
    "argv": [
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/kmutexdelete-trial-261103-1",
      "coq-check",
      "--run",
      "MutexDelete-20261103170333",
      "--round",
      "MutexDelete-annotation-r1",
      "--target-kind",
      "formal-case-lib"
    ],
    "cwd": "/home/xinra/crtos/kmutexdelete-trial-261103-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
