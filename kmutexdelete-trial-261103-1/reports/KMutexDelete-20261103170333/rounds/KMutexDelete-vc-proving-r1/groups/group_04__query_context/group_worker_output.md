# query_context delivery

Completed all six assigned top-level witnesses, with the required whole-goal `LLM_pre_process ltac:(lia || int_auto)` route. No helper, import, hypothesis, seed or executable C change was needed. Statements, declaration order, prelude and all unassigned proof tokens remain unchanged; there are no assigned split goals for this group.

The three safety witnesses establish only the constant-zero signed bounds. The three partial-solve witnesses repeat the existing branch/continuation facts and retain or reorder precisely the same manager/frame/critical resources. In particular, the null-manager branch does not invent `idmanager_query=false` or a non-null manager assumption.

Current Rocq MCP interaction used the controller-prepared group_04/dev workspace and canonical goal/auto/lib imports only: preamble state 1, 24 commands ending at state 25, all six corresponding interactive lemmas reached Qed. The candidate proof texts are exactly these checked bodies. No current sibling output or historical proof was used.

Controller group-development passed with exit 0 (22.919434 seconds; four current files recompiled), then exact group-check passed with exit 0 (25.774979 seconds; current manual/lib/goal/auto and assigned wrapper recompiled). Forbidden lemma/tactic scan was clear. Generated unassigned templates remain untouched as required and are not claimed as this group's proof work.

Terminal report is written last. All writing stops for main finalization.
