# Outcome

Current six manual top-level VCs are ready for proving; no definite structural counterexample was found. The previously missing concrete assertion instance is now available: the authorized controller coq-debug command exited 0 with status passed and displayed the first split goal after loading the current goal, auto and debug manual. This is an elaboration/debug check, not a completed implementation proof. Canonical files were read only; the debug copy differs only by one inserted Show.

# Structural Blocker Scan

All six top-level VCs have one split each. The four returns retain 0 <= ms_pre <= UINT_MAX, unlike the early range-losing drafts described in the handoff. Quotient and remainder expressions use the same ms_pre as tick_from_time_ms, so no scalar/current-pre bridge is missing. The first view implication owns an actual UInt cell, and the reverse implication owns the corresponding store_uinteger view; neither requires a resource from emp. No whole goal without splits occurs.

# Annotation Comparison Review

All six comparisons concern the generated prelude, not arithmetic premises. Current goal, auto and manual now import CRTOS_Verify.lib.common.CrtosRules before opening sac. The first actual authorized coq-debug check succeeds, directly resolving the prior failure before proof checking. The current return guards, UInt range premises and view resources were independently read and remain coherent; no comparison is accepted as a proof of its arithmetic or resource entailment. The missing scope was a missing concrete-instance import, not demonstrated cache corruption. No adapter, external cache, specification, or generated file was edited in this checking attempt.

# Split-first Judgments

In canonical manual order, all six split goals are judged provable:

| Split suffix | Judgment | Current premise basis |
| --- | --- | --- |
| return_wit_1_split_goal_1 | provable | UInt range and truncated quotient zero guard |
| return_wit_2_split_goal_1 | provable | UInt range, nonzero quotient, remainder in [5,9] |
| return_wit_3_split_goal_1 | provable | UInt range, nonzero quotient, remainder < 5 |
| return_wit_4_split_goal_1 | provable | UInt range, nonzero quotient, remainder > 9 |
| which_implies_wit_1_split_goal_spatial | provable | typed cell at exactly the same address/value as opaque view |
| which_implies_wit_2_split_goal_spatial | provable | opaque view equals the returned typed cell |

These binary judgments precede mode selection. Each parent has a split and its only split is provable, so all six select aggressive_pre_process. No LLM whole-goal route is needed.

# Common Proof Patterns

Arithmetic returns have only pure equalities: use the UInt range to bound the nonnegative product, quotient and remainder; translate C quot/rem to Z.div/mod for a positive divisor; show unsigned_last_nbits is identity on q, r and q+1 where used. Then unfold tick_from_time_ms and select the same guard branches. All bounds originate in current VC premises. There are no witness instantiations, mutable-state refinement or spatial frames in these splits.

Storage views have one resource and no existential: unfold the existing store_uint definition at width four and cancel the identical store_uinteger representation. The parent range-extraction step uses the owned typed cell, while the reverse view preserves it exactly. No helper is planned because the formal case library is absent.

# VC Deltas

The proof obligation shapes are unaffected by the import repair. Return 1 selects minimum one; return 2 selects the guarded increment and must also remove q+1 truncation; return 3 falsifies the lower remainder test; return 4 falsifies the upper test. The two view splits are the forward and reverse representation equality. Exact per-split executable strategies are in group_plan.json.

# Grouping Decisions

arithmetic_returns groups four related quotient/remainder/truncation results, four splits, difficulty 3. range_views groups two same-representation resource transformations, two splits, difficulty 1. Both groups are within the witness limit, independent, and contain only aggressive goals. All current comparison targets are covered. There are no dependencies or helper declarations.

# Risks or Blockers

No current blocker. Native auto results remain generator output. Actual manual proofs, range preprocessing and parent/final checks still must succeed. The increment guard can be handled conditionally as written; there is no need to assume it is reachable. Avoid confusing successful debug loading (with generated placeholders intact) with any VC proof completion.
