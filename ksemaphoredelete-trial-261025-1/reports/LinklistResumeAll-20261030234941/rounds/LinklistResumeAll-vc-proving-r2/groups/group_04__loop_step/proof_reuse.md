# Reuse from r1

Compared the three current assigned goal definitions with the proofs in the previous round's `group_04__loop_step/LinklistResumeAll_proof_manual.v`.

Reused `entail_wit_2` with the removed redundant nonzero premise accounted for: clear only `PreH2`, apply continuation `PreH35`, and use suspension fact `PreH23`. The proof still does not depend on target nonzero. The two `partial_solve_wit_13` proofs are unchanged and apply to the reduced current premise/conclusion lists.

No helper reuse, library edits, historical-file edits, or semantic input changes.
