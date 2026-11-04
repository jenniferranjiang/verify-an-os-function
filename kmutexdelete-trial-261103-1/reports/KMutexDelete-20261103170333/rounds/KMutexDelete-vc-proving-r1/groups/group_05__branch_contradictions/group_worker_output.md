# branch_contradictions delivery

Completed the four assigned top-level proofs only: safety_wit_8, safety_wit_9, safety_wit_10, and partial_solve_wit_8. All use the required `LLM_pre_process ltac:(lia || int_auto)` route and terminate with Qed. The three safety targets have contradictory zero/nonzero branch premises. The transport target preserves the supplied pure facts and exactly the same manager-found, lookup-frame and critical resources. No extra premise, helper, import or source annotation was introduced.

Statements, declaration order, prelude, seed library and all unassigned proof tokens remain unchanged. The assigned proof/forbidden-tactic scan is clear. No current-round sibling output was read or used. No historical proof was needed.

Controller group-development returned exit 0 / status passed in 21.973644 seconds; exact group-check returned exit 0 / status passed in 25.629003 seconds and compiled its assigned-witness wrapper. All four proofs were also checked through the current Rocq MCP to Qed using this group's generated dev workspace: state transitions 2→4, 5→7, 8→10 and 11→13. An initial interactive load from the trial root had no loadable canonical generated goal; using the group's controller-generated project mapping resolved that infrastructure issue without editing load paths or copying dependencies. No unresolved proof or infrastructure issue remains in this delivery.

Terminal report is written last; this owner has stopped all writes pending main finalize-delivery.
