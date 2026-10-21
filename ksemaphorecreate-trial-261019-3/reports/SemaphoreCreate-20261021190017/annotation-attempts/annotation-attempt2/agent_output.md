# Annotation retry: preserve existing facts and normalize checked sizeof

The frozen signature, Require, Ensure, refinement semantics and helper contracts remain unchanged. No new predicate or axiom is introduced. This round addresses the six failed VCs named by the controller handoff.

Changes:

- Expose the nonzero addresses of `sem->pend_list` and `sem->link` from the existing `SemaphoreRaw`/`NodeStorage` definitions before memset consumes that resource; retain these pure facts through later resource cuts and helper calls.
- Expose `dll_nodes_nonzero` from the existing `store_dll` before its tail is represented by `dllseg_shift_rev`; retain it across both list helper calls.
- Fold exactly the allocation and memset `sizeof(struct Semaphore)` arguments to 32. Main explicitly authorized this source-equivalent frontend normalization after rerunning real-header and slice-header ILP32 static assertions. The evidence is `checks/sizeof-constant-fold-evidence.json`. This is a GCC -m32 ILP32 surrogate check, not an ARM compiler execution. No unsupported named-size equality is assumed in Rocq.
- Append imports/scopes for current semantic libraries to the case-library seed, preserving its original prefix, and import that case library from the C annotation. This exposes future proof helpers without a generated-artifact dependency cycle.

Read the three historical group manuals and the exact old VC definitions in annotation-attempt2/before/VC/SemaphoreCreate_goal.v. Current-vs-old comparison details will be recorded after canonical regeneration.

VC comparison (read both historical manuals and current generated manual, and compare exact definitions rather than names):

- Old list-preparation `entail_wit_4_split_goal_spatial` maps to current `entail_wit_5_split_goal_spatial`. Its spatial antecedent/consequent is unchanged; current PreH9 and PreH10 explicitly provide the two embedded-node nonzero facts formerly absent. These facts are established by the new pre-memset `entail_wit_2` using SemaphoreRaw, then preserved across all needed cuts.
- Old publication `entail_wit_5_split_goal_spatial` maps to current `entail_wit_6_split_goal_spatial`. The same world/object/list ownership restores the same published-state os_inv; current PreH7/PreH8 carry pending/link nonzero and PreH16 carries old `dll_nodes_nonzero`. The latter is exposed by current `entail_wit_3` from the original store_dll. No witness or resource was removed to hide the gap.
- All four old allocation/memset partial-solve witnesses retain their names and call-site responsibility. The old named-size equality is now literal `32=32` in both pure and auxiliary statements. Memset's `0=0` and original resources remain; its extra pure nonzero facts are preserved context rather than assumptions.

The new pre-memset assertion has optional pure-only split alternatives after frame cancellation; prove original `entail_wit_2` via its full-resource left disjunct, which contains SemaphoreRaw. Optional split helpers are not required by VC_Correct and remain Abort in the controller-generated manual. No manual proof was edited here.

Proof-route recommendation: use the whole-goal LLM/direct proof route for `proof_of__SemaphoreCreate_entail_wit_2`; select the left disjunct and unfold SemaphoreRaw/NodeStorage to retain the spatial source of the node inequalities. Do not try to establish its optional pure-only split helpers. The same existing rule applies to the initial uint16 local-range witness.

Final checks all passed with exit 0 and JSON status passed: formal-case-lib-design (51.404 s, 189 dependencies reused), canonical symexec (0.659 s, all four generated files present and committed), and formal-case-lib (52.569 s, 189 dependencies reused). All six supplied failed-VC comparisons are resolved at the annotation boundary; actual VC proofs remain for the next proving round. Main also reports the source-equivalence audit passed for the exact two checked constant folds. No further semantic changes made.
