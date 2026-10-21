Completed both assigned witnesses using the required LLM_pre_process route.

- The pure witness uses the existing scheduler nesting bound directly.
- The wrapper unfolds its auxiliary VC after preprocessing, then preserves the identical SemaphoreOutsideCritical resource and establishes both pure bounds.
- No helpers, imports, predicate changes, or unassigned proof changes were introduced.
- Consulted only the accepted partial_solve proof pattern in this trial's VC/_SemaphoreCreate_proof_manual.v; no historical CRTOS trials or sibling outputs were accessed.
- Forbidden lemma/tactic scan found no matches.
- Exact assigned group-check completed with process exit 0 and JSON status passed (56.974848 seconds).

All writes are complete; ready for main-agent finalize-delivery.
