# r1 proof reuse

Reused the seven assigned proof blocks and their eight-helper closure from the r1 id_focus manual/library. The r2 seed matches the historical seed, and every helper retains the required __id_focus suffix.

Compared the current goals with the r1 group build's goals: which_implies_wit_6, which_implies_wit_7, its spatial split, and the partial_solve_wit_10 wrapper are unchanged. The other assigned partial-solve definitions remove propagated target <> 0 facts and renumber later premises. None of the reused proofs depends on that removed fact; retval = target remains PreH10 where used.

Rocq MCP rocq_compile accepted the complete reused library and seven proofs against the exact current goal definitions with success: true. Historical Qed alone was not treated as validation.
