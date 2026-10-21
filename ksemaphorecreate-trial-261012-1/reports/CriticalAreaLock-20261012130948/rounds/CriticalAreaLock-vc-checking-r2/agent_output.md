# Outcome

All three current top-level VCs are provable from the accepted inputs. The plan covers them exactly once, including the raw-auto partial-solve obligation. This is proofability analysis, not completed VC proof.

## Structural Blocker Scan

Scanned no-split return and partial-solve goals first, then entail. No missing address, scalar/current-prestate bridge, resource or existential witness was found. Return retains the same global UShort cell and exact remainder; choose `current_2` for its existential. `SemaphoreRely` explicitly equates before/current nest, so the entry bound applies to the actual written value. The inside protocol token stays indexed by the acquired observation while the heap invariant receives the increment. Partial-solve only adds its existing pure hypothesis.

Main explicitly authorized read-only inspection of the current accepted semantic dependencies to resolve opaque predicate meanings. `accepted-revisions.json` identifies predicate-r5-0a139d64743c; all 20 predicate-manifest source hashes match. No historical trial or proof was inspected.

## Annotation Comparison Review

The current handoff has no annotation comparisons. Independently checked the asserted validity and exposed nest/frame: validity is present in both the existing OS invariant and current Rely; the spatial assertion is exactly the accepted `SemaphoreOSInvariant_split_nest` entailment. Its establishment obligation remains in this plan. No new semantic premise is silently assumed.

## Proof-Mode Decisions

Before analyzing any whole-goal provability, checked all split declarations in manual order:

1. `proof_of_CriticalAreaLock_entail_wit_1_split_goal_1`: provable.
2. `proof_of_CriticalAreaLock_entail_wit_1_split_goal_spatial`: provable.

Then selected modes in parent declaration order:

1. `proof_of_CriticalAreaLock_entail_wit_1`: aggressive_pre_process, since both splits are provable; no separate whole-goal proofability analysis.
2. `proof_of_CriticalAreaLock_return_wit_1`: no splits, whole goal provable, LLM_pre_process.
3. `proof_of_CriticalAreaLock_partial_solve_wit_1`: no splits, whole goal provable, LLM_pre_process.

Only after these decisions were strategies and groups formed. The authorized coq-debug command passed with exit code 0 and JSON status passed; the debug copy differs solely by inserted Show commands. It confirms the current obligations load, not their proofs.

## Common Proof Patterns

P1 (pure projection/preservation): introduce existing pure hypotheses, extract conjunctions if needed, and use pure introduction plus reflexive entailment for unchanged spatial resources. No new resources are manufactured.

P2 (exact nest view): frame the inside token and use the accepted split/merge lemmas to expose/reassemble one physical UShort cell and the exact remaining task/scheduler/semaphore resources. No protocol token is duplicated. Helpers are not planned because the case library is absent.

## VC Deltas

- Entail pure split uses P1: `CrtosOSValid current` follows from PreH2, independently also from the owned invariant. Spatial split uses P2 with `SemaphoreOSInvariant_split_nest`; frame and address match exactly.
- Return uses P2 in the reverse updated direction. Rely transfers the entry upper bound; validity supplies nonnegativity. Therefore `unsigned_last_nbits (n+1) 16 = n+1`, and `SemaphoreOSInvariant_merge_increment` reassembles the poststate. Witness `current_2` preserves existing handler/Rely/inside-token indices. No state transition is needed for this local counter write.
- Partial-solve uses P1 with PreH1 and unchanged OutsideCritical; the raw generated auto admission is not accepted as a proof.

## Grouping Decisions

`entry_views` contains two top-level witnesses and two aggressive split goals: initial pure assertion/resource exposure plus the independent domain-preservation obligation. They share elementary framing/pure context and need no new helper.

`return_increment` is a single-witness group because it is an independent final-result reconstruction with its own uint16 normalization and state-indexing argument. Separating this from the entry work prevents return arithmetic from serializing the elementary checks. Both groups are independent and below the 12-parent limit. Plan order is entry then return; no cross-group output or dependencies are assumed.

## Risks or Blockers

No semantic blocker found. Return requires careful preservation of the original Rely hypothesis when destructing a copy, the correct UShort/modulo normalization, and existential selection at the observed state rather than its increment. These are ordinary proof obligations. Accepted split/merge lemmas eliminate the need for new heavy mathematics or library modification. Boundary n=65534 writes 65535; entry n=65535 remains excluded as approved.
