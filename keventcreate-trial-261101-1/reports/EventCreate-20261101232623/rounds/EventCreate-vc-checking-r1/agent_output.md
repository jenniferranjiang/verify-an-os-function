# Outcome

Current manual has 52 top-level witnesses and 19 split goals. Structural scan found no concrete countermodel. All 19 split goals are judged provable; 7 parents use aggressive_pre_process and the other 45 witnesses use LLM_pre_process. This is a proof plan, not a completed proof claim. Canonical files and debug manual were not modified; no coq-debug run was needed for syntactic goal inspection.

# Structural Blocker Scan

Scanned all top-level obligations, prioritizing those without splits. Options stores and pure obligations consistently use options_pre; the current event pointer is the malloc retval or explicitly equal retval alias. Failed ID insertion returns insert-ready ownership (not an unjustified zero ID). All return-state existentials have exact matching OutsideCritical resources. Lock-entry RTrans bridges before and st_lock; no equality of those states is assumed. Success unlock retains InsideCritical at the observed state and os_inv at the published state, as required. ID/local signed bounds can be obtained from typed stores. Event size/offset facts are supplied by the already reviewed EventLayoutABI import; byte conversions remain proof obligations.

# Annotation Comparison Review

Handoff annotation_comparisons is empty. Independently checked the assertion chain: which_implies_1 establishes EventZero and sentinel nonzero facts; which_implies_2 establishes context/freshness and split resources; entail_2_1/2 derive ID range implications and lock bounds from typed resources; which_implies_3 rebuilds failure os_inv/EventRaw and ret continuation; which_implies_5 builds published payload ownership; which_implies_6 rebuilds success os_inv, bounds, transition and continuation. Later VCs consume these premises; they are not axioms. os_world_wf in event_create_frame supplies os_global_context including event_context on the rollback path.

# Proof-Mode Decisions

The complete split pass was finished before deciding whole-goal modes. In manual declaration order:

- proof_of__EventCreate_return_wit_3: proof_of__EventCreate_return_wit_3_split_goal_1: 可证.
- proof_of__EventCreate_partial_solve_wit_13_pure: proof_of__EventCreate_partial_solve_wit_13_pure_split_goal_1: 可证.
- proof_of__EventCreate_which_implies_wit_1: proof_of__EventCreate_which_implies_wit_1_split_goal_1: 可证, proof_of__EventCreate_which_implies_wit_1_split_goal_2: 可证, proof_of__EventCreate_which_implies_wit_1_split_goal_spatial: 可证.
- proof_of__EventCreate_which_implies_wit_2: proof_of__EventCreate_which_implies_wit_2_split_goal_1: 可证, proof_of__EventCreate_which_implies_wit_2_split_goal_2: 可证, proof_of__EventCreate_which_implies_wit_2_split_goal_3: 可证, proof_of__EventCreate_which_implies_wit_2_split_goal_4: 可证, proof_of__EventCreate_which_implies_wit_2_split_goal_spatial: 可证.
- proof_of__EventCreate_which_implies_wit_3: proof_of__EventCreate_which_implies_wit_3_split_goal_1: 可证, proof_of__EventCreate_which_implies_wit_3_split_goal_2: 可证, proof_of__EventCreate_which_implies_wit_3_split_goal_spatial: 可证.
- proof_of__EventCreate_which_implies_wit_5: proof_of__EventCreate_which_implies_wit_5_split_goal_spatial: 可证.
- proof_of__EventCreate_which_implies_wit_6: proof_of__EventCreate_which_implies_wit_6_split_goal_1: 可证, proof_of__EventCreate_which_implies_wit_6_split_goal_2: 可证, proof_of__EventCreate_which_implies_wit_6_split_goal_3: 可证, proof_of__EventCreate_which_implies_wit_6_split_goal_4: 可证, proof_of__EventCreate_which_implies_wit_6_split_goal_spatial: 可证.

All seven parents listed above therefore use aggressive_pre_process without further whole-goal analysis. Every other top-level witness has no split and was judged provable as a whole; these use LLM_pre_process. The exact declaration coverage and modes are in group_plan.json.

# Common Proof Patterns

