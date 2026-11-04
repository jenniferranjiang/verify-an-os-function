Completed the assigned detached-scheduler NULL-delay imported-contract refinement.

The manual extracts the old os_world_wf consequence before transferring os_inv, instantiates the generic contract with the same stable and variable states, and proves its postcondition specialization as a wand. Both post branches obtain tdDelay = 0 from the detached condition. The successful branch obtains owned-list membership, uses the original global ownership NoDup via sched_owned_not_waiting to exclude the target from all modeled pending queues, and preserves their complete object sequences. NULL delay excludes both nonzero unset-delay alternatives. All returned existential values and os_inv(after) are retained.

Added fully proved helpers with suffix __import_detached_refinement; the library seed and all unassigned proof spans are preserved. Forbidden-lemma/tactic scan found no hits.

Validation: controller coq-check, target-kind group-check, group import_detached_refinement: exit code 0, JSON status passed. All five current overlay targets recompiled; elapsed 30.35317 seconds.
