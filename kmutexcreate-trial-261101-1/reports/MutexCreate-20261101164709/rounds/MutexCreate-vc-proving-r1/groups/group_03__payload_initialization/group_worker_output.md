# payload_initialization delivery

Completed all seven assigned proof spans with the fixed routes. No helper, predicate, spec, C, statement, import, seed-library or unassigned proof changes.

- `which_implies_wit_4`: unfold NodeZero, normalize nested field addresses with the existing address laws, and forget both zero-valued pointer stores using `store_ptr_undef_store_ptr`.
- `which_implies_wit_5_split_goal_spatial`: preserve value/count/priority/holder/padding exactly, existentially forget the management link values, and construct the empty wait DLL from the two self-linked pointer stores. The handoff's suggestion that self-linked itself supplies nonzero is inaccurate: its definition does not contain that pure fact. The actual proof extracts the holder field address validity and uses the already imported `mutex_field_offset_axiom` to infer pend-list address > 0. This needs no new hypothesis or trust.
- `which_implies_wit_5`: aggressive route dispatches only to the assigned spatial split via Goal_apply.
- `partial_solve_wit_10`, `11`, `12_pure`, `12`: retained pure premises and spatial permutation suffice. The auxiliary conclusion of 12 is processed separately.

Actual Rocq MCP sessions reached Qed for all goals: partial10 state4, partial11 state29, partial12pure state45, partial12 state54, which4 state20, which5 spatial state43. The aggressive top-level statement was replayed after the proven spatial split and reached Qed at state52. No assumptions were injected. Final actual source compilation validates all seven canonical declaration names.

Controller group-development exited0/status passed (18.01s). Controller group-check exited0/status passed (39.88s), recompiling the current library, goal, auto, manual and group wrapper with 198 base dependencies. Forbidden lemma/tactic scan of copied manual and library found no matches.

Stopped writing after this report for main finalization.
