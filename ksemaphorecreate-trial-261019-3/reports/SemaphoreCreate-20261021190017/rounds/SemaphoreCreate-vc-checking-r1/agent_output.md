# Outcome

Completed analysis and a 9-group plan covering all 38 current top-level witnesses. This is a proofability assessment, not a completed Rocq proof. Canonical formal files were read-only; the debug copy was not edited and no debug compilation was needed.

# Structural Blocker Scan

Scanned all top-level VCs, prioritizing all 28 without generated splits. No definite missing-address, scalar-equality, current/@pre, or existential-state countermodel was found. Calls preserve the same sem/val values; memset supplies retval_2=retval explicitly. The three return existentials select the concrete published state, locked state, and before state respectively. The original entry entailment retains the UShort cell required for its bounds. The partial-solve auxiliary goals have independent layout/ownership/reflexivity proofs of their pure side conditions, so they do not need to reconstruct discarded local stack cells.

As authorized in the main handoff clarification, current imported definitions in lib/KSemaphoreCreate.v and shared_candidates were inspected read-only. abs_semaphore_create is choice (ret (-5)) (task_atomic_cmd ...), with no val-range premise; its err relation is false. SemaphoreZero owns the value field separately from all published payloads, allowing spatial freshness. os_inv carries os_world_wf and semaphore_inv carries semaphore_context. The current CriticalSTS transition is True; this analysis uses the current protocol semantics and adds no IRQ facts.

# Annotation Comparison Review

No annotation comparisons were supplied in this attempt. Independently checked the origins of the newly exposed pure facts in entail_wit_2: alignment comes from SemaphoreZero, context and world well-formedness from the opened invariant, and address freshness must be proved from disjoint ownership. The publication transition and reconstructed invariant are established by entail_wit_5; partial_solve_wit_9 merely consumes its explicit transition, so there is no circular assumption.

# Proof-Mode Decisions

All split judgments below were completed before selecting whole-goal modes. In current manual declaration order:

- `proof_of__SemaphoreCreate_entail_wit_1_split_goal_1`: 不可证.
- `proof_of__SemaphoreCreate_entail_wit_1_split_goal_2`: 不可证.
- `proof_of__SemaphoreCreate_entail_wit_2_split_goal_1`: 可证.
- `proof_of__SemaphoreCreate_entail_wit_2_split_goal_2`: 可证.
- `proof_of__SemaphoreCreate_entail_wit_2_split_goal_3`: 可证.
- `proof_of__SemaphoreCreate_entail_wit_2_split_goal_4`: 可证.
- `proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial`: 可证.
- `proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial`: 可证.
- `proof_of__SemaphoreCreate_entail_wit_4_split_goal_1`: 可证.
- `proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial`: 可证.
- `proof_of__SemaphoreCreate_entail_wit_5_split_goal_1`: 可证.
- `proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial`: 可证.
- `proof_of__SemaphoreCreate_return_wit_1_split_goal_1`: 可证.
- `proof_of__SemaphoreCreate_return_wit_2_split_goal_1`: 可证.
- `proof_of__SemaphoreCreate_return_wit_3_split_goal_1`: 可证.
- `proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_1`: 可证.
- `proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_2`: 可证.
- `proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1`: 可证.

Both entail_wit_1 splits have lost the UShort resource and their remaining safeExec assumption imposes no bounds on val. Its original full-resource disjunct remains provable. Every other split retains the resources or pure premises required by its conclusion.

All modes were then fixed before writing tactics, helpers or groups:

