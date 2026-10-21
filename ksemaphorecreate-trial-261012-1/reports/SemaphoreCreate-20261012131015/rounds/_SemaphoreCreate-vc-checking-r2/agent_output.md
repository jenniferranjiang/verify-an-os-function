# Outcome

Analysis completed: 43 top-level witnesses and 13 split goals are covered by 9 independent groups. This is a provability/grouping decision, not completed implementation proof. Canonical files and accepted semantic inputs were not modified; the designated debug manual differs only by `Show.` inside proof bodies.

The exact handoff controller `coq-debug` command completed with process exit 0 and JSON `status: passed`, `returncode: 0` (reported elapsed 57.085433 seconds). It loaded the actual current generated goal/auto and the authorized manual overlay under the configured modern Rocq backend. All 56 Show commands reached their goals. Existing generated admissions remain and are not proof evidence.

# Structural Blocker Scan

Scanned all 43 parents, prioritizing the 39 with no split declarations. No concrete P-true/Q-false countermodel was found. Locals and object pointers stay tied to the same current state; no current/@pre bridge is missing. The two exposure VCs carry the precise private object or registry resources needed for their existential/undefined-field outputs. Call-footprint VCs preserve exactly the same resources modulo separating permutation. Closed numeric checks and incompatible guards are sufficient for safety.

The three return VCs have explicit output routes: allocation failure preserves `before`; ID-full failure selects `current_3`; success selects `current_3, sem`. Their restoration equalities can be derived from the supplied full-scheduler `SemaphoreGuarantee`, together with definitional task/semaphore projections. Do not assume a bound absent from the return VC.

The global manager's nonzero fact is justified by the existing official framework `CNotation.v:582`, `addr_of_LE_var_not_zero`, because this goal is directly an `LE_var` address. This does not infer a base object's nonzero address from one of its fields. Embedded sem.id/pend/link facts instead come from `semaphore_object_addresses` already carried by the private object. Registry head/successor/node nonzero facts come from the accepted `store_dll` definition; the actual mapped nodes provide the data/address correspondence.

IRQ resources are linear frames throughout decomposition/publication. Rely supplies valid current state and the equality of before/current physical nest. Task and scheduler views remain actual owned heaps, not newly asserted pure facts. Success freshness is derivable from disjointness of the new value cell and each old registry body's value cell; malloc's contract is not assumed to give a separate freshness proposition.

# Annotation Comparison Review

Independently inspected the complete current definitions, not just annotation's `resolved` labels. `partial_solve_wit_1_pure` concludes `32 = 32`; `partial_solve_wit_2_pure` concludes `0 = 0` and `32 = 32`. They retain, respectively, the outside-critical footprint and the nonnull allocated-object plus outside-critical footprint. No new premise is needed for these reflexive conclusions. Their corresponding auxiliary call VCs preserve those same resource frames. Literal-range `safety_wit_4` and `safety_wit_12` remain explicit and prove the signed-int range of 32. All six are grouped together for the first comparison batch. No sizeof equality is invented, and no old or new obligation was deleted.

The actual generated preamble now has `Require Coq.Program.Basics` without importing its composition notation. Generated registry terms use the real `getData`/`getPtr` projections. The actual controller debug success above confirms IMPL-20261016-BODY-01 and BODY-02 are resolved at current goal typechecking, rather than relying on the reviewer's diagnostic copies or symbolic generation alone. `Basics.const store_semaphore_body` remains the original heap payload, not an additional guarantee.

# Proof-Mode Decisions

Following the structural scan, all split goals were judged before any parent-mode decision or detailed proof strategy. The binary judgments below are in canonical manual declaration order. Every split is provable from its own current antecedent.

| Split goal | Judgment |
|---|---|
| `proof_of__SemaphoreCreate_entail_wit_1_split_goal_1` | Provable |
| `proof_of__SemaphoreCreate_entail_wit_1_split_goal_2` | Provable |
| `proof_of__SemaphoreCreate_entail_wit_1_split_goal_3` | Provable |
| `proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial` | Provable |
| `proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_1` | Provable |
| `proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial` | Provable |
| `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1` | Provable |
| `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_2` | Provable |
| `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_3` | Provable |
| `proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial` | Provable |
| `proof_of__SemaphoreCreate_entail_wit_5_split_goal_1` | Provable |
| `proof_of__SemaphoreCreate_entail_wit_5_split_goal_2` | Provable |
| `proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial` | Provable |

