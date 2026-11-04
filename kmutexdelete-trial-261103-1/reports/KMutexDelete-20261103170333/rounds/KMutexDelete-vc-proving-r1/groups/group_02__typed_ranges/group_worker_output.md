# typed_ranges delivery

Completed the five assigned proof spans: three top-level witnesses and the two assigned pure split goals. Statements, declaration order, prelude, all unassigned proof tokens and the copied library seed remain unchanged. No helper or import was added, no annotation or frozen contract was changed.

The low-16 conversion bounds use the existing proved `unsigned_Lastnbits_range` at width 16, followed by constant normalization. Each split begins with the required LLM_pre_process route, and the parent pure witness uses only aggressive_pre_process plus the two corresponding Goal_apply branches.

The auxiliary implication witness retains the premise but proves its needed bounds directly and cancels exactly the original manager, mutex_lookup_frame and InsideCritical resources; no caller-local cell is synthesized. Its first LLM_pre_process introduces the implication and the second processes the auxiliary entailment.

The entry signed range is extracted from the actual owned Int cell with store_int_range. After normalizing Int.min_signed/max_signed to their 32-bit constants, the proof preserves the same Int cell and OutsideCritical and copies the supplied safeExec fact. It does not assume representable bounds as a new premise.

All five spans were checked interactively with the current Rocq MCP, ending in Qed/no goals (states 7, 17, 27, 33 and 38; summary in tool_calls.jsonl). The own controller-staged workspace was used because the canonical VC directory contains source, while compiled current artifacts reside in the assigned group stage. No sibling output or history proof was imported.

Controller group-development passed with exit 0 (33.435827s); controller group-check passed with exit 0 (55.790749s), compiling the assigned-witness wrapper and current library. Both reused 201 unchanged base artifacts. Named forbidden-lemma/tactic scan was clear; controller validation accepted assigned proof completeness and boundaries. Generated unassigned template spans were preserved as required.

The earlier incomplete entry-range draft and initial missing canonical compiled import were local development issues, both resolved without changing the VC or its premises. No blocker remains for this group. This report is a group delivery, not parent/run final acceptance.
