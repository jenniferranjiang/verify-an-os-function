# KSemaphoreCreateIC annotation delivery

Signature: int32 KSemaphoreCreate(uint16 val).
Preconditions: the frozen dataqueue_ic contract owns os_inv(sg,before); val is the actual uint16 argument.
Output: returns -5 with unchanged state, or a valid newly allocated semaphore ID below 128 with the exact semaphore_create_ic_effect, and restores os_inv(sg,after). This is the existing shared Rocq relation and unchanged C Ensure. The underlying _SemaphoreCreate IC body has completed the prior recorded workflow; this wrapper forwards its result and state.

No canonical C, public spec, header, library, body annotation, or business statement was changed. Existing named call selection is retained. There are no loops, no additional assertions, and no new predicates or case library. Caller-local internal IC contract and wrapper contract exactly match the canonical _SemaphoreCreate IC contract modulo whitespace. Canonical C bytes match this attempt's initial history. Both IC=1 and OC=0 gcc -m32 syntax checks passed.

Controller formal-case-lib-design passed (absent policy, skipped). Controller symexec passed and committed the four formal files. Generated goals are two return branches forwarding the existential post-state and one identical os_inv call precondition. All three were solved by the native QCP solver and appear in proof_auto with generated Admitted; manual contains only its generated prelude and no manual obligation. This preserves native auto/manual division; it is not a full Rocq proof-term claim. No generated or manual file was hand-edited. Final controller acceptance, parent check, publication and final-check remain main's work.
