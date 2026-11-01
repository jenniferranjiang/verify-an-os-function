# pending_head completed

All four assigned declarations end in Qed:
- proof_of_LinklistResumeAll_which_implies_wit_1;
- proof_of_LinklistResumeAll_which_implies_wit_2_split_goal_spatial;
- proof_of_LinklistResumeAll_which_implies_wit_2;
- proof_of_LinklistResumeAll_which_implies_wit_3.

The first witness focuses the selected semaphore DLL, borrows its sentinel next field, and builds a wand restoring the same os_inv. Its nonempty case excludes equality with the sentinel by duplicate pointer-slot ownership. The second witness returns the field using separating implication elimination. The third extracts the first registered SUSPEND descriptor and its alignment while retaining the unchanged os_inv. The current conclusion does not require target <> 0.

The group library preserves the current seed and contains five fully proved helpers with suffix __pending_head. Historical r1 helpers/proofs were checked against the current seed and goals; DLL names in helpers were qualified for independent library compilation. No extra imports, axioms, semantic changes, frozen predicate/spec edits, or sibling dependencies were introduced.

Rocq MCP validation:
- The complete helper library independently compiled with success: true.
- A source-only candidate containing unchanged current goal Definitions, the current seed and helpers, and all four complete assigned proofs compiled with success: true.
- No interactive pet retries were used.

The exact assigned controller group-check completed with process exit 0, JSON status passed, and returncode 0. Target: VC/LinklistResumeAll_group_02_pending_head_check.v. Build workspace: verification_runs/LinklistResumeAll-20261030234941/_coq_builds/LinklistResumeAll-vc-proving-r2/group_02/src. It recompiled the current library, goal, auto, manual, and group wrapper (five staged sources), reusing 201 base dependencies; elapsed time 63.338867 seconds.

The forbidden-lemma/tactic scan over the group library and assigned proofs found no matches. Unassigned proof spans, declarations, statement order, prelude, and library seed were preserved. All writing stops with this delivery.
