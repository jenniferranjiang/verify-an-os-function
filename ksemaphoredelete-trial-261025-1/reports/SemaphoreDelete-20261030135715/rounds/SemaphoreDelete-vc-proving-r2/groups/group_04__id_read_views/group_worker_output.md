# id_read_views r2 delivery

Reused the r1 same-group assigned proof bodies and complete helper closure after checking the current seed, four assigned goals and relevant predicate definitions for compatibility. The helpers retain the __id_read_views suffix. Only assigned manual proof spans and the supplied group library were changed; r1 history and frozen semantic inputs remain read-only.

The proof retains a current semaphore with the original address and ID after resume_all_effect, locates its ID node in the derived manager buckets, exposes the actual UShort scalar and packages the remainder as delete_id_restore. The restoration split consumes the scalar and the wand to recover os_inv. Parent proofs follow aggressive_pre_process and Goal_apply.

Validation:
- Rocq MCP rocq_compile: success true for the full seed/helper candidate, exact current assigned goal definitions and all four proof bodies. The temporary candidate included the manual's existing AUXLib int_auto import; no new project dependency was added to the group library.
- Current r2 controller group-check: exit 0, JSON status passed.
- Forbidden lemma/tactic scan: zero matches.

No annotation gap or unresolved assigned obligation remains. All writing has stopped for main-agent finalization.
