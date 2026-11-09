# safeexec_routes delivery

Completed all 5 assigned top-level VCs and their 4 assigned split goals (9 editable proof spans). The three return top-levels and partial_solve_wit_11_pure use aggressive_pre_process followed only by Goal_apply of their assigned split. Every split and the whole partial_solve_wit_11 begins with explicit LLM_pre_process. The auxiliary whole VC needs a second preprocessing pass after the initial pass introduces its pure-VC premise; it keeps OutsideCritical and all existing pure facts.

Added exactly two proved helpers in the supplied group library, both with __safeexec_routes suffix:

- mutex_delete_found_continuation: follows the actual observed lookup success into the frozen delete-object continuation, using the given live/key/rely facts and the weakest-precondition bind rule.
- mutex_delete_void_continuation: for a nonnegative ID, constructs a lookup-miss normal abstract execution at replace_mutexes nil observed. This is valid specifically because the frozen Crtos_RTrans is the total relation; LastSeen permits that observation. It neither assumes the C manager is non-null nor invents a query-false premise. This is a property of the current abstraction, not a claim that the concrete null-manager path takes that particular heap observation.

The negative-ID return unfolds the actual negative branch to ret. No drain/retire obligation or unproved Prop definition was used as theorem evidence. No new assumptions, spec changes, source changes, or imports of sibling/generated proof helpers were introduced. Only the group's allowed spans and library additions were changed; statements, order, prelude, seed and unassigned proofs are preserved.

Rocq MCP interactive checks proved both helpers (successful Qed at state 31 and state 58 in the held session). A second exact-seed import session exposed Set-equivalence unfolding without extra library imports; the final helper uses explicit True <-> True conversion for the current total rely. Scope disambiguation uses Z.ltb rather than overloaded string notation. All these checks used the real shared definitions.

Controller validation:

- coq-check --target-kind group-development --group safeexec_routes: exit 0, status passed, 4 current files recompiled; 201 base artifacts reused; 27.982814 seconds.
- coq-check --target-kind group-check --group safeexec_routes: exit 0, status passed; exact wrapper VC/KMutexDelete_group_01_safeexec_routes_check.v and its 4 current dependencies recompiled; 201 base artifacts reused; 30.020839 seconds.

Earlier development diagnostics were ordinary proof-environment/shape repairs (disallowed redundant project import, overloaded <?, Set-equivalence unfolding, auxiliary wrapper preprocessing). No annotation gap was diagnosed. Final allowed-spans and helper scan contains no forbidden lemma/tactic, new admit/axiom/parameter, or unsafe operation. Temporary Show/Abort remain only in the authorized debug script, not the completed assigned spans.

Final copied-manual SHA-256: `10f7e9ec432b3d818035c75d9923a23091bbce7a676d82ba45ade28bbeae199f`.
Final group-library SHA-256: `99ec600ef9c6e304598a82659f113725a129554d35fb7ae792581160c6e0bead`.

Terminal report is written last. All writing stops for main's finalize-delivery; this group result is not a claim that parent/full-case validation is complete.
