# atomic_commit delivery

Completed the two assigned aggressive top-level VCs and all four assigned split goals. Statements, declaration order, prelude, seed library and unassigned proof tokens remain unchanged.

Added one fully proved local helper, `find_event_atomic_commit__atomic_commit`. It unfolds the actual atomic query semantics, selects the observed `st` permitted by LastSeen/RTrans, applies the original weakest-precondition continuation to the normal result, and returns the same X at LastSeen st. It does not add a premise, change the abstract program, use a new axiom, or rely on sibling results. The helper was checked to Qed interactively with Rocq MCP in the actual group-library context.

Both split-goal-1 GTrans obligations close during `LLM_pre_process ltac:(lia || int_auto)`. Both split-goal-2 obligations apply the local commit helper. For each top-level VC, `aggressive_pre_process` also closes the trivial GTrans branch; its one remaining branch is discharged solely with `Goal_apply` of that VC's split-goal-2 lemma. All generated split declarations remain present and proved.

Development found and repaired only local proof-script issues: explicit Z.ltb avoids the seed's string notation scope; explicit pointwise iff handles set equivalence without adding imports; the top-level Goal_apply dispatch follows the actual single remaining branch. No annotation/spec gap was found.

Final exact controller command `coq-check --run FindEventById-20261103170357 --round FindEventById-vc-proving-r1 --target-kind group-check --group atomic_commit` exited 0 with JSON status passed. It recompiled the group library, goal, auto, copied manual and assigned-witness wrapper. No prohibited lemma/tactic or unfinished assigned proof was added. No canonical, source C, state, plan or sibling file was modified.

Terminal report written last; worker has stopped modifying files. Main must still finalize this delivery.