- `proof_of__SemaphoreCreate_entail_wit_1`: `LLM_pre_process` (`entry_calls`).
- `proof_of__SemaphoreCreate_entail_wit_2`: `aggressive_pre_process` (`open_close`).
- `proof_of__SemaphoreCreate_entail_wit_3`: `aggressive_pre_process` (`open_close`).
- `proof_of__SemaphoreCreate_entail_wit_4`: `aggressive_pre_process` (`list_prepare`).
- `proof_of__SemaphoreCreate_entail_wit_5`: `aggressive_pre_process` (`publish`).
- `proof_of__SemaphoreCreate_return_wit_1`: `aggressive_pre_process` (`return_refinement`).
- `proof_of__SemaphoreCreate_return_wit_2`: `aggressive_pre_process` (`return_refinement`).
- `proof_of__SemaphoreCreate_return_wit_3`: `aggressive_pre_process` (`return_refinement`).
- `proof_of__SemaphoreCreate_partial_solve_wit_4_pure`: `aggressive_pre_process` (`call_guards`).
- `proof_of__SemaphoreCreate_partial_solve_wit_6_pure`: `aggressive_pre_process` (`call_guards`).
- `proof_of__SemaphoreCreate_safety_wit_1`: `LLM_pre_process` (`safety_entry`).
- `proof_of__SemaphoreCreate_safety_wit_2`: `LLM_pre_process` (`safety_entry`).
- `proof_of__SemaphoreCreate_safety_wit_3`: `LLM_pre_process` (`safety_entry`).
- `proof_of__SemaphoreCreate_safety_wit_4`: `LLM_pre_process` (`safety_entry`).
- `proof_of__SemaphoreCreate_safety_wit_5`: `LLM_pre_process` (`safety_entry`).
- `proof_of__SemaphoreCreate_safety_wit_6`: `LLM_pre_process` (`safety_alloc`).
- `proof_of__SemaphoreCreate_safety_wit_7`: `LLM_pre_process` (`safety_alloc`).
- `proof_of__SemaphoreCreate_safety_wit_8`: `LLM_pre_process` (`safety_alloc`).
- `proof_of__SemaphoreCreate_safety_wit_9`: `LLM_pre_process` (`safety_alloc`).
- `proof_of__SemaphoreCreate_safety_wit_10`: `LLM_pre_process` (`safety_alloc`).
- `proof_of__SemaphoreCreate_safety_wit_11`: `LLM_pre_process` (`safety_locked`).
- `proof_of__SemaphoreCreate_safety_wit_12`: `LLM_pre_process` (`safety_locked`).
- `proof_of__SemaphoreCreate_safety_wit_13`: `LLM_pre_process` (`safety_locked`).
- `proof_of__SemaphoreCreate_safety_wit_14`: `LLM_pre_process` (`safety_locked`).
- `proof_of__SemaphoreCreate_safety_wit_15`: `LLM_pre_process` (`safety_locked`).
- `proof_of__SemaphoreCreate_safety_wit_16`: `LLM_pre_process` (`safety_locked`).
- `proof_of__SemaphoreCreate_partial_solve_wit_1_pure`: `LLM_pre_process` (`entry_calls`).
- `proof_of__SemaphoreCreate_partial_solve_wit_1`: `LLM_pre_process` (`entry_calls`).
- `proof_of__SemaphoreCreate_partial_solve_wit_2_pure`: `LLM_pre_process` (`entry_calls`).
- `proof_of__SemaphoreCreate_partial_solve_wit_2`: `LLM_pre_process` (`entry_calls`).
- `proof_of__SemaphoreCreate_partial_solve_wit_3`: `LLM_pre_process` (`entry_calls`).
- `proof_of__SemaphoreCreate_partial_solve_wit_4`: `LLM_pre_process` (`call_guards`).
- `proof_of__SemaphoreCreate_partial_solve_wit_5`: `LLM_pre_process` (`call_guards`).
- `proof_of__SemaphoreCreate_partial_solve_wit_6`: `LLM_pre_process` (`call_guards`).
- `proof_of__SemaphoreCreate_partial_solve_wit_7`: `LLM_pre_process` (`list_prepare`).
- `proof_of__SemaphoreCreate_partial_solve_wit_8`: `LLM_pre_process` (`list_prepare`).
- `proof_of__SemaphoreCreate_partial_solve_wit_9_pure`: `LLM_pre_process` (`publish`).
- `proof_of__SemaphoreCreate_partial_solve_wit_9`: `LLM_pre_process` (`publish`).

