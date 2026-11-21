# call_transitions delivery

All three assigned whole-goal witnesses are proved with LLM_pre_process and Qed: entail_wit_2, entail_wit_5_1, entail_wit_5_2. Only their copied-manual proof spans were changed; declaration statements/order, prelude, all unassigned proofs and generated files remain untouched. No helper declaration, import, library, specification or assumption was added.

The first transition restores the original queue through its wand, executes the ID-reading atomic relation using the actual observed map lookup, and selects the Obtain postcondition as the weakest precondition of dataqueue_pop_after_obtain. Explicit wp_bind/wp_spec reasoning advances the existing execution hypothesis through this actual step; wp_ret proves the continuation bridge for every callee-return state and status.

The nonempty ring transition restores the read element and complete buffer, proves C remainder equals Z.mod under the supplied nonnegative/front and positive/max_len bounds, removes the harmless 16-bit cast using the modulo bound, and restores the updated queue through its update wand. The atomic relation has the recorded old queue, peak element and exact replace_dataqueues/dataqueue_publish update. The empty transition restores the same queue and preserves both optional output slots. Both select the Abandon postcondition from the weakest precondition of the actual Empty/Item return, so arbitrary returned status continues correctly without dropping the Abandon call.

The accepted Peak canonical proof supplied the field/padding and slot-wand reconstruction pattern; all adapted statements were checked here. This group does not assume the library Prop obligations or implementation correctness of runtime callees beyond their caller contracts.

Checks: final group-development exit 0/status passed; final exact group-check exit 0/status passed (29.038019 seconds). This establishes this group only, not the full Pop workflow or its recursive call closure. The terminal report is written last and the owner has stopped all writes.
