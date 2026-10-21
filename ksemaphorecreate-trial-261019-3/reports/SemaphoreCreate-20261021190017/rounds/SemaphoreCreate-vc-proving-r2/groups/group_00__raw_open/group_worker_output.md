Implemented entail_wit_2 through the full-resource LLM route: open SemaphoreRaw and NodeStorage, extract the owned nonzero fields, then cancel the same resources and preserve the OutsideCritical frame. The generated pure-only splits remain Abort.

Implemented entail_wit_3 through its assigned aggressive route and all six splits. Added fresh_semaphore__raw_open: a member of the existing semaphore DLL exposes a value cell through dllseg_split, contradicting separate ownership of the new SemaphoreZero value cell via dup_store_2bytes. Remaining splits extract the existing DLL nonzero fact, semaphore context, locked-state world invariant and alignment, and reorder the exact spatial resources.

Current group-development passed with exit code 0. No predicate, spec, statement, unassigned proof, or protected split tokens were modified. Forbidden lemma/tactic scan found no matches.

Final group-check also passed with exit code 0 and JSON status passed (107.17 seconds).
