# schedule_continuation completed

All three assigned whole-route witnesses `proof_of__SemaphoreObtain_entail_wit_14_1`, `_14_2`, and `_14_3` end in Qed. No statements, unassigned tokens, libraries, imports, specifications, or annotations were changed.

For finite waits, select the actual successful delay state `st_after`; apply the supplied universal delay-frame restoration entailment to the actual `ktask_set_delay_step`, retaining `InsideCritical held`. For infinite waits, select `suspended` and preserve its existing invariant. Construct the exact locked `inr task` effect from clear-status, priority suspension, and the actual optional delay success. Specialize the entry safe execution through `Crtos_RTrans before held`, use `wp_spec` on that concrete atomic effect, and decompose the reviewed continuation with `wp_bind`. Choose Y as the weakest precondition of `semaphore_obtain_after_assign`; `wp_ret` proves the post-call implication for arbitrary returned states. No scheduling termination or equality of pre/post scheduling states is assumed. Guarantee uses the existing Crtos CriticalSTS relation.

Historical assignment-continuation blocks were unproved. The completed historical rollback atomic-effect bridge and canonical PopDataqueue call continuation proof supplied applicable patterns; all current proofs were rechecked.

Controller group-development: exit 0, status passed (22.946372 s).
Controller exact group-check: exit 0, status passed (25.849111 s), including current group wrapper.
Forbidden lemma/tactic scan: no matches. No helper or new assumption introduced.
