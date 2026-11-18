# Cleanup refinement

Four assigned whole-goal LLM proofs independently completed in Rocq MCP using current goal source declarations, with successful Qed states 52, 105, 154 and 203. No generated/current cached goal was assumed without its source definition.

Each branch chooses the actual final state (after for nonnegative data ID; middle when skipped), folds the unchanged front/rear/max_len fields and padding into store_dataqueue of dataqueue_retired, and uses empty retired buffer. The conditional data ID reset is justified by the actual sign premise; the blank field already matches its retired value.

The execution side constructs dataqueue_cleanup_effect from the exact two conditional delete effects (or unchanged state when skipped), proves the corresponding hs_eval of os_atomic_cmd using observed membership from LastSeen and RTrans, and applies highstependret_derive. The original safeExec hypothesis supplies its atomic continuation after wp_bind/wp_assertS elimination. No new safeExec premise, unproved obligation, resource axiom or extra trust was introduced; forbidden safeExec_bind/safeExec_bind_reta were not used.

Only the four assigned manual proof spans were changed. Mechanical comparison after masking those spans shows all remaining copied-manual bytes identical to canonical. No helper file, import, global predicate, spec or generated file was modified.

Controller group-check completed with exit code 0 and status passed (52.36 seconds), recompiling current goal, auto, copied manual and assigned group wrapper. This is group delivery, not whole-function final-check.
