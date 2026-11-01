# Outcome

Completed source-level VC analysis and an exact-cover plan for 38 top-level obligations, 7 split goals, and 9 independent groups. This is proofability/planning, not a claim that the manual admits have been proved. Canonical formal files and the debug copy were not changed.

# Structural Blocker Scan

Scanned all top-level goals, prioritizing the 33 without split declarations. No concrete countermodel or missing resource/address/current-to-pre bridge was found. Local pointer rewrites in partial_solve 8/9/11/12 have explicit retval=target premises. The loop continuation keeps before/waiting while the actual heap advances to current/marked/next_state. Existential states can be chosen as those actual states.

The apparent missing old descriptor lookup in which_implies_wit_6 is not a gap. Its two whole-goal disjuncts are identical. KTaskWakeup.v defines semaphore_pending_nodes using only membership and pending-address projection in os_semaphores; replace_task_desc_map preserves that component. Hence current pending nodes imply marked pending nodes from PreH3 alone. ID existence/bounds and lookup are obtained from os_inv marked, task_world_wf, and the owned ID manager. No premise asserting desc equals the old descriptor is needed or assumed.

Current imported formal definitions were inspected read-only after main explicitly authorized that scope: the frozen-source index identifies /home/xinra/crtos/lib/KSemaphoreDelete.v, CrtosInv.v, TaskInv.v and KTaskWakeup.v. os_inv contains the pure suspended waiting payload, task-ID permutation, map registration and actual manager resources. The pure-only alternatives of entail_wit_1 and which_implies_wit_3 drop these resources, so their whole left disjunct is the intended route.

# Annotation Comparison Review

The current handoff contains no annotation comparisons and no previous attempt. All premise origins were checked against the current goal definitions, not a historical result. No predicate or spec changes are proposed.

# Proof-Mode Decisions

After the structural scan, completed the binary split-goal pass in manual declaration order, before selecting whole-goal modes:

| Split goal (prefix proof_of_LinklistResumeAll_) | Judgment |
| --- | --- |
| return_wit_1_split_goal_1 | Provable |
| return_wit_1_split_goal_2 | Provable |
| return_wit_1_split_goal_3 | Provable |
| which_implies_wit_2_split_goal_spatial | Provable |
| which_implies_wit_4_split_goal_spatial | Provable |
| which_implies_wit_5_split_goal_spatial | Provable |
| which_implies_wit_7_split_goal_spatial | Provable |

All five parents therefore use aggressive_pre_process, without a separate whole-parent proofability analysis. Every remaining top-level VC has no split and is provable by its whole goal using LLM_pre_process. Modes in canonical manual order:

- proof_of_LinklistResumeAll_entail_wit_1: LLM_pre_process
- proof_of_LinklistResumeAll_entail_wit_2: LLM_pre_process
- proof_of_LinklistResumeAll_return_wit_1: aggressive_pre_process
- proof_of_LinklistResumeAll_which_implies_wit_1: LLM_pre_process
- proof_of_LinklistResumeAll_which_implies_wit_2: aggressive_pre_process
- proof_of_LinklistResumeAll_which_implies_wit_3: LLM_pre_process
- proof_of_LinklistResumeAll_which_implies_wit_4: aggressive_pre_process
- proof_of_LinklistResumeAll_which_implies_wit_5: aggressive_pre_process
- proof_of_LinklistResumeAll_which_implies_wit_6: LLM_pre_process
- proof_of_LinklistResumeAll_which_implies_wit_7: aggressive_pre_process
- proof_of_LinklistResumeAll_safety_wit_1: LLM_pre_process
- proof_of_LinklistResumeAll_safety_wit_2: LLM_pre_process
- proof_of_LinklistResumeAll_safety_wit_3: LLM_pre_process
- proof_of_LinklistResumeAll_safety_wit_4: LLM_pre_process
- proof_of_LinklistResumeAll_safety_wit_5: LLM_pre_process
- proof_of_LinklistResumeAll_safety_wit_6: LLM_pre_process
- proof_of_LinklistResumeAll_safety_wit_7: LLM_pre_process
- proof_of_LinklistResumeAll_safety_wit_8: LLM_pre_process
- proof_of_LinklistResumeAll_safety_wit_9: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_1: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_2_pure: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_2: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_3: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_4: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_5_pure: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_5: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_6_pure: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_6: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_7_pure: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_7: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_8: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_9: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_10_pure: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_10: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_11: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_12: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_13_pure: LLM_pre_process
- proof_of_LinklistResumeAll_partial_solve_wit_13: LLM_pre_process

# Common Proof Patterns

- P, pure/frame: introduce quantified PreH facts, establish the consequent conjunction from them and cancel the identical heap. Pure conclusions need no emp premise. Conditional pure-to-aux witnesses introduce the pure theorem but their aux premises already provide the required facts.
- A/C, arithmetic/contradiction: constant machine bounds follow by computation/lia; inconsistent explicit branch facts imply False for any heap.
- W, borrowed-slot return: the single typed field and its resume_*_restore wand rebuild exactly the same indexed os_inv.
- H, pending-head exposure: isolate the selected semaphore DLL; distinguish empty/nonempty, borrow the sentinel next field and package its complement as a wand. Legal DLL ownership supplies the head inequality.
- I, ID exposure: at marked, use pending membership, task registration, the ID-node permutation, manager bucket facts and the UShort cell; borrow that cell with a restore wand.
- U, exstatus update: isolate target's map cell and exstatus slot; reassemble all map-indexed invariants after changing only tdExstatus. The exact old descriptor lookup is essential and present in which_implies_wit_4.
- S, semantic continuation: initialization needs the heavy legal-heap steps-to-batch bridge; preservation prepends one exact semaphore_resume_one; exit applies the stored continuation to reflexive nil steps.

