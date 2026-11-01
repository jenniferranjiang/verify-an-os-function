# Outcome

Completed independent r2 analysis of the current 38 top-level obligations and all 7 split goals. The exact-cover plan retains 9 coherent group IDs/order and the same proof modes. This is a proofability plan, not a claim that current witnesses have been compiled as completed proofs. Canonical sources are read-only; the debug copy has only one inserted Show in which_implies_wit_3.

# Structural Blocker Scan

Scanned all 38 top-level VCs, prioritizing 33 no-split whole goals. No definite resource/address/scalar/current-to-pre countermodel remains. partial_solve 8/9 use retval=target at PreH3, and 11/12 use it at PreH10, so field addresses coincide. All restore wands consume exactly their original typed slot; no full os_inv and separate owned slot are required simultaneously. The loop's actual heap states are before/current/marked/next_state, and existential states are instantiated accordingly while before/waiting stay fixed in the continuation.

Current which_implies_3 has no target<>0 conjunct. Its left alternative retains os_inv and can expose the selected semaphore DLL's first pure_suspend_sched_link payload, yielding descriptor registration and SUSPEND; task_wf_aligned yields alignment. Its pure-only alternative still lacks these implications and is not the chosen route. The r1 checking claim that concrete ownership implied a nonzero containing-task base was incorrect; it is explicitly discarded here.

which_implies_6 still needs no old descriptor lookup: replace_task_desc_map leaves os_semaphores unchanged, so the explicit update equation transports the pending relation from current to marked. os_inv marked supplies registered-task and ID-manager facts. No removed target-nonzero fact is used. Safety 7/8 are constant arithmetic; affected partial_solve conclusions only repackage surviving premises or the same heap. entail_2 retains target<>0 as PreH2 from the Wakeup postcondition, independent of the removed earlier annotation, and uses current descriptor/SUSPEND plus exact marked update to prepend one resume step.

# Annotation Comparison Review

Reviewed comparison source LinklistResumeAll-vc-proving-r1:pending_head, current proof_of_LinklistResumeAll_which_implies_wit_3, annotation location annotated_C/src/LinklistResumeAll.c:153. The comparison reports removal solely of target!=0. Independent inspection of the regenerated goal confirms the same input equalities, pending relation and os_inv, the same descriptor existential, alignment, lookup, SUSPEND and pending-list conclusion, and no replacement premise. The conclusion now matches what the frozen semaphore payload and task_world_wf actually establish.

Related propagated obligations reviewed against current source: entail_2; safety_7/8; partial_solve_6_pure/6_aux, 7_pure/7_aux, 8/9, 10_pure/10_aux, 11/12, 13_pure/13_aux, together with their conditional wrappers. They do not require the removed fact. Source identities in the current plan use corrected PreH numbers: alignment in partial_6 is PreH3; lookup in partial_7 is PreH7; pending in partial_10 is PreH11; entail_2 continuation/SUSPEND/head equality/nonzero are PreH35/23/26/27. No new assumptions, predicates, spec changes or executable changes are proposed.

Read the handoff-authorized r1 checking plan/notes and pending_head terminal report to identify the exact correction, then reassessed current goal definitions independently. Old reported acceptance is not treated as proof of changed r2 goals.

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
| which_implies_wit_3 | H: expose suspended descriptor and alignment (the removed target-nonzero fact is neither required nor inferred), then rebuild unchanged os_inv. |
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

Retain r1 group IDs and order because current formal helper/context boundaries are unchanged: steps_effect (1 witness, independent steps-to-batch family, difficulty 5), exstatus_focus (6, map-indexed update, 5), pending_head (3, DLL exposure and its return, 4), id_focus (6, manager extraction and ID frames, 4), loop_step (3, continuation composition/Wakeup glue, 3), final_result (1 parent/3 splits, 2), entry_frames (6, 1), loop_safety (6, 1), pending_call_frames (6, 1). The comparison current stays in pending_head, so controller selects that group for the first batch; the plan order is preserved within each batch. No group exceeds 6 top-level witnesses or the hard limit of 12.

The two singleton groups have independent mathematical boundaries: initialization's legal-heap steps-to-batch theorem versus the final stored-continuation result. Final result and loop step remain independent of the heavy initialization helper. Planned helper families keep current suffixes __steps_effect and __exstatus_focus. Every helper premise is supplied by its assigned VC; no sibling dependency is introduced. No witness-reuse analysis or proof copying was performed.

# Risks or Blockers

No annotation/specification/dependency blocker was found. The remaining substantive obligations are the legal-state steps-to-batch theorem, exstatus map reindexing, and DLL/ID resource focusing; difficulty alone is not a blocker. All changed proofs still require current-group compilation, especially scripts using positional PreH names. The pending-head route must not attempt to recover the deleted nonzero fact from task ownership.

Rocq MCP rocq_compile semantic inspection succeeded (success=true) with the shared-library workspace. It printed semaphore_pending_nodes, pure_suspend_sched_link, pure_published_slink and replace_task_desc_map and checked task_wf_aligned, confirming the precise registered/SUSPEND/alignment source and os_semaphores preservation. This was diagnostic inspection, not completed-VC proof validation. No interactive pet or raw compiler fallback was used.

The exact handoff coq-debug command completed with exit code 0, JSON status=passed and returncode=0. Its authorized overlay showed the current which_implies_wit_3 goal; no proof tactic or generated token was changed. This validates diagnostic loading and the debug boundary, not a completed proof. Final in-memory validation confirmed exact coverage of all 38 top-level VCs, all 7 split names in canonical order, 9 groups, and no duplicate witness.