- Constant/guard safety: introduce quantified variables, unfold machine bounds, derive arithmetic or explicit contradictory branch facts. Spatial resources only frame the pure target.
- Pure facts with frame permutation: expose typed scalar bounds only where needed, copy actual PreH facts, and reassociate/cancel resources. For implication-shaped partial_solve VCs, prove the aux facts from available premises rather than fabricating missing local cells to apply the _pure hypothesis.
- Abstract continuation: unfold abs_event_create choice. Malloc failure takes ret directly; locked failure/success chooses task_atomic_cmd with observed st_lock admitted by RTrans, the concrete locked transition, and after observation LastSeen after. Preserve safeExec's existential initial-state witness.
- Resource conversion: byte initializer splits all 36 bytes with reviewed ABI offsets; failure forgets values into EventRaw. Payload initialization normalizes land 7 to mod 8 and folds an empty waiting DLL. No ownership is invented or duplicated.
- OS frame: isolate/recombine event_inv with event_create_frame. Freshness follows from overlapping options-cell ownership if a new address were already in the list. Success changes both derived ID manager and management DLL consistently; empty new pending list preserves scheduler-owner coverage.

# VC Deltas


zero_layout:
- proof_of__EventCreate_which_implies_wit_1: formal targets are its 3 listed split goals; exact resource/pure differences and witnesses are specified per split in the plan.
- proof_of__EventCreate_partial_solve_wit_1_pure: Unfold the witness; introduce all quantified values and pure premises. Use EventLayoutABI.event_size_axiom and EVENT_MEM_SIZE=36, then integer bounds (UINT_MAX=4294967295). The spatial frame is irrelevant to this pure conclusion; no input range restriction is added.
- proof_of__EventCreate_partial_solve_wit_2_pure: Unfold the witness; introduce all quantified values and pure premises. Use EventLayoutABI.event_size_axiom and EVENT_MEM_SIZE=36, then integer bounds (UINT_MAX=4294967295). The spatial frame is irrelevant to this pure conclusion; no input range restriction is added. The extra memset zero-byte range goals are 0<=0 and 0<=127.

open_event_state:
- proof_of__EventCreate_which_implies_wit_2: formal targets are its 5 listed split goals; exact resource/pure differences and witnesses are specified per split in the plan.
- proof_of__EventCreate_entail_wit_2_1: Choose the left separation disjunct, keeping retval_4=-1 and every resource. Derive lock signed bounds from its Int store. Derive the conditional minimum-ID bound from idmanager_min_free_id and event_context idmax=128 (independent of whether the antecedent minimum-ID condition holds). All other pure facts are copied; reorder the id local cell.
- proof_of__EventCreate_entail_wit_2_2: Choose the right disjunct and retain successful retval_5. Minimum-free-ID plus event_context gives 0<=retval_5<128; the lock Int store yields lock bounds. Reassociate/cancel all unchanged manager, object, frame and local resources.

publish_world:
- proof_of__EventCreate_which_implies_wit_6: formal targets are its 5 listed split goals; exact resource/pure differences and witnesses are specified per split in the plan.

rollback_restore:
- proof_of__EventCreate_which_implies_wit_3: formal targets are its 3 listed split goals; exact resource/pure differences and witnesses are specified per split in the plan.
- proof_of__EventCreate_partial_solve_wit_8_pure: The required Crtos_GTrans st_lock st_lock is already PreH2; lift it to a pure assertion under the unchanged heap.
- proof_of__EventCreate_partial_solve_wit_8: Introduce the _pure implication premise, unfold the aux and cancel/reorder os_inv, EventRaw and InsideCritical. Every requested pure assertion, including the self transition and safeExec ret(-5), is already an explicit PreH; do not instantiate absent local cells.
- proof_of__EventCreate_partial_solve_wit_9: All pure facts are explicit. Commute EventRaw and OutsideCritical and cancel; the full original object remains available for the free call.

payload_init:
- proof_of__EventCreate_which_implies_wit_4: Choose the first disjunct. Unfold NodeZero at the pending sentinel, use the nested-field address identity for SysDoubleLinklistNode fields, forget the zero values to Ptr undef and commute next/prev. Alternatively the second disjunct witnesses are both 0. No new event alignment assumption is required; this is field-resource unfolding.
- proof_of__EventCreate_which_implies_wit_5: formal targets are its 1 listed split goals; exact resource/pure differences and witnesses are specified per split in the plan.
- proof_of__EventCreate_partial_solve_wit_10: All pure facts are copied from PreH; move pending NodeZero to the front and cancel the exact remaining manager, frame, DLL, fields, padding and InsideCritical resources.
- proof_of__EventCreate_partial_solve_wit_11: The consequent has the same two pending pointer undef cells and remaining resources as the antecedent. Introduce existing pure facts and cancel; no reinitialization or loss of pointer permission is needed.

