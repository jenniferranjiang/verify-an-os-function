# Outcome

The current six manual top-level VCs have no definite structural counterexample. All six split goals are judged provable, so all six parents use aggressive_pre_process. This is a proof plan, not a completed implementation proof.

## Structural Blocker Scan

There are no no-split parents. The four return VCs quantify the same ms_pre used by tick_from_time_ms and explicitly retain 0 <= ms_pre <= UINT_MAX. Their antecedent is emp because local cells have been released, but the needed scalar range now survives. The first which-implies has the actual UInt parameter cell as its antecedent; it is not an empty-heap assertion of a range. The second view restores exactly the same address and value. No current/@pre bridge, ownership, or return-expression mismatch is visible.

## Annotation Comparison Review

The handoff supplies no historical comparison entries. Independently inspecting current obligations confirms the substantive range repair: which_implies_wit_1 retains the typed parameter cell while presenting the equivalent store_uinteger view; partial_solve_wit_2 retains the pure range, and every current return VC includes that range. The two view transformations are real manual obligations. No annotation status is treated as a proof.

## Split-First Judgments and Proof Modes

The split judgments below were completed before choosing modes or strategies, in manual declaration order:

| Parent suffix | Split suffix | Judgment | Parent mode |
| --- | --- | --- | --- |
| return_wit_1 | split_goal_1 | provable | aggressive_pre_process |
| return_wit_2 | split_goal_1 | provable | aggressive_pre_process |
| return_wit_3 | split_goal_1 | provable | aggressive_pre_process |
| return_wit_4 | split_goal_1 | provable | aggressive_pre_process |
| which_implies_wit_1 | split_goal_spatial | provable | aggressive_pre_process |
| which_implies_wit_2 | split_goal_spatial | provable | aggressive_pre_process |

No whole-goal fallback or separate top-level proofability route is necessary because every parent has only provable split obligations.

## Common Proof Patterns

Arithmetic returns: the spatial part is emp, with no existential witnesses. From 0 <= ms <= 4294967295 derive 0 <= ms*100, q=(ms*100)/1000 in [0,429496729], and remainder r in [0,999]. The C truncating division/remainder agree with Z.div/Z.mod on these nonnegative arguments. All 32-bit unsigned truncations of q, r, and q+1 are identities. Unfold tick_from_time_ms and select its tests using the corresponding normalized guard. The 64-bit product fits as well (at most 429496729500), but no extra premise may be assumed. Local assertions suffice; no case library or planned helper declarations exist.

Storage views: UInt at the actual local address and store_uinteger (Z.to_nat 4) 4 are the same existing memory predicate after normalization. Both directions preserve address and value. The range source is the typed storage semantics, not an added Require or arbitrary pure assumption.

## VC Deltas

- return_wit_1: quotient guard is zero, hence the specified minimum is 1.
- return_wit_2: quotient is nonzero and remainder guard is 5..9; specification chooses q+1 and its cast is unchanged. The proof need not establish that this branch is reachable for a multiple of 100; it can prove the guarded specification directly.
- return_wit_3: quotient nonzero and r<5 make the rounding conjunction false.
- return_wit_4: quotient nonzero and r>9 make its second comparison false.
- which_implies_wit_1: typed UInt to existing opaque view, same cell, explicit split range hypotheses.
- which_implies_wit_2: reverse view, same cell, no range hypothesis required for definitional equivalence.

## Grouping Decisions

arithmetic_returns contains four top-level/split pairs sharing the exact quotient/remainder/truncation reasoning, estimated difficulty 3. range_views contains the two independent bidirectional storage views, estimated difficulty 1. Both remain well below the 12-top-level limit, with no cross-group helper ownership or dependency. The arithmetic group is ordered first because it is the only material proof risk; the two-cell-view group is independently checkable. No helper is planned because formal_case_lib_policy is absent.

## Risks or Blockers

No identified blocker. The actual proof must explicitly bridge C division/remainder to mathematical division/modulo and justify q+1's truncation bound; broad simplification must not conceal these obligations. Native auto artifacts remain untouched. No canonical or debug source was edited, and no compiler/MCP proof check was run during this structural analysis. Subsequent owner proofs and exact controller checks are still required.