# VC Deltas

Names below omit proof_of_LinklistResumeAll_. Each row identifies only the differences from the shared patterns; executable spatial/pure/witness/helper details are in group_plan.json.

| VC | Pattern and actual difference |
| --- | --- |
| entail_wit_1 | S: current=before, remaining=waiting; forget three zero cells; prove initial steps-to-effect helper from os_inv. |
| entail_wit_2 | S: current=next_state, remaining=rest; prepend one step, identify woke_desc by marked map lookup, forget task/node. |
| return_wit_1 | S: split 1 rewrites nil pending; split 2 applies continuation at final=current; split 3 unfolds KOK. |
| which_implies_wit_1 | H: nil next=head versus cons next=sched_link_of first; exact original next restore. |
| which_implies_wit_2 | W: sentinel next field at current. |
| which_implies_wit_3 | H: expose suspended descriptor and alignment/nonzero, then rebuild unchanged os_inv. |
| which_implies_wit_4 | U: old lookup provides desc; target state replaces only exstatus by -1. |
| which_implies_wit_5 | W: exstatus=-1 at marked. |
| which_implies_wit_6 | I: pending relation transports using unchanged os_semaphores; all ID facts derive at marked. |
| which_implies_wit_7 | W: UShort ID at marked. |
| safety_wit_1/2/3/9 | A: bounds for 0. |
| safety_wit_4/8 | A: bounds for 1. |
| safety_wit_5 | C: PreH1 next<>head contradicts PreH6 next=head. |
| safety_wit_6 | C: PreH1 next=head contradicts PreH7 next<>head. |
| safety_wit_7 | A: 1<>INT_MIN. |
| partial_solve_wit_1 | P: entry head equality/pending relation, os_inv before. |
| partial_solve_wit_2_pure / 2 | P: current head nonzero/equality/pending, preserve continuation in aux. |
| partial_solve_wit_3 / 4 | P: preserve next slot/wand in cons/nil branch respectively. |
| partial_solve_wit_5_pure / 5 | P: remaining=target::rest, next=sched_link_of target, current pending. |
| partial_solve_wit_6_pure / 6 | P: supplied alignment and sched-link equality before container conversion. |
| partial_solve_wit_7_pure / 7 | P: supplied current descriptor lookup before exstatus borrow. |
| partial_solve_wit_8 | P: retval=target; forget old exstatus using desc.tdExstatus witness. |
| partial_solve_wit_9 | P: retval=target; preserve written -1 cell. |
| partial_solve_wit_10_pure / 10 | P: marked update equation and old pending list, os_inv marked. |
| partial_solve_wit_11 / 12 | P: target/retval ID address rewrite in opposite directions, same task_id and wand. |
| partial_solve_wit_13_pure / 13 | P: supplied marked ID lookup and pending list before Wakeup. |

# Grouping Decisions

Plan order is risk-first. steps_effect has one independent heavy theorem family (difficulty 5); exstatus_focus owns map-indexed field update (6 VCs, difficulty 5); pending_head owns DLL access (3, difficulty 4); id_focus owns manager/ID extraction (6, difficulty 4). loop_step has the one-step continuation and its Wakeup precondition glue (3, difficulty 3). final_result is independently reviewable (1 parent, 3 splits, difficulty 2), separate from the heavy initial theorem. Three coherent groups of 6 straightforward entry, loop-safety, and pending-call frame witnesses complete coverage. No group exceeds 6 witnesses. This avoids repeated acceptance cost for tiny arithmetic groups while keeping the major resource families independent.

Only two new helpers are declared, both with their owning group suffix. No group depends on or imports a sibling. The final-result group and loop-step group do not use the heavy initialization helper, avoiding a shared critical path. No witness-reuse analysis was performed.

# Risks or Blockers

No annotation/specification/dependency blocker was established. The principal mathematical risk is steps_effect: the pure steps relation must match batch task-map, ready-fold, delay filter/find and semaphore updates from a legal initial heap. The declared obligation Definition is not a proved fact. The next risk is U's reindexing of every map-indexed invariant. DLL and ID-manager extraction may require substantial local structural reasoning, but all premises/resources are present.

Rocq MCP was used for semantic/goal inspection as requested. It did not load this project context successfully: rocq_query(Print semaphore_pending_nodes., file=VC/LinklistResumeAll_lib.v) returned success=false, reason=crashed, error="Coq: semaphore_pending_nodes not a defined object." rocq_start on proof_of_LinklistResumeAll_which_implies_wit_6 listed that theorem but returned reason=not_found with "The reference LinklistResumeAll_which_implies_wit_6 was not found in the current environment." These exact diagnostics were sent to main, who is diagnosing MCP configuration. No successful Rocq proof check is claimed, and no raw CLI proof fallback was used. Source-level planning is complete independently of that inspection failure. No debug goal expansion was required and no coq-debug call was made.
