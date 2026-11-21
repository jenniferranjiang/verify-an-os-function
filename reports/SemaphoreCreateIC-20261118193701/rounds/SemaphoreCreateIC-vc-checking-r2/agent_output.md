# SemaphoreCreateIC VC checking r2

## Outcome

Completed analysis and a four-group plan for the current 9 top-level manual obligations. This is a proofability/dispatch assessment, not implementation proof or final-check. Canonical sources and the debug manual were not modified; no raw compiler or MCP source transmission was used.

## Structural blocker scan

Scanned every top-level goal, prioritizing the two without splits: entail_wit_3 and return_wit_1. Resource addresses and current/pre values are linked: the value cell is explicitly val_pre after assignment; the new semaphore is named by sem throughout; ID min-free and object freshness survive to publication. The failed-ID route retains the unknown owned ID fields and all other object bytes, while the successful route transfers ID ownership into the manager rather than duplicating it into payload. The full dataqueue frame is present. No definite countermodel or missing scalar/resource premise was found.

## Annotation comparison review

The sole r1 comparison current is entail_wit_1. Its current two alternatives no longer quantify val_pre or assert its bounds; thus the previous counterexample choosing an arbitrary invalid val_pre no longer applies. The zero-bytes and os_inv antecedent still has all premises for the unchanged conversion, including malloc positivity, bound and alignment. Related entail_wit_3/4 and return_wit_1 carry the initialized value through the actual UShort cell or the store_semaphore payload inside the DLL. No range assumption was moved into the public Require. ID-negative/min-free contradiction in entail_wit_2_2 is independent of val. Comparison is semantically resolved, while actual conversion/freshness proofs remain outstanding.

## Split-first decisions

All split goals were assessed before choosing modes or writing detailed strategies. In manual declaration order:

| Parent | Split suffix | Judgment |
|---|---|---|
| entail_wit_1 | 1 | 可证：private allocation and published payload ownership exclude equal base |
| entail_wit_1 | 2 | 可证：semaphore_inv contains semaphore_context |
| entail_wit_1 | 3 | 可证：os_inv contains os_world_wf |
| entail_wit_1 | 4 | 可证：approved link offset plus positive base |
| entail_wit_1 | 5 | 可证：approved pending offset plus positive base |
| entail_wit_1 | spatial | 可证：complete zero-byte decomposition and global frame unfolding |
| entail_wit_2_1 | spatial | 可证：all 32 private bytes returned, unchanged global resources folded |
| entail_wit_2_2 | 1 | 可证：negative retval contradicts min-free nonnegativity |
| entail_wit_2_2 | spatial | 可证：same inconsistent branch |
| entail_wit_4 | spatial | 可证：self-linked pending becomes empty DLL, payload and management-node ownership split |
| return_wit_2 | 1 | 可证：effect failure disjunct, unchanged state |
| return_wit_3 | 1 | 可证：effect failure disjunct, unchanged state |
| partial_solve_wit_6_pure | 1 | 可证：head is a valid anchor by equality |

All seven parents with splits therefore use aggressive_pre_process. After that decision, the no-split whole goals were assessed: entail_wit_3 is provable by min-free range projection and NodeZero exposure; return_wit_1 is provable by constructing the cons-published replacement state and rebuilding its invariant. They use LLM_pre_process. No split goal is left as an alternative proof route in the plan.

## Common proof patterns

1. **Private object bytes.** The explicit malloc facts and existing approved Semaphore ABI connect the contiguous 32-byte array to typed ID/value/node fields, including both padding intervals. The existing zero conversion lemmas provide the forward direction. Failure recovery forgets field values and joins the complete byte ranges. Freshness is a separation contradiction against an existing DLL payload at the same value address.
2. **Exact frame.** Open/fold os_inv and semaphore_inv with the given context equalities for fixed globals. Frame task/tick/delay/assign/services/mutex/event/isr/exstatus/dataqueue resources. No object or queue state is silently discarded.
3. **Pure paths.** ID min-free supplies the machine ID range; its negative branch is impossible. Failure effects choose the explicit unchanged-state disjunct. Head-anchor membership uses equality.
4. **Publication.** Instantiate the exact replace_semaphores state, identify both manager and management DLL with cons publication, preserve scheduler owners because pending=nil, and lift old queue semaphore witnesses to the cons tail. This is a real mathematical and spatial proof, not an imported effect.

The absent case-lib policy forbids planning new helper declarations. Necessary intermediate mathematical facts must be proved inline in the assigned proof spans or obtained from already proved imported lemmas; the plan contains no helpers.

## VC deltas and grouping

- zero_object: entail_wit_1 alone, six splits. It is the comparison-priority group and a coherent independent byte/freshness transformation; not mixed with final-state algebra.
- failed_create: entail_wit_2_1, entail_wit_2_2, return_wit_2, return_wit_3. One heavy recovery split and four simple pure/contradictory splits share the failure path.
- initialized_payload: entail_wit_3, entail_wit_4, partial_solve_wit_6_pure. They expose/init pending storage, package payload and establish the DLL call precondition.
- publish_result: return_wit_1 alone. Independent final-result group for manager bucket equality and full OS invariant reconstruction; separating it prevents publication algebra from serializing the simpler body transitions.

All groups are independent, cover each top-level exactly once, and are below the maximum 12. Dispatch remains controller-owned; the first comparison group must actually pass before later groups. Strategies in group_plan are restricted to the selected formal targets.

## Risks or blockers

No definite blocker. High risks: freshness extraction from an arbitrary management DLL, typed-unknown-to-byte recovery, and the manager bucket equality under cons publication. These require actual checked proofs. The existing ABI axiom is limited to field layout; native auto remains generated, and ID/DLL function contracts remain imported boundaries. Neither review nor compilation establishes their implementation proofs.
