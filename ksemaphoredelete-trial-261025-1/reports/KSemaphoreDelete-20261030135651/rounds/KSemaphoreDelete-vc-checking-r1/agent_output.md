# KSemaphoreDelete VC analysis

Outcome: all three current top-level obligations are provable; no blocker found. This is a proof plan, not completed Rocq proofs.

## Structural blocker scan

All three obligations have no split goals. The return goal carries the exact OutsideCritical resource required by its existential postcondition, with the returned state after_2 available as witness. The call pure goal already quantifies the exact safeExec fact it needs. The call auxiliary goal returns the same OutsideCritical resource and duplicates only a pure fact. No current/@pre address bridge, scalar equality, ownership or existential premise is missing.

## Annotation comparison review

The handoff contains no annotation VC comparisons or prior-attempt feedback. Current obligations arise from forwarding the same frozen caller/callee contract; no new assumption or view was introduced by this wrapper.

## Proof-mode decisions

The complete split-goal pass is empty for each parent, in manual declaration order:

1. proof_of_KSemaphoreDelete_return_wit_1: no split goals.
2. proof_of_KSemaphoreDelete_partial_solve_wit_1_pure: no split goals.
3. proof_of_KSemaphoreDelete_partial_solve_wit_1: no split goals.

Whole-goal analysis therefore applies to all three. Each is provable and uses LLM_pre_process. No aggressive mode is selected.

## Common proof pattern

Preserve the unchanged OutsideCritical assertion and introduce pure safeExec conjuncts directly from the explicitly quantified PreH1. The abstract program and continuation are already identical across the call, so neither safeExec unfolding nor a semantic transition helper is needed. A pure consequent depends only on PreH1, not on spatial cancellation of the local parameter cell.

## VC deltas

- Return: instantiate the only existential with after_2, then apply the common pattern; the initial-state PreH2 is unused.
- Call pure: conclude the safeExec assertion from PreH1 over the current heap containing the local id cell and OutsideCritical.
- Call auxiliary: after introducing the implication premise and unfolding the aux definition, use PreH1 for both pure conjuncts and retain OutsideCritical. The implication premise is redundant in this generated shape and need not be invoked recursively.

## Grouping decisions

One wrapper_contract group contains all three top-level witnesses, below the hard limit of 12. They share the same direct pure/resource forwarding pattern, no helper family or expensive mathematical dependency, and a trivial existential is the only return-specific step. Splitting the return into a separate worker would add overhead without shortening a meaningful critical path. Difficulty: 1. No helpers are planned.

## Risks or blockers

No mathematical blocker identified. Canonical formal files and the debug manual were not changed. Textual definitions fully expose these goals, so no coq-debug run was needed. Generated admissions remain implementation obligations for the proving owner; none are treated as completed proof here.