allocation_calls:
- proof_of__EventCreate_partial_solve_wit_1: Unfold the implication/aux; establish sizeof(Event)=36 bounds via reviewed ABI, retain OutsideCritical and all explicit pure premises. The aux has no local cells, so prove arithmetic independently rather than trying to construct the full premise of the supplied _pure VC.
- proof_of__EventCreate_partial_solve_wit_2: Introduce the _pure premise; unfold aux and rewrite sizeof(Event)=36. Copy pointer/alignment/options/safeExec facts, establish constant memset bounds, and cancel undef byte-array plus OutsideCritical.
- proof_of__EventCreate_partial_solve_wit_3_pure: The pointer positivity, upper malloc bound and alignment are explicit PreH3/4/5. Lift them under the byte-array/local/OutsideCritical frame.
- proof_of__EventCreate_partial_solve_wit_3: Introduce the _pure premise and unfold aux. Copy the existing pointer/alias/options/safeExec premises and cancel the same zero-byte array and OutsideCritical; retval_2=retval is present.

allocation_safety:
- proof_of__EventCreate_safety_wit_1: Introduce all values and premises. The target only asserts 0 is within signed int bounds; unfold INT_MIN/INT_MAX and use arithmetic. Heap contents and aliases can be framed away for this pure result.
- proof_of__EventCreate_safety_wit_2: Introduce all values and premises. The target only asserts 0 is within signed int bounds; unfold INT_MIN/INT_MAX and use arithmetic. Heap contents and aliases can be framed away for this pure result.
- proof_of__EventCreate_safety_wit_3: Introduce all values and premises. The target only asserts 0 is within signed int bounds; unfold INT_MIN/INT_MAX and use arithmetic. Heap contents and aliases can be framed away for this pure result.
- proof_of__EventCreate_safety_wit_4: Introduce all values and premises. The target only asserts 0 is within signed int bounds; unfold INT_MIN/INT_MAX and use arithmetic. Heap contents and aliases can be framed away for this pure result.
- proof_of__EventCreate_safety_wit_5: Introduce all values and premises. The target only asserts 0 is within signed int bounds; unfold INT_MIN/INT_MAX and use arithmetic. Heap contents and aliases can be framed away for this pure result.
- proof_of__EventCreate_safety_wit_10: Introduce all values and premises. The target only asserts 0 is within signed int bounds; unfold INT_MIN/INT_MAX and use arithmetic. Heap contents and aliases can be framed away for this pure result.

branch_safety:
- proof_of__EventCreate_safety_wit_6: Use retval<>0 and retval=0 to derive False; the heap is irrelevant.
- proof_of__EventCreate_safety_wit_7: Use retval=0 and 0<retval to derive False; the heap is irrelevant.
- proof_of__EventCreate_safety_wit_8: Unfold INT_MIN; prove 5<>INT_MIN by arithmetic under the frame.
- proof_of__EventCreate_safety_wit_9: Unfold signed bounds and prove INT_MIN<=5<=INT_MAX.
- proof_of__EventCreate_safety_wit_15: Unfold INT_MIN; prove 5<>INT_MIN. All rollback resources remain a frame.
- proof_of__EventCreate_safety_wit_16: Unfold signed bounds and prove INT_MIN<=5<=INT_MAX under OutsideCritical and locals.

id_safety:
- proof_of__EventCreate_safety_wit_11: The target is the signed representability of 0; unfold integer bounds and prove arithmetically, leaving the failed ID branch resources irrelevant.
- proof_of__EventCreate_safety_wit_12: The target is the signed representability of 0; prove arithmetically, independent of the successful inserted manager.
- proof_of__EventCreate_safety_wit_13: Combine retval_4>=0 with retval_4=-1 to derive False.
- proof_of__EventCreate_safety_wit_14: Apply the explicit conditional minimum-free-ID range premise to the explicit minimum-free-ID premise; contradiction with retval_4<0.
- proof_of__EventCreate_entail_wit_1: Extract 0<=options_pre<=UINT_MAX from the owned UInt local cell, not from a strengthened function precondition. Reintroduce duplicate/reversed bounds and original safeExec and cancel the same UInt cell plus OutsideCritical.

