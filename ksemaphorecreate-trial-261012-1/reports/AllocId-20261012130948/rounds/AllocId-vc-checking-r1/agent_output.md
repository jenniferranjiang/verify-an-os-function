# Outcome

43 top-level VCs have executable strategies in 11 independent groups. This is a semantic proofability assessment, not a completed implementation proof. Canonical formal files and accepted predicate sources were read-only; no old trial was accessed. No debug unfolding was needed, so no Show was inserted or coq-debug run.

# Structural Blocker Scan

Scanned all top-level VCs before the split pass, prioritizing entail_wit_2, the three returns, entail_wit_1 and the four partial_solve witnesses. manager_pre is used consistently on both sides; the annotated manager == manager@pre equalities survive loop abstraction. Both failure returns retain all six manager/bitmap/bucket resources. Success has exactly one bitmap replace_Znth and retains old bucket ownership, as required for allocated_unlinked. The bytes existential comes from store_id_map. The partial_solve goals expose an in-bounds cell of the available full array. Pure safety targets have bounds or contradictory guards. No missing resource/current-pre bridge or concrete countermodel was found.

# Annotation Comparison Review

The handoff contains no annotation comparisons. Independently checked premise origins: id_map_bytes_ok and idbuckets_ok are extracted from store_idmanager in entail_wit_2; index scan is initialized/advanced by entail_wit_3/4; entry scan is initialized/advanced by entail_wit_5/6. Returns consume these invariants rather than assuming full/minimum-ID conclusions. The modulo/division distinction is explicit: C quot/rem is rewritten to mathematical div/mod only with nonnegative numerator and positive divisor.

# Proof-Mode Decisions

After the structural scan, all split goals were assessed in manual declaration order before any whole-goal mode decision:

- proof_of_AllocId_safety_wit_9_split_goal_1: 可证.
- proof_of_AllocId_safety_wit_9_split_goal_2: 可证.
- proof_of_AllocId_safety_wit_19_split_goal_1: 可证.
- proof_of_AllocId_safety_wit_19_split_goal_2: 可证.
- proof_of_AllocId_safety_wit_22_split_goal_1: 可证.
- proof_of_AllocId_safety_wit_22_split_goal_2: 可证.
- proof_of_AllocId_safety_wit_27_split_goal_1: 可证.
- proof_of_AllocId_safety_wit_27_split_goal_2: 可证.
- proof_of_AllocId_safety_wit_27_split_goal_3: 可证.
- proof_of_AllocId_safety_wit_27_split_goal_4: 可证.
- proof_of_AllocId_entail_wit_3_split_goal_1: 可证.
- proof_of_AllocId_entail_wit_3_split_goal_2: 可证.
- proof_of_AllocId_entail_wit_4_split_goal_1: 可证.
- proof_of_AllocId_entail_wit_5_split_goal_1: 可证.
- proof_of_AllocId_entail_wit_6_split_goal_1: 可证.

All 15 split goals are provable. Accordingly the 8 parents with splits use aggressive_pre_process without a second whole-goal proofability analysis. The remaining 35 no-split parents are provable and use LLM_pre_process. Exact parent decisions, in manual declaration order:

