# continuations

Completed the two assigned top-level VCs and their two assigned pure split goals. Both split proofs start with the required LLM_pre_process closer; both parents use aggressive_pre_process followed only by Goal_apply of their matching split.

For which_implies_wit_1, unfolding the reviewed delete-object wrapper and normalizing it exposes the existing bind. Rewriting the WP of that bind with wp_bind gives exactly the existing resume command with mutex_delete_after_resume as continuation. The safeExec existential witness and its LastSeen condition are unchanged.

For which_implies_wit_2, unfolding that continuation and rewriting wp_ret yields the WP of retire with the original X at the same witness. No new safeExec assertion, program outcome, state restriction, or low-level safeExec_bind reconstruction is introduced. Neither proof uses the permissiveness of RTrans to invent a different observation.

Only the four assigned proof spans changed. Statements, prelude, order, unassigned spans and library seed are unchanged. No helpers, imports, assumptions, or C/spec changes were added. Forbidden lemma/tactic scan is clear.

Rocq MCP used this group's controller-generated dev workspace: the first split reached Qed at state 10 from state 1, then the first parent, second split and second parent reached Qed at state 30. Current group-development returned exit 0/status passed (35.941772 seconds); exact group-check returned exit 0/status passed (33.030661 seconds), compiling the assigned wrapper and its four current dependencies. All launched sessions have exited. This delivery is complete and no further files will be modified before main finalizes.
