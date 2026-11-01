# steps_effect delivery

Assigned witness: `proof_of_LinklistResumeAll_entail_wit_1` (`LLM_pre_process`).

The proof chooses the whole left disjunct, instantiates `current = before_semaphore_waiters` and `remaining = waiting_semaphore_waiters`, obtains `resume_remaining_effect` from the proved `steps_to_effect__steps_effect`, and preserves `os_inv` while forgetting the three zero-valued local cells with the typed store-to-undef lemmas.

The group library preserves the seed and adds 34 proved helpers with suffix `__steps_effect`. The closure proves:

- From steps: waiting has no duplicates, each original descriptor is suspended, and the final task map is exactly `resume_all_task_map`.
- Ready insertion is invariant under prior status/exstatus updates, so its sequence is exactly `resume_all_ready` under the original map.
- Heap DLL resources provide active-delay pointer uniqueness and semaphore-address uniqueness; separation between inactive-map nodes and the active DLL provides delay disjointness.
- Each unset step preserves delay shape and existing inactive entries. A trace invariant proves the active filter, provenance of newly inactive entries, and presence of every selected nonzero delay. These imply exactly the batch filter/find definition, including zero, already inactive, repeated-pointer, and alias cases.
- Semaphore updates compose to one final empty pending list. Every other global/task/assign component is preserved, giving record equality with the specified batch state.

No annotation/spec gap was found. No obligation Definition was treated as a proved fact, no historical/current sibling output was imported, and no semantic inputs or unassigned proof spans were edited.

Rocq MCP verification: candidate helper families, the complete exact library, and the assigned proof against the actual staged generated goal all returned `success: true`. `Print Assumptions proof_of_LinklistResumeAll_entail_wit_1` showed only the existing memory/address/sizeof parameters and standard classical, propositional-extensionality, and functional-extensionality assumptions. The stage workspace produced the known missing-project warning, but the configured wrapper resolved aliases and compilation succeeded.

The forbidden-lemma/tactic scan found zero hits in the assigned proof and library. Controller group-development passed; final group-check result is recorded below.

Final controller group-check: exit code 0, JSON `status: passed`, elapsed 103.389371 seconds. Checked `VC/LinklistResumeAll_group_00_steps_effect_check.v` and all group dependencies in `group_00/src`.
