# KMutexDelete VC analysis — r1

Outcome: ready for proving. The current canonical manual has 35 top-level obligations and 11 split goals. No annotation comparisons or earlier checking results were supplied in this handoff. No canonical file was modified; no debug copy change or command was needed because the current goal definitions expose the relevant pure/spatial shapes directly. This is a provability analysis and group plan, not a proof-completion claim.

## Structural Blocker Scan

Read all current manual declarations, goal definitions, auto source (imports only), active case lib and goal-check interface. The no-split whole goals were checked first: the seven constant-bound safety goals need only Arch32 integer constants; three impossible branch goals contain explicit zero/nonzero contradictions; the initial typed-id entailment owns the signed Int cell that establishes its range; return_wit_4 already has the actual after_2 continuation and token. The partial_solve transport goals retain matching current resources and explicit address/scalar equalities. which_implies_wit_3 receives the found manager together with the exact management-DLL/non-Mutex frame, so its existential Mutex can be extracted without an extra lifetime assumption.

There is one non-obvious route, not a structural blocker: return_wit_1 has a null-manager branch fact but no query-false premise after Unlock. Its split is nevertheless provable in the *current frozen pure model*: Crtos_RTrans is total and LastSeen is extensional equality to that relation. For any nonnegative input, abs_mutex_delete has a normal no-hit execution by selecting an observation with an empty Mutex sequence, and that execution returns tt to the same total observation set. The safeExec precondition therefore already establishes the ret continuation required by this VC. This relies on the current broad abstraction; it must not be explained as proof that the actual global manager is null or as a new invariant premise. No heap facts are fabricated by that pure argument. The group plan makes this dependency explicit and high risk rather than silently assuming the missing query-false condition.

## Annotation Comparison Review

The comparison list is empty. New annotation premises are still accounted for locally: typed-int bounds are established by entail_wit_1 from the current id cell; found-object membership/live/address facts are established by which_implies_wit_3 from found-manager plus the actual payload DLL; the ordinary split and restore frames are exactly what which_implies_wit_1/2 prove. The helper call continuation is established by partial_solve_wit_11_pure from the lookup program and supplied actual live result, not by an unproved Prop obligation. Pure equality transport goals do not create new semantic facts. No use of the design's *_obligation definitions as proved facts is planned.

## Split-first judgments

After the structural scan, all split goals were judged before deciding any top-level proof mode. In canonical declaration order:

| Split goal | Judgment | Reason |
|---|---|---|
| `proof_of_KMutexDelete_return_wit_1_split_goal_1` | provable | Current total-rely abstract program admits an empty-Mutex no-hit observation, yielding the required unit continuation. |
| `proof_of_KMutexDelete_return_wit_2_split_goal_1` | provable | Actual query=false gives no-hit; ordinary atomic lookup followed by ret gives the continuation. |
| `proof_of_KMutexDelete_return_wit_3_split_goal_1` | provable | Negative id reduces abs_mutex_delete to ret tt. |
| `proof_of_KMutexDelete_partial_solve_wit_3_pure_split_goal_1` | provable | Low 16-bit remainder is nonnegative. |
| `proof_of_KMutexDelete_partial_solve_wit_3_pure_split_goal_2` | provable | Low 16-bit remainder is strictly below 65536. |
| `proof_of_KMutexDelete_partial_solve_wit_6_pure_split_goal_1` | provable | Shared guarantee relation is reflexive at st_lock. |
| `proof_of_KMutexDelete_partial_solve_wit_7_pure_split_goal_1` | provable | Same reflexive transition on the non-null miss path. |
| `proof_of_KMutexDelete_partial_solve_wit_10_pure_split_goal_1` | provable | Same reflexive transition on the found path. |
| `proof_of_KMutexDelete_partial_solve_wit_11_pure_split_goal_1` | provable | The actual Some(base,key) lookup transition yields the helper continuation under the original bind. |
| `proof_of_KMutexDelete_which_implies_wit_1_split_goal_spatial` | provable | Exact definitional split of Mutex manager from os_inv. |
| `proof_of_KMutexDelete_which_implies_wit_2_split_goal_spatial` | provable | Exact inverse fold, with mutex_context retained in lookup frame. |

