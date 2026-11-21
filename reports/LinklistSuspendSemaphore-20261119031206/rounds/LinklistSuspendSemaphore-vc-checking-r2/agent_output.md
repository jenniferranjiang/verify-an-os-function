# Outcome

Current r2 VC analysis and plan completed. This is proof planning, not implementation proof or final-check. There are 26 manual top-level obligations and 9 split goals; 9 parents use aggressive_pre_process and 17 use LLM_pre_process. The native auto file remains untouched.

## Structural Blocker Scan

Scanned the actual top-level formulas, prioritizing no-split goals. No definite countermodel/resource-address/current-to-pre bridge gap was identified. Task/flag/list variables in the borrowed views have explicit equalities; the last-node loop branch carries next_link=list_pre before restoring the local list cell. The same-task/two-priority-field alias is excluded by self-owned versus semaphore-owned scheduler nodes in os_inv, and must be proved spatially rather than assumed. The end-of-list/nonempty-suffix branch entails a sentinel/member alias contradiction requiring the actual DLL ownership. Enqueue is not a pure lookup shortcut: it must move the self-owned node, preserve all other ownership, and rebuild os_inv including Dataqueue relations.

## Annotation Comparison Review

The comparison points to the real derived-spec entailment obligation. Current generated files explicitly import SimpleC.CoreLang.CTypes.SimpleCtypeNotations; the existing CRTOS assertion instance is retained. I inserted only Show. in the allowed debug-manual proof and ran the exact controller coq-debug invocation. It exited 0 with status passed, loading the complete current goal (including FuncSig/Spec/HoareFun), auto and debug manual, and displayed the first top-level goal. Thus the previous pointer/struct ctype notation parse failure is actually resolved; no raw compiler, generated-file edit or MCP source transmission was used.

The derived-spec entailment definition and corresponding manual witness remain present; the generated VC_Correct signature requires the witness. Its premise is the priority contract, its result chooses the unchanged base parameters plus a return wand. The base step at flag=1 forces return=0 and gives the defined priority step. No new premise was added by the import change. This independent check does not treat annotation comparison resolved as a mathematical proof.

## Split-first Decisions

All split goals were considered before assigning top-level proof modes. In manual declaration order:
- `proof_of_LinklistSuspend_return_wit_1_split_goal_1`: provable; valid/invalid branch construction of linklist_suspend_step from the explicit suspend/enqueue/guard facts.
- `proof_of_LinklistSuspend_return_wit_2_split_goal_1`: provable; valid/invalid branch construction of linklist_suspend_step from the explicit suspend/enqueue/guard facts.
- `proof_of_LinklistSuspend_return_wit_3_split_goal_1`: provable; valid/invalid branch construction of linklist_suspend_step from the explicit suspend/enqueue/guard facts.
- `proof_of_LinklistSuspend_return_wit_4_split_goal_1`: provable; valid/invalid branch construction of linklist_suspend_step from the explicit suspend/enqueue/guard facts.
- `proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial`: provable; matching field/DLL plus its saved wand, with the given dispatch equality, entails the restored resource.
- `proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial`: provable; matching field/DLL plus its saved wand, with the given dispatch equality, entails the restored resource.
- `proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial`: provable; matching field/DLL plus its saved wand, with the given dispatch equality, entails the restored resource.
- `proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial`: provable; matching field/DLL plus its saved wand, with the given dispatch equality, entails the restored resource.
- `proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial`: provable; matching field/DLL plus its saved wand, with the given dispatch equality, entails the restored resource.

All nine split judgments are provable, so their parents select aggressive_pre_process. Every other top-level has no split and was considered as a whole; all select LLM_pre_process. The whole-goal disjunctions may use their resource-preserving spatial arm instead of an unnecessarily strong pure-only arm. No helper is planned because case-lib policy is absent.

## Common Proof Patterns

- Borrow/restore: split actual task map/ID bucket or Semaphore DLL ownership, expose only the requested field(s), and retain a wand rebuilding the same os_inv. Normalize address/value equations before wand elimination; do not unfold the full global frame unnecessarily.
- Suspend identity/state: identify the returned task from the functional registered ID relation, using preserved manager facts and available os_inv where needed; unfold admissibility and SuspendKTask's step to obtain the actual suspended descriptor/self-owned node and unchanged semaphore/service frame.
- Loop progress: choose prefix=[] at entry, append current_task to the scanned prefix on continuation, choose rest as new suffix, and derive the new prefix comparison from the actual descriptor lookup and <= guard. Restore the identical staged os_inv using the saved field wand.
- Ownership transfer: construct after from semaphore_enqueue_state plus removal of the task from sched_owned_tasks; use NoDup/spatial exclusion to show the task moves exactly once and preserve the scheduler owner permutation, descriptor map, service restrictions, semaphore IDs/value, Dataqueue references and other modules.
- Priority insertion: use the scanned prefix and strict break condition (or empty suffix) to construct linklist_priority_insert; no sorted-list precondition. Prove the concrete before/after dispatch result matches the chosen mapped task sequence.
- Results/spec specialization: instantiate the explicit linklist_suspend_step arm with existing staged/ignored/after witnesses; derived priority spec chooses the same pre-state parameters and uses flag=1 to force the valid result-zero arm.

## VC Deltas and Grouping Decisions

The full executable strategies are in group_plan.json, only for selected formal proof targets. Group order:

1. spec_and_results: derived entailment plus return_wit_1..4; isolated comparison current and final relation construction, 5 tops/4 splits, difficulty2.
2. suspend_identity: entail_wit_1_1/1_2/2_1/2_2 and which_implies_wit_1; ID field borrow, task identification and staged state, 5 tops/1 split, difficulty4.
3. fifo_enqueue: entail_wit_3 and which_implies_wit_2; FIFO ownership transfer and its exact return wand, 2 tops/1 split, difficulty5.
4. priority_enqueue: entail_wit_7_1..7_4 and which_implies_wit_4/7; exit-position semantics, shared high-cost ownership transfer and resulting DLL restoration, 6 tops/2 splits, difficulty5.
5. loop_progress: entail_wit_4_1/4_2/6_1/6_2; empty/cons initialization and two advance shapes, 4 tops, difficulty3.
6. loop_borrows: entail_wit_5 and which_implies_wit_3/5/6; two task priority fields, current next and sentinel head/tail field views, 4 tops/1 split, difficulty5.

Every top-level occurs exactly once; every split follows its parent. All groups are independent and within the 12-witness cap. FIFO and priority updates are separate to avoid one long transition group; priority exit cases share the same nontrivial enqueue/frame family and remain together. Final result construction is separated from heavy state transitions. No dependency/pool or new case-library helper is introduced.

## Risks or Blockers

No current blocker. The real proving risks are task/ID identity under a preserved manager, disjoint priority-field borrowing, sentinel/member exclusion, and reconstructing os_inv after transferring one self-owned scheduler node to one semaphore while preserving Dataqueue associations. These require actual proofs, not assertions of the corresponding Prop obligations. The successful loading check and this plan do not establish any of the 26 implementation VCs.