Only after all thirteen judgments were fixed were the parent modes decided. All four parents with split declarations select aggressive preprocessing. The other 39 parents have no splits, their whole goals are provable, and they select LLM preprocessing. The following table is in manual parent order; strategies are confined to the formal goals selected by these modes.

| Parent | Mode | Group |
|---|---|---|
| `proof_of__SemaphoreCreate_entail_wit_1` | `aggressive_pre_process` | `critical_decomposition` |
| `proof_of__SemaphoreCreate_entail_wit_2_1` | `aggressive_pre_process` | `manager_failure` |
| `proof_of__SemaphoreCreate_entail_wit_2_2` | `aggressive_pre_process` | `manager_failure` |
| `proof_of__SemaphoreCreate_entail_wit_3` | `LLM_pre_process` | `registry_preparation` |
| `proof_of__SemaphoreCreate_entail_wit_4` | `LLM_pre_process` | `registry_preparation` |
| `proof_of__SemaphoreCreate_entail_wit_5` | `aggressive_pre_process` | `publish_transition` |
| `proof_of__SemaphoreCreate_return_wit_1` | `LLM_pre_process` | `returns_and_unlock` |
| `proof_of__SemaphoreCreate_return_wit_2` | `LLM_pre_process` | `returns_and_unlock` |
| `proof_of__SemaphoreCreate_safety_wit_1` | `LLM_pre_process` | `entry_and_lock` |
| `proof_of__SemaphoreCreate_safety_wit_2` | `LLM_pre_process` | `entry_and_lock` |
| `proof_of__SemaphoreCreate_safety_wit_3` | `LLM_pre_process` | `entry_and_lock` |
| `proof_of__SemaphoreCreate_safety_wit_4` | `LLM_pre_process` | `normalized_calls` |
| `proof_of__SemaphoreCreate_safety_wit_5` | `LLM_pre_process` | `allocation_safety` |
| `proof_of__SemaphoreCreate_safety_wit_6` | `LLM_pre_process` | `allocation_safety` |
| `proof_of__SemaphoreCreate_safety_wit_7` | `LLM_pre_process` | `allocation_safety` |
| `proof_of__SemaphoreCreate_safety_wit_8` | `LLM_pre_process` | `allocation_safety` |
| `proof_of__SemaphoreCreate_safety_wit_9` | `LLM_pre_process` | `allocation_safety` |
| `proof_of__SemaphoreCreate_safety_wit_10` | `LLM_pre_process` | `allocation_safety` |
| `proof_of__SemaphoreCreate_safety_wit_11` | `LLM_pre_process` | `manager_and_exit_safety` |
| `proof_of__SemaphoreCreate_safety_wit_12` | `LLM_pre_process` | `normalized_calls` |
| `proof_of__SemaphoreCreate_safety_wit_13` | `LLM_pre_process` | `manager_and_exit_safety` |
| `proof_of__SemaphoreCreate_safety_wit_14` | `LLM_pre_process` | `manager_and_exit_safety` |
| `proof_of__SemaphoreCreate_safety_wit_15` | `LLM_pre_process` | `manager_and_exit_safety` |
| `proof_of__SemaphoreCreate_safety_wit_16` | `LLM_pre_process` | `manager_and_exit_safety` |
| `proof_of__SemaphoreCreate_safety_wit_17` | `LLM_pre_process` | `manager_and_exit_safety` |
| `proof_of__SemaphoreCreate_return_wit_3` | `LLM_pre_process` | `returns_and_unlock` |
| `proof_of__SemaphoreCreate_partial_solve_wit_1_pure` | `LLM_pre_process` | `normalized_calls` |
| `proof_of__SemaphoreCreate_partial_solve_wit_1` | `LLM_pre_process` | `normalized_calls` |
| `proof_of__SemaphoreCreate_partial_solve_wit_2_pure` | `LLM_pre_process` | `normalized_calls` |
| `proof_of__SemaphoreCreate_partial_solve_wit_2` | `LLM_pre_process` | `normalized_calls` |
| `proof_of__SemaphoreCreate_partial_solve_wit_3_pure` | `LLM_pre_process` | `entry_and_lock` |
| `proof_of__SemaphoreCreate_partial_solve_wit_3` | `LLM_pre_process` | `entry_and_lock` |
| `proof_of__SemaphoreCreate_partial_solve_wit_4_pure` | `LLM_pre_process` | `critical_decomposition` |
| `proof_of__SemaphoreCreate_partial_solve_wit_4` | `LLM_pre_process` | `critical_decomposition` |
| `proof_of__SemaphoreCreate_partial_solve_wit_5` | `LLM_pre_process` | `manager_failure` |
| `proof_of__SemaphoreCreate_partial_solve_wit_6_pure` | `LLM_pre_process` | `manager_failure` |
| `proof_of__SemaphoreCreate_partial_solve_wit_6` | `LLM_pre_process` | `manager_failure` |
| `proof_of__SemaphoreCreate_partial_solve_wit_7_pure` | `LLM_pre_process` | `registry_preparation` |
| `proof_of__SemaphoreCreate_partial_solve_wit_7` | `LLM_pre_process` | `registry_preparation` |
| `proof_of__SemaphoreCreate_partial_solve_wit_8_pure` | `LLM_pre_process` | `registry_preparation` |
| `proof_of__SemaphoreCreate_partial_solve_wit_8` | `LLM_pre_process` | `registry_preparation` |
| `proof_of__SemaphoreCreate_partial_solve_wit_9_pure` | `LLM_pre_process` | `returns_and_unlock` |
| `proof_of__SemaphoreCreate_partial_solve_wit_9` | `LLM_pre_process` | `returns_and_unlock` |