## Proof-Mode Decisions

All split judgments are provable, so every top-level parent with splits selects aggressive_pre_process; its top-level proof is not separately reanalysed for mode selection. Every no-split whole goal is provable and selects LLM_pre_process. Canonical top-level declaration order:

| Top-level VC | Mode | Group |
|---|---|---|
| `proof_of_KMutexDelete_safety_wit_1` | `LLM_pre_process` | `initialization_bounds` |
| `proof_of_KMutexDelete_safety_wit_2` | `LLM_pre_process` | `initialization_bounds` |
| `proof_of_KMutexDelete_safety_wit_3` | `LLM_pre_process` | `initialization_bounds` |
| `proof_of_KMutexDelete_safety_wit_4` | `LLM_pre_process` | `initialization_bounds` |
| `proof_of_KMutexDelete_safety_wit_5` | `LLM_pre_process` | `query_context` |
| `proof_of_KMutexDelete_safety_wit_6` | `LLM_pre_process` | `query_context` |
| `proof_of_KMutexDelete_safety_wit_7` | `LLM_pre_process` | `query_context` |
| `proof_of_KMutexDelete_safety_wit_8` | `LLM_pre_process` | `branch_contradictions` |
| `proof_of_KMutexDelete_safety_wit_9` | `LLM_pre_process` | `branch_contradictions` |
| `proof_of_KMutexDelete_safety_wit_10` | `LLM_pre_process` | `branch_contradictions` |
| `proof_of_KMutexDelete_entail_wit_1` | `LLM_pre_process` | `typed_ranges` |
| `proof_of_KMutexDelete_return_wit_4` | `LLM_pre_process` | `found_result_frame` |
| `proof_of_KMutexDelete_partial_solve_wit_1` | `LLM_pre_process` | `initialization_bounds` |
| `proof_of_KMutexDelete_partial_solve_wit_2` | `LLM_pre_process` | `query_context` |
| `proof_of_KMutexDelete_partial_solve_wit_3` | `LLM_pre_process` | `typed_ranges` |
| `proof_of_KMutexDelete_partial_solve_wit_4` | `LLM_pre_process` | `query_context` |
| `proof_of_KMutexDelete_partial_solve_wit_5` | `LLM_pre_process` | `query_context` |
| `proof_of_KMutexDelete_partial_solve_wit_6` | `LLM_pre_process` | `unlock_context` |
| `proof_of_KMutexDelete_partial_solve_wit_7` | `LLM_pre_process` | `unlock_context` |
| `proof_of_KMutexDelete_partial_solve_wit_8` | `LLM_pre_process` | `branch_contradictions` |
| `proof_of_KMutexDelete_partial_solve_wit_9_pure` | `LLM_pre_process` | `found_result_frame` |
| `proof_of_KMutexDelete_partial_solve_wit_9` | `LLM_pre_process` | `found_result_frame` |
| `proof_of_KMutexDelete_partial_solve_wit_10` | `LLM_pre_process` | `unlock_context` |
| `proof_of_KMutexDelete_partial_solve_wit_11` | `LLM_pre_process` | `safeexec_routes` |
| `proof_of_KMutexDelete_return_wit_1` | `aggressive_pre_process` | `safeexec_routes` |
| `proof_of_KMutexDelete_return_wit_2` | `aggressive_pre_process` | `safeexec_routes` |
| `proof_of_KMutexDelete_return_wit_3` | `aggressive_pre_process` | `safeexec_routes` |
| `proof_of_KMutexDelete_partial_solve_wit_3_pure` | `aggressive_pre_process` | `typed_ranges` |
| `proof_of_KMutexDelete_partial_solve_wit_6_pure` | `aggressive_pre_process` | `unlock_context` |
| `proof_of_KMutexDelete_partial_solve_wit_7_pure` | `aggressive_pre_process` | `unlock_context` |
| `proof_of_KMutexDelete_partial_solve_wit_10_pure` | `aggressive_pre_process` | `unlock_context` |
| `proof_of_KMutexDelete_partial_solve_wit_11_pure` | `aggressive_pre_process` | `safeexec_routes` |
| `proof_of_KMutexDelete_which_implies_wit_1` | `aggressive_pre_process` | `lookup_bridge` |
| `proof_of_KMutexDelete_which_implies_wit_2` | `aggressive_pre_process` | `lookup_bridge` |
| `proof_of_KMutexDelete_which_implies_wit_3` | `LLM_pre_process` | `lookup_bridge` |

