Completed the five assigned top-level witnesses using `LLM_pre_process ltac:(lia || congruence)`.

- `safety_wit_15` and `entail_wit_5_1`: contradictory `resched = 1` and `resched = 0` premises.
- `safety_wit_16` and `entail_wit_6_2`: contradictory `resched = 0` and `resched <> 0` premises.
- `entail_wit_4_3`: the same idmanager query equals both false and true.

No helpers were added; the group library seed and all unassigned declarations/proofs were preserved. Forbidden lemma scan was clear.

Validation:
- Controller group-development: exit 0, JSON status passed.
- Rocq MCP `rocq_compile`: success true for all five candidate lemmas together, with the copied manual prelude and the staged group_11/dev workspace. Earlier calls encountered a missing goal artifact and then the MCP fallback alias masking the staged mapping; the main agent corrected the wrapper mapping, and the final MCP compile passed.
- Controller group-check: exit 0, JSON status passed, compiling the exact group wrapper in group_11/src.

All writes are complete; ready for main finalize-delivery.