- proof_of_AllocId_safety_wit_9: aggressive_pre_process.
- proof_of_AllocId_safety_wit_19: aggressive_pre_process.
- proof_of_AllocId_safety_wit_22: aggressive_pre_process.
- proof_of_AllocId_safety_wit_27: aggressive_pre_process.
- proof_of_AllocId_entail_wit_2: LLM_pre_process.
- proof_of_AllocId_entail_wit_3: aggressive_pre_process.
- proof_of_AllocId_entail_wit_4: aggressive_pre_process.
- proof_of_AllocId_entail_wit_5: aggressive_pre_process.
- proof_of_AllocId_entail_wit_6: aggressive_pre_process.
- proof_of_AllocId_return_wit_1: LLM_pre_process.
- proof_of_AllocId_return_wit_2: LLM_pre_process.
- proof_of_AllocId_return_wit_3: LLM_pre_process.
- proof_of_AllocId_safety_wit_1: LLM_pre_process.
- proof_of_AllocId_safety_wit_2: LLM_pre_process.
- proof_of_AllocId_safety_wit_3: LLM_pre_process.
- proof_of_AllocId_safety_wit_4: LLM_pre_process.
- proof_of_AllocId_safety_wit_5: LLM_pre_process.
- proof_of_AllocId_safety_wit_6: LLM_pre_process.
- proof_of_AllocId_safety_wit_7: LLM_pre_process.
- proof_of_AllocId_safety_wit_8: LLM_pre_process.
- proof_of_AllocId_safety_wit_10: LLM_pre_process.
- proof_of_AllocId_safety_wit_11: LLM_pre_process.
- proof_of_AllocId_safety_wit_12: LLM_pre_process.
- proof_of_AllocId_safety_wit_13: LLM_pre_process.
- proof_of_AllocId_safety_wit_14: LLM_pre_process.
- proof_of_AllocId_safety_wit_15: LLM_pre_process.
- proof_of_AllocId_safety_wit_16: LLM_pre_process.
- proof_of_AllocId_safety_wit_17: LLM_pre_process.
- proof_of_AllocId_safety_wit_18: LLM_pre_process.
- proof_of_AllocId_safety_wit_20: LLM_pre_process.
- proof_of_AllocId_safety_wit_21: LLM_pre_process.
- proof_of_AllocId_safety_wit_23: LLM_pre_process.
- proof_of_AllocId_safety_wit_24: LLM_pre_process.
- proof_of_AllocId_safety_wit_25: LLM_pre_process.
- proof_of_AllocId_safety_wit_26: LLM_pre_process.
- proof_of_AllocId_safety_wit_28: LLM_pre_process.
- proof_of_AllocId_safety_wit_29: LLM_pre_process.
- proof_of_AllocId_safety_wit_30: LLM_pre_process.
- proof_of_AllocId_entail_wit_1: LLM_pre_process.
- proof_of_AllocId_partial_solve_wit_1: LLM_pre_process.
- proof_of_AllocId_partial_solve_wit_2: LLM_pre_process.
- proof_of_AllocId_partial_solve_wit_3: LLM_pre_process.
- proof_of_AllocId_partial_solve_wit_4: LLM_pre_process.

# Common Proof Patterns

- CONST / CONTRADICTION: pure machine constants or inconsistent path guards; heap does not supply extra facts.
- BOUNDS / MASK: id_map_bytes_ok gives 0..65535 capacity, entry-scan gives id range, quotient bounds give end<=8192, and C remainder is in 0..7.
- INDEX_SCAN / ENTRY_SCAN: initialize or extend the all-set prefix; entry uses a right-shifted byte and an existential offset. Offset 8 is excluded by the valid byte being different from 255. The shifted result stays in UChar range.
- FRAME / TRANSPORT: preserve resources; expand/fold store_idmanager through OSHeap with its existing heap bridge, choosing the actual byte list. Public OSHeap_ushort_eq and crtos_heap_lift_sep are usable; Local transport lemmas in SemaphoreCriticalViews are not exported. Other transport facts must be established inside witness proofs from their definitions.
- ARRAY: split full into the indexed cell plus missing_i under existing bounds; the final write-preparation VC forgets only the cell value.
- FULL: translate the scan's all-set prefix to idmanager_query using the byte membership equation and quotient/remainder decomposition; fold unchanged manager ownership.
- ALLOCATE: prove minimum free ID from old bit=false and lower bits=true; update exactly one byte/bit and prove id_map_bytes_ok for idlist_add, preserving unlinked bucket resources. No STS transition is involved in this helper function.

