# map_updates completed

Both assigned whole-goal witnesses are Qed: proof_of_PopDataqueue_entail_wit_1 and proof_of_PopDataqueue_entail_wit_4. No split route is assigned to this group.

The first goal extracts the initial assertS observation from safeExec, retains os_inv using prop_apply_p, obtains the map lookup and constructs a same-object split/merge restoration wand. InsideCritical and both optional output slots are unchanged.

The second goal extracts the post-Obtain observation and proves ready preservation for Pop locally: explicit wrap/non-wrap arithmetic gives count(pop q)=count(q)-1 and positive old count; every new FIFO index k is the old index S k modulo the capacity, so the existing Forall initialized property transfers. Empty and nonempty branches hold one copy of the remaining map resources. The nonempty wand uses store_map_missing_i_equiv and store_map_merge to update only the selected key. Pure map invariants retain semaphore associations; task/global world facts and every other OS resource are reconstructed for replace_dataqueues. No obligation Prop is assumed.

Read-only references were the completed canonical DataqueuePeak focus proof and InitDataqueue map publication/frame proof. They were adapted within assigned spans, not imported as generated dependencies. No helper declaration, import, case library, public spec, canonical C, generated file or additional assumption was introduced.

Latest controller group-development passed and exact group-check passed with exit0/status passed; exact check elapsed 34.689437 seconds. The copied manual is ready for main finalize-delivery. This is group completion, not Pop function final-check.
