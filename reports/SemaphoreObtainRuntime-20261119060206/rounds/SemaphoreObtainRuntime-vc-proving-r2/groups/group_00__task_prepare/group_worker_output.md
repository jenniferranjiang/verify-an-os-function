# task_prepare r2

The six assigned top-level witnesses and all six applicable aggressive split witnesses are proved with Qed in the group manual. The two entail_wit_7 generated split blocks retain Proof/Abort as required by the whole proof route.

- entail_wit_7 extracts the actual entry assertion from safeExec at the rely-reached state and preserves os_inv resources.
- entail_wit_8 obtains the running descriptor from admissibility, splits the published store_map cell, borrows exstatus, and constructs a writing-zero restoration wand. The proof restores the updated descriptor map and preserves task/world invariants, scheduler ownership, service slots, assign, Delay owners, zombie and semaphore/mutex/event queues, and all other module resources. It does not assume the running task address is nonzero.
- entail_wit_9 restores the wand and transfers admissibility and the unchanged future-delay condition.
- entail_wit_10 derives task nonzero from the returned flag-1 LinklistSuspend relation through ktask_suspend_step, and instantiates the carried future-delay premise at the returned suspended state.
- which_implies_wit_7/8 borrow and return the Assign running-pointer cell.

Only assigned proof spans and the group reports were changed. No helper file, project library, C annotation, goal, auto proof, spec, or assumption was changed. Historical proof reuse is documented separately. Forbidden-lemma/tactic scan has no hits.

Controller group-development: exit 0, status passed (56.26 seconds). Controller exact group-check: exit 0, status passed (66.81 seconds), including the group wrapper. All writing stops after terminal report creation.
