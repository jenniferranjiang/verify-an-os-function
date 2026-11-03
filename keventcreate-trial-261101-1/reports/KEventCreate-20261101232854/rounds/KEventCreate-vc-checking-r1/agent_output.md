# KEventCreate VC checking

Outcome: all four current top-level VCs are provable; no annotation/specification/dependency blocker. No canonical file or debug copy was edited.

## Structural blocker scan

Read current goal, manual, auto, goal-check and active case lib. The manual contains four top-level declarations in this order: return_wit_1, return_wit_2, partial_solve_wit_1_pure, partial_solve_wit_1. All have no split declarations. Each returned-state existential can be instantiated by the same after_3 already indexing the sole OutsideCritical resource. Every pure result/bound/safeExec fact is an explicit PreH premise. The callee precondition uses exactly the same options_pre, before, sg and X as its available PreH1; there is no missing scalar/current-@pre bridge or missing resource address. No countermodel or structural gap was found.

## Annotation comparison review

The current handoff contains no annotation comparisons and no prior attempts/feedback sources. All facts used below are explicit in the current definitions, so no comparison resolution or historical proof is assumed.

## Split-first and proof-mode decisions

The complete split-goal pass is empty: each of the four top-level VCs has zero split goals. Only after completing that pass, inspected each whole VC in manual order. All four whole goals are provable and select LLM_pre_process. No aggressive mode or split strategy is appropriate.

## Common proof patterns

R: introduce quantified parameters and pure hypotheses, instantiate the post-state existential using the current state index, introduce given pure facts and cancel the identical OutsideCritical resource. No internal critical-state or OS-invariant unfolding and no refinement transition is necessary.

P: introduce quantifiers and PreH1, establish pure safeExec assertions directly from that identical premise, and preserve/cancel OutsideCritical when present. Pure facts can be duplicated; spatial ownership is not duplicated. The UInt options cell is only present in the pure-side-condition antecedent and need not be transformed.

## VC deltas

- return_wit_1: pattern R; after := after_3, retval=-5 from PreH1 and post safeExec from PreH2. The entry safeExec PreH3 is not needed.
- return_wit_2: pattern R; after_2 := after_3, bounds from PreH1/PreH2 and post safeExec from PreH3. Entry safeExec PreH4 is not needed.
- partial_solve_wit_1_pure: pattern P; its pure conclusion is exactly PreH1 despite the additional local UInt options cell in the antecedent.
- partial_solve_wit_1: first introduce the implication premise, then apply pattern P to the auxiliary goal. Both pure conclusions repeat the explicit PreH1. The implication premise is unnecessary, so there is no proof dependency on the separate pure witness.

## Grouping decisions

Two groups of two top-level VCs: return_branches groups the two result branches and their common existential/resource pattern; callee_precondition groups the pure side condition and duplicated precondition/resource framing. All are difficulty 1, with no planned helper or heavy mathematics. The groups are independent and below the limit of 12 witnesses. This avoids over-fragmenting four trivial obligations while retaining distinct final-result and call-precondition contexts.

## Risks or blockers

None for these current wrapper VCs. The outer proof relies on the declared _EventCreate contract; this analysis does not establish its implementation or any new Event layout fact. Proof execution and acceptance remain with the group owners/controller. Source and spec definitions remain unchanged.
