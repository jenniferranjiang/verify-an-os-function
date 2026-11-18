# IRQ observation proof

Completed assigned whole-goal `proof_of_DeInitDataqueue_entail_wit_1`. The generated pure fallback and its two Abort splits are unchanged.

The proof extracts the checked `dataqueue_cleanup_entry` from the existing safeExec using the definitions of safe/LastSeen and the standard wp_bind/wp_assertS equations. LastSeen set equivalence and the given Crtos_RTrans fact establish membership of the actual IRQ observation. Applying the resulting spatial entailment with prop_apply_p retains os_inv while obtaining cleanup_guard, hence both semaphore_delete_quiescent conditions. InsideCritical, os_inv and the private store_dataqueue are returned unchanged. No new safeExec premise, obligation assumption or trusted statement is introduced.

Rocq MCP proved the complete goal at state24. The saved span uses the same proof with the entry-definition unfolding explicitly scoped to its hypothesis and local goal. Controller group-check passed with exit0/status passed, elapsed43.245058s, recompiling current goal/auto/manual/group wrapper. A mechanical comparison with canonical input after masking the sole assigned proof span confirmed all unassigned bytes unchanged. Only the assigned manual span was edited.