lock_and_id_calls:
- proof_of__EventCreate_partial_solve_wit_4: Copy all explicit pure premises and commute EventZero with OutsideCritical. No new state witness is needed.
- proof_of__EventCreate_partial_solve_wit_5: The observed lock state st_lock and RTrans from before are explicit. Copy them, reorder os_inv/EventZero/InsideCritical and cancel without equating before to st_lock.
- proof_of__EventCreate_partial_solve_wit_6: Copy nonnull/alignment/context/freshness/RTrans/alias/options/safeExec facts; reorder manager and insert-ready ID to satisfy IdInsertObj, retaining the complete frame and field resources.
- proof_of__EventCreate_partial_solve_wit_7_pure: Project explicit nonnull, alignment, sentinel nonzero, safeExec original command and RTrans facts from the failed ID branch.
- proof_of__EventCreate_partial_solve_wit_7: Unfold the implication/aux. All pure requirements are explicit; reorder the event_create_frame, unchanged manager/DLL and private object resources. The ID remains insert-ready rather than zero.

publish_calls:
- proof_of__EventCreate_partial_solve_wit_12_pure: Project event nonnull/alignment/link nonzero and minimum-free-ID from explicit premises; retain the initialized sentinel as frame.
- proof_of__EventCreate_partial_solve_wit_12: Unfold aux after introducing _pure. Copy pure premises, move options/events and self-linked pending sentinel to the front, and cancel the exact unchanged frame/manager/DLL/object resources.
- proof_of__EventCreate_partial_solve_wit_13: Unfold aux and independently establish dll_insert_anchor at the head from the store_dll (including head nonzero), keeping the DLL for the call. Copy explicit pure facts and cancel/reorder store_event, occupy_dll_node, inserted manager, event_create_frame and InsideCritical. Do not try to use an unavailable local-cell premise from _pure.
- proof_of__EventCreate_partial_solve_wit_13_pure: formal targets are its 1 listed split goals; exact resource/pure differences and witnesses are specified per split in the plan.

success_unlock:
- proof_of__EventCreate_partial_solve_wit_14_pure: Project nonnull/alignment/event_context/minimum-ID/freshness/original safeExec/RTrans from explicit premises after management insertion.
- proof_of__EventCreate_partial_solve_wit_14: Introduce _pure, unfold aux, copy all explicit premises and reorder event_create_frame, inserted manager, extended DLL and InsideCritical. Keep dll_insert_after_dispatch unchanged here; publication normalization belongs to which_implies_6.
- proof_of__EventCreate_partial_solve_wit_15_pure: The exact success Crtos_GTrans is already PreH4. Lift it under the updated os_inv and local/token frame.
- proof_of__EventCreate_partial_solve_wit_15: Introduce _pure, unfold aux, copy ID bounds, exact post safeExec and success transition; reorder InsideCritical and updated os_inv for unlock. Keep InsideCritical indexed by st_lock and os_inv indexed by the published after state.

returns:
- proof_of__EventCreate_return_wit_1: Choose after_2=replace_events(event_publish retval_2 retval options_pre (os_events st_lock)) st_lock. Bounds and safeExec(ret retval) are explicit; cancel OutsideCritical at precisely that state.
- proof_of__EventCreate_return_wit_2: Choose after=st_lock. The -5 equality is reflexive and safeExec(ret -5) is explicit; cancel OutsideCritical.
- proof_of__EventCreate_return_wit_3: formal targets are its 1 listed split goals; exact resource/pure differences and witnesses are specified per split in the plan.

# Grouping Decisions

Thirteen independent groups are ordered with the highest-risk families first: zero-byte layout, opening/freshness, complete successful publication, then rollback restoration and payload initialization. The publish_world singleton is justified by its independent heavy ID-bucket consistency/world-restoration helper family and five split goals. No group has more than six top-level witnesses (hard limit 12). Lower-risk allocation/safety/frame/return work is separated from heavy mathematical transformations. No group imports sibling output. Helpers are only those to be newly proved in their assigned group; suffixes match group IDs. The two publication helpers are proved within publish_world; the zero-byte and freshness helpers are owned by their respective groups. Final-result work is separate from state publication to avoid an unnecessary tail dependency.

# Risks or Blockers

No confirmed blocker. Highest implementation risks are: translating byte arrays into typed stores without losing ID padding; extracting a payload from a DLL to prove freshness; relating 16 filtered event buckets to idmanager_link/add; transporting all OS predicates through replace_events; and deriving safeExec residuals while preserving its existential witness. These are proof work, not grounds to weaken contracts. Definitions ending in _obligation are propositions awaiting proof, not available lemmas. The reviewed EventLayoutABI size and top-level field-offset axioms are trusted layout facts; no further axioms or whole-VC assumptions are planned. All input uint32 options remain admitted, including values whose low three bits are not a valid wait strategy.
