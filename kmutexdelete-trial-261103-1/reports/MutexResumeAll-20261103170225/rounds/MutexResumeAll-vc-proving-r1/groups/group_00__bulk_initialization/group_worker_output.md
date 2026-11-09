# bulk_initialization proof delivery

Assigned witness: `proof_of_LinklistResumeAll_entail_wit_3`, route `LLM_pre_process`. The complete original spatial branch is used; no split-route assumptions are substituted.

The group library proves `resume_steps_bulk__bulk_initialization`: from the actual initial `os_inv` and membership of the original Mutex, every finite `mutex_resume_all_steps` result satisfies the reviewed aggregate `mutex_resume_all_effect`. The proof extracts Mutex-address uniqueness, unique scheduler ownership, delay-link uniqueness and active/inactive disjointness from the original resources. It derives exact task-map READY/exstatus updates, ready-fold transfer, delay cancellation composition, target pending update and preservation of other global components. Neither a `*_obligation : Prop` declaration nor a trusted new assumption is used as theorem evidence.

The assigned VC instantiates remaining with the original pending sequence and current with st_lock, preserves `os_inv` and the critical token, weakens the two local pointer cells to unknown values, and discharges `mutex_resume_remaining_effect` with the proved bridge. Its proof was checked interactively with Rocq MCP through `Qed` (session states 2 → 3 → 14 → 15) before the controller group check.

Only the assigned proof span and the provided group library were changed. The library seed is unchanged; new lemmas all end in `__bulk_initialization`. No canonical file, source C, frozen contract, sibling candidate, shared predicate, manual statement or unassigned proof token was modified.

Parent supplied a precise read-only historical reference to the archived Semaphore ResumeAll library. The selected task-map/ready/delay helper closure was adapted to the current Mutex/general wakeup relations and recompiled; source/frame preservation and scheduler ownership are separately proved for Mutex. See `proof_reuse.md`. An unused historical find-pointer lemma was removed before the final check.

Validation: multiple controller `group-development` checks passed as the helper closure was assembled; the complete proof and helpers passed `group-check` with exit 0 and JSON status passed. The final same-command check after removing the unused helper also passed (exit 0, JSON status passed, 63.616635 seconds). No forbidden lemma/tactic, added Axiom/Parameter, Admitted helper, unsafe typing or rollback command is used. Generated placeholders outside the assigned span remain untouched and are outside this group's acceptance wrapper.
