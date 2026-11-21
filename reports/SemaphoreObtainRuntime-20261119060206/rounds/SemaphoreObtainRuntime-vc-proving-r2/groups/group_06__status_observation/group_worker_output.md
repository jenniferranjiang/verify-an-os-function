Completed all seven assigned declarations (three top-level VCs and four applicable split goals), with Qed.

- entail 15 applies the supplied scheduling continuation to its returned safeExec fact.
- entail 16 derives the original cached task address lookup from the after-assign assertS at st_lock using the actual rely relation. It splits store_published_task from task_desc_map, borrows only exstatus, and constructs a same-value restoration wand that reconstructs the complete os_inv. It does not equate the scheduled and observed states or assume the cached task is still the running task.
- entail 17 selects the concrete read-only semaphore_read_status transition, derives the returned exstatus continuation, applies the restoration wand, and preserves InsideCritical. Guarantee reflexivity closes by native preprocessing.

Historical r1 resume_status blocks were unfinished and were not reused. No statement, library, trust boundary, or unassigned span was changed. Assigned proof text contains no forbidden lemma/tactic, added axiom, admitted obligation, or debugging command.

Exact controller coq-check --target-kind group-check --group status_observation exited 0 with JSON status passed (46.088224 seconds). Main still performs delivery finalization and whole-function checks.
