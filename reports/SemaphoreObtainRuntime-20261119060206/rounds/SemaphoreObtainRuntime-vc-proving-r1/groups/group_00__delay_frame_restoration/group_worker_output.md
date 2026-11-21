# delay_frame_restoration proof notes

Assigned witness: `proof_of__SemaphoreObtain_entail_wit_11`. The clean complete proof passed `group-development` (exit 0, status passed). Exact `group-check` also passed (exit 0, status passed). The assigned group is complete; parent merge/final-check remains the responsibility of the main workflow.

The witness chooses a concrete residual frame containing the descriptor map with the target cell omitted, all target descriptor/stack resources except its delay pointer, owned scheduler nodes, and unchanged OS module resources. Local facts prove that changing only `tdDelay` preserves task and assignment well-formedness and pure task-map associations in semaphore/mutex/event/zombie lists.

The target suspended task is absent from `sched_owned_tasks` by the existing suspension transition. This excludes it from service-slot descriptors whose `tdDelay = 0` condition must remain unchanged. Failure reconstructs the original state; success merges the updated descriptor into the same finite map domain and reassembles `os_inv` using the actual returned delay/tick resources. The frame theorem is proved, not assumed. Null and inactive eligibility are split without requiring `inactive_map(0)`.

Checks use the assigned local QCP controller commands. No statement, C source, specification, imported boundary, shared library, or trusted premise was changed. All additional lemmas are local assertions inside the assigned proof span. Broad state reduction was replaced by an explicit definitionally equal resource view to avoid expanding the complete separation model. Temporary progress markers and tactic diagnostic timeouts have been removed.

The entire copied manual was scanned against the role skill forbidden-token list with no matches. The assigned proof contains no `Admitted`, `Axiom`, `Abort`, or diagnostic commands. Existing unassigned proof placeholders remain untouched.