formal_case_lib is absent. No helper declarations are planned. Necessary intermediate pure and transport statements belong as proof-local assertions within the selected witnesses, using only accepted sources and their formal dependencies.

# VC Deltas

- return_wit_1: Pattern ALLOCATE (high risk, single independent final-result group). Updated bitmap, success disjunction; before bucket list remains unchanged.
- entail_wit_5: split 1 Pattern ENTRY_SCAN; exact target differences and premise sources are in group_plan.json.
- entail_wit_6: split 1 Pattern ENTRY_SCAN (high risk); exact target differences and premise sources are in group_plan.json.
- safety_wit_22: split 1 Pattern BOUNDS, split 2 Pattern BOUNDS; exact target differences and premise sources are in group_plan.json.
- return_wit_2: Pattern FULL. First clear bit lies beyond capacity; valid IDs all precede it.
- return_wit_3: Pattern FULL. Outer byte scan exhausted; every valid ID lies in an earlier full byte.
- entail_wit_1: Pattern FRAME. See the selected target strategy for its exact constant, guard or array-access difference.
- entail_wit_2: Pattern TRANSPORT. Extract bytes and bridge all native heap atoms.
- entail_wit_3: split 1 Pattern INDEX_SCAN, split 2 Pattern BOUNDS; exact target differences and premise sources are in group_plan.json.
- entail_wit_4: split 1 Pattern INDEX_SCAN; exact target differences and premise sources are in group_plan.json.
- safety_wit_9: split 1 Pattern BOUNDS, split 2 Pattern BOUNDS; exact target differences and premise sources are in group_plan.json.
- safety_wit_14: Pattern BOUNDS. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_19: split 1 Pattern BOUNDS, split 2 Pattern BOUNDS; exact target differences and premise sources are in group_plan.json.
- partial_solve_wit_1: Pattern ARRAY. See the selected target strategy for its exact constant, guard or array-access difference.
- partial_solve_wit_2: Pattern ARRAY. See the selected target strategy for its exact constant, guard or array-access difference.
- partial_solve_wit_3: Pattern ARRAY. See the selected target strategy for its exact constant, guard or array-access difference.
- partial_solve_wit_4: Pattern ARRAY. Forget the exposed cell value for the write.
- safety_wit_27: split 1 Pattern MASK, split 2 Pattern MASK, split 3 Pattern MASK, split 4 Pattern MASK; exact target differences and premise sources are in group_plan.json.
- safety_wit_23: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_28: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_1: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_2: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_3: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_4: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_5: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_6: Pattern CONTRADICTION. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_7: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_8: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_10: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_11: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_12: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_13: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_15: Pattern CONTRADICTION. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_16: Pattern CONTRADICTION. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_17: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_18: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_25: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_26: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_20: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_21: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_24: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_29: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.
- safety_wit_30: Pattern CONST. See the selected target strategy for its exact constant, guard or array-access difference.

# Grouping Decisions

Plan order starts with the highest-risk independent successful return, then entry scan, failure returns and carrier transport. Index-scan/bounds share capacity arithmetic; four array-access witnesses share one split pattern. Remaining safety work is partitioned into groups of at most six by program stage. The single-witness allocate_result group is justified by its independent, substantial final-result bitmap update proof; it has no sibling dependency. All other groups contain 2..6 top-level witnesses, within the hard limit of 12. Groups are independent and may not read sibling output.

# Risks or Blockers

No semantic blocker. High proof-engineering risk: ALLOCATE must establish byte replacement membership and transport, ENTRY_SCAN must discharge shift/testbit arithmetic, and TRANSPORT must bridge pointer/array atoms across carriers without relying on unavailable Local lemmas. Existing accepted idnode lemmas cover byte range, low bits, query correspondence, quotient/modulo decomposition and replacement Forall; remaining facts are proof-local work, not missing premises. Generated-auto admissions are placeholders and provide no verified evidence for any witness in this plan.