# Common Proof Patterns

- **PURE**: introduce the VC parameters and project explicit premises or prove closed arithmetic/reflexivity; the antecedent heap is merely the domain of the pure conclusion. No new heap, existential or transition is required.
- **FRAME**: the implication-shaped partial-solve parent introduces its pure-VC premise, then proves the auxiliary directly from the explicit facts and identical owned resources. Use separating associativity/commutativity to arrange the call footprint; preserve all protocol tokens and state parameters.
- **LIFT**: use the accepted `crtos_heap_lift_sep`/`crtos_heap_lift_entails` on heap pieces; expose pure-and and existential structure by the lift definition. `OSHeap_ushort_eq` is exported; analogous pointer transport, where required, is proved inline from the same byte/lift definitions. Normalize nested field notation using the framework's address equations. No carrier bridge may create IRQ tokens.
- **NEST**: Rely supplies validity and before/current nest equality. Transport the entry bound and use `semaphore_nesting_roundtrip_bounded`. Preserve all task/scheduler components. Return VCs instead use their already supplied restoration guarantee to establish the necessary record equality.
- **PUBLISH**: derive fresh base address from separated old/new value cells, ID absence/range from min-free/query, and value range from the actual UShort cell. Head insertion with empty pending list preserves all old pending/task/ready constraints. Prove the manager bucket update equals the map/filter-derived published manager; fold the new body and actual updated registry edges, then the invariant. All nontrivial facts are local proof assertions, not new assumed premises.

# VC Deltas

Names below omit the common `proof_of__SemaphoreCreate_` prefix. Exact per-target executable strategies, including P/Q resources, witnesses, bounds and transitions, are in the plan.

