# semaphore_views delivery

Completed all four assigned top-level witnesses and both applicable spatial splits with Qed. The manager view and restoration wand, ID-to-original selection and UShort bounds, same-value restoration, and positive semaphore decrement all retain the full global frame, including Dataqueue resources. The two aggressive top-level proofs compose their assigned spatial split via Goal_apply; whole goals use LLM_pre_process.

Proofs were reused from the accepted r1 historical group after comparing current declarations and top-level goal definitions with annotation-attempt3/before. Only the six assigned proof spans were changed. No new helper, dependency, assumption or source/spec change was introduced.

Validation: exact controller `coq-check --target-kind group-check --group semaphore_views` for proving r2 exited 0 with JSON status passed (59.99 seconds), recompiling current goal, auto, manual and the group wrapper. This establishes this group only; main performs full merge/final verification. All writes are stopped for finalization.
