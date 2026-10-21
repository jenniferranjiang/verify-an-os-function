# Outcome

Completed VC analysis: 25 top-level obligations, four split goals, six independent groups. This is a proofability/grouping decision, not a completed implementation proof. The current auto file still contains admitted seeds; none were treated as established results.

## Structural Blocker Scan

Scanned every top-level VC, prioritizing the 23 no-split goals. No concrete countermodel or missing ownership/current-to-entry bridge was found. All manager/node resources use manager_pre and idnode_pre consistently; the two loop invariants explicitly preserve both entry addresses. Pure safety and call-packaging obligations retain their needed scalar facts. Return 1 has exactly the final linked manager needed for its right branch. Return 2 has the unchanged manager and detached old node needed for its left branch. Return 3 has an inconsistent antecedent: min-free-id entails a nonnegative retval, contrary to retval < 0. No absent detached resource must be manufactured in the success branch. The split-bearing node conversions retain identical field expressions and all three field values.

## Annotation Comparison Review

The handoff contains no annotation comparisons. Independently checked the current assertions: entail 3 establishes id <= 65535 from min-free-id plus the manager id_max UShort range, and establishes link nonzero from accepted store_sem_id_detached metadata. This is not an ABI/address-arithmetic inference. Entail 4 uses the explicitly retained node/link nonzero facts to rebuild the detached predicate after updating id. The accepted source definitions are shared-candidate/arm32le/idnode.v and lib/SemaphoreRep.v; their heap carrier is interpreted using lib/CrtosHeapBridge.v and lib/SemaphoreCriticalViews.v. No historical trial evidence was used.

## Proof-Mode Decisions

After the structural scan, all four split goals were assessed before any whole-goal proofability/mode analysis, in manual declaration order:

1. entail_wit_3_split_goal_1: provable. min-free gives retval < idmax; the owned UShort id_max supplies idmax <= 65535.
2. entail_wit_3_split_goal_2: provable. The exact required link-nonzero fact is in detached metadata.
3. entail_wit_3_split_goal_spatial: provable. Detached unfolds to exactly the three requested cells, under an unchanged manager frame.
4. entail_wit_4_split_goal_spatial: provable. The three cells and explicit metadata reconstruct detached with the new id.

Then all top-level modes were fixed. The two split-bearing parents use aggressive mode without a separate whole-goal proofability analysis. Every no-split parent is provable as a whole and uses LLM mode. Only after these decisions were strategies and groups formed. In the following complete declaration-order table, names omit the common proof_of_IdInsertObj_ prefix.

| Top-level | Split goals / whole-goal decision | Mode |
| --- | --- | --- |
| entail_wit_3 | entail_wit_3_split_goal_1, entail_wit_3_split_goal_2, entail_wit_3_split_goal_spatial | aggressive_pre_process |
| entail_wit_4 | entail_wit_4_split_goal_spatial | aggressive_pre_process |
| return_wit_3 | none; whole goal provable | LLM_pre_process |
| safety_wit_1 | none; whole goal provable | LLM_pre_process |
| safety_wit_2 | none; whole goal provable | LLM_pre_process |
| safety_wit_3 | none; whole goal provable | LLM_pre_process |
| safety_wit_4 | none; whole goal provable | LLM_pre_process |
| safety_wit_5 | none; whole goal provable | LLM_pre_process |
| safety_wit_6 | none; whole goal provable | LLM_pre_process |
| safety_wit_7 | none; whole goal provable | LLM_pre_process |
| safety_wit_8 | none; whole goal provable | LLM_pre_process |
| safety_wit_9 | none; whole goal provable | LLM_pre_process |
| safety_wit_10 | none; whole goal provable | LLM_pre_process |
| safety_wit_11 | none; whole goal provable | LLM_pre_process |
| safety_wit_12 | none; whole goal provable | LLM_pre_process |
| safety_wit_13 | none; whole goal provable | LLM_pre_process |
| safety_wit_14 | none; whole goal provable | LLM_pre_process |
| entail_wit_1 | none; whole goal provable | LLM_pre_process |
| entail_wit_2 | none; whole goal provable | LLM_pre_process |
| return_wit_1 | none; whole goal provable | LLM_pre_process |
| return_wit_2 | none; whole goal provable | LLM_pre_process |
| partial_solve_wit_1_pure | none; whole goal provable | LLM_pre_process |
| partial_solve_wit_1 | none; whole goal provable | LLM_pre_process |
| partial_solve_wit_2_pure | none; whole goal provable | LLM_pre_process |
| partial_solve_wit_2 | none; whole goal provable | LLM_pre_process |

## Common Proof Patterns