- `entail_wit_1` splits: validity from OSInvariant; sem.id nonzero from private-object metadata; global manager nonzero from the existing named-global framework fact; LIFT decomposes invariant and splits the zeroed object into detached ID plus registered-private remainder. The incremented scheduler view stays intact.
- `entail_wit_2_1` splits: NEST yields the reflexive failure guarantee; LIFT recombines the unchanged manager/registry invariant and exact zeroed private object.
- `entail_wit_2_2` splits: min-free gives nonnegative retval, contradicting the negative branch guard. Every conclusion follows from that contradiction, including spatial output; no failed allocation fact is assumed.
- `entail_wit_3`: choose the first whole-goal alternative; LIFT exposes the zeroed private remainder, preserves object metadata and value, and weakens its four known zero pointer cells to undef. The optional equivalent existential alternative uses four zero witnesses.
- `entail_wit_4`: choose the second alternative; instantiate nodes with the actual registry map and successor with its owned head-next. Keep nonzero metadata when converting the DLL to shifted-reverse form. `map getData` and the `getPtr` relationship are proved from that exact map, including the empty-list case.
- `entail_wit_5` splits: PUBLISH yields direct and restored publication guarantees and the incremented published invariant. New registry nodes are the new object/link node prepended to the original nodes. The old abstract node list is reconstructed from data and pointer relations. The manager identity uses list extensionality for the 16 buckets and the `replace_Znth` single-bucket update. This is the highest-risk group.
- `return_wit_1/2/3`: select the success, full-manager failure, and allocation-failure alternatives, respectively. For success use witnesses current_3 and sem; for full-manager failure use current_3. Actual outside-critical resources are rewritten using record equality and canceled; no new protocol step is needed.
- `safety_wit_1/2/3/5/6/11/13/14`: PURE bounds for 0. `4/12`: bounds for 32. `9/16`: 5 differs from INT_MIN. `10/17`: bounds for 5. `7/8`: null/non-null contradiction. `15`: retval>=0 contradicts retval=-1.
- `partial_solve_wit_1_pure` and `2_pure`: PURE normalized-size reflexivities; their parents use FRAME on outside/allocated footprints.
- `partial_solve_wit_3_pure`: entry-bound projection; parent permutes zeroed-private and outside protocol.
- `partial_solve_wit_4_pure`: manager and embedded-ID nonzero projections; parent moves unchanged detached-ID/manager pieces to the call footprint.
- `partial_solve_wit_5`: FRAME moves the exact zeroed private object in front for free while preserving the critical invariant.
- `partial_solve_wit_6_pure` and `9_pure`: project IRQ validity and the existing restoration guarantee; parents preserve the failed or published unlock invariant, respectively.
- `partial_solve_wit_7_pure`: pending-head reflexivity/nonzero; parent moves only its undefined pending slots to the call footprint.
- `partial_solve_wit_8_pure`: registry-head/new-link/successor nonzero projections; parent exposes only the four insertion slots, retaining the actual shifted segment and private body frame.

# Grouping Decisions

The plan starts with `normalized_calls` (6 parents), containing both comparison-current VCs, their auxiliary obligations and their literal safety checks. The independent `publish_transition` singleton follows early because its three splits share freshness, published-state validity and manager/registry reconstruction; this is a coherent independent transition family rather than an arbitrary one-witness split. `registry_preparation` has 6 parents sharing private-field exposure, registry opening and their call footprints. `critical_decomposition` has 3 parents and 4 aggressive splits. `manager_failure` has 5 parents and 6 aggressive splits, four of which are immediate inconsistent-guard obligations. `returns_and_unlock` has 5 parents and is separated from publication so that result selection is not part of the heavy transition tail. `entry_and_lock` has 5 parents; each remaining safety group has 6.

Every group is within the hard cap 12 and the usual 2–6 range except the justified publication singleton. All groups are independent, and none reads a sibling proof/library. Plan order determines dispatch order; numeric difficulty is only a human risk estimate. The first comparison group does not require new heavy mathematics.

# Risks or Blockers

No current annotation/spec/dependency blocker. Highest proof-engineering risk is publication: separation-based freshness, nested heap-carrier transport, manager list extensionality and DLL folding must all be proved from the stated premises. The absent `formal_case_lib` prohibits planning helper declarations; the plan has no `helpers` entries. Necessary inductions and equalities must be established inline within the selected proofs, without altering shared predicates, generated statements or trusted contracts.

Debug success establishes current goal typechecking only. It does not discharge the 43 implementation obligations, remove generated admissions, or establish final integrity. Those remain the subsequent proving and finalization work.