## Common Proof Patterns

1. **Constant bounds / contradiction.** Numeric goals have no required heap consequence. Branch contradictions are explicit pure zero/nonzero facts; do not over-expand the manager.
2. **Transport.** Preserve the same spatial manager, lookup frame and/or critical token; copy supplied pure facts and use separation associativity/commutativity. For a `pureVC -> aux` wrapper it is legitimate to prove the aux directly from its own complete premises; do not invent local variable cells merely to apply the pureVC argument.
3. **Typed range / narrowing.** Input bounds come from the owned signed Int cell. Narrowing bounds come from the mathematical low-bit/remainder operation with positive modulus 2^16. These are different sources, and neither requires a stronger public ID precondition.
4. **Lookup ownership.** `mutex_lookup_frame` is an exact non-manager frame. Expand/fold it with the existing module predicates, using mutex_context for the stable manager address. Found-manager membership maps back through the derived manager's filtered/mapped buckets to an actual Mutex; the object's nonzero address comes from its stored payload, not from ID arithmetic.
5. **Continuation.** Negative inputs simplify to ret. Nonnegative paths unfold one ordinary atomic lookup and bind. Actual Some results pass the actual `(p,key)` to the helper continuation. For the null-manager return VC only, the total-rely abstraction also supplies the explicit empty-Mutex no-hit construction described above. The global critical protocol is unchanged; this reasoning adds no environment assumption.
6. **Final state.** Return_wit_4 instantiates `after := after_2`, preserving the actual returned OutsideCritical and continuation. A historical pre/lookup state is not substituted for this actual result.

## VC Deltas

There are no prior-round comparisons. Per-VC strategy differences are stored in group_plan.json: constant initializers differ only in current cells; query transports differ only in miss/null/found facts; unlock witnesses share the reflexive transition but retain their own full contexts. The three `which_implies` witnesses carry all heap splitting, reassembly and found-object extraction. Safeexec witnesses carry only pure lookup/bind reasoning and cannot assume the implementations of drain/retire.

## Grouping Decisions

Eight independent groups cover every top-level VC exactly once (sizes 3,5,3,5,6,4,6,3), below the hard bound 12 and within the usual 2–6 range. The high-risk lookup resource bridge and continuation semantics are placed first. They are separate helper families: the former needs bucket/list/payload extraction, the latter pure monadic execution; neither group imports a sibling output. The typed-range work is separate from constant initializer safety. Transport, contradiction, unlock, and final-result work are smaller independent groups, preventing the final after_2 projection from becoming part of a heavy tail group.

Only the two high-risk groups plan new helpers, each with the exact owner suffix. They state properties whose premises are present in their VCs. The found-bucket helper is pure; the payload-nonzero helper extracts a pure consequence from actual DLL ownership and must be used without losing that heap. The continuation helpers state the current model's actual semantics, not new axioms or substituted specs. All such helpers still require formal proof by the group owner.

## Risks or Blockers

No definite blocker found. `lookup_bridge` is high risk because it crosses ID bucket representation, derived Mutex state and DLL payload membership; `safeexec_routes` is high risk because safeExec/atomic/bind/LastSeen are nested and set equality is extensional. The null-manager return route is especially sensitive to any later tightening of the shared rely relation: changing that relation would require new analysis, whereas the present handoff fixes the current imported definitions. Helper complexity or not-yet-written proofs is not itself an annotation gap. Group owners must report actual unprovable current VCs rather than weakening the frozen spec or using pending design obligations as evidence.