# Common Proof Patterns

- P1: Typed ownership supplies integer bounds, alignment or address validity; retain and frame the cell while extracting pure consequences. Applies to entry bounds and call guards.
- P2: Open/fold os_inv, semaphore_inv and SemaphoreZero; use existing world/context conjuncts, normalize global addresses, and cancel unchanged resources. Freshness additionally follows by contradiction from duplicate value-field ownership in a DLL member.
- P3: Open a circular DLL at its first edge and recombine an inserted cut with its unchanged tail. Empty-list case uses head=next with distinct fields; no inequality between those nodes is assumed.
- P4: Publication builds a cons semaphore state, with an empty pending list, unchanged task/role/scheduling fields, and a manager map/filter bridge matching allocation plus hash-bucket insertion.
- P5: Pure safeExec refinement follows an existing normal transition of the abstract choice: immediate failure, atomic full-ID failure, or atomic success. The returned LastSeen predicate is exactly the poststate rely closure; no concrete heap is consumed by these splits.
- P6: Auxiliary call VCs reassert supplied pure facts and permute identical resources; prove constant/layout/reflexivity side conditions directly where local cells were removed.
- P7: Safety bounds are closed constants; inconsistent guards close False by arithmetic.

# VC Deltas

- entail_wit_1: P1 on the original full-local-store branch; its generated pure splits remain unused.
- entail_wit_2: P2 opens world/semaphore/private-object resources and establishes freshness; 5 formal split targets.
- entail_wit_3: P2 folds the unchanged state and untouched private object on ID-full failure; 1 spatial split.
- entail_wit_4: P3 exposes insertion cut, derives id<128 from context, and weakens zero pending-node cells to writable storage; 2 splits.
- entail_wit_5: P4 publishes the new object and folds the new invariant; guarantee target uses the actual current CriticalSTS. Two independent formal splits, with manager/world helpers local to the publish group.
- return_wit_1/2/3: P5 success, locked capacity failure, and allocation failure, respectively.
- partial_solve_wit_1[_pure]/2[_pure]: P6 plus current Semaphore sizeof=32 layout evidence.
- partial_solve_wit_3: P6 with explicit memset equality and private zero-object frame.
- partial_solve_wit_4[_pure]: P1 address validity plus P6 reordering; no stack-resource reconstruction.
- partial_solve_wit_5: P6 moves SemaphoreZero to the free-call position.
- partial_solve_wit_6[_pure]: P6 with reflexive guarantee for unchanged locked state.
- partial_solve_wit_7/8: P6 moves NodeStorage/insertion cut to the front while retaining tail and frame.
- partial_solve_wit_9[_pure]: P6 with already-established explicit publication guarantee.
- safety_wit_1..16: P7; contradictions at 6,7,13,14; constant 5 inequalities at 8,9,15,16; remaining targets constant 0 bounds.

# Grouping Decisions

Dispatch order prioritizes publication and invariant/freshness obligations, then DLL preparation and independent return refinement. Publication retains its own two consumption VCs and local helpers but is separated from final return refinement and trivial safety work, preventing a single oversized tail group. The remaining groups follow coherent allocation-entry/call-guard/program-phase safety contexts. Counts are 3,2,3,3,6,5,5,5,6 top-level witnesses; all comply with the maximum 12 and usual 2–6 range. No sibling dependency or output reuse is planned. Each helper statement and all premise sources are documented in group_plan.json.

# Risks or Blockers

No definite blocker. Highest risk is the manager representation bridge for entail_wit_5 (map/filter of the cons state versus ID-add/link), followed by DLL-member freshness and list cut/reassembly. These are proof obligations, not assumptions. All return proofs must use actual safeExec/normal-transition lemmas with the current LastSeen lifting. Existing layout facts must be used as currently imported; adding new axioms, weakening predicates or bypassing checks is not part of this plan. The pure entry splits are genuinely unprovable but are not blockers because the original witness is provable.
