# Outcome

Current canonical manual has seven top-level VCs and four split goals. All selected goals are provable from the current accepted predicates and explicit premises. Two independent proof groups are proposed; no helper is planned because the case-lib policy is absent.

# Structural Blocker Scan

Scanned every top-level VC, prioritizing the four without splits. Safety asks only the signed-int bounds of literal 1; return has identical resources on both sides; the partial pure witness asks for its two explicit assumptions; the partial auxiliary wrapper repeats these assumptions and preserves identical resources. The three entailment VCs preserve the same `InsideCritical` parameters, same global nest-cell address, and same frame. No missing address, current/pre-state equality, existential bridge, or concrete countermodel was found. The decrement branches retain `CrtosOSValid after`; the source guard distinguishes positive decrement from the zero no-write path.

# Annotation Comparison Review

The handoff lists no annotation comparisons. Independently checked that the pure validity and exposed nest cell used by the decrement VCs are established by `entail_wit_1`: the accepted `SemaphoreOSInvariant_split_nest` provides both and the exact frame. `SemaphoreOSInvariant_merge_decrement` reconstructs the invariant from that frame and the actual written value. No assumption is introduced only at the point of use.

# Proof-Mode Decisions

All split judgments were completed before considering whole-goal modes, in manual declaration order:

- `entail_wit_1_split_goal_1`: provable (validity follows from the invariant).
- `entail_wit_1_split_goal_spatial`: provable (exact accepted nest split).
- `entail_wit_2_1_split_goal_spatial`: provable (positive guarded decrement and 16-bit bounds).
- `entail_wit_2_2_split_goal_spatial`: provable (validity plus guard implies zero, so no-write agrees with saturated decrement).

The three parents therefore use `aggressive_pre_process` without a separate whole-goal proofability analysis. In manual order, `safety_wit_1`, `return_wit_1`, `partial_solve_wit_1_pure`, and `partial_solve_wit_1` have no split declarations and each has a provable whole goal, so each uses `LLM_pre_process`.

# Common Proof Patterns

Nest resources: frame `SemaphoreInsideCritical`, use the accepted `SemaphoreOSInvariant_split_nest` / `SemaphoreOSInvariant_merge_decrement`, and reassociate the exact global UShort and frame resources. Bounds come from the explicit `CrtosOSValid` hypothesis. No new state witness, heap resource, IRQ token, or scheduler transition is invented.

Pure projection: introduce the existing quantified hypotheses, inject their pure facts, and cancel identical resources. Signed-int literal safety reduces to fixed architecture bounds. Reflexive return preserves the outside-critical predicate without unfolding it.

# VC Deltas

`entail_wit_1` supplies validity and the typed cell/frame. `entail_wit_2_1` additionally normalizes `unsigned_last_nbits (n-1) 16` using `1 <= n <= 65535`, and rewrites the saturated decrement to `n-1`. `entail_wit_2_2` uses `0 <= n < 1` to establish `n=0` and the unchanged cell. `safety_wit_1` proves only literal bounds. `return_wit_1` is reflexive. The partial pure witness repeats two assumptions; its implication wrapper repeats them twice while preserving its heap.

# Grouping Decisions

`nest_resources` has three top-level VCs and all four split goals. Their shared frame and range-normalization context justify keeping them together. `safety_and_projection` has four independent, short whole goals with no heavy transformation. Neither group requires a helper or a sibling result; both respect the limit of twelve parents. The potential tail is the nest arithmetic/resource group; final return and call projections have already been separated.

# Risks or Blockers

No semantic blocker. Resource reassociation and unfolding the official `unsigned_last_nbits` notation may require local tactic adjustment. These are ordinary proof work, not missing premises. The raw generated auto file contains placeholders; every corresponding witness is included in this plan, and proving must use completed manual witnesses rather than relying on those placeholders. Definitions were explicit enough for this analysis; no debug expansion or canonical-file edit was needed.
