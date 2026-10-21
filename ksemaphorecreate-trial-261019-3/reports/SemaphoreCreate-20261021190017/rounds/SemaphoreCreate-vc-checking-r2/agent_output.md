# Outcome

Completed analysis of the current canonical manual and goal: 41 top-level obligations, 21 split obligations. The plan selects 9 aggressive and 32 LLM top-level proofs in 9 independent groups. This is proofability analysis, not a completed formal proof. Canonical sources and the debug copy were not changed.

# Structural Blocker Scan

Scanned all top-level obligations, prioritizing the 30 with no split blocks. No definite missing-resource, current/pre-state bridge, scalar bridge or existential countermodel was found. Every auxiliary target retains the same named semaphore address and the same before/locked/published state as its source. Allocation and memset now require the literal equality 32=32. Partial solve 4 and 6 auxiliary antecedents omit local-variable cells, so their strategies derive the required predicate facts directly rather than attempting to manufacture local cells to apply their pure obligations.

# Annotation Comparison Review

The supplied comparison entries were independently matched to current goal definitions. Entail 2 must extract both embedded-node nonzero facts from SemaphoreRaw; its full antecedent retains that resource. These are not axioms: entail 2 itself is assigned a full-resource proof. Entail 3 must extract dll_nodes_nonzero from os_inv's semaphore store_dll, along with world well-formedness, semaphore context, alignment, and fresh-object disjointness. Its six split obligations retain os_inv and SemaphoreZero, so their establishing responsibilities remain visible.

Entail 5 spatial now explicitly has pending/link nonzero as PreH9/PreH10, while retaining the original two NodeZero resources and DllInsertAfterCut/NodeStorage targets. Entail 6 spatial has both embedded inequalities and old dll_nodes_nonzero as PreH7/PreH8/PreH16 and retains the full published os_inv target. Thus the reported nonzero gaps are no longer lost across the call cuts. The four allocation/memset pure/auxiliary obligations all use 32=32 and preserve the same resource responsibilities. The comparison's layout equivalence claim was not independently re-audited in this role; the current VC syntax no longer needs that missing equation.

# Proof-Mode Decisions

Split judgments were completed before choosing whole-goal modes. In manual declaration order (names abbreviated by removing proof_of__SemaphoreCreate_):

| Parent | Split suffixes in order | Judgment in order |
|---|---|---|
| entail_wit_1 | 1, 2 | unprovable, unprovable |
| entail_wit_2 | 1, 2 | unprovable, unprovable |
| entail_wit_3 | 1, 2, 3, 4, 5, spatial | provable, provable, provable, provable, provable, provable |
| entail_wit_4 | spatial | provable |
| entail_wit_5 | 1, spatial | provable, provable |
| entail_wit_6 | 1, spatial | provable, provable |
| return_wit_1 | 1 | provable |
| return_wit_2 | 1 | provable |
| return_wit_3 | 1 | provable |
| partial_solve_wit_4_pure | 1, 2 | provable, provable |
| partial_solve_wit_6_pure | 1 | provable |

Entail 1 splits discard the UShort ownership that establishes the value range. Entail 2 splits discard SemaphoreRaw and therefore the NodeStorage nonzero facts. Their whole-resource disjuncts are provable, so these two parents select LLM_pre_process. All other split parents select aggressive_pre_process without further whole-goal proofability analysis. Every no-split top-level obligation is provable and selects LLM_pre_process.

# Common Proof Patterns

- Typed ownership extraction: derive pure bounds/nonzero/alignment from an owned predicate, retain/refold the original predicate, and frame the remaining resources.
- Frame permutation: target pure conjuncts are hypotheses; reinsert them and cancel the same separation-conjunction factors after reordering. No heap or state is invented.
- Invariant opening/refolding: expose or reconstruct the same task/scheduler/object components and semaphore representation. Existential witnesses are existing representation values.
- DLL cut transformation: case split the old list as empty/nonempty; preserve its shifted tail and redistribute only boundary link cells. New-link nonzero comes from the explicit annotation, and zero link values come from NodeZero.
- Publication: construct the new semaphore with empty pending list; align the manager add/link operation with the published list; rebuild the DLL and world invariant while all non-semaphore state components remain unchanged.
- Abstract return: select the corresponding abstract creation execution (success, manager full, or immediate allocation failure) and derive the safeExec ret continuation at its exact resulting LastSeen state.
- Safety: constant signed-int range arithmetic or directly contradictory branch hypotheses, lifted through the heap frame.

# VC Deltas

All selected targets have individual executable proof routes in group_plan.json; no routes are assigned to rejected pure-only splits.

- entail 1 uses typed ownership; entail 2 uses raw storage extraction.
- entail 3 splits 1/2 establish freshness and old DLL node nonzero; splits 3/4/5 extract context/world-wf/alignment; spatial opens the invariant and zero object.
- entail 4 restores the unchanged invariant on manager-full failure.
- entail 5 obtains the bound 128 from semaphore_context and prepares the list cut plus pending NodeStorage.
- entail 6 proves locked-to-published GTrans and reconstructs the published invariant. Its InsideCritical token still names locked.
- return 1 uses published state and id; return 2 uses locked and -5; return 3 uses before and -5.
- partial 1/2 pure are reflexive literal call-argument obligations; their auxiliary proofs retain OutsideCritical and raw storage respectively. Partial 3 moves SemaphoreZero across the frame.
- partial 4 pure extracts manager and ID-node nonzero; its auxiliary repeats the extraction without local cells. Partial 5 moves SemaphoreZero for cleanup. Partial 6 pure/aux establish the stuttering GTrans. Partial 7 moves pending NodeStorage; partial 8 moves DllInsertAfterCut; partial 9 pure/aux reuse the explicit published-state GTrans.
- safety 1/2/3/5/6/11/13/14 check zero, 4/12 check 32, 9/17 check negation of 5, 10/18 check 5; 7/8/15/16 eliminate contradictory branches.

# Grouping Decisions

Plan order is raw_open, publish, list_prepare, entry_calls, critical_cleanup, returns, safety_entry, safety_alloc, safety_locked. First-batch comparison current obligations are placed in the first four groups. raw_open couples the newly exposed nonzero facts with the freshness proof from ownership. Publication is isolated with its two unlock auxiliaries to contain its heavy manager/DLL/world-wf reasoning. List preparation retains both adjacent call-frame obligations. Each remaining group has 3 or 6 top-level obligations and one coherent program-stage or proof-pattern context. All groups are independent; none reads a sibling output. Three newly planned helpers belong solely to their corresponding groups and use exact group suffixes.

# Risks or Blockers

No definite annotation/specification/dependency blocker found. High risk: freshness from separated list ownership, publication's manager/list correspondence, and preservation of os_world_wf. The plan explicitly assigns their mathematical proof responsibility rather than assuming comparison status proves them. DLL cut reconstruction is medium risk. No coq-debug invocation was needed because the canonical goal definitions expose the current obligation shapes directly; no formal compilation claim is made for this checking role.
