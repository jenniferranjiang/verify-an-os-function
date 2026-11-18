# Owned buffer view proof

The assigned whole VC was proved in Rocq MCP against the exact current goal declaration (final state112, proof_finished=true). Four constructive local assertions are included inside its assigned proof span: undef pointer-to-uint representation conversion for ILP32; uint-to-four-byte array using the existing typed-store decomposition; either Some or None DataElem slot to eight bytes; and arbitrary store_array_rec to the contiguous byte array by list induction and CharArray merge. Known slot values are forgotten using existing proved store-forget lemmas.

The authorized dataqueue_layout_abi is used solely for the two DataElem field offsets. The actual resource conversion and concatenation are proved; no obligation Prop is assumed. Null base keeps the fields and padding with no buffer; nonnull base returns exactly max_len*8 allocation bytes while retaining all structural fields and padding.

Only proof_of_DeInitDataqueue_which_implies_wit_1 is modified. No helper file, import, generated goal, spec, global library or additional assumption was introduced. Formal controller group-check result follows.

Controller group-check passed: exit0/status passed,60.11seconds; current goal/auto/manual/group wrapper recompiled. Unassigned source outside the single assigned span was compared byte-for-byte with current canonical and is identical.
