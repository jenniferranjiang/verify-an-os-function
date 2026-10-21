# Outcome

Blocked by an absent formal C-layout bridge, independently identified in the current raw goals. No successful proving plan is issued. This is a concrete missing premise, not a judgment based on proof difficulty.

## Structural Blocker Scan

The current manual has 41 top-level VCs and 13 split goals. The top-level structural scan examined the current resources, scalar bridges, existential origins and three result routes. The non-split allocation/memset pure obligations expose a definite gap:

- `proof_of__SemaphoreCreate_partial_solve_wit_1_pure`: antecedent has four scalar locals and `SemaphoreOutsideCritical sg hs before`, with only the entry nest cap. Consequent requires `sizeof("Semaphore") = 32`.
- `proof_of__SemaphoreCreate_partial_solve_wit_2_pure`: antecedent adds nonzero allocated-object ownership and scalar locals, but still has no size equality. Consequent requires `0 = 0` and the same size equality.

Official `/home/xinra/qcp-binary-democases/Rocq/SeparationLogic/CNotation.v:55` declares `sizeof_alias_type : string -> Z` as a Parameter. Lines 57-62 interpret `FET_alias` through that Parameter; line 521 makes `sizeof("Semaphore")` that alias case. The current imported goal/manual, accepted semantic library and its trial formal dependencies do not establish its value. `store_sem_allocated p` owns a literal 32-byte CharArray and object-address metadata; that does not equate an independent size Parameter to 32.

Countermodel shape: interpret `sizeof_alias_type "Semaphore"` as 64, leaving all other interpretations fixed. Choose an empty caller stack, a valid before-state with empty semaphores, valid empty task world, 32 empty ready queues and nest zero; choose stable addresses/configuration satisfying `SemaphoreStableContext`. The outside protocol has empty heap, empty tokens and its prescribed reachable-state set. Add disjoint valid local cells with values sem=0, lock=0, id=0 and val=0. The first antecedent is satisfiable, while its pure consequent is false. For the second, choose a nonzero separately allocated address p with valid object metadata and a disjoint literal 32-byte undef allocation; use sem=p and the same other locals/protocol. Its antecedent remains satisfiable when the size Parameter is 64, and its consequent is false.

The corresponding unsuffixed partial_solve_wit_1/2 are implications from the pure witness to an auxiliary assertion. They are not themselves classified as false solely because their auxiliary assertions mention the size. The blocker is precisely the two pure top-level goals.

Other scanned resource shapes preserve the critical token, task views and scheduler view. Registry node map/data/link facts are genuinely supplied by `store_sem_registry` (canonical mapped nodes), with head/successor nonzero supplied by `store_dll`. Successful publication still requires nontrivial proofs of fresh object address from disjoint body/value ownership and manager filter/update equality. No claim of completion is made for those proofs.

## Annotation Comparison Review

The handoff lists no annotation comparisons. The current `Basics.const store_semaphore_body` reduces to the existing payload function and is not a new predicate. Existential node constraints must still be derived from registry ownership; they are not assumed from the annotation author's explanation. Global manager nonzero is supported by official `addr_of_LE_var_not_zero`; it does not solve the independent sizeof equality.

## Proof-Mode Decisions

The structural countermodel rule applies before split-first proof-mode selection. Both failing pure goals have no split goals. No aggressive/LLM mode or full split-goal proofability decision is issued for the remaining obligations.

## Common Proof Patterns

Not planned after the structural blocker.

## VC Deltas

The two exact failing goals correspond to `x_malloc(sizeof(struct Semaphore))` at `annotated_C/src/_SemaphoreCreate.c:121` and `memset(sem, 0, sizeof(struct Semaphore))` at line 125. Their frozen trusted contracts require literal size 32 at lines 31 and 37. The generated goal uses an abstract size expression without a formal layout connection.

## Grouping Decisions

`groups` is empty because this attempt is blocked; no proof groups have been dispatched or proposed. The formal case library is absent and no helper is planned.

## Risks or Blockers

Repair the source-to-formal layout connection through an authorized checked frontend/layout mechanism so the actual generated `sizeof` term is provably 32. Do not weaken the frozen malloc/memset contracts, add an unjustified global axiom, alter canonical generated goals, or invent a local assertion without proving its origin. Canonical/shared formal files and the debug manual are unchanged. No raw compiler/tool bypass was used. No debug compile was necessary: the countermodel follows directly from the current goal and transparent notation definitions. The remaining VCs require renewed full split-first review after this dependency repair.
