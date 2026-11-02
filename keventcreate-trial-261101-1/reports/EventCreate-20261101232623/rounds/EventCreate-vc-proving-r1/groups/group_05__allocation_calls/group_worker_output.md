Completed all four assigned allocation_calls witnesses using the LLM_pre_process route.

The malloc/memset bounds use the reviewed EventLayoutABI.event_size_axiom, converted to the generated sizeof notation and 36-byte model. Explicit pointer, alignment, alias, options and safeExec premises are retained; the byte-array and OutsideCritical resources cancel unchanged. No helper or seed-library changes were needed.

Validation: group-development passed (exit 0); group-check passed (exit 0). Forbidden lemma/tactic scan returned no matches.