- P1, lifted representation: OSHeap preserves the same byte ownership and disjoint joins on the standard empty-token/full-state carrier. Use crtos_heap_lift_sep for separating structure, existing public OSHeap_ushort_eq for UShort, and inline unfolding of scalar pointer/byte stores and heap lift for Ptr. Reuse all byte witnesses and joins. Metadata is pure; the manager frame is unchanged. Local transport lemmas in SemaphoreCriticalViews are not assumed publicly available. No new named helper is planned because formal_case_lib is absent.
- P2, pure frame: introduce whole-goal binders, prove the requested pure facts from explicit PreH assumptions or fixed INT_MIN/INT_MAX constants, and cancel unchanged spatial resources when Q contains them. Q-only-pure cases require no spatial output or existential witnesses.
- P3, branch injection: choose the postcondition disjunct matching the already returned call state, provide its pure facts and cancel its exact heap. For an unreachable branch, derive False from contradictory guards instead of inventing resources.

## VC Deltas

- entail 3 split 1: P1/P2; only idmax's UShort range is needed from the allocated manager, plus retval < idmax. No bitmap or bucket transformation.
- entail 3 split 2: P1/P2; project detached link-nonzero metadata, preserving the exact field-address term.
- entail 3 spatial: P1; expose old_id/previous/next while framing allocated manager.
- entail 4 spatial: P1 in reverse; rebuild metadata from PreH2/3 and repackage id/previous/next. The C write is already reflected in P.
- return 3: P3; min-free's lower bound contradicts the negative guard.
- safety 1, 2, 4, 5, 7, 8, 9: P2; constant zero is within Int bounds. Safety 8 uses full-manager failure frame; safety 9 uses allocated-manager success frame, neither affects the constant conclusion.
- safety 3: P2; manager = 0 and manager <> 0.
- safety 6: P2; node = 0 and node <> 0.
- safety 10: P2; retval >= 0 and retval = -1.
- safety 11, 12: P2; constant 1 differs from INT_MIN. Safety 11 additionally has an impossible min-free/negative guard, but does not need that contradiction.
- safety 13, 14: P2; constant 1 is within Int bounds; safety 14 likewise does not require its unreachable guard to prove the constant claim.
- entail 1: P2; manager/node nonzero and 0 = 0, unchanged entry heaps.
- entail 2: P2; manager/node nonzero and id = 0, unchanged entry heaps.
- return 1: P3; right branch with min-free fact and exact idmanager_link sm (idmanager_add before id) id idnode_pre state. The successful InsertObj contract already supplies this transition.
- return 2: P3; left branch with full-before manager and detached node still carrying old_id/previous/next.
- partial 1 pure: P2; manager nonzero from PreH1, with stack slots and entry heaps as frame.
- partial 1: P2; introduce the implication's premise, unfold aux, reproduce duplicate manager nonzero, node nonzero and id = 0; cancel entry heaps.
- partial 2 pure: P2; manager/node nonzero from PreH1/2, with stack slots and allocated/detached-new-id heaps as frame.
- partial 2: P2; introduce the implication premise, unfold aux, reproduce duplicate manager/node nonzero and min-free; cancel allocated/detached-new-id heaps.

There are no target existentials, safeExec goals, list/array permutations, or fresh mathematical lemmas. Any byte witnesses exposed by P1 are reused from the same input cells. State transitions occur at the accepted call boundaries; the local VCs only expose/repackage node fields or inject already-established call results.

## Grouping Decisions

Plan order prioritizes the only moderately technical carrier conversion: node_representation has two aggressive parents and all four split goals (difficulty 3). return_results independently contains the three final outcomes (difficulty 1). invariants_and_calls contains six coherent invariant/call framing obligations (difficulty 1). initial_constant_safety has five fixed-zero bound obligations; unreachable_checks has the three explicit contradictions; allocation_constant_safety has six post-allocation constant bounds (each difficulty 1). Group sizes are 2, 3, 6, 5, 3, 6, all below the hard limit 12. No helpers or inter-group dependencies are planned. Final-result work is separated from carrier conversion, so it cannot prolong that group's critical path. Each safety group has no split or helper load.

## Risks or Blockers

No semantic blocker found. The main implementation risk is selecting the correct Task versus OS carrier notation during inline pointer-cell transport; the semantic carrier/byte equivalence is explicit in accepted bridge definitions. Do not infer nonzero subobject addresses from integer offsets. Canonical files and accepted predicate sources remain read-only.

The exact handoff controller coq-debug command exited 0 with JSON status passed using its selected pv-bench-8.20.1 coqtop. The authorized debug copy contains only five added Show commands (four splits and return 3); this confirmed loading and goal names, not proof completion. Static reading of actual goal definitions and accepted predicate definitions supplied the semantic analysis. No raw Coq command was used.
