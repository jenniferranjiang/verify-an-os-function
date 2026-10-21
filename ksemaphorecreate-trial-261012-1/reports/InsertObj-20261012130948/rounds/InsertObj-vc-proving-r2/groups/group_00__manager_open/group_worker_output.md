Completed both assigned witnesses with LLM_pre_process and Qed.

proof_of_InsertObj_entail_wit_1 adapts the same-trial r1 manager_open proof. The required first LLM_pre_process tactic selects the original first disjunct, so this proof closes that branch rather than manually selecting the second disjunct suggested by the strategy note. It opens the accepted manager and detached predicates, transports exact owned cells through OSHeap, extracts UShort ranges and nonzero metadata, and explicitly converts the detached prev/next cells to the required undef cells only at the final entailment. All resources are retained.

proof_of_InsertObj_entail_wit_2 proves the remainder/mod bridge from existing nonnegative id and positive hoffset premises; lifts store_idbuckets_split and store_idbucket_cases; then proves BSS and initialized alternatives separately. The nonzero bucket head comes from accepted representation metadata. All manager, bitmap, detached-node, and bucket-frame resources are explicitly canceled.

No helpers, imports, statements, semantic sources, unassigned spans, or historical files were changed. Forbidden-lemma/tactic scan had no matches.

During diagnosis, development session 25039 and debug session 64303 overlapped. Both were followed to actual exit 1 and showed the same ordinary proof mismatch; neither result was used as acceptance. All subsequent checks ran serially. The repaired development check passed with exit 0 and JSON status passed (92.695493 seconds). After removing temporary Show commands, the final exact group-check passed with exit 0 and JSON status passed (111.678063 seconds), compiling the current manual and group wrapper.

All tool sessions are closed. No remaining annotation or infrastructure blocker.
