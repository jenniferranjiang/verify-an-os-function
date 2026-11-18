# call_frames_2 delivery (round 2)

All ten assigned top-level witnesses are proved by reusing the accepted round-1 call_frames_3 and call_frames_4 proof spans. Every corresponding current goal definition, including its auxiliary/pure definitions, was compared with annotation-attempt2/before and is byte-for-byte identical. No proof adaptation or extra assumption was necessary.

Pure projections use the required explicit LLM_pre_process closer. Implication-shaped frame goals introduce their existing pure premise and unfold their exact auxiliary definition before the same tactic. Only assigned proof spans were replaced; unassigned text was mechanically compared with current canonical and is unchanged. No helpers, imports, axioms, admissions or generated statement edits were added.

The exact handoff controller group-check completed with exit code 0 and JSON status passed, elapsed 30.095462 seconds. It recompiled the current goal, auto, manual and assigned-witness wrapper. This is group validation; main still performs finalize-delivery and eventual full parent/final checks.

No MCP replay was needed for these identical previously checked statements; the current controller compilation is the new proof evidence. Historical sources and comparison are recorded in proof_reuse.md.
