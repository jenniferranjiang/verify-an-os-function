# Cleanup proof reuse

Reused the four accepted proofs from r1 group_01__cleanup_malloc and group_02__cleanup_create. Each current goal has exactly one additional alignment binder: PreH4 for entail_wit_2_1 and 2_2, PreH9 for 2_3, PreH13 for 2_4. Removing that binder and incrementing the later old PreH identifiers makes the old/current goal bodies byte-for-byte equal. Proof references were shifted accordingly; no mathematical steps or assumptions were added. Historical files remained read-only.
