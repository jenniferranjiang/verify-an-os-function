Completed all 8 assigned proof spans in the copied manual using the prescribed proof modes.

- Pending-head address equality follows by unfolding mutex_pending_head.
- Drained facts are projected from the existing premises at the relevant states.
- Global manager non-nullness uses CNotation.addr_of_LE_var_not_zero.
- ID bounds follow from the existing mutex_delete_drained / mutex_delete_live predicates.
- No helpers were added; group library seed and all statements and unassigned proofs remain unchanged.

Validation: forbidden lemma/tactic scan found no matches. Rocq MCP closed the ID lower-bound split in the controller-generated group_07 src workspace with its formal mappings. Exact controller group-check exited 0 with status passed, compiling the group manual, library, and wrapper. Earlier coq-debug calls reported initial unfinished assigned proofs and then a missing optional debug script; neither affects the successful exact group-check.
