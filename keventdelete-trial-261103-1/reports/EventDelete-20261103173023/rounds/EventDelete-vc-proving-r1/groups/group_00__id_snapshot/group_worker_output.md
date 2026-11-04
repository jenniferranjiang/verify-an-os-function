# id_snapshot proof delivery

Completed `proof_of__EventDelete_which_implies_wit_6` with the assigned `LLM_pre_process` route. The guard supplies the original event, non-null address, matching ID and empty pending list; membership supplies the prefix/original/suffix decomposition.

All additional facts are derived from the owned invariant. The actual management DLL payload gives address uniqueness by disjoint options fields. `idbuckets_ok` and the event context give ID uniqueness and bounds below 128; membership gives a true ID query. Pure list lemmas identify address filtering with ID filtering, prove the target bucket removal and preservation of every other bucket, and establish the complete manager equality.

The ID scalar is borrowed through its actual manager bucket and DLL member. Proven wand composition retains the ID links, other buckets, management payload and complete OS frame, restoring the same invariant when the unchanged scalar returns. Helpers have the required `__id_snapshot` suffix; the seed library, statements and unassigned spans are preserved. No extra assumptions, design-obligation axioms or strengthened annotations are used.

Validation: all helper and VC proofs closed interactively. The exact assigned controller `coq-check --target-kind group-check --group id_snapshot` completed with exit code 0 and JSON `status: passed`; it recompiled the group library, goal, automatic/manual proofs and group wrapper. Forbidden-lemma/tactic scan found no prohibited additions.
